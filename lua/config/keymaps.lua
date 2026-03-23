local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
map("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })

map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlight" })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })

map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit Window" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })

map("n", "<leader>ws", "<C-w>s", { desc = "Split Horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split Vertical" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close Window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close Other Windows" })
map("n", "<leader>wh", "<C-w>h", { desc = "Focus Left Window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus Lower Window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus Upper Window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus Right Window" })
map("n", "<leader>wH", "<cmd>vertical resize -5<cr>", { desc = "Resize Window Left" })
map("n", "<leader>wL", "<cmd>vertical resize +5<cr>", { desc = "Resize Window Right" })
map("n", "<leader>wJ", "<cmd>resize +3<cr>", { desc = "Resize Window Down" })
map("n", "<leader>wK", "<cmd>resize -3<cr>", { desc = "Resize Window Up" })
