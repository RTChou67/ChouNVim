-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- ========================================
        -- 核心依赖（必须最先加载）
        -- ========================================
        { import = "plugins.core" },

        -- ========================================
        -- 重要的单文件插件
        -- ========================================
        { import = "plugins.treesitter" },
        { import = "plugins.formatting" },

        -- ========================================
        -- 分类插件目录
        -- ========================================
        { import = "plugins.coding" },
        { import = "plugins.editor" },
        { import = "plugins.lsp" },
        { import = "plugins.ui" },
        { import = "plugins.git" },
        { import = "plugins.extras" },
    },

    -- ========================================
    -- Lazy.nvim 配置
    -- ========================================
    defaults = {
        lazy = false,    -- 默认不懒加载（除非插件自己指定）
        version = false, -- 使用 git HEAD 而不是版本号
    },

    install = {
        colorscheme = { "tokyonight", "habamax" },
    },

    checker = {
        enabled = true,   -- 自动检查插件更新
        notify = false,   -- 不要每次都通知
        frequency = 3600, -- 检查频率（秒）
    },

    change_detection = {
        enabled = true,
        notify = false,
    },

    ui = {
        border = "rounded",
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },

    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
