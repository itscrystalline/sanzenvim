{...}: {
  vim.visuals.rainbow-delimiters = {
    enable = true;
    setupOpts = {
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
  };
}
