return {
	-- 1. Mason: 管理 Formatter, Linter 等非 LSP 工具
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local ensure_installed = {
				"stylua",
				"black",
				"isort",
				"clang-format",
				"shfmt",
				"pylint",
				"shellcheck",
			}

			local function ensure_tools()
				for _, tool in ipairs(ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end

			if mr.refresh then
				mr.refresh(ensure_tools)
			else
				ensure_tools()
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				-- 在 0.10+ 中，直接在这里定义图标即可，不再需要 sign_define 循环
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "󰌵",
						[vim.diagnostic.severity.INFO] = "ℹ",
					},
				},
				float = {
					border = "rounded",
					source = true, -- 修复警告：用 true 替代 "always"
				},
			})

			-- B. 准备 Capabilities (配合补全)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- C. 定义服务器配置字典 (数据驱动，逻辑更清晰)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
							completion = { callSnippet = "Replace" },
							hint = {
								enable = true,
								paramType = true,
								setType = false,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				},
				texlab = {
					settings = {
						texlab = {
							build = { onSave = true },
						},
					},
				},
			}

			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_installation = true,
				handlers = {
					-- 默认 handler
					function(server_name)
						local opts = servers[server_name] or {}
						opts.capabilities = capabilities
						lspconfig[server_name].setup(opts)
					end,
				},
			})
		end,
	},
}
