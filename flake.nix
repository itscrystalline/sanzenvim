{
  description = "sanzenvim (燦然vim)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-portable = {
      url = "github:DavHau/nix-portable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    nix-portable,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      armCrossPkgs = (import nixpkgs {inherit system;}).pkgsCross.aarch64-multiplatform;
      pkgsfn = withCross:
        import nixpkgs {
          inherit system;
          overlays =
            if withCross
            then [
              (_: _: {
                inherit (armCrossPkgs) rustPlatform;
              })
            ]
            else [];
        };

      nvim = {
        full ? true,
        extraModules ? [],
        crossCompilex86_64ToArm ? false,
      }:
        (nvf.lib.neovimConfiguration {
          pkgs = pkgsfn crossCompilex86_64ToArm;
          extraSpecialArgs = {inherit nvf full;};
          modules =
            [
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
      packages = rec {
        default = nvim {};
        mini = nvim {full = false;};
        unwrapped = nvim {extraModules = [./generators/unwrapped.nix];};
        lua = import ./generators/lua.nix {
          unwrapped = nvim {
            extraModules = [
              ./generators/unwrapped.nix
              ({lib, ...}: {
                vim.autocomplete.blink-cmp.setupOpts.fuzzy.prebuilt_binaries.download = lib.mkForce true;
              })
            ];
          };
          pkgs = pkgsfn false;
        };

        defaultCross = nvim {crossCompilex86_64ToArm = true;};
        miniCross = nvim {
          full = false;
          crossCompilex86_64ToArm = true;
        };
        unwrappedCross = nvim {
          extraModules = [./generators/unwrapped.nix];
          crossCompilex86_64ToArm = true;
        };
      };

      bundlers.simple = drv: let
        pkgs = pkgsfn false;
      in
        (import ./generators/simple-bundler.nix) {
          inherit pkgs;
          nix-portable-bundler = nix-portable.bundlers.${system}.default;
        }
        drv;
    });
}
