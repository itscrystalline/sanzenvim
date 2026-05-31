{
  description = "sanzenvim (燦然vim)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # FIXME: wait till https://github.com/NotAShelf/nvf/pull/1519 merges to remove
    nvf-cord-pr = {
      url = "github:notashelf/nvf/pull/1519/head";
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
      url = "git+https://git.iw2tryhard.dev/itscrystalline/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    nvf-cord-pr,
    nix-portable,
    upstream-nur,
    my-nur,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nur = (import upstream-nur {inherit pkgs;}) // {repos.itscrystalline = import my-nur {inherit pkgs;};};

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
              ./options.nix
              ./neovide.nix
              ./keymaps.nix
              ./visuals
              ./utilities
              ./languages

              ./lua-post.nix

              ./generators/pick-local-lsp.nix

              # FIXME: wait till https://github.com/NotAShelf/nvf/pull/1519 merges to remove
              "${nvf-cord-pr}/modules/plugins/rich-presence/cord-nvim/config.nix"
              "${nvf-cord-pr}/modules/plugins/rich-presence/cord-nvim/cord-nvim.nix"
              "${nvf-cord-pr}/modules/plugins/rich-presence/cord-nvim/default.nix"
              ({lib, ...}: {
                disabledModules = ["modules/plugins/rich-presence/default.nix"];
                config.vim.lazy.plugins.cord-nvim = lib.mkIf full {package = lib.mkForce nvf-cord-pr.packages.${system}.cord-nvim;};
              })
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
