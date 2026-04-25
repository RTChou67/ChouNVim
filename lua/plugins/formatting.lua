return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            c = { "clang-format" },
            python = { "isort", "black" },
            lua = { "stylua" },
            cpp = { "clang-format" },
            bash = { "shfmt" },
            fortran = { "fprettify" },
            rust = { "rustfmt" },
            sh = { "shfmt" },
            toml = { "taplo" },
            yaml = { "yamlfmt" },
            zsh = { "shfmt" },
            tex = { "latexindent" },
        },
        format_on_save = function(bufnr)
            return {
                timeout_ms = 2000,
                lsp_format = "fallback",
            }
        end,
    },
}
