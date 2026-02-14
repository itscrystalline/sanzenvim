# This module rewrites all explicit dependencies on language servers,
# formatters, linters, and debuggers into implicit ones, expecting them
# to be provided by the environment (e.g. a devShell / direnv / system PATH).
{
  lib,
  pkgs,
  ...
}: {
  vim = {
    # ── LSP server commands ─────────────────────────────────────────────
    # Override every server cmd to use a bare command name from PATH
    # instead of a Nix store path.
    lsp.servers = {
      # Nix (nvf default: nil)
      nil.cmd = lib.mkForce ["nil"];
      # Lua (nvf default: lua-language-server)
      lua-language-server.cmd = lib.mkForce ["lua-language-server"];
      # C/C++ (nvf default: clangd via clang-tools)
      clangd.cmd = lib.mkForce ["clangd"];
      # Python – custom ty server (sanzenvim)
      ty.cmd = lib.mkForce ["ty" "server"];
      # TypeScript/JavaScript – vtsls (sanzenvim)
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
      # Vue (sanzenvim)
      vue_ls.cmd = lib.mkForce ["vue-language-server" "--stdio"];
      # YAML (nvf default: yaml-language-server)
      yaml-language-server.cmd = lib.mkForce ["yaml-language-server" "--stdio"];
      # Markdown (nvf default: marksman)
      marksman.cmd = lib.mkForce ["marksman" "server"];
      # Zig (nvf default: zls)
      zls.cmd = lib.mkForce ["zls"];
      # PHP (nvf default: phpactor)
      phpactor.cmd = lib.mkForce ["phpactor" "language-server"];
      # C# (sanzenvim uses roslyn_ls)
      roslyn_ls.cmd = lib.mkForce ["roslyn-ls" "--logLevel=Warning" "--stdio"];
      # Java (nvf default: jdtls)
      jdtls.cmd = lib.mkForce ["jdt-language-server"];
      # Kotlin (nvf default: kotlin-language-server)
      kotlin-language-server.cmd = lib.mkForce ["kotlin-language-server"];
      # R (nvf default: r_language_server via rWrapper)
      r_language_server.cmd = lib.mkForce ["R" "--no-echo" "-e" "languageserver::run()"];
      # Typst (nvf default: tinymist)
      tinymist.cmd = lib.mkForce ["tinymist"];
      # HTML (nvf default: superhtml)
      superhtml.cmd = lib.mkForce ["superhtml" "lsp"];
      # CSS (nvf default: cssls via vscode-langservers-extracted)
      cssls.cmd = lib.mkForce ["vscode-css-language-server" "--stdio"];
      # JSON (nvf default: jsonls via vscode-langservers-extracted)
      jsonls.cmd = lib.mkForce ["vscode-json-language-server" "--stdio"];
      # Assembly (nvf default: asm-lsp)
      asm-lsp.cmd = lib.mkForce ["asm-lsp"];
      # Verilog – custom veridian server (sanzenvim)
      veridian.cmd = lib.mkForce ["veridian"];
    };
    languages = {
      # ── Rust LSP ────────────────────────────────────────────────────────
      # rustaceanvim accepts a list of strings to discover from PATH.
      rust.lsp.package = lib.mkForce ["rust-analyzer"];

      # ── Typst preview dependencies ──────────────────────────────────────
      typst.extensions.typst-preview-nvim.setupOpts.dependencies_bin = lib.mkForce {
        tinymist = "tinymist";
        websocat = "websocat";
      };

      # ── DAP ──────────────────────────────────────────────────────────────
      # Disable DAP for unwrapped builds – debugger adapters embed Nix store
      # paths in generated Lua that cannot be overridden via module options.

      enableDAP = lib.mkForce false;
    };

    # ── Formatter commands ──────────────────────────────────────────────
    # Override every formatter command that nvf sets to a Nix store path.
    formatter.conform-nvim.setupOpts = {
      formatters = {
        # Nix
        alejandra.command = lib.mkForce "alejandra";
        # Lua
        stylua.command = lib.mkForce "stylua";
        # Rust
        rustfmt.command = lib.mkForce "rustfmt";
        # Typst
        typstyle.command = lib.mkForce "typstyle";
        # Markdown (nvf default: deno_fmt)
        deno_fmt.command = lib.mkForce "deno";
        # CSS / TS / JS (nvf default: prettier)
        prettier.command = lib.mkForce "prettier";
        # HTML (nvf default: superhtml)
        superhtml = {
          command = lib.mkForce "superhtml";
          args = lib.mkForce ["fmt" "-"];
        };
        # JSON (nvf default: jsonfmt)
        jsonfmt = {
          command = lib.mkForce "jsonfmt";
          args = lib.mkForce ["-w" "-"];
        };
        # Python (sanzenvim uses ruff)
        ruff = {
          command = lib.mkForce "ruff";
          args = lib.mkForce ["format" "-"];
        };
        # R (nvf default: styler)
        styler.command = lib.mkForce "styler";
      };
      # nvf's ts.nix has a nested setupOpts path for formatters
      setupOpts.formatters.prettier.command = lib.mkForce "prettier";
    };

    # ── Diagnostics linter commands ─────────────────────────────────────
    # Override every linter cmd that nvf sets to a Nix store path.
    diagnostics.nvim-lint.linters = {
      # Nix
      statix.cmd = lib.mkForce "statix";
      deadnix.cmd = lib.mkForce "deadnix";
      # Lua
      luacheck.cmd = lib.mkForce "luacheck";
      # HTML
      htmlhint.cmd = lib.mkForce "htmlhint";
      # Markdown
      markdownlint-cli2.cmd = lib.mkForce "markdownlint-cli2";
      # TypeScript/JavaScript
      eslint_d.cmd = lib.mkForce "eslint_d";
      # Kotlin
      ktlint.cmd = lib.mkForce "ktlint";
    };

    # ── QML LSP/formatter ────────────────────────────────────────────────
    # nvf's QML module uses qtdeclarative for both qmlls and qmlformat.
    # Override the server cmd; the formatter is only used when LSP is off,
    # so the server override alone is sufficient.
    lsp.servers.qmlls.cmd = lib.mkForce ["qmlls"];

    # ── Remove explicit LSP/formatter/linter packages ─────────────────
    # Keep blink-cmp dependencies (ripgrep) bundled in all builds.
    extraPackages = lib.mkForce [pkgs.ripgrep pkgs.direnv];
  };
}
