{
  pkgs,
  lib,
  ...
}: {
  vim = {
    utility.direnv.enable = true;
    extraPackages = [pkgs.direnv];
    autocmds = [
      {
        enable = true;
        callback =
          lib.mkLuaInline
          # lua
          ''
            function()
              local next = next
              local clients = vim.lsp.get_clients()

              if next(clients) ~= nil then
                for _, c in ipairs(clients) do
                  c:stop()
                end
                vim.cmd([[edit]])
              else
                print("No LSP attached yet")
              end
            end
          '';
        desc = "Restart LSPs when direnv has loaded.";
        event = ["User"];
        pattern = ["DirenvLoaded"];
      }
    ];
  };
}
