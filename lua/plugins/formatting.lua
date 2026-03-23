return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            c = { "clang-format" },
            python = { "black" },
            lua = { "stylua" },
            cpp = { "clang-format" },
            bash = { "shfmt" },
            sh = { "shfmt" },
            zsh = { "shfmt" },
            tex = { "latexindent" },
        },
        format_on_save = function(bufnr)
            return {
                timeout_ms = 2000,
                lsp_fallback = true,
            }
        end,
    },
}
