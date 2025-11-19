return {
    "neovim/nvim-lspconfig",
    opts = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
                end
                -- === 导航 ===
                map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
                map("n", "gr", vim.lsp.buf.references, "References")
                map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
                map("n", "gy", vim.lsp.buf.type_definition, "Type Definition")
                -- === 文档 ===
                map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
                map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
                map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help (Insert)")
                -- === 代码操作 ===
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("v", "<leader>ca", vim.lsp.buf.code_action, "Code Action (Visual)")
                map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
                -- === 诊断 ===
                map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
                map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                map("n", "<leader>e", vim.diagnostic.open_float, "Show Diagnostic")
                map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic List")
                -- === 工作区 ===
                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "List Workspace Folders")
                -- === 格式化 ===
                -- 检查当前 LSP 是否支持格式化
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client and client.supports_method("textDocument/formatting") then
                    map("n", "<leader>cf", function()
                        vim.lsp.buf.format({ async = true })
                    end, "Format Document")
                    map("v", "<leader>cf", function()
                        vim.lsp.buf.format({ async = true })
                    end, "Format Range")
                end
            end,
        })
        return {}
    end,
}
