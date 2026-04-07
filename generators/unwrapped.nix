{
  lib,
  pkgs,
  full,
  ...
}: {
  vim = {
    lsp.servers = {
      nil.cmd = lib.mkForce ["nil"];
      lua-language-server.cmd = lib.mkForce ["lua-language-server"];
      clangd.cmd = lib.mkForce ["clangd"];
      ty.cmd = lib.mkForce ["ty" "server"];
      vtsls = {
        cmd = lib.mkForce ["vtsls" "--stdio"];
        settings.vtsls.tsserver.globalPlugins = lib.mkForce [
          {
            name = "@vue/typescript-plugin";
            location = "";
            languages = ["vue"];
            configNamespace = "typescript";
          }
        ];
      };
      vue_ls.cmd = lib.mkForce ["vue-language-server" "--stdio"];
      yaml-language-server.cmd = lib.mkForce ["yaml-language-server" "--stdio"];
      marksman.cmd = lib.mkForce ["marksman" "server"];
      zls.cmd = lib.mkForce ["zls"];
      phpactor.cmd = lib.mkForce ["phpactor" "language-server"];
      roslyn_ls.cmd = lib.mkForce ["roslyn-ls" "--logLevel=Warning" "--stdio"];
      jdtls.cmd = lib.mkForce ["jdt-language-server"];
      kotlin-language-server.cmd = lib.mkForce ["kotlin-language-server"];
      r_language_server.cmd = lib.mkForce ["R" "--no-echo" "-e" "languageserver::run()"];
      tinymist.cmd = lib.mkForce ["tinymist"];
      superhtml.cmd = lib.mkForce ["superhtml" "lsp"];
      cssls.cmd = lib.mkForce ["vscode-css-language-server" "--stdio"];
      jsonls.cmd = lib.mkForce ["vscode-json-language-server" "--stdio"];
      asm-lsp.cmd = lib.mkForce ["asm-lsp"];
      veridian.cmd = lib.mkForce ["veridian"];
      qmlls.cmd = lib.mkForce ["qmlls"];
      bashls.cmd = lib.mkForce ["bashls" "start"];
    };
    languages = {
      rust.lsp.package = lib.mkForce ["rust-analyzer"];
      typst.extensions.typst-preview-nvim.setupOpts.dependencies_bin = lib.mkForce {
        tinymist = "tinymist";
        websocat = "websocat";
      };
      enableDAP = lib.mkForce false;
    };

    formatter.conform-nvim.setupOpts = {
      formatters = {
        alejandra.command = lib.mkForce "alejandra";
        stylua.command = lib.mkForce "stylua";
        rustfmt.command = lib.mkForce "rustfmt";
        typstyle.command = lib.mkForce "typstyle";
        deno_fmt.command = lib.mkForce "deno";
        prettier.command = lib.mkForce "prettier";
        superhtml = {
          command = lib.mkForce "superhtml";
          args = lib.mkForce ["fmt" "-"];
        };
        jsonfmt = {
          command = lib.mkForce "jsonfmt";
          args = lib.mkForce ["-w" "-"];
        };
        ruff = {
          command = lib.mkForce "ruff";
          args = lib.mkForce ["format" "-"];
        };
        styler.command = lib.mkForce "styler";
        shfmt.command = lib.mkForce "shfmt";
      };
    };

    diagnostics.nvim-lint.linters = {
      statix.cmd = lib.mkForce "statix";
      deadnix.cmd = lib.mkForce "deadnix";
      luacheck.cmd = lib.mkForce "luacheck";
      htmlhint.cmd = lib.mkForce "htmlhint";
      markdownlint-cli2.cmd = lib.mkForce "markdownlint-cli2";
      eslint_d.cmd = lib.mkForce "eslint_d";
      ktlint.cmd = lib.mkForce "ktlint";
      shellcheck.cmd = lib.mkForce "shellcheck";
    };

    extraPackages = lib.mkForce ([pkgs.ripgrep pkgs.direnv]
      ++ (
        if full
        then [pkgs.imagemagick pkgs.silicon]
        else []
      ));
  };
}
