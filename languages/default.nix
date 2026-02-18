{
  full,
  lib,
  ...
}: {
  imports = [
    ./blink-cmp.nix
    ./conform.nix
    ./lspsaga.nix

    ./dap

    ./nix.nix
    ./rust.nix
    ./clang.nix
    ./html-css-js-ts.nix
    ./python.nix
    ./zig.nix
    ./markdown.nix
    ./lua.nix
    ./php.nix
    ./csharp.nix
    ./yaml-json.nix
    ./java.nix
    ./kotlin.nix
    ./assembly.nix
    ./r.nix
    ./typst.nix
    ./qml.nix
  ];
  vim = {
    languages = {
      enableTreesitter = true;
      enableDAP = full;
      enableExtraDiagnostics = true;
      enableFormat = true;
    };
    lsp = lib.mkIf full {
      enable = true;
      lspconfig.enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      mappings = {
        codeAction = "ca";
        format = "cf";
        goToDefinition = "gD";
      };
    };
    diagnostics = {
      enable = true;
      config = {
        virtual_text = {
          current_line = false;
        };
        virtual_lines = {
          current_line = true;
        };
        update_in_insert = true;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "ca";
        action = ":lua vim.lsp.buf.code_action()<CR>";
        desc = "Code actions";
        silent = true;
      }
      {
        mode = "n";
        key = "cf";
        action = ":lua vim.lsp.buf.format()<CR>";
        desc = "Format code";
        silent = true;
      }
      {
        mode = "n";
        key = "gD";
        action = ":lua vim.lsp.buf.definition()<CR>";
        desc = "Goto definition";
        silent = true;
      }
      {
        mode = "n";
        key = "[c";
        action = ''
          function()
            require("treesitter-context").go_to_context(vim.v.count1)
          end
        '';
        lua = true;
        silent = true;
        desc = "Previous scope";
      }
      {
        mode = "n";
        key = "<leader>ut";
        action = ''
          function()
            local enabled = not vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(enabled)
            vim.notify("Inlay Hints " .. (enabled and "on" or "off"))
          end
        '';
        silent = true;
        lua = true;
        desc = "Toggle inlay hints";
      }
    ];
  };
}
