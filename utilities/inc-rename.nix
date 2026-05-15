{nur, ...}: {
  vim.lazy.plugins.inc-rename-nvim = {
    package = nur.repos.itscrystalline.inc-rename-nvim;
    setupModule = "inc_rename";
    setupOpts = {};
    keys = [
      {
        mode = "n";
        key = "cr";
        action =
          # lua
          ''
            function()
              return ":IncRename " .. vim.fn.expand("<cword>")
            end
          '';
        lua = true;
        expr = true;
        desc = "LSP Rename";
      }
    ];
  };
}
