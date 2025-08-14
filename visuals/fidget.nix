{...}: {
  vim.visuals.fidget-nvim = {
    enable = true;
    setupOpts = {
      logger = {
        level = "warn";
        float_precision = 1.0e-2;
      };
    };
  };
}
