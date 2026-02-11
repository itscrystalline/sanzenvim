# sanzenvim (燦然vim)

Portable Neovim configuration built with [nvf](https://github.com/notashelf/nvf).

## Download

| Binary                 | Link                                                                                               |
| ---------------------- | -------------------------------------------------------------------------------------------------- |
| sanzenvim-full-x86_64  | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-full-x86_64.zip |
| sanzenvim-full-aarch64 | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-full-aarch64.zip |
| sanzenvim-mini-x86_64  | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-mini-x86_64.zip |
| sanzenvim-mini-aarch64 | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-mini-aarch64.zip |

## Build

```bash
nix bundle --bundler .#simple -o bundle .#unwrapped
```

## Usage

### Regular Linux (No Nix)

```bash
./bundle/bin/nvim
```

Install LSPs via package manager (npm, pip, cargo, apt) and they'll be auto-detected.

### Nix Systems

```bash
nix-shell -p lua-language-server rust-analyzer
./bundle/bin/nvim myfile.lua
```

The bundle detects `/nix/store` and creates LSP wrappers in `~/.cache/sanzenvim-portable/lsp-wrappers/` to access host LSPs.

### Supported LSPs

Auto-detected if in PATH: `lua-language-server`, `nil`, `rust-analyzer`, `clangd`, `typescript-language-server`, `pyright`, `pylsp`, `jdtls`, `gopls`, `zls`, `marksman`, `yaml-language-server`, and more.

## Troubleshooting

### Bootstrap Error

If you see "Fatal error: nix is unable to build packages":
- The bundle automatically fixes this on first run
- Verify fix: `ls ~/.nix-portable-sanzenvim/.bootstrapped`

### LSPs Not Detected

1. Check PATH: `which lua-language-server`
2. Check wrappers: `ls ~/.cache/sanzenvim-portable/lsp-wrappers/`
3. Clear cache and retry:
   ```bash
   rm -rf ~/.cache/sanzenvim-portable ~/.nix-portable-sanzenvim
   ```
