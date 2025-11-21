{full, ...}: {
  vim.languages.csharp = {
    enable = full;
    lsp.servers = ["roslyn_ls"];
  };
}
