{lib, ...}: let
  inherit (lib.nvim.dag) entryBefore;
in {
  vim = {
    luaConfigRC.zellij-terminal =
      entryBefore ["mappings"]
      # lua
      ''
        function _G.ZellijLazygit()
        	---@type nil|string
        	_G.opened_lazygit = _G.opened_lazygit or nil

          local fidget = require("fidget")

        	if _G.opened_lazygit ~= nil then
        		fidget.notify("reopening lazygit")
        		local result = vim.system({ "zellij", "action", "focus-pane-id", _G.opened_lazygit }):wait()
        		if result.code ~= 0 then
        			fidget.notify(result.stderr, vim.log.levels.WARN)
        			_G.opened_lazygit = nil
        			_G.ZellijLazygit()
        		end
        	else
        		fidget.notify("opening new lazygit")
        		local result = vim.system({ "zellij", "action", "new-pane", "-f", "--width", "80%", "--height", "60%", "--cwd", vim.fn.getcwd(), "--", "lazygit" }):wait()
        		if result.code ~= 0 then
        			fidget.notify("Unable to open new pane. Are you in zellij / have lazygit installed?", vim.log.levels.ERROR)
        		else
        			_G.opened_lazygit = result.stdout:gsub("%s+", "")
        			fidget.notify("got lazygit term " .. _G.opened_lazygit)
        		end
        	end
        end
      '';
    keymaps = [
      {
        mode = "n";
        key = "<leader>g";
        action =
          # lua
          ''
            function()
              _G:ZellijLazygit()
            end
          '';
        lua = true;
        silent = true;
        desc = "open lazygit in zellij float";
      }
    ];
  };
}
