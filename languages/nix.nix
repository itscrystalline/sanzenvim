_: {
  vim = {
    languages.nix = {
      enable = true;
      format.type = ["alejandra"];
      lsp = {
        enable = true;
      };
    };
    lsp.servers.nil.settings.nil.nix.flake.autoArchive = false;
  };
}
