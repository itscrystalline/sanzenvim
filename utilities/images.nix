{
  full,
  pkgs,
  lib,
  ...
}: {
  vim = lib.mkIf full {
    luaPackages = [
      "magick"
    ];
    lazy.plugins = {
      "image-nvim" = let
        setupModule = "image";
        setupOpts = {
          backend = "kitty";
          processor = "magick_rock";
        };

        inherit (lib.nvim.lua) toLuaObject;
      in {
        package = "image-nvim";
        event = "DeferredUIEnter";
        after =
          # lua
          ''
            if os.getenv("ZELLIJ") == nil then
              require("${setupModule}").setup(${toLuaObject setupOpts})
            end
          '';
      };
      "img-clip.nvim" = {
        package = pkgs.vimPlugins.img-clip-nvim;
        setupModule = "img-clip";
        setupOpts = {
          default = {
            dir_path = "assets";
            copy_images = true;
          };
        };
        keys = [
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
      };
    };
  };
}
