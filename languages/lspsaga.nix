{...}: {
  vim.lsp.lspsaga = {
    enable = true;
    setupOpts = {
      ui = {
        border = "rounded"; # One of none, single, double, rounded, solid, shadow
        code_action = "💡"; # Can be any symbol you want 💡
      };
      diagnostic = {
        border_follow = true;
        diagnostic_only_current = false;
        show_code_action = true;
        keys = {
          quit = ["q" "<ESC>"];
        };
      };
      hover = {
        open_cmd = "!zen"; # Choose your browser
        open_link = "gx";
      };
      rename.in_select = false;
    };
  };
}
