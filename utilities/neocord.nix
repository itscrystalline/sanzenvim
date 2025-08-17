{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
  inherit (pkgs) fetchFromGitHub;

  setupOpts = {
    enable_line_number = true;
    blacklist = ["Alpha" "^/run/user/%d+/firenvim/.*$"];
  };
in {
  # vim.presence.neocord = {
  #   enable = true;
  # };
  vim.startPlugins = [
    (pkgs.vimPlugins.neocord.overrideAttrs {
      src = fetchFromGitHub {
        owner = "itscrystalline";
        repo = "neocord";
        rev = "fix-firenvim";
        hash = "sha256-WZ2yYQFqrfGq1+znXH3RyI1rGwZcDtwC82L0/scgex0=";
      };
    })
  ];

  vim.pluginRC.neocord = entryAnywhere ''
    -- Description of each option can be found in https://github.com/IogaMaster/neocord#lua
    require("neocord").setup(${toLuaObject setupOpts})
  '';
}
