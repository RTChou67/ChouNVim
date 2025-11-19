return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "Trouble" },
	keys = {
		{ "<leader>xx", "<cmd>Trouble toggle<cr>", desc = "Toggle Trouble" },
		{ "<leader>xw", "<cmd>Trouble toggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		{ "<leader>xd", "<cmd>Trouble toggle document_diagnostics<cr>", desc = "Document Diagnostics" },
	},
	opts = {
		-- 您的配置
	},
}
