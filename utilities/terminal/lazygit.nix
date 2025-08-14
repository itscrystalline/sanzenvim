{...}: {
  vim.terminal.toggleterm.lazygit = {
    enable = true;
    direction = "float";
    mappings = {
      open = "<leader>gg";
    };
  };
}
