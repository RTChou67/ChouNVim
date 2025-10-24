return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl", -- 新版使用 ibl 接口
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("ibl").setup({
			indent = {
				char = "│", -- 可选: "▏", "┊", "┆", "│"
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				highlight = { "Function", "Label" },
			},
		})
	end,
}
