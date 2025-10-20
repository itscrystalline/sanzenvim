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
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

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
