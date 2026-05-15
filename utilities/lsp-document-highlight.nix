{nur, ...}: {
  vim.lazy.plugins.lsp-document-highlight-nvim = {
    package = nur.repos.itscrystalline.lsp-document-highlight-nvim;
    setupModule = "lsp-document-highlight";
    setupOpts.throttle = 50;
    event = "LspAttach";
    after = ''
      require("lsp-document-highlight").enable()
    '';
    keys = [
      {
        mode = "n";
        key = "[r";
        action =
          # lua
          ''
            function()
              require("lsp-document-highlight").jump(-vim.v.count1, true)
            end
          '';
        lua = true;
        desc = "Previous Reference";
      }
      {
        mode = "n";
        key = "]r";
        action =
          # lua
          ''
            function()
              require("lsp-document-highlight").jump(vim.v.count1, true)
            end
          '';
        lua = true;
        desc = "Next Reference";
      }
    ];
  };
}
