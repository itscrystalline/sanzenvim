{
  pkgs,
  lib,
  ...
}: let
  filetypes = ["typescript" "javascript" "javascriptreact" "typescriptreact" "vue"];
  vue-language-server = lib.getExe pkgs.vue-language-server;
  vtsls = lib.getExe pkgs.vtsls;
  vue-plugin = {
    name = "@vue/typescript-plugin";
    location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
    languages = ["vue"];
    configNamespace = "typescript";
  };
in {
  vim = {
    languages = {
      html.enable = true;
      css.enable = true;
      ts = {
        enable = true;
        lsp.enable = false;
        treesitter.enable = true;
        treesitter.tsPackage = pkgs.vimPlugins.nvim-treesitter.builtGrammars.typescript;
      };
    };
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      vue
      tsx
    ];
    lsp.servers = {
      vtsls = {
        inherit filetypes;
        cmd = ["${vtsls}" "--stdio"];
        settings = let
          inlayHints = {
            enumMemberValues.enabled = true;
            functionLikeReturnTypes.enabled = true;
            parameterNames.enabled = "all";
            parameterNames.suppressWhenArgumentMatchesName = true;
            propertyDeclarationTypes.enabled = true;
            variableTypes.enabled = true;
            variableTypes.suppressWhenTypeMatchesName = true;
          };
        in {
          vtsls.tsserver.globalPlugins = [vue-plugin];
          javascript = {inherit inlayHints;};
          typescript = {inherit inlayHints;};
        };
      };
      vue_ls = {
        cmd = ["${vue-language-server}" "--stdio"];
      };
    };
  };
}
