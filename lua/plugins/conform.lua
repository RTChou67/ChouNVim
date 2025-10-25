return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			python = { "black" },
			lua = { "stylua" },
			cpp = { "clang-format" },
			sh = { "shfmt" },
			zsh = { "shfmt" },
			tex = { "latexindent" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
