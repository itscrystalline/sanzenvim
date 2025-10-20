{
  pkgs,
  lib,
  full,
  ...
}: let
  asm-lsp = pkgs.asm-lsp.overrideAttrs (final: prev: {
    version = "ba39d01";
    src = pkgs.fetchFromGitHub {
      owner = "bergercookie";
      repo = "asm-lsp";
      rev = "ba39d0155216fc7d6f011522a849126d3f9f461b";
      hash = "sha256-qO9PF7VKZUe+nd3e6eQhsutvM6CqA7u6qDm0+yleIy4=";
    };
    cargoDeps = prev.cargoDeps.overrideAttrs (prevDepsAttrs: {
      vendorStaging = prevDepsAttrs.vendorStaging.overrideAttrs {
        inherit (final) src version;
        outputHash = "sha256-4GbKT8+TMf2o563blj8lnZTD7Lc+z9yW11TfxYzDSg4=";
      };
    });
  });
in {
  vim.languages.assembly.enable = full;
  vim.lsp.servers.asm-lsp.cmd = lib.mkIf full (lib.mkForce [(lib.getExe asm-lsp)]);
}
