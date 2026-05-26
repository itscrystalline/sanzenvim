{full, ...}: {
  vim.languages.zig.enable = full;
  vim.lsp.servers.zls.settings.zls = {
    build_on_save_args = ["-fincremental"];
  };
}
