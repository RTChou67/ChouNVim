return {
	"stevearc/aerial.nvim",
	opts = {
		layout = {
			default_direction = "right",
			width = 30,
		},
		on_attach = function(_)
			vim.cmd("AerialOpen")
		end,
	},
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function(_, opts)
		require("aerial").setup(opts)
		vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline" })
	end,
}
