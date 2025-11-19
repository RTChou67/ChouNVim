vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = vim.fn.exepath("python")
local opt = vim.opt
opt.number = true
opt.signcolumn = "yes"

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

opt.termguicolors = true
opt.cursorline = true -- 高亮当前行
opt.mouse = "a"       -- 启用鼠标
opt.wrap = false      -- 不自动换行
opt.scrolloff = 8     -- 滚动时保持 8 行边距
opt.sidescrolloff = 8


opt.ignorecase = true
opt.smartcase = true -- 有大写字母时区分大小写
opt.hlsearch = true
opt.incsearch = true


opt.splitbelow = true
opt.splitright = true


opt.timeoutlen = 500
opt.updatetime = 300


opt.clipboard = "unnamedplus"


opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"


opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10 -- 补全菜单高度


opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1
opt.confirm = true
opt.wildmode = "longest:full,full"
