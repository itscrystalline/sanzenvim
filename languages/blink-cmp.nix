{
  pkgs,
  lib,
  icons,
  ...
}: {
  vim.autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    mappings = {
      close = "<C-ESC>";
      complete = "<C-Space>";
      confirm = "<CR>";
      next = "<Tab>";
      previous = "<S-Tab>";
      scrollDocsDown = "<Down>";
      scrollDocsUp = "<Up>";
    };
    setupOpts = {
      cmdline.keymap.preset = "default";
      completion = {
        trigger.show_on_blocked_trigger_characters = [" " "\n" "\t" ":"];
        documentation.auto_show_delay_ms = 50;
        ghost_text.enabled = true;
        menu.draw.columns = lib.mkLuaInline ''
          {
            ${
            if icons
            then ''{ "kind_icon" },''
            else ""
          }
            { "label", "label_description", gap = 1 },
            { "kind" }
          }
        '';
      };
      signature.enabled = true;
      sources = {
        providers = {
          lsp.score_offset = 1000;
          nerdfont = {
            module = "blink-nerdfont";
            score_offset = -100;
          };
          ripgrep.score_offset = -10;
          spell.score_offset = -10;
        };
      };
    };
    sourcePlugins = {
      ripgrep.enable = true;
      nerdfont = {
        enable = true;
        package = pkgs.vimPlugins.blink-nerdfont-nvim;
        module = "blink-nerdfont";
      };
      spell.enable = true;
    };
  };
  vim.extraPackages = [pkgs.ripgrep];
}
