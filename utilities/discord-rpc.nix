{
  lib,
  full,
  ...
}: {
  vim.presence.cord-nvim = lib.mkIf full {
    enable = true;
    setupOpts.display = {
      theme = "minecraft";
      flavor = "accent";
    };
  };
}
