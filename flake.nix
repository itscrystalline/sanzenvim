{
  description = "sanzenvim (燦然vim)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    my-nur.url = "github:itscrystalline/nur-packages";
  };
  outputs = {
    nixpkgs,
    flake-utils,
    nvf,
    my-nur,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages.default =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit nvf my-nur;};
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
    });
}
