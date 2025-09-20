return {
	"williamboman/mason-lspconfig.nvim",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/neodev.nvim", lazy = false },
		{ "williamboman/mason.nvim", lazy = false },
		{ "neovim/nvim-lspconfig", lazy = false },
	},
	config = function()
		-- 1) Setup neodev for enhanced Lua support in Neovim
		require("neodev").setup()
		-- 2) Initialize Mason package manager
		require("mason").setup()
		-- 3) Configure Mason LSPConfig integration
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "pyright" },
			automatic_installation = true,
			handlers = {
				-- Default handler for all servers
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				-- Lua language server: rely on .luarc.json for settings
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						-- Use .luarc.json or .luarc.jsonc in project root for all settings
						root_dir = require("lspconfig.util").root_pattern(
							".luarc.json",
							".luarc.jsonc",
							".git",
							"lua",
							"Makefile"
						),
					})
				end,
			},
		})
	end,
}
