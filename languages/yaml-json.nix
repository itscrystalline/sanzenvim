{
  lib,
  full,
  ...
}: {
  vim = {
    languages.yaml.enable = true;
    languages.json.enable = true;
    # treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [jsonc];
    lsp.servers = lib.mkIf full {
      yaml-language-server = {
        on_attach = lib.mkForce (
          lib.mkLuaInline "default_on_attach"
        );
      };
    };
  };
}
