{nur, ...}: {
  vim.lazy.plugins.inc-rename-nvim = {
    package = nur.repos.itscrystalline.inc-rename-nvim;
    setupModule = "inc_rename";
    setupOpts = {};
  };
}
