return {
	"brianhuster/live-preview.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	keys = {
		{ "<leader>mb", "<cmd>LivePreview<cr>", desc = "Browser Live Preview (Markdown/HTML)" },
	},
	opts = {
		port = 8080,
		browser = "default",
	},
}
