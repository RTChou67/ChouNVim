local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
map("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
