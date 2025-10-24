return {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
        ensure_installed = { -- LSPs
        "lua_ls", "pyright", -- Formatters
        "black", "stylua", "clang-format", "shfmt"}
    },
    config = function()
        require("mason").setup()
    end
}
