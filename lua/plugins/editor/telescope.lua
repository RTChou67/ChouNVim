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
	cmd = "Telescope",
	keys = {
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find Buffers",
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Find Diagnostics",
		},
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
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Find Help Tags",
		},
		{
			"<leader>fk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Find Keymaps",
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
	end,
}
