-- lua/plugins/ui/dropbar.lua
return {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>pw", function() require("dropbar.api").pick() end, desc = "Pick Winbar" },
    },
    opts = {
        -- 基础配置通常就足够好用了
        bar = {
            -- 如果你想在某些文件类型中禁用它
            exclude_filetypes = {
                "neo-tree",
                "dashboard",
                "Aerial",
            },
        },
    },
}
