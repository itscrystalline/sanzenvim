{full, ...}: {
  vim.lsp.lspsaga = {
    enable = true;
    setupOpts = {
      ui = {
        border = "rounded"; # One of none, single, double, rounded, solid, shadow
        code_action =
          if full
          then "💡"
          else "!!"; # Can be any symbol you want 💡
      };
      diagnostic = {
        border_follow = true;
        diagnostic_only_current = false;
        show_code_action = true;
        keys = {
          quit = ["<ESC>"];
        };
      };
      hover = {
        open_cmd = "!xdg-open"; # Choose your browser
        open_link = "gx";
      };
      rename = {
        in_select = false;
        keys = {
          quit = ["q" "<ESC>"];
        };
      };
    };
  };
}
