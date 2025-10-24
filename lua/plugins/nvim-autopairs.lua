return {
	"windwp/nvim-autopairs",

	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({

			disable_for_filetype = { "TelescopePrompt", "vim" },

			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
		})

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		if cmp then
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end

		local Rule = require("nvim-autopairs.rule")

		autopairs.add_rules({
			Rule("`", "`", "markdown"):with_pair(function(opts)
				local prev_char = string.sub(opts.line, opts.col - 1, opts.col - 1)
				if prev_char == "`" then
					return true
				end
				return false
			end),
		})

		autopairs.add_rules({
			Rule("$", "$", { "tex", "markdown" }):with_pair(function(opts)
				local before = opts.line:sub(opts.col - 1, opts.col - 1)
				if before == "$" then
					return true
				end
				return false
			end)
:with_cr(function(opts)
				local prev_line = vim.api.nvim_buf_get_lines(0, opts.row - 2, opts.row - 1, false)[1]
				local next_line = vim.api.nvim_buf_get_lines(0, opts.row, opts.row + 1, false)[1]

				if prev_line:match("%s*%$%s*$") and next_line:match("^%s*%$%s*") then
					return true
				end
				return false
			end),
		})
	end,
}
