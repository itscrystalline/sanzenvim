{pkgs, ...}: {
  vim.languages.nix = {
    enable = true;
    format = {
      package = pkgs.alejandra;
      type = "alejandra";
    };
    lsp = {
      enable = true;
    };
  };
}
