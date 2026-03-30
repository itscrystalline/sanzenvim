local function ensure_treesitter_parsers()
	local config_dir = vim.fn.stdpath("config")
	local flag_file = config_dir .. "/.ts_installed"

	if vim.fn.filereadable(flag_file) == 1 then
		return
	end

	local parser_dir = config_dir .. "/pack/mnw/start/nvim-treesitter-grammars/parser"
	local extensions = { "*.so", "*.dll", "*.dylib" }
	local has_parsers = false

	for _, ext in ipairs(extensions) do
		local parsers = vim.fn.glob(parser_dir .. "/" .. ext, false, true)
		if #parsers > 0 then
			has_parsers = true
			break
		end
	end

	if has_parsers then
		vim.fn.writefile({}, flag_file)
		return
	end

	vim.notify("Installing treesitter parsers (first run)...", vim.log.levels.INFO)

	vim.cmd([[
    TSInstall lua nix markdown markdown_inline vim vimdoc bash json yaml toml
  ]])

	vim.defer_fn(function()
		local installed = false
		for _, ext in ipairs(extensions) do
			local parsers = vim.fn.glob(parser_dir .. "/" .. ext, false, true)
			if #parsers > 0 then
				installed = true
				break
			end
		end

		if installed then
			vim.fn.writefile({}, flag_file)
			vim.notify("Treesitter parsers installed successfully!", vim.log.levels.INFO)
		else
			vim.notify("Treesitter install may have failed - check :TSInstallInfo", vim.log.levels.WARN)
		end
	end, 5000)
end

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

vim.opt.packpath:prepend(config_dir)
vim.opt.runtimepath:prepend(config_dir)

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.cmd("packloadall")
vim.api.nvim_create_autocmd("VimEnter", {
	callback = ensure_treesitter_parsers,
	once = true,
})
dofile(config_file)
