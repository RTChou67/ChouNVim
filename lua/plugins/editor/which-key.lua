return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup()
		wk.add({
			{ "<leader>b", group = "Buffers" },
			{ "<leader>c", group = "Code" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>m", group = "Markdown" },
			{ "<leader>n", group = "Search" },
			{ "<leader>o", group = "Outline" },
			{ "<leader>p", group = "Pick" },
			{ "<leader>q", group = "Quit / Session" },
			{ "<leader>r", group = "Rename / Refactor" },
			{ "<leader>w", group = "Windows" },
			{ "<leader>x", group = "Diagnostics" },
		})
	end,
}
