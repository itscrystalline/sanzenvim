{
  pkgs,
  full,
  lib,
  ...
}: {
  vim = lib.mkIf full {
    lazy.plugins."nvim-silicon" = {
      package = pkgs.vimPlugins.nvim-silicon;
      lazy = true;
      setupModule = "nvim-silicon";
      setupOpts = {
        font = "JetBrainsMono NF=14;Noto Sans Mono CJK JP=14;Noto Sans Mono=14;Noto Color Emoji=14";
        theme = "catppuccin-mocha_dark";
        background = "#1E1E2E";
        pad_horiz = 0;
        pad_vert = 0;
        no_window_controls = true;
        to_clipboard = true;
        command = "silicon";
        language = lib.mkLuaInline ''
          function()
            local ft = vim.bo.filetype
          	if ft == "oil" or ft == "toggleterm" or ft == "alpha" then
              return "bash"
            else
              return ft
            end
          end
        '';
        line_offset = lib.mkLuaInline ''
          function(args)
            return args.line1
          end
        '';
        shadow_blur_radius = 0;
        shadow_offset_x = 0;
        shadow_offset_y = 0;
      };
      keys = [
        {
          mode = "v";
          key = "<leader>Y";
          action = "function() require('nvim-silicon').clip() end";
          desc = "Copy selected code as image to clipboard";
          lua = true;
          silent = true;
        }
      ];
    };
    extraPackages = [pkgs.silicon];
  };
}
