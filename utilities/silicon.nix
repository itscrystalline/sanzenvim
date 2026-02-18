{
  pkgs,
  full,
  lib,
  ...
}: let
  inherit (lib.nvim.lua) toLuaObject;
  setupOpts = {
    windowControls = false;
  };
in {
  vim.extraPlugins."silicon.lua" = lib.mkIf full {
    package = pkgs.vimPlugins.nvim-silicon;
    setup = ''
      require('silicon').setup(${toLuaObject setupOpts})
    '';
  };
  vim.keymaps = [
    {
      mode = "v";
      key = "<leader>Y";
      action = "function() silicon.visualise_api({}) end";
      desc = "Copy selected code as image to clipboard";
      lua = true;
      silent = true;
    }
  ];
}
