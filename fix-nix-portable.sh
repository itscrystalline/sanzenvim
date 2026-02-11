#!/usr/bin/env bash
# Script to make nix-portable use the host's /nix/store

set -e

NP_DIR="${NP_LOCATION:-$HOME}/.nix-portable"

echo "Fixing nix-portable to access host /nix/store..."

# Remove existing nix-portable setup if it exists
if [ -e "$NP_DIR" ]; then
    echo "Removing existing $NP_DIR..."
    rm -rf "$NP_DIR"
fi

# Create the directory structure
mkdir -p "$NP_DIR"

# Create a symlink to the host /nix
if [ -d "/nix" ]; then
    echo "Symlinking $NP_DIR/nix -> /nix"
    ln -sf /nix "$NP_DIR/nix"
    echo "Done! The unwrapped build should now access host /nix/store"
else
    echo "Warning: /nix does not exist on this system"
    echo "The portable build will create its own /nix"
fi
