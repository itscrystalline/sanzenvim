{...}: {
  vim.languages.rust = {
    enable = true;
    extensions.crates-nvim.enable = true;
    lsp.opts = ''
      checkOnSave = true,
      check = {
        command = "clippy",
      },
      inlayHints = {
        enable = true,
        showParameterNames = true,
        parameterHintsPrefix = "<- ",
        otherHintsPrefix = "=> ",
      },
      procMacro = {
        enable = true,
      },
      capabilities =
        (function()
              local capabilities = vim.lsp.protocol.make_client_capabilities()
              capabilities.textDocument.completion.completionItem.snippetSupport = true
              capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                  'documentation',
                  'detail',
                  'additionalTextEdits',
                }
              }
              return capabilities
            end)(),
    '';
  };
}
