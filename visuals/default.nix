{
  # pkgs,
  lib,
  # config,
  # options,
  ...
}: {
  imports = [
    ./fidget.nix
    ./rainbow-delimiters.nix
    ./cinnamon-nvim.nix
  ];
}
