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
      };
    };
  };
}
