{...}: {
  vim.languages.markdown = {
    enable = true;
    extensions.markview-nvim = {
      enable = true;
      setupOpts = {
        preview.icon_provider = "mini";
      };
    };
  };
}
