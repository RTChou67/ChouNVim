return {
	"folke/tokyonight.nvim",
	lazy = false, -- 不懒加载，确保启动时生效
	priority = 1000, -- 优先加载
	opts = {
		style = "storm", -- 可选："storm", "moon", "night", "day"
		transparent = false, -- 设置为 true 可开启透明背景
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
