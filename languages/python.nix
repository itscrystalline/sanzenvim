{
  pkgs,
  lib,
  ...
}: {
  vim.languages.python = {
    enable = true;
    lsp.enable = false;
    format.type = ["ruff"];
  };
  vim.lsp.servers.ty = {
    cmd = lib.mkForce [(lib.getExe pkgs.ty) "server"];
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
    # capabilities = [
    # ];
    settings.ty = {
      completions.autoImport = true;
      inlayHints.variableTypes = true;
    };
  };
}
