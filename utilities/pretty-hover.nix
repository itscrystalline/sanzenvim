{nur, ...}: {
  vim.lazy.plugins.pretty_hover-nvim = {
    package = nur.repos.itscrystalline.pretty_hover-nvim;
    setupModule = "pretty_hover";
    event = "LspAttach";
    keys = [
      {
        mode = "n";
        key = "K";
        action = ''function() require("pretty_hover").hover() end'';
        lua = true;
        desc = "Open Docs";
        silent = true;
      }
    ];
  };
}
