{lib, ...}: {
  vim.tabline.nvimBufferline = {
    enable = true;
    mappings = {
      closeCurrent = "<leader>bd";
      cycleNext = "<Tab>";
      cyclePrevious = "<S-Tab>";
      moveNext = "<leader>bn";
      movePrevious = "<leader>bp";
      pick = "<leader>bb";
    };
    setupOpts = {
      options = {
        diagnostics = "nvim_lsp";
        # diagnostics_indicator = lib.mkLuaInline ''
        #   function(count, level, diagnostics_dict, context)
        #     local s = " "
        #     for e, n in pairs(diagnostics_dict) do
        #       local sym = e == "error" and " "
        #         or (e == "warning" and " " or " ")
        #       s = s .. n .. sym
        #     end
        #     return s
        #   end
        # '';
        separator_style = "thick";
      };
    };
  };
}
