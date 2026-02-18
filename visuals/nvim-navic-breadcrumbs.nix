{...}: {
  vim = {
    ui.breadcrumbs = {
      enable = true;
      lualine.winbar.enable = false;
      navbuddy = {
        enable = true;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "cn";
        action = ":Navbuddy<CR>";
        desc = "Open Navbuddy";
        silent = true;
      }
    ];
  };
}
