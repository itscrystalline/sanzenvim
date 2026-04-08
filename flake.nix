{
  description = "sanzenvim (燦然vim)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-portable = {
      url = "github:DavHau/nix-portable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    upstream-nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nur = {
      url = "github:itscrystalline/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    nvf,
    nix-portable,
    upstream-nur,
    my-nur,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs-stable = import nixpkgs-stable {inherit system;};
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_: _: {
            # FIXME: wait until unstable.aarch64-linux.deno builds successfully to remove
            inherit (pkgs-stable) deno;
          })
        ];
      };
      nur = (import upstream-nur {inherit pkgs;}) // {repos.itscrystalline = import my-nur {inherit pkgs;};};

      inherit (pkgs-stable) neovim-unwrapped;

      nvim = {
        full ? true,
        icons ? full,
        extraModules ? [],
      }:
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit nur nvf full icons;};
          modules =
            [
              {vim.package = neovim-unwrapped;}

              ./options.nix
              ./neovide.nix
              ./keymaps.nix
              ./visuals
              ./utilities
              ./languages

              ./lua-post.nix
            ]
            ++ extraModules;
        }).neovim;
    in {
      packages = {
        default = nvim {};
        mini = nvim {full = false;};
        unwrapped = nvim {extraModules = [./generators/unwrapped.nix];};
        lua = import ./generators/lua.nix {
          inherit pkgs;
          unwrapped = nvim {
            full = true;
            extraModules = [
              ./generators/unwrapped.nix
              ({lib, ...}: {
                vim.autocomplete.blink-cmp.setupOpts.fuzzy = {
                  prebuilt_binaries.download = lib.mkForce true;
                  implementation = lib.mkForce "lua";
                };
              })
            ];
          };
        };
      };

      bundlers.simple = drv:
        (import ./generators/simple-bundler.nix) {
          inherit pkgs;
          nix-portable-bundler = nix-portable.bundlers.${system}.default;
        }
        drv;
    });
}
