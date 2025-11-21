{...}: {
  vim.languages.nix = {
    enable = true;
    format.type = ["alejandra"];
    lsp = {
      enable = true;
    };
  };
}
