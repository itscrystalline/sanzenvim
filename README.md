# sanzenvim (燦然vim)

Portable Neovim configuration built with
[nvf](https://github.com/notashelf/nvf).

## Download

| Binary                 | Link                                                                                               |
| ---------------------- | -------------------------------------------------------------------------------------------------- |
| sanzenvim-full-x86_64  | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-full-x86_64.zip  |
| sanzenvim-full-aarch64 | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-full-aarch64.zip |
| sanzenvim-mini-x86_64  | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-mini-x86_64.zip  |
| sanzenvim-mini-aarch64 | https://nightly.link/itscrystalline/sanzenvim/workflows/build.yaml/main/sanzenvim-mini-aarch64.zip |

---

| Lua Config | Link                                                                                                         |
| ---------- | ------------------------------------------------------------------------------------------------------------ |
| x86_64     | https://nightly.link/itscrystalline/sanzenvim/workflows/export-lua.yaml/main/sanzenvim-lua-linux-aarch64.zip |
| aarch64    | https://nightly.link/itscrystalline/sanzenvim/workflows/export-lua.yaml/main/sanzenvim-lua-linux-aarch64.zip |

Lua config requires compiling `telescope-fzf-native` manually.

```shell
cd /path/to/sanzenvim/pack/mnw/start/telescope-fzf-native.nvim
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```
