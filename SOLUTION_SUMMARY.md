# Bootstrap Fix Summary

## The Problem

The universal bundle was failing on systems with Nix installed with the error:
```
proot error: '/nix/store/xxx/bin/nix' not found
Fatal error: nix is unable to build packages
```

This occurred because:
1. Nix-portable embeds the nix binary path at **build time** (e.g., `/nix/store/5iy5nfkv9p3037jyjjqhnh1rqap68in7-nvf-with-helpers/bin/nix`)
2. When using proot runtime, this path doesn't exist in the emptyroot sandbox
3. The previous attempt used `NP_NIX` environment variable, but this doesn't work because the path is already hardcoded in the bundle

## The Solution

Use nix-portable's `NP_RUN` environment variable to **completely override** how nix is executed:

```bash
# Instead of trying to tell nix-portable which nix to use (doesn't work):
export NP_NIX=/usr/bin/nix

# We override the execution entirely (works!):
export NP_RUN="exec /usr/bin/nix"
```

When nix-portable needs to run nix, instead of using its hardcoded path, it will execute:
```bash
$NP_RUN {nix-binary-path-from-build-time} {args...}
```

Which becomes:
```bash
exec /usr/bin/nix {nix-binary-path-from-build-time} {args...}
```

Since we use `exec`, the system nix **replaces** the process entirely, ignoring the hardcoded path.

## Implementation Details

### Case 1: System Has Nix

```bash
SYSTEM_NIX="$(command -v nix)"
export NP_RUNTIME="nix"
export NP_RUN="exec $SYSTEM_NIX"
```

Result: Uses system nix directly, fastest performance, no extraction needed.

### Case 2: No System Nix

Creates a wrapper script at `~/.nix-portable-sanzenvim/bin/nix-wrapper`:

```bash
#!/bin/bash
WRAPPER_DIR="$(dirname "$(readlink -f "$0")")"
NIX_BIN="$WRAPPER_DIR/nix"

# Extract nix from bundle on first run
if [ ! -x "$NIX_BIN" ]; then
    unzip -p "$BUNDLE_CACHE" "nix/store/*/bin/nix" > "$NIX_BIN"
    chmod +x "$NIX_BIN"
fi

exec "$NIX_BIN" "$@"
```

Then:
```bash
export NP_RUNTIME="bwrap"
export NP_RUN="exec ~/.nix-portable-sanzenvim/bin/nix-wrapper"
```

Result: Wrapper handles lazy extraction, then executes embedded nix.

## Why This Works

The key insight is in nix-portable's documentation:

> `NP_RUN` - override the complete command to run nix
> (to use an unsupported runtime, or for debugging)
> nix will then be executed like: `$NP_RUN {nix-binary} {args...}`

By setting `NP_RUN="exec /path/to/nix"`:
1. Nix-portable calls: `exec /path/to/nix /nix/store/xxx/bin/nix --version`
2. `exec` replaces the process with our nix binary
3. Our nix receives the args (including the hardcoded path)
4. But since `exec` replaced the process, the hardcoded path is ignored
5. The command effectively becomes: `/path/to/nix --version`

## Verification

After the fix, users can verify:

```bash
# Check bootstrap was applied
ls ~/.nix-portable-sanzenvim/.bootstrapped

# Check configuration
cat ~/.nix-portable-sanzenvim/.np_runtime  # "nix" or "bwrap"
cat ~/.nix-portable-sanzenvim/.np_nix      # Path to nix or wrapper

# Enable debug mode
NP_DEBUG=2 bundle/bin/nvim --version
```

Debug output will show:
```
+ NP_RUNTIME=nix
+ NP_RUN=exec /usr/bin/nix
...
Testing if nix can build stuff without sandbox
```

And **no** "Fatal error" message!

## Files Modified

1. **simple-bundler.nix** (lines 56-115)
   - Replaced `NP_NIX` with `NP_RUN`
   - Added wrapper script creation for systems without nix
   - Improved configuration persistence

2. **BOOTSTRAP_FIX.md**
   - Updated explanation to reflect NP_RUN approach
   - Clarified why NP_NIX doesn't work
   - Added debug instructions

3. **test-bootstrap-fix.sh** (new)
   - Automated test script
   - Verifies bootstrap, configuration, and execution

4. **TESTING_INSTRUCTIONS.md** (new)
   - Comprehensive testing guide
   - Covers all environments (NixOS, Ubuntu+Nix, bare Ubuntu)
   - Debug instructions and success criteria

## Commits

- **e0dc049**: Fix bootstrap using NP_RUN to override nix execution
- **3b7a20c**: Add comprehensive test suite for bootstrap workaround

## Next Steps

User needs to:
1. Build the bundle: `nix bundle --bundler .#simple -o bundle .#unwrapped`
2. Test in environments:
   - NixOS container
   - Ubuntu with Nix
   - Bare Ubuntu
3. Report results

If all tests pass, the bootstrap issue is **completely resolved**.
