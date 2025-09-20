return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- Extend capabilities for nvim-cmp
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Global diagnostic display configuration (你的原设置)
		vim.diagnostic.config({
			virtual_text = { severity = vim.diagnostic.severity.WARN },
			signs = { severity = { min = vim.diagnostic.severity.ERROR } },
			underline = { severity = vim.diagnostic.severity.HINT },
			severity_sort = true,
			update_in_insert = false,
		})

		-- Define diagnostic symbols
		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		-- ========== 新版：使用 vim.lsp.config / vim.lsp.enable ==========
		-- 1) 若想给所有 LSP 设置共同的 defaults（例如 capabilities、on_attach）
		vim.lsp.config("*", {
			capabilities = capabilities,
			-- on_attach = function(client, bufnr) ... end,  -- 如需设定可放这里
		})

		-- 2) 为 lua_ls 定义具体配置（等价于以前的 lspconfig.lua_ls.setup）
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" }, -- 若使用 mason 安装，确保可在 PATH 中找到
			filetypes = { "lua" },
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
			-- 这里和以前一样传 settings，包含 diagnostics/globals & workspace.library
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
			-- 若你想为该服务器覆盖默认 on_attach 或 capabilities，也可以在这里直接写：
			-- capabilities = capabilities,
			-- on_attach = function(client, bufnr) ... end,
		}

		-- 3) 启用该配置（让 Neovim 按 filetype 自动启动/attach）
		--    你可以在这里显式启用，或让其他工具（如 mason-lspconfig）在安装后调用。
		vim.lsp.enable("lua_ls")

		-- ===========================================================
		-- 说明：
		-- - 定义放在 `vim.lsp.config`（或 lsp/ 目录里的文件）后，使用 vim.lsp.enable 启用。
		-- - 如果你用 mason/mason-lspconfig 管理安装：mason 负责安装二进制，
		--   但你需要确保启用/注册方式与 mason 的 handler 不冲突（mason-lspconfig 的新版本也在适配这些 API）。:contentReference[oaicite:2]{index=2}
	end,
}
