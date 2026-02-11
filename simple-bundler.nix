# Universal portable bundler that works on ALL Linux systems
# - Systems WITHOUT Nix: Fully portable, self-contained
# - Systems WITH Nix: Can access environment LSPs including nix-shell
#
# Strategy: Wrap nix-portable bundle with a script that:
# 1. Detects if host /nix/store exists
# 2. If yes: Copies/links LSPs to portable's PATH before launching
# 3. If no: Runs normally in portable mode

{
  pkgs,
  nix-portable-bundler,
}:

program:
let
  # Create base nix-portable bundle using the provided bundler
  baseBundle = nix-portable-bundler program;
  
in
pkgs.runCommand "universal-portable-${program.name}" {} ''
  mkdir -p $out/bin
  
  cat > $out/bin/nvim << 'WRAPPER_SCRIPT'
#!/usr/bin/env bash
# Universal portable wrapper for sanzenvim unwrapped build
# Works on ALL Linux systems (with or without Nix)

set -e

# Find this script
SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Extract embedded bundle on first run
CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/sanzenvim-portable"
BUNDLE_CACHE="$CACHE_DIR/nvim-portable"

if [ ! -x "$BUNDLE_CACHE" ]; then
    mkdir -p "$CACHE_DIR"
    # Extract the bundle (find the line number differently to avoid self-reference)
    MARKER="NP_PAYLOAD"
    PAYLOAD_LINE=$(grep -n "^__''${MARKER}_START__$" "$SCRIPT_PATH" | cut -d: -f1)
    PAYLOAD_LINE=$((PAYLOAD_LINE + 1))
    tail -n +$PAYLOAD_LINE "$SCRIPT_PATH" | base64 -d > "$BUNDLE_CACHE"
    chmod +x "$BUNDLE_CACHE"
fi

# Detect if host has Nix installed
if [ -d "/nix/store" ] && [ -n "$(ls -A /nix/store 2>/dev/null | head -n 1)" ]; then
    # Host has Nix! Set up to access host LSPs
    # Use a separate NP_LOCATION to avoid conflicts
    export NP_LOCATION="''${SANZENVIM_NP_LOCATION:-$HOME}"
    NP_DIR="$NP_LOCATION/.nix-portable-sanzenvim"
    
    # Bootstrap workaround: Override how nix-portable runs nix
    # This fixes the "nix is unable to build packages" error by using NP_RUN
    if [ ! -e "$NP_DIR/.bootstrapped" ]; then
        echo "Applying bootstrap workaround..." >&2
        
        # Create directory structure
        mkdir -p "$NP_DIR"
        
        # Check if system has nix installed
        if command -v nix >/dev/null 2>&1 && [ -x "$(command -v nix)" ]; then
            # System has nix installed - use it directly with NP_RUN
            SYSTEM_NIX="$(command -v nix)"
            export NP_RUNTIME="nix"
            # NP_RUN completely overrides how nix is executed
            # Format: $NP_RUN {nix-binary} {args...}
            # We use 'exec' to replace the nix binary call entirely
            export NP_RUN="exec $SYSTEM_NIX"
            echo "Using system nix at: $SYSTEM_NIX (via NP_RUN)" >&2
            echo "$SYSTEM_NIX" > "$NP_DIR/.np_nix"
        else
            # No system nix - create a wrapper that extracts and runs embedded nix
            mkdir -p "$NP_DIR/bin"
            
            # Create a wrapper script that nix-portable will call
            cat > "$NP_DIR/bin/nix-wrapper" << 'NIX_WRAPPER_EOF'
#!/bin/bash
# Extract and execute the embedded nix binary
WRAPPER_DIR="$(dirname "$(readlink -f "$0")")"
NIX_BIN="$WRAPPER_DIR/nix"

# Extract nix from bundle on first run
if [ ! -x "$NIX_BIN" ]; then
    BUNDLE_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/sanzenvim-portable/nvim-portable"
    if [ -f "$BUNDLE_CACHE" ] && command -v unzip >/dev/null 2>&1; then
        unzip -p "$BUNDLE_CACHE" "nix/store/*/bin/nix" 2>/dev/null > "$NIX_BIN" || true
        chmod +x "$NIX_BIN" 2>/dev/null || true
    fi
fi

# Execute nix if available, otherwise fail gracefully
if [ -x "$NIX_BIN" ]; then
    exec "$NIX_BIN" "$@"
else
    echo "Error: Could not extract nix binary from bundle" >&2
    exit 1
fi
NIX_WRAPPER_EOF
            chmod +x "$NP_DIR/bin/nix-wrapper"
            
            # Use NP_RUN to call our wrapper
            export NP_RUNTIME="bwrap"
            export NP_RUN="exec $NP_DIR/bin/nix-wrapper"
            echo "Using extracted nix via wrapper (via NP_RUN)" >&2
            echo "$NP_DIR/bin/nix-wrapper" > "$NP_DIR/.np_nix"
        fi
        
        # Save runtime for next time
        echo "$NP_RUNTIME" > "$NP_DIR/.np_runtime"
        
        # Mark as bootstrapped
        touch "$NP_DIR/.bootstrapped"
        echo "Bootstrap workaround applied successfully" >&2
    else
        # Already bootstrapped - restore configuration
        if [ -f "$NP_DIR/.np_runtime" ]; then
            export NP_RUNTIME="$(cat "$NP_DIR/.np_runtime")"
        fi
        if [ -f "$NP_DIR/.np_nix" ]; then
            NIX_PATH="$(cat "$NP_DIR/.np_nix")"
            if [ "$NP_RUNTIME" = "nix" ]; then
                # Direct system nix
                export NP_RUN="exec $NIX_PATH"
            else
                # Wrapper script
                export NP_RUN="exec $NIX_PATH"
            fi
        fi
    fi
    
    # Create wrapper scripts for host LSPs in a temp directory
    # This works around the proot sandbox limitation
    LSP_WRAPPER_DIR="$CACHE_DIR/lsp-wrappers"
    mkdir -p "$LSP_WRAPPER_DIR"
    
    # Function to create wrapper for a host binary
    create_wrapper() {
        local cmd="$1"
        local wrapper="$LSP_WRAPPER_DIR/$cmd"
        if [ ! -f "$wrapper" ] && command -v "$cmd" >/dev/null 2>&1; then
            local host_path="$(command -v "$cmd")"
            cat > "$wrapper" << 'WRAPPER_END'
#!/bin/sh
exec "$host_path" "$@"
WRAPPER_END
            sed -i "s|\$host_path|$host_path|" "$wrapper"
            chmod +x "$wrapper"
        fi
    }
    
    # Create wrappers for common LSPs if they exist in host PATH
    for lsp in lua-language-server nil rust-analyzer clangd \
               vscode-json-language-server vscode-css-language-server \
               typescript-language-server pyright pylsp jdtls kotlin-language-server \
               gopls zls marksman yaml-language-server; do
        create_wrapper "$lsp" 2>/dev/null || true
    done
    
    # Prepend wrapper directory to PATH so wrappers are found first
    export PATH="$LSP_WRAPPER_DIR:$PATH"
fi

# Execute the nix-portable bundle
exec "$BUNDLE_CACHE" "$@"

__NP_PAYLOAD_START__
WRAPPER_SCRIPT
  
  # Append the base64-encoded nix-portable bundle
  base64 ${baseBundle}/bin/nvim >> $out/bin/nvim
  
  chmod +x $out/bin/nvim
''

