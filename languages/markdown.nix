{
  lib,
  full,
  icons,
  ...
}: {
  vim.languages.markdown = {
    enable = true;
    extensions.markview-nvim = {
      enable = true;
      setupOpts = {
        preview.icon_provider = lib.optionalString icons "mini";
        typst = {
          code_blocks = {
            pad_amount = 0;
            style = "simple";
          };
          raw_blocks = {
            pad_amount = 0;
            style = "simple";
          };
        };
      };
    };
  };
}
