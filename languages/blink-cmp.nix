{
  pkgs,
  lib,
  full,
  ...
}: let
  deepMergeWithLists = lhs: rhs:
    lib.mapAttrs (
      k: v:
        if lib.hasAttr k rhs
        then let
          lv = v;
          rv = rhs.${k};
        in
          if lib.isAttrs lv && lib.isAttrs rv
          then deepMergeWithLists lv rv
          else if lib.isList lv && lib.isList rv
          then lv ++ rv
          else rv
        else v
    )
    lhs
    // lib.removeAttrs rhs (lib.attrNames lhs);

  withPlugins = plugins:
    lib.foldl' deepMergeWithLists {} (map ({
        name,
        package,
        module,
        addToDefault ? true,
      }: {
        setupOpts.sources = {
          default =
            if addToDefault
            then [name]
            else [];
          providers =
            if addToDefault
            then {
              ${name}.module = module;
            }
            else {};
        };
        sourcePlugins.${name} = {
          inherit package module;
          enable = true;
        };
      })
      plugins);
in {
  vim.autocomplete.blink-cmp =
    deepMergeWithLists {
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
          documentation.auto_show_delay_ms = 50;
          ghost_text.enabled = true;
          menu.draw.columns = lib.mkLuaInline ''
            {
              ${
              if full
              then ''{ "kind_icon" },''
              else ""
            }
              { "label", "label_description", gap = 1 },
              { "kind" }
            }
          '';
        };
        signature = {
          enabled = true;
        };
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
      };
    } (
      withPlugins [
        {
          name = "ripgrep";
          module = "blink-ripgrep";
          package = "blink-ripgrep-nvim";
        }
        {
          name = "emoji";
          module = "blink-emoji";
          package = "blink-emoji-nvim";
        }
        {
          name = "nerdfont";
          module = "blink-nerdfont";
          package = pkgs.vimPlugins.blink-nerdfont-nvim;
        }
        {
          name = "npm";
          module = "blink-cmp-npm";
          package = pkgs.vimPlugins.blink-cmp-npm-nvim;
        }
        {
          name = "spell";
          module = "blink-cmp-spell";
          package = "blink-cmp-spell";
        }
      ]
    );
  vim.extraPackages = [pkgs.ripgrep];
}
