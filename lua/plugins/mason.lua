return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	opts = {
		ensure_installed = {

			-- Formatters
			"black",
			"stylua",
			"clang-format",
			"shfmt",
		},
	},
	config = function()
		require("mason").setup()
	end,
}
