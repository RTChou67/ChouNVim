return {
    "stevearc/aerial.nvim",
    keys = {
        { "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle Outline" },
    },
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
        on_attach = function(bufnr)
            vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Prev Symbol" })
            vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next Symbol" })
        end,
    },
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
}
