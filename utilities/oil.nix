{...}: {
  vim.utility.oil-nvim = {
    enable = true;
    setupOpts = {
      columns = [
        "icon"
        "size"
      ];
      delete_to_trash = true;
      use_default_keymaps = true;
      watch_for_changes = true;
      view_options = {
        show_hidden = true;
      };
      preview_win = {
        border = "rounded";
        win_options = {
          winblend = 0;
        };
      };

      float = {
        padding = 5;
        max_width = 0; # ''math.ceil(vim.o.lines * 0.8 - 4)'';
        max_height = 0; # ''math.ceil(vim.o.columns * 0.8)'';
        border = "rounded"; # 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        win_options = {
          winblend = 0;
        };
      };
      keymaps = {
        "g?" = "actions.show_help";
        "<CR>" = "actions.select";
        "<C-\\>" = "actions.select_vsplit";
        "<C-e>" = "actions.select_split"; # this is used to navigate left
        "<C-t>" = "actions.select_tab";
        "<C-p>" = "actions.preview";
        "<C-c>" = "actions.close";
        "<C-r>" = "actions.refresh";
        "<BS>" = "actions.parent";
        "_" = "actions.open_cwd";
        "`" = "actions.cd";
        "~" = "actions.tcd";
        "gs" = "actions.change_sort";
        "gx" = "actions.open_external";
        "g." = "actions.toggle_hidden";
        "q" = "actions.close";
        "<ESC>" = "actions.close";
      };
    };
  };
}
