{...}: {
  vim.visuals.indent-blankline = {
    enable = true;
    setupOpts = {
      indent.char = "▎";
      scope = {
        enabled = true;
        highlight = [
          "RainbowDelimiterRed"
          "RainbowDelimiterOrange"
          "RainbowDelimiterYellow"
          "RainbowDelimiterGreen"
          "RainbowDelimiterCyan"
          "RainbowDelimiterBlue"
          "RainbowDelimiterViolet"
        ];
      };
      exclude = {
        buftypes = [
          "terminal"
          "nofile"
        ];
        filetypes = [
          "help"
          "alpha"
          "dashboard"
          "neo-tree"
          "Trouble"
          "trouble"
          "notify"
          "toggleterm"
        ];
      };
    };
  };
}
