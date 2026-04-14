{
  pkgs,
  lib,
  full,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
in {
  vim = lib.mkIf full {
    lazy.plugins = {
      molten-nvim = {
        package = pkgs.vimPlugins.molten-nvim;
        after = ''
          -- I find auto open annoying, keep in mind setting this option will require setting
          -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
          vim.g.molten_auto_open_output = false

          -- optional, I like wrapping. works for virt text and the output window
          vim.g.molten_wrap_output = true

          -- Output as virtual text. Allows outputs to always be shown, works with images, but can
          -- be buggy with longer images
          vim.g.molten_virt_text_output = true

          -- this will make it so the output shows up below the ``` cell delimiter
          vim.g.molten_virt_lines_off_by_1 = true
        '';
      };

      quarto-nvim = {
        package = pkgs.vimPlugins.quarto-nvim;
        setupModule = "quarto";
        ft = ["quarto" "markdown"];
        setupOpts = {
          lspFeatures = {
            enabled = true;
            languages = ["python" "bash" "lua" "html" "r"];
            chunks = "all";
            diagnostics = {
              enabled = true;
              triggers = ["BufWritePost"];
            };
            completion = {
              enabled = true;
            };
          };
          codeRunner = {
            enabled = true;
            default_method = "molten";
          };
        };
      };

      "jupytext.nvim" = {
        package = pkgs.vimPlugins.jupytext-nvim;
        setupModule = "jupytext";
        setupOpts = {
          style = "markdown";
          output_extension = "md";
          force_ft = "markdown";
        };
      };
    };

    # Keymaps for notebook workflow
    keymaps = [
      {
        mode = "n";
        key = "]b";
        action = ":MoltenNext<CR>";
        desc = "Next code cell";
        silent = true;
      }
      {
        mode = "n";
        key = "[b";
        action = ":MoltenPrev<CR>";
        desc = "Previous code cell";
        silent = true;
      }
      # Molten evaluation keymaps
      {
        mode = "n";
        key = "<leader>me";
        action = ":MoltenEvaluateOperator<CR>";
        desc = "Evaluate operator";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>mo";
        action = ":noautocmd MoltenEnterOutput<CR>";
        desc = "Open output window";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>mrr";
        action = ":MoltenReevaluateCell<CR>";
        desc = "Re-evaluate cell";
        silent = true;
      }
      {
        mode = "v";
        key = "<leader>mr";
        action = ":<C-u>MoltenEvaluateVisual<CR>gv";
        desc = "Execute visual selection";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>md";
        action = ":MoltenDelete<CR>";
        desc = "Delete Molten cell";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>mh";
        action = ":MoltenHideOutput<CR>";
        desc = "Hide output window";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>md";
        action = ":MoltenDeinit<CR>";
        desc = "Deinitialize Molten";
        silent = true;
      }

      {
        mode = "n";
        key = "<leader>mra";
        action = ":MoltenReevaluateAll<CR>";
        desc = "Run all cells";
        silent = true;
      }
      {
        mode = "n";
        key = "<leader>mrl";
        action = "require('quarto.runner').run_line";
        desc = "Run line";
        silent = true;
        lua = true;
      }
      {
        mode = "n";
        key = "<leader>mrA";
        action = ''
          function() require('quarto.runner').run_all(true) end
        '';
        desc = "Run all cells of all languages";
        silent = true;
        lua = true;
      }
    ];

    # Autocommands for .ipynb file handling
    autocmds = let
      fnBody = ''
        vim.schedule(function()
          vim.cmd("UpdateRemotePlugins")
          require('lz.n').trigger_load("jupytext")
          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            if venv ~= nil then
                kernel_name = string.match(venv, "/.+/(.+)")
            end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(("MoltenInit %s"):format(kernel_name))
          end
          vim.cmd("MoltenImportOutput")
        end)
      '';
    in [
      {
        event = ["BufAdd"];
        pattern = ["*.ipynb"];
        callback = mkLuaInline ''
          function(e)
            ${fnBody}
          end
        '';
        desc = "Auto-import outputs when opening .ipynb files";
      }
      {
        event = ["BufEnter"];
        pattern = ["*.ipynb"];
        callback = mkLuaInline ''
          function(e)
            if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
              ${fnBody}
            end
          end
        '';
        desc = "Auto-import outputs when opening .ipynb files";
      }
      {
        event = ["BufWritePost"];
        pattern = ["*.ipynb"];
        callback = mkLuaInline ''
          function()
            if require("molten.status").initialized() == "Molten" then
                vim.cmd("MoltenExportOutput!")
            end
          end
        '';
        desc = "Auto-export outputs when saving .ipynb files";
      }
    ];

    python3Packages = [
      "pynvim"
      "jupyter-client"
      "cairosvg"
      "plotly"
      "kaleido"
      "pnglatex"
      "pyperclip"
      "jupyter"
      "jupytext"
      "ipykernel"
    ];

    extraPackages = [pkgs.python313Packages.jupytext pkgs.jupyter];

    luaPackages = ["magick"];
  };
}
