{
  full,
  lib,
  pkgs,
  ...
}: let
  matlabLspScript = pkgs.writeShellScript "matlab-lsp" ''
    exec distrobox enter matlab -- node --no-deprecation $HOME/.local/share/matlab-lsp/out/index.js --matlabInstallPath $HOME/.local/share/matlab "$@"
  '';
in
  lib.mkIf full {
    vim = {
      lsp.servers.matlab_ls = {
        cmd = ["${matlabLspScript}" "--stdio"];
        filetypes = ["matlab"];
        root_dir = lib.mkLuaInline ''
          function(bufnr, on_dir)
            local root_dir = vim.fs.root(bufnr, '.git')
            on_dir(root_dir or vim.fn.getcwd())
          end
        '';
        settings = {
          MATLAB = {
            indexWorkspace = true;
            installPath = "/home/itscrystalline/.local/share/matlab";
            matlabConnectionTiming = "onStart";
          };
        };
      };
      diagnostics.nvim-lint = {
        linters.mh_lint.cmd = "mh_lint";
        linters_by_ft.matlab = ["mh_lint"];
      };
      formatter.conform-nvim.setupOpts = {
        formatters.mh_style.command = "mh_style";
        formatters_by_ft.matlab = ["mh_style"];
      };

      treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.matlab];
      extraPackages = with pkgs.python313Packages; [miss-hit miss-hit-core];
    };
  }
