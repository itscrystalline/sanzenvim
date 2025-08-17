{
  pkgs,
  lib,
  ...
}: {
  vim.languages.python = {
    enable = true;
    lsp.enable = false;
  };
  vim.lsp.servers.basedpyright = {
    cmd = lib.mkForce ["${pkgs.basedpyright}/bin/basedpyright-langserver" "--stdio"];
    filetypes = ["python"];
    root_markers = [
      "pyproject.toml"
      "setup.py"
      "setup.cfg"
      "requirements.txt"
      "Pipfile"
      "pyrightconfig.json"
      ".git"
    ];
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true;
          useLibraryCodeForTypes = true;
          diagnosticMode = "openFilesOnly";
        };
      };
    };
  };
}
