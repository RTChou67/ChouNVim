vim.g.python3_host_prog = vim.fn.exepath("python")
require("config.lazy")
vim.opt.number = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.keymap.set("n", "<C-s>", ":w<CR>", {
	desc = "Save file",
})
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", {
	desc = "Save file",
})
vim.keymap.set("i", "<C-H>", "<C-W>", {
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<Esc><Esc>", ":qa!<CR>", {
	desc = "Force quit all",
})

vim.o.timeoutlen = 100
vim.o.updatetime = 100

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})
