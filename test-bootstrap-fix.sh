#!/bin/bash
# Test script to verify the bootstrap workaround works
# Run this after building the bundle with: nix bundle --bundler .#simple -o bundle .#unwrapped

set -e

BUNDLE="${1:-bundle/bin/nvim}"

if [ ! -x "$BUNDLE" ]; then
    echo "Error: Bundle not found at $BUNDLE"
    echo "Usage: $0 [path-to-bundle]"
    echo "Build with: nix bundle --bundler .#simple -o bundle .#unwrapped"
    exit 1
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            Testing Bootstrap Workaround Fix                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Test 1: Check if bundle runs without errors
echo "Test 1: Running bundle with --version..."
if NP_DEBUG=1 "$BUNDLE" --version 2>&1 | tee /tmp/bundle-test.log | grep -q "NVIM"; then
    echo "✓ Bundle executed successfully"
else
    echo "✗ Bundle failed to execute"
    cat /tmp/bundle-test.log
    exit 1
fi
echo ""

# Test 2: Check if bootstrap workaround was applied
echo "Test 2: Checking if bootstrap workaround was applied..."
if [ -f ~/.nix-portable-sanzenvim/.bootstrapped ]; then
    echo "✓ Bootstrap marker file exists"
    
    # Check saved configuration
    if [ -f ~/.nix-portable-sanzenvim/.np_runtime ]; then
        RUNTIME=$(cat ~/.nix-portable-sanzenvim/.np_runtime)
        echo "  Runtime: $RUNTIME"
    fi
    
    if [ -f ~/.nix-portable-sanzenvim/.np_nix ]; then
        NIX_PATH=$(cat ~/.nix-portable-sanzenvim/.np_nix)
        echo "  Nix path: $NIX_PATH"
        
        # Verify the nix binary/wrapper exists
        if [ -x "$NIX_PATH" ]; then
            echo "  ✓ Nix binary/wrapper is executable"
        else
            echo "  ✗ Nix binary/wrapper not found or not executable"
        fi
    fi
else
    echo "✗ Bootstrap marker not found (workaround may not have run)"
fi
echo ""

# Test 3: Check environment detection
echo "Test 3: Environment detection..."
if [ -d "/nix/store" ] && [ -n "$(ls -A /nix/store 2>/dev/null | head -n 1)" ]; then
    echo "✓ System has /nix/store (Nix environment detected)"
    
    if command -v nix >/dev/null 2>&1; then
        echo "  ✓ System nix found at: $(command -v nix)"
        echo "  Expected NP_RUN: exec $(command -v nix)"
    else
        echo "  ℹ No system nix in PATH (will use wrapper)"
        echo "  Expected NP_RUN: exec ~/.nix-portable-sanzenvim/bin/nix-wrapper"
    fi
else
    echo "ℹ No /nix/store detected (bare system, no workaround needed)"
fi
echo ""

# Test 4: Check debug output
echo "Test 4: Checking debug output from NP_DEBUG=2..."
NP_DEBUG=2 "$BUNDLE" --version 2>&1 | grep -A5 "NP_RUNTIME\|NP_RUN" | head -20 || echo "No debug info found"
echo ""

# Test 5: Clean and re-test
echo "Test 5: Clean bootstrap and re-test..."
rm -rf ~/.nix-portable-sanzenvim
echo "Removed bootstrap files, running again..."
"$BUNDLE" --version 2>&1 | grep -E "Applying bootstrap|Using system nix|Using extracted|Bootstrap workaround applied" || echo "No bootstrap messages (may already be using fallback)"
echo ""

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    Test Results Summary                      ║"
echo "╠══════════════════════════════════════════════════════════════╣"

# Summary
if [ -f ~/.nix-portable-sanzenvim/.bootstrapped ]; then
    echo "║  ✓ Bootstrap workaround applied                              ║"
else
    echo "║  ✗ Bootstrap workaround NOT applied                          ║"
fi

if [ -f ~/.nix-portable-sanzenvim/.np_runtime ] && [ -f ~/.nix-portable-sanzenvim/.np_nix ]; then
    echo "║  ✓ Configuration saved correctly                             ║"
else
    echo "║  ✗ Configuration not saved                                   ║"
fi

# Check if nix binary exists
if [ -f ~/.nix-portable-sanzenvim/.np_nix ]; then
    NIX_PATH=$(cat ~/.nix-portable-sanzenvim/.np_nix)
    if [ -x "$NIX_PATH" ]; then
        echo "║  ✓ Nix binary/wrapper is executable                         ║"
    else
        echo "║  ✗ Nix binary/wrapper not executable                        ║"
    fi
fi

echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Full test log saved to: /tmp/bundle-test.log"
