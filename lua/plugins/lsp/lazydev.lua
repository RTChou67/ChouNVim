return {
    "folke/lazydev.nvim",
    ft = "lua", -- 仅在 lua 文件加载
    opts = {
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    },
}
