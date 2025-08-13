{
  # pkgs,
  # lib,
  # config,
  # options,
  ...
}: {
  vim.globals = {
    neovide_padding_top = 16;
    neovide_padding_bottom = 16;
    neovide_padding_right = 16;
    neovide_padding_left = 16;
    neovide_hide_mouse_when_typing = false;
    neovide_cursor_vfx_mode = "railgun";
    neovide_cursor_animation_length = 0.1;
  };
  vim.luaConfigPost = ''
    if vim.g.neovide then
      vim.keymap.set('v', '<C-c>', '"+y') -- Copy
      vim.keymap.set('n', '<C-v>', '"+P') -- Paste normal mode
      vim.keymap.set('v', '<C-v>', '"+P') -- Paste visual mode
      vim.keymap.set('c', '<C-v>', '<C-R>+') -- Paste command mode
      vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') -- Paste insert mode
    end
  '';
}
