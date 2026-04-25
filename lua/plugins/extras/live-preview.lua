return {
	"brianhuster/live-preview.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	cmd = "LivePreview",
	main = "livepreview",
	keys = {
		{ "<leader>mb", "<cmd>LivePreview start<cr>", desc = "Browser Live Preview (Markdown/HTML)" },
	},
	opts = {
		port = 8080,
		browser = "default",
	},
}
