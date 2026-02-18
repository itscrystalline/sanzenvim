{
  codeshot-nvim,
  sss,
  pkgs,
  full,
  lib,
  ...
}: let
  inherit (lib.nvim.lua) toLuaObject;
  setupOpts = {
    bin_path = "${sss.packages."${pkgs.stdenv.hostPlatform.system}".code}/bin/sss_code";
    copy = "%c | wl-copy";
    silent = true; # Run command as Silent
    show_line_numbers = true;
    use_current_theme = true;
    fonts = "JetBrainsMono NF=h14";
    background = "#1E1E2E";
    radius = 16;
    save_format = "png";
  };
in {
  vim.extraPlugins."codeshot.nvim" = lib.mkIf full {
    package = codeshot-nvim.packages."${pkgs.stdenv.hostPlatform.system}".default;
    setup = ''
      require('codeshot').setup(${toLuaObject setupOpts})
    '';
  };
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>Y";
      action = ":SSSelected<CR>";
      desc = "Copy selected code as image to clipboard";
      silent = true;
    }
  ];
}
