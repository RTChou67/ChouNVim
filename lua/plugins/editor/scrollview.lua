return { -- 交互式滚动条（支持拖动）
	"dstein64/nvim-scrollview",
	config = function()
		require("scrollview").setup({})
	end,
}
