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
  };
}
