# How to Use the Universal Bundle

## Quick Start

### Build Command

```bash
nix bundle --bundler .#simple -o bundle .#unwrapped --impure
```

This creates a portable `bundle/bin/nvim` that works on **all Linux systems**.

## Usage Scenarios

### Scenario 1: Regular Linux System (No Nix Installed)

The bundle is **completely self-contained** and requires no dependencies.

```bash
# Download or copy the bundle to your system
./bundle/bin/nvim

# That's it! nvim runs with all built-in features
```

**What happens:**
- The bundle automatically extracts and runs nix-portable
- All dependencies are bundled inside
- LSPs can be installed via system package managers (apt, dnf, etc.)
- LSPs installed via npm, pip, cargo, etc. work automatically

**Example with system LSPs:**
```bash
# Install LSPs using your package manager
sudo apt install lua-language-server  # Ubuntu/Debian
npm install -g typescript-language-server  # via npm
cargo install rust-analyzer  # via cargo

# Run nvim - it will find and use these LSPs
./bundle/bin/nvim myfile.lua
```

### Scenario 2: Nix System (With Nix Installed)

The bundle **automatically detects Nix** and enables environment LSP access!

```bash
# Use LSPs from nix-shell
nix-shell -p lua-language-server nil rust-analyzer
./bundle/bin/nvim myfile.lua
# LSPs from nix-shell are automatically available!

# Or use globally installed LSPs
nix-env -i lua-language-server
./bundle/bin/nvim myfile.lua
# Works perfectly!

# Or use direnv with a shell.nix
cd my-project  # has shell.nix with LSPs
direnv allow
./bundle/bin/nvim myfile.lua
# Project-specific LSPs work!
```

**What happens:**
- Bundle detects `/nix/store` exists
- Creates wrapper scripts in `~/.cache/sanzenvim-portable/lsp-wrappers/`
- Wrappers exec LSPs from nix-shell, nix-env, or direnv
- LSPs work seamlessly inside the portable environment

## Advanced Usage

### Custom Cache Location

```bash
# Change where the bundle extracts itself
XDG_CACHE_HOME=/custom/path ./bundle/bin/nvim

# Or use the SANZENVIM_NP_LOCATION variable
SANZENVIM_NP_LOCATION=/custom/path ./bundle/bin/nvim
```

### Checking What LSPs Are Detected

On a Nix system, after first run:

```bash
ls ~/.cache/sanzenvim-portable/lsp-wrappers/
# Shows which LSPs were auto-detected and wrapped
```

### Supported LSPs (Auto-detected)

The bundle automatically creates wrappers for these LSPs if found in PATH:
- `lua-language-server` (Lua)
- `nil` (Nix)
- `rust-analyzer` (Rust)
- `clangd` (C/C++)
- `vscode-json-language-server` (JSON)
- `vscode-css-language-server` (CSS)
- `typescript-language-server` (TypeScript/JavaScript)
- `pyright`, `pylsp` (Python)
- `jdtls` (Java)
- `kotlin-language-server` (Kotlin)
- `gopls` (Go)
- `zls` (Zig)
- `marksman` (Markdown)
- `yaml-language-server` (YAML)

## Comparison with Standard Bundle

### Standard nix-portable bundle (GitHub Actions default):
```bash
nix bundle --bundler github:DavHau/nix-portable -o bundle .#unwrapped
```
- ✅ Fully portable (works without Nix)
- ❌ Cannot access nix-shell LSPs (proot sandbox blocks /nix/store)
- ✅ Can access system-path LSPs (npm, pip, apt, etc.)

### Universal bundle (new simple bundler):
```bash
nix bundle --bundler .#simple -o bundle .#unwrapped --impure
```
- ✅ Fully portable (works without Nix)
- ✅ **CAN access nix-shell LSPs** (via wrapper mechanism)
- ✅ Can access system-path LSPs (npm, pip, apt, etc.)

## Troubleshooting

### LSPs not found on Nix system

1. Verify LSPs are in PATH:
   ```bash
   nix-shell -p lua-language-server
   which lua-language-server  # Should show a path
   ```

2. Check if wrappers were created:
   ```bash
   ls ~/.cache/sanzenvim-portable/lsp-wrappers/
   ```

3. Run nvim with debug to see PATH:
   ```bash
   ./bundle/bin/nvim --headless -c 'lua print(vim.env.PATH)' -c 'quit'
   ```

### Clear cache and restart

```bash
rm -rf ~/.cache/sanzenvim-portable
rm -rf ~/.nix-portable-sanzenvim
./bundle/bin/nvim  # Fresh start
```

## Why This Approach?

The universal bundle solves a fundamental limitation of nix-portable:

**The Problem:** Nix-portable uses proot to create a sandboxed environment. Proot binds the portable's `/nix` directory over the host's `/nix`, preventing access to LSPs installed via `nix-shell` or `nix-env`.

**The Solution:** Instead of trying to modify proot's bindings, we create wrapper scripts in `~/.cache` (which IS accessible from the sandbox). These wrappers execute the host's LSP binaries, giving full access to environment LSPs while maintaining portability.

**Result:** One bundle that works everywhere, adapting automatically to the host environment!
