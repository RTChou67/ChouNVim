return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        notifier = { enabled = true },
        dashboard = { enabled = true },
        scroll = { enabled = true },
        input = { enabled = true },
        terminal = { enabled = true },
        bigfile = { enabled = true },
        words = { enabled = true },
        indent = { enabled = true },
    },
}
