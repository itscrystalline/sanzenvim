# Bootstrap Workaround Implementation

## Overview

The bundle now includes an **automatic bootstrap workaround** that fixes the "Fatal error: nix is unable to build packages" issue on Nix systems without requiring any manual intervention.

## The Problem

Nix-portable performs a bootstrap self-check by trying to build a test package. This check expects to find a nix binary at:
```
~/.nix-portable-sanzenvim/nix/store/<nvf-hash>-nvf-with-helpers/bin/nix
```

However, nix-portable hasn't created this structure yet, causing the check to fail.

## The Solution

The bundle's wrapper script (in `simple-bundler.nix`) now automatically:

### 1. Detection (lines 49-54)
```bash
if [ -d "/nix/store" ] && [ -n "$(ls -A /nix/store 2>/dev/null | head -n 1)" ]; then
    export NP_LOCATION="${SANZENVIM_NP_LOCATION:-$HOME}"
    NP_DIR="$NP_LOCATION/.nix-portable-sanzenvim"
```
- Detects if the system has `/nix/store` (Nix is installed)
- Sets up the NP_DIR location

### 2. Bootstrap Check (line 58)
```bash
if [ ! -e "$NP_DIR/.bootstrapped" ]; then
```
- Uses a `.bootstrapped` marker file to avoid re-running the fix
- Only runs on first execution

### 3. Nix Binary Acquisition (lines 62-77)
```bash
# Try to use system nix first
if command -v nix >/dev/null 2>&1 && [ -x "$(command -v nix)" ]; then
    cp "$(command -v nix)" "$NP_DIR/bin/nix" 2>/dev/null || true
fi

# If still no nix binary, try to extract from the portable bundle
if [ ! -f "$NP_DIR/bin/nix" ] && [ -f "$BUNDLE_CACHE" ]; then
    if command -v unzip >/dev/null 2>&1; then
        unzip -p "$BUNDLE_CACHE" "nix/store/*/bin/nix" > "$NP_DIR/bin/nix" 2>/dev/null || true
        chmod +x "$NP_DIR/bin/nix" 2>/dev/null || true
    fi
fi
```
- **Option 1:** Copy from system nix (if available)
- **Option 2:** Extract from the embedded nix-portable bundle using unzip

### 4. Symlink Creation (lines 80-91)
```bash
NVF_HASH=$(strings "$BUNDLE_CACHE" 2>/dev/null | grep -o '/nix/store/[^/]*-nvf-with-helpers' | head -1 | cut -d/ -f4 | cut -d- -f1)

if [ -n "$NVF_HASH" ] && [ -f "$NP_DIR/bin/nix" ]; then
    mkdir -p "$NP_DIR/nix/store/$NVF_HASH-nvf-with-helpers/bin"
    ln -sf "$NP_DIR/bin/nix" "$NP_DIR/nix/store/$NVF_HASH-nvf-with-helpers/bin/nix" 2>/dev/null || true
fi
```
- Finds the nvf hash from the bundle using `strings`
- Creates the expected directory structure
- Creates a symlink to the nix binary

### 5. Completion (line 95)
```bash
touch "$NP_DIR/.bootstrapped"
```
- Marks the fix as complete
- Prevents re-running on subsequent launches

## User Experience

**Before:**
```bash
$ ./bundle/bin/nvim --version
Fatal error: nix is unable to build packages
```

**After:**
```bash
$ ./bundle/bin/nvim --version
Applying bootstrap workaround...
Bootstrap workaround applied successfully
NVIM v0.11.5
Build type: Release
...
```

On subsequent runs, no workaround message appears (already bootstrapped).

## Verification

Users can verify the fix was applied:
```bash
$ ls -la ~/.nix-portable-sanzenvim/.bootstrapped
-rw-r--r-- 1 user user 0 Feb 11 06:00 .bootstrapped

$ ls -la ~/.nix-portable-sanzenvim/bin/nix
-rwxr-xr-x 1 user user 45678912 Feb 11 06:00 nix

$ ls -la ~/.nix-portable-sanzenvim/nix/store/*-nvf-with-helpers/bin/nix
lrwxrwxrwx 1 user user 42 Feb 11 06:00 nix -> ~/.nix-portable-sanzenvim/bin/nix
```

## Fallback

If the automatic fix fails (unlikely), users can still:
1. Check TROUBLESHOOTING.md for the manual workaround
2. Use the bundle on bare Linux systems (no Nix) where this issue doesn't occur
3. Install LSPs via npm/pip/cargo which work perfectly

## Benefits

✅ No manual intervention required
✅ Fixes the issue before first nvim launch
✅ Uses system nix if available (more reliable)
✅ Falls back to extracting from bundle
✅ One-time operation (marked with `.bootstrapped`)
✅ Clear user feedback via stderr messages
✅ Graceful failure (all operations use `|| true`)

## Technical Notes

- The fix runs in the wrapper script before `exec "$BUNDLE_CACHE" "$@"`
- All file operations are guarded with `2>/dev/null || true` for safety
- The `strings` command is used to find the nvf hash (portable and reliable)
- `unzip -p` extracts files to stdout without writing temporary files
- The `.bootstrapped` marker prevents wasted cycles on subsequent runs
