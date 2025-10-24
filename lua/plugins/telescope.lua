return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	cmd = "Telescope", -- 添加 cmd 以防万一
	-- <--- 核心修改：添加 keys 来触发加载
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({ cwd = "/home/rtchou" })
			end,
			desc = "Find Files in /home/rtchou",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep({ cwd = "/home/rtchou" })
			end,
			desc = "Live Grep in /home/rtchou",
		},
	},
	config = function()
		require("telescope").setup({
			extensions = {
				fzf = {
					fuzzy = false,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		pcall(require("telescope").load_extension, "fzf")
		
		-- 移除这里的 local builtin = ... 和 vim.keymap.set ...
	end,
}