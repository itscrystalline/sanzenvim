{
  # pkgs,
  lib,
  # config,
  # options,
  ...
}: {
  imports = [
    ./catppuccin.nix
  ];
  vim.lazy = {
    enable = true;
  };
}
