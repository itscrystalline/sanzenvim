local config_dir = vim.fn.stdpath("config")
local generated_config = config_dir .. "/sanzenvim.generated.lua"

vim.opt.packpath:prepend(config_dir)
vim.opt.runtimepath:prepend(config_dir)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.cmd("packloadall")
dofile(generated_config)
