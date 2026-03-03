local M = {}

M.menu = {
	default = {
		{
			name = "  Cut",
			cmd = '"+x',
			rtxt = "",
		},
		{
			name = "  Copy",
			cmd = '"+y',
			rtxt = "",
		},
		{
			name = "  Paste",
			cmd = '"+p',
			rtxt = "",
		},
		{ name = "separator" },
		{
			name = "  Go to Definition",
			cmd = "lua vim.lsp.buf.definition()",
			rtxt = "gd",
		},
		{
			name = "  Go to Declaration",
			cmd = "lua vim.lsp.buf.declaration()",
			rtxt = "gD",
		},
		{
			name = "  Find References",
			cmd = "lua vim.lsp.buf.references()",
			rtxt = "gr",
		},
		{ name = "separator" },
		{
			name = "  Code Action",
			cmd = "lua vim.lsp.buf.code_action()",
			rtxt = "<leader>ca",
		},
		{
			name = "  Rename",
			cmd = "lua vim.lsp.buf.rename()",
			rtxt = "<leader>rn",
		},
		{ name = "separator" },
		{
			name = "  Format",
			cmd = "lua require('conform').format({ lsp_fallback = true })",
			rtxt = "",
		},
		{ name = "separator" },
		{
			name = "  Telescope Find Files",
			cmd = "Telescope find_files",
			rtxt = "<leader>ff",
		},
		{
			name = "  Telescope Live Grep",
			cmd = "Telescope live_grep",
			rtxt = "<leader>fg",
		},
	},

	nvimtree = {
		{
			name = "  Open",
			cmd = "lua require('neo-tree.sources.filesystem.commands').open(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "",
		},
		{
			name = "  New File",
			cmd = "lua require('neo-tree.sources.filesystem.commands').add(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "a",
		},
		{
			name = "  New Directory",
			cmd = "lua require('neo-tree.sources.filesystem.commands').add_directory(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "A",
		},
		{ name = "separator" },
		{
			name = "  Rename",
			cmd = "lua require('neo-tree.sources.filesystem.commands').rename(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "r",
		},
		{
			name = "  Delete",
			cmd = "lua require('neo-tree.sources.filesystem.commands').delete(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "d",
		},
		{ name = "separator" },
		{
			name = "  Copy",
			cmd = "lua require('neo-tree.sources.filesystem.commands').copy_to_clipboard(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "y",
		},
		{
			name = "  Cut",
			cmd = "lua require('neo-tree.sources.filesystem.commands').cut_to_clipboard(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "x",
		},
		{
			name = "  Paste",
			cmd = "lua require('neo-tree.sources.filesystem.commands').paste_from_clipboard(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "p",
		},
		{ name = "separator" },
		{
			name = "  Refresh",
			cmd = "lua require('neo-tree.sources.filesystem.commands').refresh(require('neo-tree.sources.manager').get_state('filesystem'))",
			rtxt = "R",
		},
	},

	markdown = {
		{
			name = "  Cut",
			cmd = '"+x',
			rtxt = "",
		},
		{
			name = "  Copy",
			cmd = '"+y',
			rtxt = "",
		},
		{
			name = "  Paste",
			cmd = '"+p',
			rtxt = "",
		},
		{ name = "separator" },
		{
			name = "  Preview (Split)",
			cmd = "lua require('render-markdown').enable(); require('render-markdown').preview()",
			rtxt = "",
		},
		{
			name = "  Preview (Browser)",
			cmd = "LivePreview",
			rtxt = "<leader>mb",
		},
		{ name = "separator" },
		{
			name = "  Format",
			cmd = "lua require('conform').format({ lsp_fallback = true })",
			rtxt = "",
		},
		{ name = "separator" },
		{
			name = "  Telescope Find Files",
			cmd = "Telescope find_files",
			rtxt = "<leader>ff",
		},
		{
			name = "  Telescope Live Grep",
			cmd = "Telescope live_grep",
			rtxt = "<leader>fg",
		},
	},
}

return M
