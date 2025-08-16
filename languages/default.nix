{...}: {
  imports = [
    ./blink-cmp.nix
    ./conform.nix
    ./lspsaga.nix

    ./nix.nix
    ./rust.nix
  ];
  vim.languages = {
    enableTreesitter = true;
    enableDAP = true;
    enableExtraDiagnostics = true;
    enableFormat = true;
  };
  vim.lsp = {
    enable = true;
    formatOnSave = true;
    inlayHints.enable = true;
    mappings = {
      codeAction = "ca";
      format = "cf";
      goToDefinition = "gD";
      hover = "ch";
    };
  };
  vim.diagnostics = {
    enable = true;
    config = {
      virtual_text = {
        current_line = false;
      };
      virtual_lines = {
        current_line = true;
      };
      update_in_insert = true;
    };
  };
}
