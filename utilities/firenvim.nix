{
  pkgs,
  lib,
  full,
  ...
}: let
  inherit (lib.nvim.lua) toLuaObject;
  makeIgnore = list:
    builtins.listToAttrs (map (elem: {
        name = "${elem}*";
        value = {
          priority = 1;
          takeover = "never";
        };
      })
      list);

  localSettings =
    {
      "https://labs.cognitiveclass.ai*" = {
        selector = "textarea:not([class=xterm-helper-textarea])";
      };
    }
    // makeIgnore [
      "https://twitter.com"
      "https://docs.google.com"
      "https://www.canva.com"
      "https://www.instagram.com"
      "https://www.messenger.com"
      "https://nc.iw2tryhard.dev"
      "https://chatgpt.com"
      "https://classroom.google.com"
      "https://google.com"
      "https://app.slack.com"
      "https://deepl.com"
      "https://claude.ai"
    ];
in {
  vim.extraPlugins.firenvim = lib.mkIf full {
    package = pkgs.vimPlugins.firenvim.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "a18ef908ac06b52ad9333b70e3e630b0a56ecb3d";
        hash = "sha256-3uzx6zJqvNhyqHTwuE108BztSb7WB/2w5EpzvTyTHyU=";
      };
    };
    setup = ''
      vim.g.firenvim_config = {
        localSettings = ${toLuaObject localSettings}
      }
    '';
  };
}
