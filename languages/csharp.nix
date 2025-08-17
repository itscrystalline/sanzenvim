{
  pkgs,
  lib,
  ...
}: {
  vim.languages.csharp = {
    enable = true;
    lsp.servers = "roslyn_ls";
  };
}
