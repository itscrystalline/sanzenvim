{
  lib,
  full,
  ...
}: {
  vim.languages.markdown = {
    enable = true;
    extensions.markview-nvim = {
      enable = true;
      setupOpts = lib.mkIf full {
        preview.icon_provider = "mini";
      };
    };
  };

  # vim.treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
  # ];
}
