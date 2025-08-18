{...}: {
  vim.treesitter.context = {
    enable = true;
    setupOpts = {
      max_lines = 3;
      min_window_height = 15;
      mode = "topline";
      trim_scope = "outer";
      separator = null;
    };
  };
}
