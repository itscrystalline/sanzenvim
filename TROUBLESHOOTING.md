# Troubleshooting Guide

## Common Issues and Solutions

### Issue: "Fatal error: nix is unable to build packages"

**Symptoms:**
- Running the bundle results in "Fatal error: nix is unable to build packages"
- The bundle extracts successfully to `~/.cache/sanzenvim-portable/nvim-portable`
- The error occurs during nix-portable's bootstrap process

**Root Cause:**
This is a known bootstrap issue with nix-portable where it performs a self-check by trying to build a test package. The check fails in certain environments.

**Status: AUTOMATICALLY FIXED** 🎉

The bundle now includes an automatic bootstrap workaround that:
1. Detects when running on a Nix system
2. Automatically extracts or copies the nix binary
3. Creates the required symlink structure before first run
4. Marks the fix as applied with a `.bootstrapped` marker file

**What happens automatically:**
- On first run, if `/nix/store` exists, the wrapper script:
  - Creates `~/.nix-portable-sanzenvim/bin/nix` (from system or bundle)
  - Finds the nvf hash from the extracted bundle
  - Creates the symlink: `~/.nix-portable-sanzenvim/nix/store/<hash>-nvf-with-helpers/bin/nix`
  - Marks the fix as complete

**Manual workaround (if automatic fix fails):**

If for some reason the automatic fix doesn't work, you can apply it manually:

```bash
#!/bin/bash
# Fix nix-portable bootstrap issue

NP_DIR="${HOME}/.nix-portable-sanzenvim"
CACHE_DIR="${HOME}/.cache/sanzenvim-portable"

# Step 1: Run bundle once to extract it
./bundle/bin/nvim --version 2>&1 | head -1

# Step 2: Find the nvf hash from the extracted bundle
NVF_HASH=$(strings "$CACHE_DIR/nvim-portable" | grep -o '/nix/store/[^/]*-nvf-with-helpers' | head -1 | cut -d/ -f4 | cut -d- -f1)

echo "Found NVF hash: $NVF_HASH"

# Step 3: Create the nix-portable directory structure
mkdir -p "$NP_DIR/nix/store/${NVF_HASH}-nvf-with-helpers/bin"

# Step 4: Copy the nix binary from your system or nix-portable
# Option A: If you have nix installed system-wide
if command -v nix >/dev/null 2>&1; then
    cp "$(command -v nix)" "$NP_DIR/bin/nix"
fi

# Option B: Extract from another working nix-portable instance
# (Skip if Option A worked)

# Step 5: Create the required symlink
ln -sf "$NP_DIR/bin/nix" "$NP_DIR/nix/store/${NVF_HASH}-nvf-with-helpers/bin/nix"

# Step 6: Mark as fixed
touch "$NP_DIR/nix/store/.fixed"

echo "Workaround applied. Try running the bundle again."
```

**Verify the automatic fix:**

Check if the fix was applied:
```bash
ls -la ~/.nix-portable-sanzenvim/.bootstrapped
ls -la ~/.nix-portable-sanzenvim/bin/nix
```

If these files exist, the automatic fix was applied.

**On bare Linux systems (no manual action needed):**

The bundle works perfectly on bare Linux systems (without Nix). Just install LSPs via your package manager:

```bash
# Install LSPs via npm
npm install -g typescript-language-server vscode-langservers-extracted

# Install LSPs via pip
pip install python-lsp-server pyright

# Install LSPs via apt (if available)
sudo apt install lua-language-server

# Run the bundle - LSPs will be auto-detected!
./bundle/bin/nvim
```

The bundle automatically detects these LSPs and makes them available to nvim.

## LSP Detection Not Working

**Symptoms:**
- LSPs are installed but not detected by nvim
- `which <lsp-name>` shows the LSP in PATH

**Solution:**

1. Verify LSPs are in PATH:
   ```bash
   which typescript-language-server
   which lua-language-server
   ```

2. Check if wrappers were created (on Nix systems):
   ```bash
   ls ~/.cache/sanzenvim-portable/lsp-wrappers/
   ```

3. On Nix systems, the bundle detects `/nix/store` and creates wrappers. Ensure your LSPs are accessible:
   ```bash
   nix-shell -p lua-language-server
   ./bundle/bin/nvim
   ```

4. Clear cache and retry:
   ```bash
   rm -rf ~/.cache/sanzenvim-portable
   rm -rf ~/.nix-portable-sanzenvim
   ./bundle/bin/nvim
   ```

## Performance Issues

**Symptoms:**
- First run is slow
- Takes time to start

**Explanation:**
- First run extracts the 271MB bundle to `~/.cache/sanzenvim-portable/`
- This is a one-time operation
- Subsequent runs are much faster

**Solution:**
- Wait for the first extraction to complete
- Consider pre-extracting the bundle if deploying to multiple systems

## Wrapper Scripts Not Being Created

**Symptoms:**
- On a Nix system but wrappers aren't created
- `~/.cache/sanzenvim-portable/lsp-wrappers/` is empty

**Solution:**

1. Verify `/nix/store` exists:
   ```bash
   ls /nix/store | head
   ```

2. Check environment variable:
   ```bash
   echo $SANZENVIM_NP_LOCATION
   ```

3. Manually trigger wrapper creation by ensuring LSPs are in PATH before running:
   ```bash
   export PATH="/nix/store/.../bin:$PATH"
   ./bundle/bin/nvim
   ```

## Clear All Cache

If you encounter persistent issues, completely reset:

```bash
#!/bin/bash
# Complete cache reset

rm -rf ~/.cache/sanzenvim-portable
rm -rf ~/.nix-portable-sanzenvim
rm -rf ~/.nix-portable  # If you used the old location

# Optional: Clear bundle output
rm -rf bundle

echo "Cache cleared. Rebuild with:"
echo "nix bundle --bundler .#simple -o bundle .#unwrapped"
```

## Getting Help

If issues persist:

1. Check the bundle extracted successfully:
   ```bash
   ls -lh ~/.cache/sanzenvim-portable/nvim-portable
   ```

2. Verify your system:
   ```bash
   uname -a
   cat /etc/os-release
   ```

3. Check if it's a Nix vs non-Nix system:
   ```bash
   [ -d /nix/store ] && echo "Nix system" || echo "Bare system"
   ```

4. Test LSP detection:
   ```bash
   for lsp in typescript-language-server lua-language-server rust-analyzer; do
     command -v $lsp >/dev/null && echo "✓ $lsp" || echo "✗ $lsp"
   done
   ```

5. Report the issue with:
   - Your OS and kernel version
   - Whether you have Nix installed
   - List of LSPs you're trying to use
   - Full error message
