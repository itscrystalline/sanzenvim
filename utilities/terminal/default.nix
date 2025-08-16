{lib, ...}: {
  imports = [
    ./lazygit.nix
  ];
  vim.terminal.toggleterm = {
    enable = true;
    mappings = {
      open = "<leader>nn";
    };
    setupOpts = {
      direction = "horizontal";
      size = lib.mkLuaInline ''
        function(term)
          if term.direction == "horizontal" then
            return math.max(15, vim.o.lines * 0.4)
          elseif term.direction == "vertical" then
            return math.min(20, vim.o.columns * 0.3)
          end
        end
      '';
      insert_mappings = false;
      terminal_mappings = false;
      shade_terminals = false;
      autochdir = true;
      float_opts = {
        border = "curved";
        zindex = 100;
      };
      winbar.enabled = false;
    };
  };
}
