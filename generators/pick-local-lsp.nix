{
  lib,
  pkgs,
  ...
}: let
  # https://github.com/NotAShelf/nvf/issues/1180#issuecomment-4025396405
  choiceScript = target:
    pkgs.writeShellScriptBin "${target}_search" ''
      path_to_executable=$(which ${target})
       if [ -x "$path_to_executable" ] ; then
            exec ${target} "$@"
      fi
      exec ${pkgs.lib.getExe pkgs.${target}} "$@"
    '';
  choiceScriptPkgs = target: pkgsName: let
    entry = lib.attrsets.attrByPath (lib.strings.splitString "." pkgsName) null pkgs;
  in
    pkgs.writeShellScriptBin "${target}_search" ''
      path_to_executable=$(which ${target})
       if [ -x "$path_to_executable" ] ; then
            exec ${target} "$@"
      fi
      exec ${entry}/bin/${target} "$@"
    '';
in {
  vim.lsp.servers = {
    nil.cmd = lib.mkForce ["${lib.getExe (choiceScript "nil")}"];
    lua-language-server.cmd = lib.mkForce ["${lib.getExe (choiceScript "lua-language-server")}"];
    clangd.cmd = lib.mkForce ["${lib.getExe (choiceScriptPkgs "clangd" "clang-tools")}"];
    ty.cmd = lib.mkForce ["${lib.getExe (choiceScript "ty")}" "server"];
    vtsls = {
      cmd = lib.mkForce ["${lib.getExe (choiceScript "vtsls")}" "--stdio"];
      settings.vtsls.tsserver.globalPlugins = lib.mkForce [
        {
          name = "@vue/typescript-plugin";
          location = "";
          languages = ["vue"];
          configNamespace = "typescript";
        }
      ];
    };
    vue_ls.cmd = lib.mkForce ["${lib.getExe (choiceScript "vue-language-server")}" "--stdio"];
    yaml-language-server.cmd = lib.mkForce ["${lib.getExe (choiceScript "yaml-language-server")}" "--stdio"];
    marksman.cmd = lib.mkForce ["${lib.getExe (choiceScript "marksman")}" "server"];
    zls.cmd = lib.mkForce ["${lib.getExe (choiceScript "zls")}"];
    phpactor.cmd = lib.mkForce ["${lib.getExe (choiceScript "phpactor")}" "language-server"];
    roslyn_ls.cmd = lib.mkForce ["${lib.getExe (choiceScript "roslyn-ls")}" "--logLevel=Warning" "--stdio"];
    jdtls.cmd = lib.mkForce ["${lib.getExe (choiceScript "jdt-language-server")}"];
    kotlin-language-server.cmd = lib.mkForce ["${lib.getExe (choiceScript "kotlin-language-server")}"];
    r_language_server.cmd = lib.mkForce ["${lib.getExe (choiceScript "R")}" "--no-echo" "-e" "languageserver::run()"];
    tinymist.cmd = lib.mkForce ["${lib.getExe (choiceScript "tinymist")}"];
    superhtml.cmd = lib.mkForce ["${lib.getExe (choiceScript "superhtml")}" "lsp"];
    cssls.cmd = lib.mkForce ["${lib.getExe (choiceScriptPkgs "vscode-css-language-server" "vscode-langservers-extracted")}" "--stdio"];
    jsonls.cmd = lib.mkForce ["${lib.getExe (choiceScriptPkgs "vscode-json-language-server" "vscode-langservers-extracted")}" "--stdio"];
    asm-lsp.cmd = lib.mkForce ["${lib.getExe (choiceScript "asm-lsp")}"];
    veridian.cmd = lib.mkForce ["${lib.getExe (choiceScriptPkgs "veridian" "veridian")}"]; # complains abt not having meta.mainProgram
    qmlls.cmd = lib.mkForce ["${lib.getExe (choiceScriptPkgs "qmlls" "kdePackages.qtdeclarative.out")}"];
    bashls.cmd = lib.mkForce ["${lib.getExe (choiceScriptPkgs "bashls" "bash-language-server")}" "start"];
    matlab_ls.cmd = lib.mkForce ["${lib.getExe (choiceScript "matlab-language-server")}" "start"];
  };
  vim.languages = {
    rust.lsp.package = lib.mkForce ["${lib.getExe (choiceScript "rust-analyzer")}"];
    typst.extensions.typst-preview-nvim.setupOpts.dependencies_bin = lib.mkForce {
      tinymist = "${lib.getExe (choiceScript "tinymist")}";
      websocat = "${lib.getExe (choiceScript "websocat")}";
    };
  };
}
