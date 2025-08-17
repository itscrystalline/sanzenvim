{pkgs, ...}: {
  vim.languages.markdown = {
    enable = true;
    extensions.markview-nvim = {
      enable = true;
      setupOpts = {
        preview.icon_provider = "mini";
      };
    };
  };

  # vim.treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
  # ];
}
