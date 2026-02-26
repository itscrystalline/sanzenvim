{
  description = "sanzenvim (燦然vim)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    my-nur = {
      url = "github:itscrystalline/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-portable = {
      url = "github:DavHau/nix-portable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    my-nur,
    nix-portable,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      armCrossPkgs = (import nixpkgs {inherit system;}).pkgsCross.aarch64-multiplatform;
      pkgs = withCross:
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
          pkgs = pkgs crossCompilex86_64ToArm;
          extraSpecialArgs = {inherit nvf my-nur full;};
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
      packages = {
        default = nvim {};
        mini = nvim {full = false;};
        unwrapped = nvim {extraModules = [./unwrapped.nix];};

        defaultCross = nvim {crossCompilex86_64ToArm = true;};
        miniCross = nvim {
          full = false;
          crossCompilex86_64ToArm = true;
        };
        unwrappedCross = nvim {
          extraModules = [./unwrapped.nix];
          crossCompilex86_64ToArm = true;
        };
      };

      bundlers.simple = drv:
        (import ./simple-bundler.nix) {
          inherit pkgs;
          nix-portable-bundler = nix-portable.bundlers.${system}.default;
        }
        drv;
    });
}
