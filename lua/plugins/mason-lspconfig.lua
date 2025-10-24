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
		require("neodev").setup()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "pyright" },
			automatic_installation = true,
			handlers = {
				-- Default handler for all servers
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,

				-- Lua language server: 集中配置
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						-- 1. 使用 nvim-lspconfig.lua 中的 root_markers 替换旧的 root_dir
						root_markers = {
							".luarc.json",
							".luarc.jsonc",
							".luacheckrc",
							".stylua.toml",
							"stylua.toml",
							"selene.toml",
							"selene.yml",
							".git",
						},
						-- 2. 使用 nvim-lspconfig.lua 中的 settings
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end,
			},
		})
	end,
}
