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
	config = function()
		require("telescope").setup({
			defaults = {
				-- 设置默认搜索目录
				cwd = "/home/rtchou",
			},
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

		-- 可选：绑定快捷键以使用固定目录
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({
				cwd = "/home/rtchou",
			})
		end, {
			desc = "Find Files in /home/rtchou",
		})

		vim.keymap.set("n", "<leader>fg", function()
			builtin.live_grep({
				cwd = "/home/rtchou",
			})
		end, {
			desc = "Live Grep in /home/rtchou",
		})
	end,
}
