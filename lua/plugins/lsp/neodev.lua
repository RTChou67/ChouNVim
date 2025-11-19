return {
    "folke/neodev.nvim",
    ft = "lua", -- 只在打开 Lua 文件时加载
    opts = {
        library = {
            enabled = true,
            runtime = true, -- Neovim runtime files
            types = true, -- Neovim types
            plugins = true, -- 已安装插件的类型
        },
        setup_jsonls = true, -- 配置 JSON LSP（用于 settings.json）
    },
}
