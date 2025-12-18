return {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")

        -- 颜色定义（自动适配你的主题颜色）
        local colors = {
            bright_bg = utils.get_highlight("Folded").bg,
            bright_fg = utils.get_highlight("Folded").fg,
            red = utils.get_highlight("DiagnosticError").fg,
            dark_red = utils.get_highlight("DiffDelete").fg,
            green = utils.get_highlight("DiagnosticOk").fg,
            blue = utils.get_highlight("Function").fg,
            gray = utils.get_highlight("NonText").fg,
            orange = utils.get_highlight("DiagnosticWarn").fg,
            purple = utils.get_highlight("Statement").fg,
            cyan = utils.get_highlight("Special").fg,
            diag_warn = utils.get_highlight("DiagnosticWarn").fg,
            diag_error = utils.get_highlight("DiagnosticError").fg,
            diag_hint = utils.get_highlight("DiagnosticHint").fg,
            diag_info = utils.get_highlight("DiagnosticInfo").fg,
        }

        -- 1. 模式模块 (Normal, Insert, etc.)
        local ViMode = {
            init = function(self)
                self.mode = vim.fn.mode(1)
            end,
            static = {
                mode_names = { n = "NOR", i = "INS", v = "VIS", V = "V-L", ["\22"] = "V-B", c = "CMD", s = "SEL", S = "S-L", ["\19"] = "S-B", R = "REP", t = "TRM" },
                mode_colors = { n = "red", i = "green", v = "cyan", V = "cyan", ["\22"] = "cyan", c = "orange", s = "purple", S = "purple", ["\19"] = "purple", R = "orange", r = "orange", ["!"] = "red", t = "red" },
            },
            provider = function(self)
                return "  " .. (self.mode_names[self.mode] or self.mode) .. " "
            end,
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return { fg = "bright_bg", bg = self.mode_colors[mode], bold = true }
            end,
            update = { "ModeChanged" },
        }

        -- 2. 文件信息模块
        local FileNameBlock = {
            init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
        }
        local FileIcon = {
            init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
                    { default = true })
            end,
            provider = function(self) return self.icon and (self.icon .. " ") end,
            hl = function(self) return { fg = self.icon_color } end,
        }
        local FileName = {
            provider = function(self)
                local filename = vim.fn.fnamemodify(self.filename, ":t")
                if filename == "" then return "[No Name]" end
                return filename
            end,
            hl = { fg = "cyan" },
        }
        local FileFlags = {
            {
                condition = function() return vim.bo.modified end,
                provider = " ● ",
                hl = { fg = "green" },
            },
            {
                condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
                provider = "  ",
                hl = { fg = "orange" },
            },
        }
        FileNameBlock = utils.insert(FileNameBlock, { provider = "  " }, FileIcon, FileName, FileFlags,
            { provider = " " })

        -- 3. Git 模块 (修复了 nil 比较错误)
        local Git = {
            condition = conditions.is_git_repo,
            init = function(self)
                -- 获取 gitsigns 的数据
                self.status_dict = vim.b.gitsigns_status_dict

                -- 安全检查：如果 status_dict 为空，则初始化一个空的表，防止后续报错
                if not self.status_dict then
                    self.status_dict = { added = 0, removed = 0, changed = 0, head = "" }
                end

                -- 关键修复点：使用 (val or 0) 确保即使是 nil 也能参与比较
                local added = self.status_dict.added or 0
                local removed = self.status_dict.removed or 0
                local changed = self.status_dict.changed or 0

                self.has_changes = added ~= 0 or removed ~= 0 or changed ~= 0
            end,
            hl = { fg = "orange" },
            { provider = "  " },
            {
                provider = function(self)
                    return self.status_dict.head or ""
                end,
                hl = { bold = true }
            },
            {
                condition = function(self) return self.has_changes end,
                provider = "(",
            },
            -- 以下 provider 也要确保 nil 安全
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("+" .. count)
                end,
                hl = { fg = "green" }
            },
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("~" .. count)
                end,
                hl = { fg = "orange" }
            },
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("-" .. count)
                end,
                hl = { fg = "red" }
            },
            {
                condition = function(self) return self.has_changes end,
                provider = ")",
            },
        }

        -- 4. LSP 与 诊断模块
        local Diagnostics = {
            condition = conditions.has_diagnostics,
            static = { error_icon = " ", warn_icon = " ", info_icon = " ", hint_icon = "󰌵 " },
            init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,
            update = { "DiagnosticChanged", "BufEnter" },
            { provider = function(self) return self.errors > 0 and (self.error_icon .. self.errors .. " ") end,    hl = { fg = "diag_error" } },
            { provider = function(self) return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ") end, hl = { fg = "diag_warn" } },
            { provider = function(self) return self.info > 0 and (self.info_icon .. self.info .. " ") end,         hl = { fg = "diag_info" } },
            { provider = function(self) return self.hints > 0 and (self.hint_icon .. self.hints .. " ") end,       hl = { fg = "diag_hint" } },
        }

        local LSPActive = {
            condition = conditions.lsp_attached,
            update = { "LspAttach", "LspDetach" },
            provider = function()
                local names = {}
                for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                    table.insert(names, server.name)
                end
                return "  [" .. table.concat(names, " ") .. "] "
            end,
            hl = { fg = "green", bold = true },
        }

        -- 5. 位置与百分比模块
        local Ruler = {
            provider = " %7(%l/%L%):%2c %P ",
            hl = { fg = "gray" },
        }

        -- 组装状态栏
        local StatusLine = {
            hl = { fg = "gray", bg = "bright_bg" },
            ViMode,
            FileNameBlock,
            Git,
            { provider = "%=" }, -- 占位符，将后面的内容推向右侧
            Diagnostics,
            LSPActive,
            Ruler,
        }

        require("heirline").setup({
            statusline = StatusLine,
            opts = { colors = colors }
        })
    end,
}
