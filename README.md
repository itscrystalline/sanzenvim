# sanzenvim (燦然vim)

Portable Neovim configuration built with [nvf](https://github.com/notashelf/nvf).

## Download

Pre-built universal bundles are available for download:

| Binary                 | Link                                                                                               |
| ---------------------- | -------------------------------------------------------------------------------------------------- |
| sanzenvim-full-x86_64  | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-full-x86_64.zip |
| sanzenvim-full-aarch64 | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-full-aarch64.zip |
| sanzenvim-mini-x86_64  | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-mini-x86_64.zip |
| sanzenvim-mini-aarch64 | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-mini-aarch64.zip |

## Build from Source

```bash
nix bundle --bundler .#simple -o bundle .#unwrapped
```

This creates a portable `bundle/bin/nvim` that works on **all Linux systems**.

## Usage

The universal bundle works on both systems **with** and **without** Nix installed.

### On Regular Linux (No Nix)

The bundle is completely self-contained:

```bash
# Download and extract the bundle
./bundle/bin/nvim
```

Install LSPs via your package manager:
```bash
sudo apt install lua-language-server  # Ubuntu/Debian
npm install -g typescript-language-server  # via npm
cargo install rust-analyzer  # via cargo
```

### On Nix Systems

The bundle automatically detects Nix and enables environment LSP access:

```bash
# Use LSPs from nix-shell
nix-shell -p lua-language-server rust-analyzer
./bundle/bin/nvim myfile.lua

# Use globally installed LSPs
nix-env -i lua-language-server
./bundle/bin/nvim myfile.lua

# Use direnv with shell.nix
cd my-project  # has shell.nix with LSPs
direnv allow
./bundle/bin/nvim myfile.lua
```

**How it works:** The bundle detects `/nix/store`, creates wrapper scripts in `~/.cache/sanzenvim-portable/lsp-wrappers/`, and executes host LSP binaries, bypassing the proot sandbox. On Nix systems, a bootstrap workaround is **automatically applied** on first run to ensure the bundle works correctly.

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

## Advanced Usage

### Custom Cache Location

```bash
XDG_CACHE_HOME=/custom/path ./bundle/bin/nvim
# Or
SANZENVIM_NP_LOCATION=/custom/path ./bundle/bin/nvim
```

### Check Detected LSPs

```bash
ls ~/.cache/sanzenvim-portable/lsp-wrappers/
```

### Clear Cache

```bash
rm -rf ~/.cache/sanzenvim-portable
rm -rf ~/.nix-portable-sanzenvim
```

## Troubleshooting

### LSPs not found on Nix system

1. Verify LSPs are in PATH:
   ```bash
   nix-shell -p lua-language-server
   which lua-language-server
   ```

2. Check if wrappers were created:
   ```bash
   ls ~/.cache/sanzenvim-portable/lsp-wrappers/
   ```

3. Debug PATH:
   ```bash
   ./bundle/bin/nvim --headless -c 'lua print(vim.env.PATH)' -c 'quit'
   ```

### Bootstrap Issues

If you encounter "Fatal error: nix is unable to build packages", see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed workarounds and solutions.

### Clear Cache

```bash
rm -rf ~/.cache/sanzenvim-portable
rm -rf ~/.nix-portable-sanzenvim
```

For more detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Technical Details

The universal bundle uses a wrapper approach to solve nix-portable's proot sandbox limitation:

- **Problem:** Proot binds the portable's `/nix` over the host's `/nix`, blocking access to LSPs from `nix-shell` or `nix-env`
- **Solution:** Wrapper scripts in `~/.cache` (accessible from the sandbox) execute host LSP binaries
- **Result:** One bundle that works everywhere, adapting automatically to the environment
