# Testing the Bootstrap Workaround Fix

This document provides step-by-step instructions to test the bootstrap workaround fix in different environments.

## Quick Test

```bash
# 1. Build the bundle
nix bundle --bundler .#simple -o bundle .#unwrapped

# 2. Run the test script
./test-bootstrap-fix.sh bundle/bin/nvim
```

## Manual Testing in Different Environments

### Test 1: NixOS or System with Nix Installed

**Setup:**
```bash
docker run -it --rm -v $(pwd)/bundle:/bundle nixos/nix bash
```

**Expected behavior:**
- Bundle detects system nix
- Sets `NP_RUNTIME=nix` and `NP_RUN="exec /usr/bin/nix"`
- No extraction needed, uses system nix directly
- Bootstrap message: "Using system nix at: /usr/bin/nix (via NP_RUN)"

**Test commands:**
```bash
# Enable debug mode
export NP_DEBUG=2

# Run bundle
/bundle/bin/nvim --version

# Check what was configured
cat ~/.nix-portable-sanzenvim/.np_runtime  # Should show: nix
cat ~/.nix-portable-sanzenvim/.np_nix      # Should show: /usr/bin/nix or similar

# Verify environment
env | grep NP_                             # Should show NP_RUNTIME=nix and NP_RUN
```

**Success criteria:**
- ✓ Bundle runs without "Fatal error: nix is unable to build packages"
- ✓ Bootstrap message shows system nix being used
- ✓ `.np_runtime` contains "nix"
- ✓ `.np_nix` contains path to system nix (e.g., `/usr/bin/nix`)

### Test 2: Ubuntu with Nix Installed

**Setup:**
```bash
# Install Nix on Ubuntu
docker run -it --rm ubuntu:24.04 bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
source /etc/profile

# Copy bundle to container
# (mount volume or use docker cp)
```

**Expected behavior:**
- Same as Test 1 (system nix detected and used)

**Test commands:**
```bash
export NP_DEBUG=1
/path/to/bundle/bin/nvim --version
ls -la ~/.nix-portable-sanzenvim/
cat ~/.nix-portable-sanzenvim/.np_*
```

### Test 3: Bare Ubuntu (No Nix)

**Setup:**
```bash
docker run -it --rm -v $(pwd)/bundle:/bundle ubuntu:24.04 bash
```

**Expected behavior:**
- No system nix detected
- Creates wrapper script at `~/.nix-portable-sanzenvim/bin/nix-wrapper`
- Wrapper extracts nix from bundle on first call
- Sets `NP_RUNTIME=bwrap` and `NP_RUN="exec ~/.nix-portable-sanzenvim/bin/nix-wrapper"`
- Bootstrap message: "Using extracted nix via wrapper (via NP_RUN)"

**Test commands:**
```bash
# First run - should show bootstrap
/bundle/bin/nvim --version 2>&1 | grep -E "Applying bootstrap|Using extracted|Bootstrap workaround"

# Check what was created
ls -la ~/.nix-portable-sanzenvim/bin/
cat ~/.nix-portable-sanzenvim/.np_runtime  # Should show: bwrap
cat ~/.nix-portable-sanzenvim/.np_nix      # Should show: wrapper path

# Verify wrapper is executable
~/.nix-portable-sanzenvim/bin/nix-wrapper --version

# Second run - should be silent
/bundle/bin/nvim --version
```

**Success criteria:**
- ✓ Bundle runs successfully
- ✓ Wrapper script created at `~/.nix-portable-sanzenvim/bin/nix-wrapper`
- ✓ Nix binary extracted to `~/.nix-portable-sanzenvim/bin/nix`
- ✓ `.np_runtime` contains "bwrap"
- ✓ Wrapper is executable and works

### Test 4: Debugging with NP_DEBUG

**Enable maximum debug output:**
```bash
NP_DEBUG=2 /bundle/bin/nvim --version 2>&1 | tee debug.log
```

**What to look for in debug.log:**
```
+ NP_RUNTIME=nix
+ NP_RUN=exec /usr/bin/nix
...
executable is hardcoded to: /nix/store/xxx/bin/nvim
...
Testing if nix can build stuff without sandbox
...
```

**Verify:**
- `NP_RUNTIME` is set (should be "nix" or "bwrap")
- `NP_RUN` is set (should be "exec /path/to/nix" or "exec /path/to/nix-wrapper")
- No "Fatal error: nix is unable to build packages" message

### Test 5: Clean State Test

**Test bootstrap from scratch:**
```bash
# Remove previous bootstrap
rm -rf ~/.nix-portable-sanzenvim ~/.cache/sanzenvim-portable

# Run and observe bootstrap messages
/bundle/bin/nvim --version 2>&1

# Verify files were created
ls -la ~/.nix-portable-sanzenvim/
cat ~/.nix-portable-sanzenvim/.bootstrapped
```

## Expected Test Results

### On NixOS / Ubuntu with Nix

```
Applying bootstrap workaround...
Using system nix at: /usr/bin/nix (via NP_RUN)
Bootstrap workaround applied successfully
NVIM v0.11.5
Build type: Release
...
```

Files created:
```
~/.nix-portable-sanzenvim/
├── .bootstrapped
├── .np_runtime  (contains: nix)
└── .np_nix      (contains: /usr/bin/nix or similar)
```

### On Bare Ubuntu (No Nix)

```
Applying bootstrap workaround...
Using extracted nix via wrapper (via NP_RUN)
Bootstrap workaround applied successfully
NVIM v0.11.5
Build type: Release
...
```

Files created:
```
~/.nix-portable-sanzenvim/
├── .bootstrapped
├── .np_runtime  (contains: bwrap)
├── .np_nix      (contains: /home/user/.nix-portable-sanzenvim/bin/nix-wrapper)
└── bin/
    ├── nix-wrapper  (wrapper script)
    └── nix          (extracted nix binary)
```

## Troubleshooting

**If you see "Fatal error: nix is unable to build packages":**
1. Enable debug: `NP_DEBUG=2 /bundle/bin/nvim --version`
2. Check if `NP_RUN` is being set
3. Verify the nix binary/wrapper exists and is executable
4. Clean state and retry: `rm -rf ~/.nix-portable-sanzenvim`

**If bootstrap workaround doesn't apply:**
1. Check if `/nix/store` exists: `ls /nix/store`
2. The workaround only applies on systems with Nix
3. On bare systems, the bundle should work without workaround

**If wrapper script fails:**
1. Check bundle exists: `ls -lh ~/.cache/sanzenvim-portable/nvim-portable`
2. Verify unzip is available: `which unzip`
3. Try manual extraction: `unzip -l ~/.cache/sanzenvim-portable/nvim-portable | grep bin/nix`

## Reporting Results

When reporting test results, include:

1. **Environment:** (NixOS / Ubuntu with Nix / Bare Ubuntu)
2. **Command:** The exact command you ran
3. **Output:** Both stdout and stderr
4. **Files created:** Contents of `~/.nix-portable-sanzenvim/`
5. **Success/Failure:** Did the bundle run without errors?
6. **Debug log:** If using `NP_DEBUG=2`, attach the full log

Example report:
```
Environment: Ubuntu 24.04 with Nix installed
Command: NP_DEBUG=1 bundle/bin/nvim --version
Success: ✓

Output:
Applying bootstrap workaround...
Using system nix at: /usr/bin/nix (via NP_RUN)
Bootstrap workaround applied successfully
NVIM v0.11.5

Files:
~/.nix-portable-sanzenvim/.np_runtime: nix
~/.nix-portable-sanzenvim/.np_nix: /usr/bin/nix
```
