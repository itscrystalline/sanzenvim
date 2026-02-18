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
    codeshot-nvim = {
      url = "github:SergioRibera/codeshot.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sss = {
      url = "github:SergioRibera/sss";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    my-nur,
    nix-portable,
    codeshot-nvim,
    sss,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        # overlays = [
        #   (_: prev: rec {
        #     hostsys = prev.stdenv.hostPlatform.system;
        #     inherit (nixpkgs-stable.legacyPackages.${hostsys}) clang-tools;
        #   })
        # ];
      };

      nvim = full: extraModules:
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit nvf my-nur full codeshot-nvim sss;};
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
      packages.default = nvim true [];
      packages.mini = nvim false [];
      packages.unwrapped = nvim true [./unwrapped.nix];

      bundlers.simple = drv:
        (import ./simple-bundler.nix) {
          inherit pkgs;
          nix-portable-bundler = nix-portable.bundlers.${system}.default;
        }
        drv;
    });
}
