{pkgs, ...}: {
  vim.telescope = {
    enable = true;
    extensions = [
      {
        name = "fzf";
        packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
        setup = {
          fzf = {
            fuzzy = true;
            override_generic_sorter = true;
            override_file_sorter = true;
            case_mode = "smart_case";
          };
        };
      }
      {
        name = "ui-select";
        packages = [pkgs.vimPlugins.telescope-ui-select-nvim];
        setup = {
          specific_opts = {
            codeactions = true;
          };
        };
      }
      {
        name = "zoxide";
        packages = [pkgs.vimPlugins.telescope-zoxide];
        setup = {
          prompt_title = "Zoxide List";
        };
      }
    ];
    mappings = {
      buffers = "<leader>bf";
      diagnostics = "cD";
      findFiles = "<leader><leader>";
      liveGrep = "<leader>fw";
      lspDefinitions = "gd";
      lspDocumentSymbols = "gs";
      lspImplementations = "gi";
      lspReferences = "gR";
      lspTypeDefinitions = "gt";
      lspWorkspaceSymbols = "gS";
    };
    setupOpts = {
      defaults = {
        color_devicons = true;
      };
    };
  };
}
