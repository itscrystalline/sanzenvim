local function get_config_dir()
	local info = debug.getinfo(1, "S")
	if info and info.source then
		local source = info.source:sub(1, 1) == "@" and info.source:sub(2) or info.source
		local resolved = vim.loop.fs_realpath(source) or source
		return vim.loop.fs_realpath(vim.fn.fnamemodify(resolved, ":h")) or vim.fn.fnamemodify(resolved, ":h")
	end

	error("no config dir")
end

local config_dir = get_config_dir()
local config_file = config_dir .. "/sanzenvim.generated.lua"

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("TSInstall " .. treesitter_parsers)
	end,
	once = true,
})

vim.opt.packpath:prepend(config_dir)
vim.opt.runtimepath:prepend(config_dir)

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.cmd("packloadall")

dofile(config_file)
