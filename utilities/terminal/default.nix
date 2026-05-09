_: {
  imports = [
    ./lazygit.nix
  ];
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>n";
      action = '':silent! !zellij action new-pane -f --width 80\% --height 60\%<CR>'';
      silent = true;
      desc = "Toggle zellij terminal";
    }
  ];
}
