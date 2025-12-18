{
  pkgs,
  lib,
  config,
  ...
}: let
  enabled = config.vim.lsp.enable;

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
        treesitter.tsPackage = pkgs.vimPlugins.nvim-treesitter.builtGrammars.typescript;
      };
    };
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      vue
      tsx
    ];
    lsp.servers = lib.mkIf enabled {
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
        on_init = lib.mkLuaInline ''
          function(client)
            client.handlers['tsserver/request'] = function(_, result, context)
              local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
              local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
              local clients = {}

              vim.list_extend(clients, ts_clients)
              vim.list_extend(clients, vtsls_clients)

              if #clients == 0 then
                vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = 'typescript.tsserverRequest',
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                  local response = r and r.body
                  -- TODO: handle error or response nil here, e.g. logging
                  -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                  local response_data = { { id, response } }

                  ---@diagnostic disable-next-line: param-type-mismatch
                  client:notify('tsserver/response', response_data)
                end)
            end
          end
        '';
      };
    };
  };
}
