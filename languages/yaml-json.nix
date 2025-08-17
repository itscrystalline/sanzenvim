{
  pkgs,
  lib,
  ...
}: {
  vim = {
    languages.yaml.enable = true;
    languages.json.enable = true;
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [jsonc];
    lsp.servers = {
      yaml-language-server = {
        on_attach = lib.mkForce (
          lib.mkLuaInline "default_on_attach"
        );
      };
      jsonls.cmd = lib.mkForce ["${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server" "--stdio"];
    };
  };
}
