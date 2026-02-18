{full, ...}: {
  vim = {
    lsp.lspsaga = {
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
            quit = ["q" "<ESC>"];
          };
        };
        hover = {
          open_cmd = "!xdg-open"; # Choose your browser
          open_link = "gx";
        };
        rename = {
          in_select = true;
          keys = {
            quit = ["<ESC>"];
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "cr";
        action = ":Lspsaga rename<CR>";
        desc = "Open Navbuddy";
        silent = true;
      }
      {
        mode = "n";
        key = "K";
        action = ":Lspsaga hover_doc<CR>";
        desc = "Open Docs";
        silent = true;
      }
      {
        mode = "n";
        key = "]d";
        action = ":Lspsaga diagnostic_jump_next<CR>";
        silent = true;
        desc = "Next Diagnostic";
      }
      {
        mode = "n";
        key = "[d";
        action = ":Lspsaga diagnostic_jump_prev<CR>";
        silent = true;
        desc = "Previous Diagnostic";
      }
    ];
  };
}
