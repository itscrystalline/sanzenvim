# Bootstrap Workaround Implementation

## Overview

The bundle now includes an **automatic bootstrap workaround** that fixes the "Fatal error: nix is unable to build packages" issue on Nix systems by using nix-portable's `NP_RUN` environment variable to override how nix is executed.

## The Problem

Nix-portable performs a bootstrap self-check by trying to build a test package. This fails because:
1. Nix-portable embeds the nix binary path at **build time** (e.g., `/nix/store/xxx/bin/nix`)
2. When using proot runtime, this path doesn't exist in the emptyroot sandbox
3. Setting `NP_NIX` doesn't work because the path is already hardcoded in the bundle

## The Solution

We use `NP_RUN` to **completely override** how nix-portable executes nix:

- `NP_RUNTIME` - Tells nix-portable which runtime to use (nix, bwrap, or proot)
- `NP_RUN` - Overrides the complete command to run nix (format: `$NP_RUN {nix-binary} {args...}`)

### Strategy

1. **If system has nix:** Use `NP_RUN="exec /path/to/nix"` to replace the hardcoded nix path entirely
2. **If no system nix:** Create a wrapper script that extracts nix from bundle and use `NP_RUN="exec /path/to/wrapper"`

This completely overrides nix-portable's nix execution, bypassing the bootstrap check.

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

### 3. System Nix Detection
```bash
if command -v nix >/dev/null 2>&1 && [ -x "$(command -v nix)" ]; then
    SYSTEM_NIX="$(command -v nix)"
    export NP_RUNTIME="nix"
    export NP_RUN="exec $SYSTEM_NIX"
    echo "Using system nix at: $SYSTEM_NIX (via NP_RUN)" >&2
```
- Checks if system has nix installed
- Sets `NP_RUN` to exec system nix directly
- Sets `NP_RUNTIME=nix` to use native nix (fastest)
- Completely replaces nix-portable's hardcoded nix path

### 4. Fallback: Wrapper Script
```bash
else
    # Create a wrapper script that extracts and runs embedded nix
    cat > "$NP_DIR/bin/nix-wrapper" << 'EOF'
#!/bin/bash
NIX_BIN="$WRAPPER_DIR/nix"
if [ ! -x "$NIX_BIN" ]; then
    unzip -p "$BUNDLE_CACHE" "nix/store/*/bin/nix" > "$NIX_BIN"
    chmod +x "$NIX_BIN"
fi
exec "$NIX_BIN" "$@"
EOF
    export NP_RUNTIME="bwrap"
    export NP_RUN="exec $NP_DIR/bin/nix-wrapper"
fi
```
- Creates a wrapper script that handles nix extraction
- Wrapper extracts nix from bundle on first call
- Sets `NP_RUN` to exec the wrapper
- Sets `NP_RUNTIME=bwrap` (bubblewrap, faster than proot)

### 5. Persistence
```bash
echo "$NP_RUNTIME" > "$NP_DIR/.np_runtime"
echo "$NIX_PATH" > "$NP_DIR/.np_nix"
# On restore:
export NP_RUN="exec $(cat "$NP_DIR/.np_nix")"
```
- Saves configuration to files
- On subsequent runs, restores `NP_RUN` with saved path
- Avoids re-detection overhead

## User Experience

**First run:**
```bash
$ ./bundle/bin/nvim --version
Applying bootstrap workaround...
Using system nix at: /usr/bin/nix (via NP_RUN)
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

$ env | grep NP_
NP_RUNTIME=nix
NP_RUN=exec /usr/bin/nix
```

## Why This Works

The key insight is that `NP_RUN` **completely replaces** how nix is executed:

1. Nix-portable hardcodes the nix binary path at build time (e.g., `/nix/store/xxx/bin/nix`)
2. This hardcoded path doesn't exist when using proot (emptyroot sandbox)
3. `NP_NIX` doesn't help because the path is already embedded
4. `NP_RUN` overrides the **execution** entirely: `$NP_RUN {nix-binary} {args...}`
5. We set `NP_RUN="exec /usr/bin/nix"` to replace the hardcoded path
6. Nix-portable now executes our command instead of its hardcoded binary

This is the **official** way to override nix execution, as documented in nix-portable's README.

## Benefits

✅ Uses `NP_RUN` to completely override nix execution (official mechanism)
✅ Replaces hardcoded build-time path with runtime path
✅ Faster - uses system nix when available (native runtime)
✅ Falls back gracefully to wrapper script that extracts nix
✅ One-time detection, saved for future runs
✅ Clear user feedback via stderr messages
✅ Works on both NixOS and Ubuntu with Nix

## Technical Notes

- `NP_RUN` format: Command that will be prepended before nix binary and args
- We use `exec` to replace the process entirely (more efficient)
- Configuration is saved in `~/.nix-portable-sanzenvim/.np_runtime` and `.np_nix`
- On subsequent runs, `NP_RUN` is reconstructed from saved path
- Wrapper script handles lazy extraction of nix binary on first use
- The `.bootstrapped` marker prevents re-running detection logic

## Debugging

Enable debug mode to see what's happening:
```bash
NP_DEBUG=2 ./bundle/bin/nvim --version
```

This will show:
- Which runtime is selected
- The exact `NP_RUN` command being used
- Bootstrap detection and workaround application
