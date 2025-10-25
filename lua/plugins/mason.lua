return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {
			-- LSPs
			"lua_ls",
			"julia-lsp",
			"pyright",
			"texlab",
			-- Formatters
			"black",
			"stylua",
			"clang-format",
			"shfmt",
			"latexindent",
		},
	},
	config = function()
		require("mason").setup()
	end,
}
