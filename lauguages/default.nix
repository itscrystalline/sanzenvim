{...}: {
  imports = [
    ./blink-cmp.nix
    ./conform.nix

    ./nix.nix
  ];
  vim.languages = {
    enableTreesitter = true;
    enableDAP = true;
    enableExtraDiagnostics = true;
    enableFormat = true;
  };
}
