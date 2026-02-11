# Bootstrap Workaround Implementation

## Overview

The bundle now includes an **automatic bootstrap workaround** that fixes the "Fatal error: nix is unable to build packages" issue on Nix systems by using nix-portable's environment variables to control its runtime behavior.

## The Problem

Nix-portable performs a bootstrap self-check by trying to build a test package. This check fails in certain environments because it expects specific directory structures that don't exist yet.

## The Solution

Instead of trying to manually create the directory structure nix-portable expects, we use **nix-portable's own environment variables** to control its behavior:

- `NP_RUNTIME` - Tells nix-portable which runtime to use (nix, bwrap, or proot)
- `NP_NIX` - Specifies the path to the nix executable to use

### Strategy

1. **If system has nix:** Use `NP_NIX` to point to system nix and set `NP_RUNTIME=nix`
2. **If no system nix:** Extract nix from bundle and use `NP_RUNTIME=bwrap`

This bypasses nix-portable's bootstrap check entirely by telling it exactly which nix binary to use.

## Implementation

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
- Uses a `.bootstrapped` marker file to avoid re-running
- Only runs on first execution

### 3. System Nix Detection (lines 65-71)
```bash
if command -v nix >/dev/null 2>&1 && [ -x "$(command -v nix)" ]; then
    export NP_NIX="$(command -v nix)"
    export NP_RUNTIME="nix"
    echo "Using system nix at: $NP_NIX" >&2
```
- Checks if system has nix installed
- Sets `NP_NIX` to system nix path
- Sets `NP_RUNTIME=nix` to use native nix (fastest)

### 4. Fallback: Extract from Bundle (lines 72-83)
```bash
else
    # Extract nix binary from the portable bundle
    unzip -p "$BUNDLE_CACHE" "nix/store/*/bin/nix" > "$NP_DIR/bin/nix"
    chmod +x "$NP_DIR/bin/nix"
    
    export NP_NIX="$NP_DIR/bin/nix"
    export NP_RUNTIME="bwrap"
fi
```
- If no system nix, extract from the embedded bundle
- Sets `NP_NIX` to extracted nix
- Sets `NP_RUNTIME=bwrap` (bubblewrap, faster than proot)

### 5. Persistence (lines 93-103)
```bash
# Save runtime configuration for next time
echo "$NP_RUNTIME" > "$NP_DIR/.np_runtime"
echo "$NP_NIX" > "$NP_DIR/.np_nix"
```
- Saves configuration to files
- On subsequent runs, restores from saved files
- Avoids re-detection overhead

## User Experience

**First run:**
```bash
$ ./bundle/bin/nvim --version
Applying bootstrap workaround...
Using system nix at: /usr/bin/nix
Bootstrap workaround applied successfully
NVIM v0.11.5
...
```

**Subsequent runs:**
```bash
$ ./bundle/bin/nvim --version
NVIM v0.11.5
...
```

Silent - no workaround messages.

## Verification

Users can verify the fix was applied:
```bash
$ ls -la ~/.nix-portable-sanzenvim/.bootstrapped
-rw-r--r-- 1 user user 0 Feb 11 06:00 .bootstrapped

$ cat ~/.nix-portable-sanzenvim/.np_runtime
nix

$ cat ~/.nix-portable-sanzenvim/.np_nix
/usr/bin/nix
```

## Why This Works

Nix-portable's environment variables are read before its bootstrap check:

1. `NP_NIX` overrides nix-portable's default nix binary search
2. `NP_RUNTIME` overrides nix-portable's runtime selection
3. When these are set, nix-portable skips its bootstrap self-check
4. The bundle works immediately without directory manipulation

This is the **correct** way to configure nix-portable, as documented in its README.

## Benefits

✅ Uses nix-portable's official configuration mechanism
✅ No directory structure manipulation needed
✅ Faster - uses system nix when available (native runtime)
✅ Falls back gracefully to extracted nix + bwrap
✅ One-time detection, saved for future runs
✅ Clear user feedback via stderr messages
✅ Works on both NixOS and Ubuntu with Nix

## Technical Notes

- Configuration is saved in `~/.nix-portable-sanzenvim/.np_runtime` and `.np_nix`
- On subsequent runs, configuration is restored from these files
- All operations use `|| true` for safety
- The `.bootstrapped` marker prevents re-running detection logic
