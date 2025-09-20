-- ~/.config/nvim/lua/plugins/autopairs.lua

return {
	"windwp/nvim-autopairs",
	-- 在 Insert-mode 进入时加载，或在与 nvim-cmp 集成时加载
	event = "InsertEnter",
	-- 可选：如果你想更深入地与 nvim-cmp 集成
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			-- 不在注释中启用自动配对
			disable_for_filetype = { "TelescopePrompt", "vim" },
			-- 默认开启了对 backspace 和 enter 键的增强功能
			check_ts = true, -- 使用 treesitter 检查上下文，更精确
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false, -- 在 java 中禁用 treesitter 支持
			},
			-- 你可以在这里添加或覆盖默认的配对规则
			-- 例如，让单引号不自动配对
			-- map_bs = false, -- 取消对 backspace 的映射
		})

		-- 如果你使用了 nvim-cmp，强烈建议添加以下代码
		-- 这会使得在接受补全建议时，autopairs 的行为更加智能
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		if cmp then
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end

		-- --- 自定义规则示例 ---
		local Rule = require("nvim-autopairs.rule")

		-- 为 Markdown 添加 ` `` ` 的自动配ت
		autopairs.add_rules({
			Rule("`", "`", "markdown"):with_pair(function(opts)
				-- 检查前一个字符是否也是反引号
				local prev_char = string.sub(opts.line, opts.col - 1, opts.col - 1)
				if prev_char == "`" then
					return true
				end
				return false
			end),
		})

		-- 为 LaTeX/Markdown 添加 `$$` 的自动配对
		autopairs.add_rules({
			Rule("$", "$", { "tex", "markdown" })
				:with_pair(function(opts)
					-- 检查光标前是否还有一个 $
					local before = opts.line:sub(opts.col - 1, opts.col - 1)
					if before == "$" then
						return true
					end
					return false
				end)
				-- 在 $$ 中间按回车会自动换行并缩进
				:with_cr(function(opts)
					local prev_line = vim.api.nvim_buf_get_lines(0, opts.row - 2, opts.row - 1, false)[1]
					local next_line = vim.api.nvim_buf_get_lines(0, opts.row, opts.row + 1, false)[1]
					-- 检查是否处于 $$ ... $$ 环境中
					if prev_line:match("%s*%$%s*$") and next_line:match("^%s*%$%s*") then
						return true
					end
					return false
				end),
		})
	end,
}
