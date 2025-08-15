{
  # pkgs,
  lib,
  # config,
  # options,
  ...
}: {
  imports = [
    ./catppuccin.nix
    ./fidget.nix
    ./rainbow-delimiters.nix
    ./cinnamon-nvim.nix
    ./bufferline.nix
    ./alpha.nix
  ];
}
