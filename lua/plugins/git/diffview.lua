return {
	"sindrets/diffview.nvim",
	event = "VeryLazy", -- 或者使用 cmd 来更极致地懒加载
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
		"DiffviewFileHistory",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
	},
	opts = {
		enhanced_diff_hl = true, -- 更好的差异高亮
		view = {
			-- 配置 Diff 视图的布局
			-- 可选值: "diff1_plain", "diff2_horizontal", "diff2_vertical", "diff3_horizontal", "diff3_vertical", "diff3_mixed"
			default = {
				layout = "diff2_horizontal",
			},
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = true, -- 在合并冲突时禁用诊断信息，避免干扰
			},
			file_history = {
				layout = "diff2_horizontal",
			},
		},
		file_panel = {
			listing_style = "tree", -- 文件列表显示为树状 "tree" 或 列表 "list"
			win_config = {
				position = "left", -- 文件面板在左侧
				width = 30,
			},
		},
		hooks = {
			diff_buf_read = function(bufnr)
				-- 在 Diff 缓冲区中禁用某些功能以提升性能或避免干扰
				vim.opt_local.cursorline = false
				vim.opt_local.list = false
			end,
		},
	},
}
