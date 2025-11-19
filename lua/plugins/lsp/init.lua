return {
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
				-- Formatters
				"stylua", -- Lua
				"black", -- Python
				"isort", -- Python imports
				"clang-format", -- C/C++
				"shfmt", -- Shell

				-- 可选：Linters
				"pylint", -- Python
				"shellcheck", -- Shell
			}
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

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
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"folke/neodev.nvim",
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
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰌵",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- 设置诊断符号
			local signs = {
				Error = "",
				Warn = "",
				Hint = "󰌵",
				Info = "",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local lspconfig = require("lspconfig")

			require("mason-lspconfig").setup({

				ensure_installed = {
					"lua_ls", -- Lua
					"pyright", -- Python
					"texlab", -- LaTeX
				},
				automatic_installation = true,

				handlers = {

					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,

					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
									},
									diagnostics = {
										globals = { "vim" }, -- 识别 vim 全局变量
									},
									workspace = {
										-- Neovim runtime files
										library = vim.api.nvim_get_runtime_file("", true),
										checkThirdParty = false, -- 不提示第三方库
									},
									telemetry = {
										enable = false, -- 禁用遥测
									},
									completion = {
										callSnippet = "Replace", -- 补全时替换整个函数调用
									},
									hint = {
										enable = true, -- 启用 inlay hints
										setType = false,
										paramType = true,
										paramName = "Disable",
										semicolon = "Disable",
										arrayIndex = "Disable",
									},
								},
							},
						})
					end,

					["pyright"] = function()
						lspconfig.pyright.setup({
							capabilities = capabilities,
							settings = {
								python = {
									analysis = {
										typeCheckingMode = "basic", -- off, basic, strict
										autoSearchPaths = true,
										useLibraryCodeForTypes = true,
										diagnosticMode = "workspace",
									},
								},
							},
						})
					end,

					["texlab"] = function()
						lspconfig.texlab.setup({
							capabilities = capabilities,
							settings = {
								texlab = {
									build = {
										onSave = true,
									},
								},
							},
						})
					end,
				},
			})
		end,
	},
}
