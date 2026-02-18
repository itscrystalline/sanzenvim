{
  lib,
  full,
  ...
}: let
  icons =
    if full
    then {
      buffer_close_icon = "󰅖";
      modified_icon = "● ";
      close_icon = " ";
      left_trunc_marker = " ";
      right_trunc_marker = " ";
    }
    else {
      buffer_close_icon = "X";
      modified_icon = "* ";
      close_icon = "x ";
      left_trunc_marker = "<- ";
      right_trunc_marker = "-> ";
    };
in {
  vim.tabline.nvimBufferline = {
    enable = true;
    mappings = {
      closeCurrent = "<leader>bq";
      cycleNext = "<Tab>";
      cyclePrevious = "<S-Tab>";
      moveNext = "<leader>bn";
      movePrevious = "<leader>bp";
      pick = "<leader>bb";
    };
    setupOpts = {
      options =
        {
          diagnostics = "nvim_lsp";
          separator_style = "thick";
          numbers = "none";
          indicator =
            if full
            then {
              icon = "▎";
              style = "icon";
            }
            else {
              style = "underline";
            };
        }
        // icons;
    };
  };
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>bQQ";
      action = ":BufferLineCloseOthers<CR>";
      desc = "Close all other buffers";
      silent = true;
    }
    {
      mode = "n";
      key = "<leader>bQR";
      action = ":BufferLineCloseRight<CR>";
      desc = "Close all buffers to the right";
      silent = true;
    }
    {
      mode = "n";
      key = "<leader>bQL";
      action = ":BufferLineCloseLeft<CR>";
      desc = "Close all buffers to the left";
      silent = true;
    }
  ];
}
