# Bootstrap Fix for nix-portable

## Problem

When running the nix-portable bundle on a system with `/nix/store`, nix-portable encounters the error:

```
Fatal error: nix is unable to build packages
```

This happens because:
1. The bundle is built with a hardcoded nix binary path (e.g., `/nix/store/XXX-nvf-with-helpers/bin/nix`)
2. nix-portable expects to find the nix binary in the same directory as nvim
3. But in our bundle, nix and nvim are in separate store paths
4. On systems with `/nix/store`, the bootstrap check tries to use the hardcoded path and fails

## Solution

Create a symlink to the actual nix binary where nix-portable expects to find it.

### How It Works

**nix-portable's assumption:**
- If nvim is at `/nix/store/XXX-nvf-with-helpers/bin/nvim`
- Then nix must be at `/nix/store/XXX-nvf-with-helpers/bin/nix`

**Our bundle's reality:**
- nvim is at `/nix/store/XXX-nvf-with-helpers/bin/nvim`
- nix is at `/nix/store/YYY-nix-2.20.6/bin/nix` (different store path!)

**The fix:**
- On first run, detect the `/nix/store` directory
- Run bundle once to extract the embedded store to `~/.nix-portable/nix/store`
- Find the actual nix binary in the extracted store
- Create symlink: `~/.nix-portable/nix/store/XXX-nvf-with-helpers/bin/nix` → actual nix binary
- Bootstrap check now succeeds because nix is found where expected

### Code Implementation

The wrapper script (`simple-bundler.nix`) implements this logic:

1. Checks if `/nix/store` exists and is non-empty
2. Creates configuration directory `~/.nix-portable-sanzenvim/`
3. On first run (if `.bootstrapped` marker doesn't exist):
   - Runs the bundle once to extract the store (output suppressed)
   - Finds the actual nix binary: `find ~/.nix-portable/nix/store -name "nix" -type f`
   - Finds the nvf-with-helpers directory
   - Creates symlink: `nvf-with-helpers/bin/nix` → actual nix binary location
   - Creates `.bootstrapped` marker file
4. On subsequent runs: Symlink already exists, bundle works normally

### Testing

You can verify the workaround is working with debug output:

```bash
NP_DEBUG=1 ./bundle/bin/nvim --version
```

Expected output:
```
Applying bootstrap workaround...
Bootstrap workaround applied: created nix symlink
Testing if nix can build stuff without sandbox
[nix successfully builds test derivation]
NVIM v0.11.5
...
```

## Why This Works

nix-portable derives the nix binary path from the nvim binary path:

```bash
nixBin=$(dirname $nvimBin)/nix
```

By creating a symlink at the expected location pointing to the actual nix binary, we satisfy nix-portable's assumption without modifying its code. The bootstrap check succeeds because:

1. nix-portable extracts the embedded store to `~/.nix-portable/nix/store`
2. It binds this to `/nix/store` inside its sandbox (proot/bwrap)
3. It tries to run `/nix/store/XXX-nvf-with-helpers/bin/nix`
4. Our symlink redirects this to the actual nix binary
5. Bootstrap test passes, nvim runs successfully

## Implementation Details

- Symlink is created in `~/.nix-portable/nix/store` (the extracted store)
- Inside the sandbox, paths resolve correctly due to bind mounting
- No system modifications required (everything in user's home directory)
- Works on both NixOS and regular Linux with `/nix/store`
- LSP wrappers still work as before, giving access to host LSPs

## User Experience

**First run on a system with /nix/store:**
```bash
$ ./bundle/bin/nvim --version
Applying bootstrap workaround...
Bootstrap workaround applied: created nix symlink
Installing git. Disable this by specifying the git executable path with 'NP_GIT'
[downloads git and dependencies]
NVIM v0.11.5
...
```

**Subsequent runs:**
```bash
$ ./bundle/bin/nvim --version
NVIM v0.11.5
...
```

Silent - no workaround messages, instant startup.

## Debugging

Enable debug mode to see what's happening:
```bash
NP_DEBUG=2 ./bundle/bin/nvim --version
```

This will show:
- Which runtime is selected (proot/bwrap)
- The nix binary path being used
- Bootstrap check execution
- Success or failure of the bootstrap test
