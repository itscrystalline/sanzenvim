{lib, ...}: let
  mkFmt = lang: list:
    if builtins.isAttrs (lib.last list)
    then
      (let
        len = builtins.length list;
        formatters = lib.take (len - 1) list;
        options = builtins.elemAt (len - 1);

        formatters_attrs = builtins.listToAttrs (lib.imap0 (idx: val: {
            name = "__unkeyed-${builtins.toString idx}";
            value = val;
          })
          formatters);
      in {
        "${lang}" = formatters_attrs // options;
      })
    else {
      "${lang}" = list;
    };
in {
  vim.formatter.conform-nvim = {
    enable = true;
    setupOpts = {
      notify_on_error = true;
      format_on_save = lib.mkLuaInline ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end
      '';
      formatters_by_ft = lib.mergeAttrsList [
        (mkFmt "lua" ["stylua"])
        (mkFmt "nix" ["alejandra"])
      ];
    };
  };
}
