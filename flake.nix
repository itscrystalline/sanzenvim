{
  description = "sanzenvim (燦然vim)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    my-nur.url = "github:itscrystalline/nur-packages";

    # clangd-fix.url = "github:nixos/nixpkgs?ref=pull/462747/head";
  };
  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    my-nur,
    nixpkgs-stable,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_: prev: {
            inherit (nixpkgs-stable.legacyPackages.${prev.system}) clang-tools;
          })
        ];
      };

      nvim = full:
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit nvf my-nur full;};
          modules = [
            ./options.nix
            ./neovide.nix
            ./keymaps.nix
            ./visuals
            ./utilities
            ./languages

            ./lua-post.nix
          ];
        }).neovim;
    in {
      packages.default = nvim true;
      packages.mini = nvim false;
    });
}
