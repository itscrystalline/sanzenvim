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
}
