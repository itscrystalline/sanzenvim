{pkgs, ...}: {
  vim = {
    utility.direnv.enable = true;
    extraPackages = [pkgs.direnv];
    # causes way more problems than it's worth
    # autocmds = [
    #   {
    #     enable = true;
    #     callback =
    #       lib.mkLuaInline
    #       # lua
    #       ''
    #         function()
    #           local next = next
    #           local clients = vim.lsp.get_clients()
    #           local cwd = vim.fn.getcwd()
    #           local buf_name = vim.api.nvim_buf_get_name(0)
    #
    #           if next(clients) ~= nil and buf_name ~= "" then
    #             for _, c in ipairs(clients) do
    #               if c.root_dir ~= nil and string.find(c.root_dir, cwd) then
    #                 c:stop()
    #               end
    #             end
    #             -- if string.find(cwd, buf_name) then
    #             vim.cmd([[edit]])
    #             -- end
    #           end
    #         end
    #       '';
    #     desc = "Restart LSPs when direnv has loaded.";
    #     event = ["User"];
    #     pattern = ["DirenvLoaded"];
    #   }
    # ];
  };
}
