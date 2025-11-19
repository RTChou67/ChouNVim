return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            direction = "float",
            start_in_insert = true,
            insert_mappings = true,
            close_on_exit = true,
            float_opts = {
                border = "rounded",
            },
        })
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set("n", "tgt", "<cmd>ToggleTerm<cr>", opts)
        end

        vim.cmd("autocmd TermOpen * lua set_terminal_keymaps()")
    end,
    keys = {
        { "tgt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
}
