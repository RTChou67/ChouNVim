return {
	"kylechui/nvim-surround",
	version = "*", -- 使用最新版本
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			-- 可以在这里添加自定义配置
		})
	end,
}
