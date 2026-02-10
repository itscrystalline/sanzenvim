# This module rewrites all explicit dependencies on language servers and
# formatters into implicit ones, expecting them to be provided by the
# environment (e.g. a devShell / direnv / system PATH).
{
  lib,
  config,
  ...
}: {
  vim = {
    # Override LSP server commands to use bare command names from PATH
    # instead of Nix store paths. This covers both nvf-managed servers
    # and custom ones defined in this config.
    lsp.servers = {
      # Nix (nvf default: nil)
      nil.cmd = lib.mkForce ["nil"];
      # Lua (nvf default: lua-language-server)
      lua-language-server.cmd = lib.mkForce ["lua-language-server"];
      # Clang (nvf default: clangd)
      clangd.cmd = lib.mkForce ["clangd"];
      # Python – custom ty server
      ty.cmd = lib.mkForce ["ty" "server"];
      # TypeScript/JavaScript – vtsls
      vtsls.cmd = lib.mkForce ["vtsls" "--stdio"];
      # Vue
      vue_ls.cmd = lib.mkForce ["vue-language-server" "--stdio"];
      # YAML
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
      # Verilog – custom veridian server
      veridian.cmd = lib.mkForce ["veridian"];
    };

    # Override Rust LSP package to use bare command from PATH
    languages.rust.lsp.package = lib.mkForce ["rust-analyzer"];

    # Override formatter commands to use bare names from PATH.
    # nvf-managed formatters set `command` to Nix store paths;
    # we rewrite them to plain command names.
    formatter.conform-nvim.setupOpts.formatters = {
      alejandra.command = lib.mkForce "alejandra";
      stylua.command = lib.mkForce "stylua";
      rustfmt.command = lib.mkForce "rustfmt";
    };

    # Remove explicit formatter packages – they should come from the environment
    extraPackages = lib.mkForce [];
  };
}
