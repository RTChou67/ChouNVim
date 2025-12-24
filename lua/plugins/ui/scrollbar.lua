return {
    "dstein64/nvim-scrollview",
    event = "BufReadPost",
    config = function()
        require("scrollview").setup({
            excluded_filetypes = { "neo-tree", "dashboard", "Aerial", "help" },
            scrollview_auto_mouse = true,
            sign_column = 1,
            winblend = 30,
        })
    end,
}
