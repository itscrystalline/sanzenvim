{...}: {
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
  ];
  vim = {
    languages = {
      enableTreesitter = true;
      enableDAP = true;
      enableExtraDiagnostics = true;
      enableFormat = true;
    };
    lsp = {
      enable = true;
      lspconfig.enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      mappings = {
        codeAction = "ca";
        format = "cf";
        goToDefinition = "gD";
        hover = "ch";
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
  };
}
