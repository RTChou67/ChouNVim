return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "tokyonight", -- 确保你使用的配色主题存在
				globalstatus = true, -- 推荐开启：全局状态栏
			},
		})
	end,
}
