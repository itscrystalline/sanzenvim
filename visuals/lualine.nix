{...}: {
  vim.statusline.lualine = {
    enable = true;
    activeSection = {
      a = [
        ''
          {
            "mode",
            icons_enabled = true,
            separator = {
              left = '▎',
              right = ''
            },
          }
        ''
      ];
      b = [
        ''
          {
            "filetype",
            colored = true,
            icon_only = true,
            icon = { align = 'center' }
          }
        ''
        ''
          {
            "filename",
            symbols = {modified = ' ', readonly = ' '},
            separator = {right = ''}
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
            separator = {right = ''}
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

              return require("mini.icons").get("file", vim.api.nvim_buf_get_name(bufnr)) .. " " .. table.concat(active_clients, ", ")
            end,
            icon = ' ',
            separator = {left = ''},
          }
        ''
        ''
          {
            "diagnostics",
            sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc'},
            symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},
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
            separator = { left = '', right = '' }
          }
        ''
        ''
          {
            'searchcount',
            maxcount = 999,
            timeout = 120,
            separator = {left = ''}
          }
        ''
        ''
          {
            "branch",
            icon = ' •',
            separator = {left = ''}
          }
        ''
      ];
      z = [
        ''
          {
            "progress",
            separator = {left = ''}
          }
        ''
        ''
          {
            "fileformat",
            color = {fg='black'},
            symbols = {
              unix = '', -- e712
              dos = '',  -- e70f
              mac = '',  -- e711
            }
          }
        ''
      ];
    };
  };
}
