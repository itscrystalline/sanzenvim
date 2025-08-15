{...}: {
  vim.lazy.plugins.catppuccin = {
    package = "catppuccin";
    after = ''
      require("catppuccin").setup({
        auto_integrations = true,
        integrations = {
          indent_blankline = {
            enabled = true,
            scope_color = "pink",
            colored_indent_levels = true,
          },
        },
        flavor = "mocha",
        dim_inactive = {
          enabled = true,
        },
        custom_highlights = function(colors)
          return {
            AlphaHeader = { fg = colors.pink },
            TelescopeBorder = { fg = colors.pink },
            LazygitBorder = { fg = colors.pink },
            FloatBorder = { fg = colors.pink },
            LspInfoBorder = { fg = colors.pink },
            DapUIFloatBorder = { fg = colors.pink },
            MiniNotifyBorder = { fg = colors.pink },
            NeoTreeDirectoryName = { fg = colors.pink },
            NeoTreeDirectoryIcon= { fg = colors.pink },
            NeoTreeRootName = { fg = colors.pink },
            NeoTreeTitleBar = { bg = colors.pink },
            lualine_a_normal = { bg = colors.pink },
            lualine_b_normal = { fg = colors.pink },
            lualine_c_normal = { fg = colors.pink },
            DiffAdd = { fg = colors.green },
            DiffChange = { fg = colors.flamingo },
            DiffDelete = { fg = colors.red },
          }
        end
      })
      vim.cmd.colorscheme("catppuccin")
    '';
  };
}
