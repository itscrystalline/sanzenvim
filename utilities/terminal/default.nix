{...}: {
  imports = [
    ./lazygit.nix
  ];
  vim.terminal.toggleterm = {
    enable = true;
  };
}
