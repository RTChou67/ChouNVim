return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "storm",
		transparent = false,
		terminal_colors = true,
		styles = {
			comments = {
				italic = true,
			},
			keywords = {
				italic = true,
			},
			functions = {},
			variables = {},
		},
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd([[colorscheme tokyonight]])
	end,
}
