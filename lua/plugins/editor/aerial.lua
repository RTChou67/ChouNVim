return {
    "stevearc/aerial.nvim",
    -- 1. 核心改进：添加 keys 属性来触发加载
    keys = {
        { "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle Outline" },
    },
    -- 2. 使用 opts 直接定义配置
    opts = {
        layout = {
            default_direction = "right",
            width = 30,
        },
        default_mode = "vsplit",
        filter_kind = {
            "Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
            "Variable",
            "Constant",
            "Field",
            "Property",
        },
        -- on_attach 里的快捷键是在 Aerial 窗口内使用的
        on_attach = function(bufnr)
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Prev Symbol" })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next Symbol" })
        end,
    },
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    -- 3. 简化 config：如果你只用了 opts，通常不需要再写 config 函数
    -- lazy.nvim 会自动帮你执行 require("aerial").setup(opts)
}
