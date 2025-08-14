{
  # pkgs,
  lib,
  # config,
  # options,
  ...
}: {
  vim.lazy.plugins.catppuccin = {
    package = "catppuccin";
    after = ''
      require("catppuccin").setup({
        auto_integrations = true,
        flavor = "mocha",
        dim_inactive = {
          enabled = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    '';
  };
}
