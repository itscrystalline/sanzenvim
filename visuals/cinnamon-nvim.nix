{...}: {
  vim.visuals.cinnamon-nvim = {
    enable = true;
    setupOpts = {
      keymaps = {
        basic = true;
        extra = true;
      };
      options = {
        delay = 2;
        max_delta = {
          line = false;
          column = false;
          time = 500;
        };
      };
    };
  };
}
