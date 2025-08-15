{...}: {
  vim.luaConfigPost = ''
    -- indent-blankline
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

    -- neovide
    if vim.g.neovide then
      vim.keymap.set('v', '<C-c>', '"+y') -- Copy
      vim.keymap.set('n', '<C-v>', '"+P') -- Paste normal mode
      vim.keymap.set('v', '<C-v>', '"+P') -- Paste visual mode
      vim.keymap.set('c', '<C-v>', '<C-R>+') -- Paste command mode
      vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode
    end
  '';
}
