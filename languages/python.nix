{
  pkgs,
  lib,
  ...
}: {
  vim.languages.python.enable = true;
  vim.lsp.servers.basedpyright.cmd = lib.mkForce ["${pkgs.basedpyright}/bin/basedpyright-langserver" "--stdio"];
}
