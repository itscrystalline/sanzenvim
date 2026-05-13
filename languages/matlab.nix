{
  full,
  lib,
  pkgs,
  ...
}: let
  matlabSearchScript = pkgs.writeShellScript "matlabls-docker.sh" ''
    CONTAINER=$(docker ps --filter "ancestor=matlab-with-ls:latest" --format "{{.ID}}" | head -1)
    if [ -z "$CONTAINER" ]; then
        echo "no running container found" >&2
        exit 1
    fi
    exec docker exec -i "$CONTAINER" node /usr/local/lib/matlab-language-server/out/index.js "$@"
  '';
in
  lib.mkIf full {
    vim = {
      lsp.servers.matlab_ls = {
        cmd = ["${matlabSearchScript}" "--stdio"];
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
            installPath = "/opt/matlab/R2026a";
            matlabConnectionTiming = "onStart";
            telemetry = false;
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
