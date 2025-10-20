{
  full,
  lib,
  ...
}: {
  vim.debugger.nvim-dap = {
    enable = lib.mkForce full;
    ui = {
      enable = true;
      autoStart = true;
    };
  };
}
