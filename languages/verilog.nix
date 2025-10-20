{
  lib,
  full,
  my-nur,
  pkgs,
  ...
}: {
  vim = lib.mkIf full {
    lsp.servers.veridian = {
      autostart = true;
      cmd = ["${my-nur.packages.${pkgs.system}.veridian}"];
      filetypes = ["systemverilog" "verilog" "sv"];
      root_markers = [".git" "veridian.yml"];
    };
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      verilog
      vhdl
    ];
    # autocmds = [
    #   {
    #     enable = true;
    #     command = ":LspStart veridian<CR>";
    #     desc = "Start veridian LSP";
    #     event = ["BufNew"];
    #     pattern = ["*.sv"];
    #   }
    # ];
  };
}
