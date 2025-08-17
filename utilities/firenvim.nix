{
  pkgs,
  lib,
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
    ];
in {
  vim.extraPlugins.firenvim = {
    package = pkgs.vimPlugins.firenvim.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "c927486daff6d1eb8a0d61fd9e264bc1bf5f2c36";
        hash = "sha256-TrY86Pd7vN3gEpKNq5FC/QPZR1uMfxz/vvuLuOmFSgU=";
      };
    };
    setup = ''
      vim.g.firenvim_config = {
        localSettings = ${toLuaObject localSettings}
      }
    '';
  };
}
