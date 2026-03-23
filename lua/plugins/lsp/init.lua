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
				"rustfmt",
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
			local lspconfig = require("lspconfig")
			local lsp_keymaps = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = lsp_keymaps,
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
					end

					map("gd", vim.lsp.buf.definition, "Goto Definition")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("gr", vim.lsp.buf.references, "Goto References")
					map("gi", vim.lsp.buf.implementation, "Goto Implementation")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>lf", function()
						require("conform").format({ bufnr = bufnr, lsp_fallback = true })
					end, "Format Buffer")
					map("<leader>lr", "<cmd>LspRestart<cr>", "Restart LSP")

					if client and client.name == "clangd" then
						map("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch Source/Header")
					end
				end,
			})

			-- C. 定义服务器配置字典 (数据驱动，逻辑更清晰)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = {
									vim.env.VIMRUNTIME,
									"${3rd}/luv/library",
								},
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
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = "clippy",
							},
							procMacro = {
								enable = true,
							},
						},
					},
				},
				clangd = {},
				texlab = {
					settings = {
						texlab = {
							build = { onSave = true },
						},
					},
				},
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = false,
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
