#!/usr/bin/env bash

# Wrapper script to fix nix-portable bind mounts for host /nix/store access
# This allows the unwrapped build to access LSPs from nix-shell

# Check if host has /nix/store
if [ -d "/nix/store" ] && [ "$(ls -A /nix/store 2>/dev/null)" ]; then
    # If ~/.nix-portable doesn't exist yet, create a symlink to /nix
    # This will make the host's /nix/store accessible inside the portable environment
    NP_DIR="${NP_LOCATION:-$HOME}/.nix-portable"
    
    if [ ! -e "$NP_DIR" ]; then
        echo "First run: Setting up nix-portable to use host /nix/store..."
        mkdir -p "$(dirname "$NP_DIR")"
        # Link to the host /nix instead of creating a new one
        ln -sf /nix "$NP_DIR/nix"
    elif [ -d "$NP_DIR/nix/store" ] && [ ! -L "$NP_DIR/nix" ]; then
        # If nix-portable already created its own store, we need to merge or replace
        echo "Warning: nix-portable has its own store. To access host LSPs, please:"
        echo "  1. Remove ~/.nix-portable"
        echo "  2. Run this script again"
        echo ""
        echo "Or use NP_LOCATION to specify a different directory:"
        echo "  NP_LOCATION=/tmp/nvim-portable $0 $@"
        echo ""
        echo "Continuing with existing setup (host /nix/store will NOT be accessible)..."
    fi
fi

# Run the actual nix-portable bundle
exec "$(dirname "$0")/bundle/bin/nvim" "$@"
