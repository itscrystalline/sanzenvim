_: {
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>g";
      action = '':silent! !zellij action new-pane -f --width 80\% --height 80\% -c -- lazygit<CR>'';
      silent = true;
      desc = "open lazygit in zellij float";
    }
  ];
}
