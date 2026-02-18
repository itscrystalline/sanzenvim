{
  pkgs,
  full,
  lib,
  ...
}: let
  inherit (lib.nvim.lua) toLuaObject;
  setupOpts = {
    font = "JetBrainsMono NF=14;Noto Sans Mono CJK JP=14;Noto Sans Mono=14;Noto Color Emoji=14";
    theme = "Github";
    background = "#1E1E2E";
    pad_horiz = 16;
    pad_vert = 16;
    no_window_controls = true;
    to_clipboard = true;
    command = "silicon";
    language = lib.mkLuaInline ''
      function()
        local ft = vim.bo.filetype
      	if ft == "oil" or ft == "toggleterm" or ft == "alpha" then
          return "txt"
        else
          return ft
        end
      end
    '';
  };
in {
  vim = {
    extraPlugins."nvim-silicon" = lib.mkIf full {
      package = pkgs.vimPlugins.nvim-silicon;
      setup = ''
        require('nvim-silicon').setup(${toLuaObject setupOpts})
      '';
    };
    keymaps = lib.optionals full [
      {
        mode = "v";
        key = "<leader>Y";
        action = "function() require('nvim-silicon').clip() end";
        desc = "Copy selected code as image to clipboard";
        lua = true;
        silent = true;
      }
    ];
    extraPackages = lib.optionals full [pkgs.silicon];
  };
}
