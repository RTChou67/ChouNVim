return {
    -- ==========================================
    -- Mason: LSP/DAP/Linter/Formatter 包管理器
    -- ==========================================
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

            -- 确保安装必要的工具
            local mr = require("mason-registry")

            -- 需要安装的工具列表
            local ensure_installed = {
                -- Formatters
                "stylua",       -- Lua
                "black",        -- Python
                "isort",        -- Python imports
                "clang-format", -- C/C++
                "shfmt",        -- Shell

                -- 可选：Linters
                -- "pylint",     -- Python
                -- "shellcheck", -- Shell
            }

            -- 自动安装逻辑
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- 触发 FileType 事件，重新加载
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

    -- ==========================================
    -- LSPConfig: LSP 客户端配置
    -- ==========================================
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim", -- 必须在 lspconfig 之前
        },
        config = function()
            -- =====================================
            -- 1. 诊断配置
            -- =====================================
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

            -- =====================================
            -- 2. LSP Capabilities (补全能力)
            -- =====================================
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- 可选：启用 snippets 支持
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            -- =====================================
            -- 3. Mason-lspconfig 桥接
            -- =====================================
            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup({
                -- 自动安装这些 LSP servers
                ensure_installed = {
                    "lua_ls",  -- Lua
                    "pyright", -- Python
                    "texlab",  -- LaTeX
                },
                automatic_installation = true,

                -- =====================================
                -- 4. LSP Handlers (服务器配置)
                -- =====================================
                handlers = {
                    -- 默认 handler：适用于大多数服务器
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    -- =====================================
                    -- 特殊配置：lua_ls
                    -- =====================================
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

                    -- =====================================
                    -- 特殊配置：pyright (可选)
                    -- =====================================
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

                    -- =====================================
                    -- 特殊配置：texlab (可选)
                    -- =====================================
                    -- ["texlab"] = function()
                    -- 	lspconfig.texlab.setup({
                    -- 		capabilities = capabilities,
                    -- 		settings = {
                    -- 			texlab = {
                    -- 				build = {
                    -- 					onSave = true,
                    -- 				},
                    -- 			},
                    -- 		},
                    -- 	})
                    -- end,

                    -- =====================================
                    -- 添加更多服务器配置
                    -- =====================================
                    -- 如果使用默认配置，不需要写 handler
                    -- 如果需要特殊配置，添加对应的 handler
                },
            })
        end,
    },
}

