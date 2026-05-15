{
  lib,
  full,
  ...
}: let
  enable = minis:
    lib.mergeAttrsList
    (map (mini:
      if lib.isString mini
      then {"${mini}".enable = true;}
      else if lib.isAttrs mini
      then {
        "${mini.name}" = {
          enable = true;
          setupOpts = mini.opts;
        };
      }
      else builtins.throw "strings or attrs please")
    minis);
in {
  vim.mini = enable ([
      "align"
      "bracketed"
      {
        name = "clue";
        opts = {
          triggers = [
            {
              mode = "n";
              keys = "<Leader>";
            }
            {
              mode = "x";
              keys = "<Leader>";
            }

            {
              mode = "i";
              keys = "<C-x>";
            }

            {
              mode = "n";
              keys = "g";
            }
            {
              mode = "x";
              keys = "g";
            }

            {
              mode = "n";
              keys = "\'";
            }
            {
              mode = "n";
              keys = "\`";
            }
            {
              mode = "x";
              keys = "'";
            }
            {
              mode = "x";
              keys = "`";
            }

            {
              mode = "n";
              keys = "\"";
            }
            {
              mode = "x";
              keys = "\"";
            }
            {
              mode = "i";
              keys = "<C-r>";
            }
            {
              mode = "c";
              keys = "<C-r>";
            }

            {
              mode = "n";
              keys = "<C-w>";
            }

            {
              mode = "n";
              keys = "z";
            }
            {
              mode = "x";
              keys = "z";
            }
          ];

          clues = lib.mkLuaInline ''
            {
              require('mini.clue').gen_clues.builtin_completion(),
              require('mini.clue').gen_clues.g(),
              require('mini.clue').gen_clues.marks(),
              require('mini.clue').gen_clues.registers(),
              require('mini.clue').gen_clues.windows(),
              require('mini.clue').gen_clues.z(),
            }
          '';
        };
      }
      "comment"
      "cursorword"
      {
        name = "surround";
        opts.mappings = {
          add = "ys";
          delete = "ds";
          find = "sf";
          find_left = "sF";
          highlight = "hs";
          replace = "cs";
          update_n_lines = "sn";
          suffix_last = "l";
          suffix_next = "n";
        };
      }
      "pairs"
      {
        name = "hipatterns";
        opts = {
          highlighters = {
            fixme = {
              pattern = "%f[%w]()FIXME()%f[%W]";
              group = "MiniHipatternsFixme";
            };
            hack = {
              pattern = "%f[%w]()HACK()%f[%W]";
              group = "MiniHipatternsHack";
            };
            todo = {
              pattern = "%f[%w]()TODO()%f[%W]";
              group = "MiniHipatternsTodo";
            };
            note = {
              pattern = "%f[%w]()NOTE()%f[%W]";
              group = "MiniHipatternsNote";
            };

            hex_color = lib.mkLuaInline "require('mini.hipatterns').gen_highlighter.hex_color()";
          };
        };
      }
    ]
    ++ lib.optionals full [
      "icons"
    ]);
}
