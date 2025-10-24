return {
	"williamboman/mason-lspconfig.nvim",
	-- 移除 lazy = false, event 会使其懒加载
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "folke/neodev.nvim" }, -- 移除 lazy = false
		{ "williamboman/mason.nvim" }, -- 移除 lazy = false
		{ "neovim/nvim-lspconfig" }, -- 移除 lazy = false
		{ "hrsh7th/cmp-nvim-lsp" }, -- <--- 从 nvim-lspconfig.lua 移入
	},
	config = function()
		require("neodev").setup()
		require("mason").setup()

		-- ---- 从 nvim-lspconfig.lua 移入的逻辑 ----
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
		-- -----------------------------------------

		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "pyright" },
			automatic_installation = true,
			handlers = {
				-- 默认 handler，确保传递 capabilities
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities, -- <--- 确保添加
					})
				end,

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities, -- <--- 确保添加
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
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim", "require" } },
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
