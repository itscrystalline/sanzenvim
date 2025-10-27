{
  lib,
  full,
  ...
}: let
  inherit (lib) mkLuaInline;
  padding = val: {
    type = "padding";
    inherit val;
  };
in {
  vim.dashboard.alpha = {
    enable = true;
    theme = null;
    layout = [
      (padding 10)
      {
        opts = {
          hl = "AlphaHeader";
          position = "center";
        };
        type = "text";
        val = [
          "       `;,      `;,                `;,     `;,                       燦然vim (sanzenvim)"
          "        ;;       ,;'        `;,     ;;      ,;'                                         "
          "       ,;;,;;;'  ,;       `';;;;;;;;;;;;;;   ,;                                         "
          "   ,;;;';;'     ,;'          ;;     ;;     ,;'                   \"\"                     "
          "        ;;     ,;'          ,;;     ;;    ,;'         ;;;    ;;  ;;    ,;;;,,;;;,,;;;,  "
          "       ,;;    ,;''',      ,;;;' ,   ;;   ,;''',      ;;\";;   ;;;;;;   ,;\" \";;\" \";;\" \";, "
          "   ,;''  `   ,;'   ';,   ,;' ;;  ',;;'  ,;'   ';,   ;;  ;;   ;;  ;;   ;;   ;;   ;;   ;; "
          "   ;;       ,;'     ';,,;'   ';,       ,;'     ';,,;;   ;;, ,;;,,;;,,,;;   ;;   ;;   ;;,"
          "    `;;;;;,,;'                ';;;;;;;;;'                \";;;\" ;;\"\";;;;'   ;;   ;;   `;;"
        ];
      }
      (padding 6)
      {
        type = "button";
        val = "${
          if full
          then "  "
          else ""
        }Zoxide";
        on_press = mkLuaInline "function() require('telescope').extensions.zoxide.list() end";
        opts = {
          # hl = "comment";
          keymap = [
            "n"
            "z"
            ":Telescope zoxide list <CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "z";

          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      (padding 1)
      {
        type = "button";
        val = "${
          if full
          then "  "
          else ""
        }Find File";
        on_press = mkLuaInline "function() require('telescope.builtin').find_files() end";
        opts = {
          # hl = "comment";
          keymap = [
            "n"
            "f"
            ":Telescope find_files <CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "f";

          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      (padding 1)
      {
        type = "button";
        val = mkLuaInline "${
          if full
          then ''require('mini.icons').get('directory', vim.fn.getcwd()) ..''
          else ""
        }'  Open Directory'";
        on_press = mkLuaInline "function() require('telescope.builtin').find_files() end";
        opts = {
          # hl = "comment";
          keymap = [
            "n"
            "o"
            ":Oil --float<CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "o";

          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      (padding 1)
      {
        type = "button";
        val = "${
          if full
          then "  "
          else ""
        }New File";
        on_press = mkLuaInline "function() vim.cmd[[ene]] end";
        opts = {
          # hl = "comment";
          keymap = [
            "n"
            "n"
            ":ene <BAR> startinsert <CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "n";

          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      (padding 1)
      {
        type = "button";
        val = "${
          if full
          then "󰈭  "
          else ""
        }Find Word";
        on_press = mkLuaInline "function() require('telescope.builtin').live_grep() end";
        opts = {
          # hl = "comment";
          keymap = [
            "n"
            "g"
            ":Telescope live_grep <CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "g";

          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
      (padding 1)
      {
        type = "button";
        val = "${
          if full
          then "  "
          else ""
        }Quit Neovim";
        on_press = mkLuaInline "function() vim.cmd[[qa]] end";
        opts = {
          # hl = "comment";
          keymap = [
            "n"
            "q"
            ":qa<CR>"
            {
              noremap = true;
              silent = true;
              nowait = true;
            }
          ];
          shortcut = "q";

          position = "center";
          cursor = 3;
          width = 38;
          align_shortcut = "right";
          hl_shortcut = "Keyword";
        };
      }
    ];
  };
}
