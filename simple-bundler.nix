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
# Bootstrap workaround: Create nix symlink where nix-portable expects it
# This fixes the "nix is unable to build packages" error on systems with /nix/store
if [ -d "/nix/store" ] && [ -n "$(ls -A /nix/store 2>/dev/null | head -n 1)" ]; then
    # Host has /nix/store - apply bootstrap workaround
    # Use a separate NP_LOCATION to avoid conflicts  
    export NP_LOCATION="''${SANZENVIM_NP_LOCATION:-$HOME}"
    NP_DIR="$NP_LOCATION/.nix-portable-sanzenvim"
    mkdir -p "$NP_DIR"
    
    # Bootstrap workaround: nix-portable expects the nix binary in the same directory as nvim
    # But our bundle has them in separate store paths. Create a symlink on first run.
    if [ ! -e "$NP_DIR/.bootstrapped" ]; then
        echo "Applying bootstrap workaround..." >&2
        
        # Run the bundle once to extract the store (redirect output to avoid noise)
        "$BUNDLE_CACHE" --version >/dev/null 2>&1 || true
        
        # Find the actual nix binary in the extracted store
        NP_STORE="$NP_LOCATION/.nix-portable/nix/store"
        if [ -d "$NP_STORE" ]; then
            # Find the nix binary
            NIX_BINARY=$(find "$NP_STORE" -name "nix" -type f -executable 2>/dev/null | head -n 1)
            
            if [ -n "$NIX_BINARY" ]; then
                # Find the nvim-with-helpers directory
                NVIM_DIR=$(find "$NP_STORE" -name "*nvf-with-helpers" -type d 2>/dev/null | head -n 1)
                
                if [ -n "$NVIM_DIR" ] && [ ! -e "$NVIM_DIR/bin/nix" ]; then
                    # Create symlink
                    ln -sf "$NIX_BINARY" "$NVIM_DIR/bin/nix" 2>/dev/null || true
                    echo "Bootstrap workaround applied: created nix symlink" >&2
                fi
            fi
        fi
        
        touch "$NP_DIR/.bootstrapped"
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

