{
  full,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nvim.dag) entryAnywhere;
  inherit (lib.nvim.lua) toLuaObject;
in {
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
        key = "<leader>PP";
        action = ":PasteImage<CR>";
        desc = "Paste image from system clipboard";
        silent = true;
      }
      {
        mode = ["n" "v"];
        key = "<leader>PS";
        action = ''
          function()
            local telescope = require("telescope.builtin")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            telescope.find_files({
              attach_mappings = function(_, map)
                local function embed_image(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  local filepath = entry[1]
                  actions.close(prompt_bufnr)

                  local img_clip = require("img-clip")
                  img_clip.paste_image(nil, filepath)
                end

                map("i", "<CR>", embed_image)
                map("n", "<CR>", embed_image)

                return true
              end,
            })
          end
        '';
        desc = "Paste image from telescope selection";
        lua = true;
        silent = true;
      }
    ];
    extraPackages = lib.optionals full [pkgs.imagemagick];
  };
  vim.pluginRC.image-nvim = lib.mkIf full (lib.mkForce (entryAnywhere ''
    if not vim.g.started_by_firenvim then
      require("image").setup(
          ${toLuaObject config.vim.utility.images.image-nvim.setupOpts}
      )
    end
  ''));
}
