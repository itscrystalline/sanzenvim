{pkgs, ...}: let
  duck-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "duck.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "tamton-aquib";
      repo = "duck.nvim";
      rev = "d8a6b08af440e5a0e2b3b357e2f78bb1883272cd";
      hash = "sha256-97QSkZHpHLq1XyLNhPz88i9VuWy6ux7ZFNJx/g44K2A=";
    };
    patches = [./parent-window-close-fix.patch];
  };
in {
  vim = {
    extraPlugins.duck-nvim = {
      package = duck-nvim;
      setup = ''
        local duck = require("duck")
        local animals = {
          { "🦍",  6 },
          { "🐕",  7 },
          { "🐈",  6 },
          { "🐇",  9 },
          { "🐓",  4 },
          { "🐤",  3 },
          { "🐧",  2 },
          { "🦅", 12 },
          { "🦆",  5 },
          { "🦢",  4 },
          { "🐢",  0 },
          { "🐟",  7 },
          { "🦀",  1 },
          { "🐝", 15 }
        }
        local result = animals[math.random(1, #animals)]
        duck.hatch(result[1], result[2])
      '';
    };
    autocmds = [
      {
        enable = true;
        callback = pkgs.lib.mkLuaInline ''
          function()
            local duck = require("duck")
            duck.hatch("🦀", 1)
          end
        '';
        desc = "spawn rust";
        event = ["BufNew"];
        pattern = ["*.rs"];
      }
    ];
  };
}
