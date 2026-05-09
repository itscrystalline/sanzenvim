{full, ...}: {
  vim.languages.csharp = {
    enable = full;
    lsp.servers = ["roslyn-ls"];

    extensions.roslyn-nvim.enable = true;
  };
}
