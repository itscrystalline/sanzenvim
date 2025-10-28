{full, ...}: {
  vim.statusline.lualine = {
    enable = true;
    disabledFiletypes = [
      "alpha"
      "winbar"
      "statusline"
    ];
    activeSection = {
      a = [
        ''
          {
            "mode",
            icons_enabled = ${
            if full
            then "true"
            else "false"
          },
            separator = {
              left = '${
            if full
            then "▎"
            else ""
          }',
              right = '${
            if full
            then ""
            else "▒"
          }'
            },
          }
        ''
      ];
      b = [
        ''
          {
            "filetype",
            colored = true,
            icons_enabled = ${
            if full
            then "true"
            else "false"
          },
            icon = { align = 'center' }
          }
        ''
        ''
          {
            "filename",
            ${
            if full
            then "symbols = {modified = ' ', readonly = ' '}"
            else "symbols = {modified = 'M', readonly = 'RO'}"
          },
            separator = {right = '${
            if full
            then ""
            else "▒"
          }'}
          }
        ''
      ];
      c = [
        ''
          {
            "diff",
            colored = false,
            diff_color = {
              -- Same color values as the general color option can be used here.
              added    = 'green',    -- Changes the diff's added color
              modified = 'flamingo', -- Changes the diff's modified color
              removed  = 'red', -- Changes the diff's removed color you
            },
            symbols = {added = '+', modified = '~', removed = '-'}, -- Changes the diff symbols
            separator = {right = '${
            if full
            then ""
            else "▒"
          }'}
          }
        ''
      ];
      x = [
        ''
          {
            -- Lsp server name
            function()
              local buf_ft = vim.bo.filetype
              local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }

              if excluded_buf_ft[buf_ft] then
                return ""
                end

              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })

              if vim.tbl_isempty(clients) then
                return "-"
              end

              local active_clients = {}
              for _, client in ipairs(clients) do
                table.insert(active_clients, client.name)
              end

              return ${
            if full
            then ''require("mini.icons").get("file", vim.api.nvim_buf_get_name(bufnr)) .. " " ..''
            else ""
          } table.concat(active_clients, ", ")
            end,
            ${
            if full
            then "icon = ' ',"
            else "icon = 'LSP',"
          }
            separator = {left = '${
            if full
            then ""
            else "▒"
          }'},
          }
        ''
        ''
          {
            "diagnostics",
            sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc'},
            ${
            if full
            then "symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},"
            else "symbols = {error = 'E ', warn = 'W ', info = 'I ', hint = 'H '},"
          }
            colored = true,
            update_in_insert = false,
            always_visible = false,
            diagnostics_color = {
              color_error = { fg = 'red' },
              color_warn = { fg = 'yellow' },
              color_info = { fg = 'cyan' },
            },
          }
        ''
      ];
      y = [
        ''
          {
            "",
            draw_empty = true,
            separator = { left = '${
            if full
            then ""
            else "▒"
          }', right = '${
            if full
            then ""
            else "▒"
          }' }
          }
        ''
        ''
          {
            'searchcount',
            maxcount = 999,
            timeout = 120,
            separator = {left = '${
            if full
            then ""
            else "▒"
          }'}
          }
        ''
        ''
          {
            "branch",
            icons_enabled = ${
            if full
            then "true"
            else "false"
          },
            separator = {left = '${
            if full
            then ""
            else "▒"
          }'}
          }
        ''
      ];
      z = [
        ''
          {
            "progress",
            separator = {left = '${
            if full
            then ""
            else "▒"
          }'}
          }
        ''
      ];
    };
  };
}
