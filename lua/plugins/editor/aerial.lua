return {
    "stevearc/aerial.nvim",
    opts = {
        layout = {
            default_direction = "right",
            width = 30,
        },
        default_mode = "vsplit",
        -- 添加这个配置来控制显示的详细程度
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
        on_attach = function(bufnr)
            vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<CR>",
                { buffer = bufnr, desc = "Toggle Aerial" })
        end,
    },
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function(_, opts)
        require("aerial").setup(opts)
        vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline" })
    end,
}
