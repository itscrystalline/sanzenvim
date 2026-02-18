{
  full,
  pkgs,
  lib,
  ...
}: {
  vim = {
    utility.images = {
      image-nvim = {
        enable = full;
        setupOpts = {
          backend = "kitty";
          integrations.markdown.downloadRemoteImages = true;
        };
      };
      img-clip.enable = full;
    };
    keymaps = [
      {
        mode = ["n" "v"];
        key = "<leader>P";
        action = ":PasteImage<CR>";
        desc = "Paste image from system clipboard";
        silent = true;
      }
    ];
    extraPackages = lib.optionals full [pkgs.imagemagick];
  };
}
