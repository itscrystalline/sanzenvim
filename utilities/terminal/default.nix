{lib, ...}: let
  inherit (lib.nvim.dag) entryBefore;
in {
  imports = [
    ./lazygit.nix
  ];
  vim.luaConfigRC.zellij-terminal =
    entryBefore ["mappings"]
    # lua
    ''
      function _G.ZellijTerminal()
      	---@type nil|string
      	_G.opened_zellij_floating = _G.opened_zellij_floating or nil

        local fidget = require("fidget")

      	if _G.opened_zellij_floating ~= nil then
      		fidget.notify("opening term " .. _G.opened_zellij_floating)
      		local result = vim.system({ "zellij", "action", "focus-pane-id", _G.opened_zellij_floating }):wait()
      		if result.code ~= 0 then
      			fidget.notify(result.stderr, vim.log.levels.WARN)
      			_G.opened_zellij_floating = nil
      			_G.ZellijTerminal()
      		end
      	else
      		fidget.notify("opening new term")
      		local result = vim.system({ "zellij", "action", "new-pane", "-f", "--width", "80%", "--height", "60%", "--cwd", vim.fn.getcwd() }):wait()
      		if result.code ~= 0 then
      			fidget.notify("Unable to open new pane. Are you in zellij?", vim.log.levels.ERROR)
      		else
      			_G.opened_zellij_floating = result.stdout:gsub("%s+", "")
      			fidget.notify("got term " .. _G.opened_zellij_floating)
      		end
      	end
      end
    '';
  vim.keymaps = [
    {
      mode = "n";
      key = "<leader>n";
      action =
        # lua
        ''
          function()
            _G:ZellijTerminal()
          end
        '';
      lua = true;
      silent = true;
      desc = "Toggle zellij terminal";
    }
  ];
}
