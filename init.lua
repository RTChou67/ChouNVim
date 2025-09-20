vim.g.python3_host_prog = vim.fn.exepath("python")
require("config.lazy")
vim.opt.number = true
vim.opt.syntax = "off"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

-- Ctrl+S 保存
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })
vim.keymap.set("i", "<C-H>", "<C-W>", { noremap = true, silent = true })
-- 双Esc 强制退出所有
vim.keymap.set("n", "<Esc><Esc>", ":qa!<CR>", { desc = "Force quit all" })

-- 可选：减少等待延迟，提高连按速度响应
vim.o.timeoutlen = 300

vim.diagnostic.config({
	virtual_text = true, -- 显示内联错误信息
	signs = true, -- 左边栏图标
	underline = true, -- 下划线高亮错误
	update_in_insert = true, -- ✅ 关键：插入模式中也实时更新诊断
	severity_sort = true, -- 严重性排序
})
