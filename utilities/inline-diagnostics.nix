{nur, ...}: {
  vim.lazy.plugins.tiny-inline-diagnostic-nvim = {
    package = nur.repos.itscrystalline.tiny-inline-diagnostic-nvim;
    setupModule = "tiny-inline-diagnostic";
    setupOpts.options.multilines.enabled = true;
  };
}
