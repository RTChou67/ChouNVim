return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },
	opts = {
		check_ts = true,
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			java = false,
		},
		disable_filetype = { "TelescopePrompt", "vim" },
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = [=[[%'%"%)%>%]%]%}%, stream]=],
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
	},
	config = function(_, opts)
		local autopairs = require("nvim-autopairs")
		autopairs.setup(opts)
		local cmp_status, cmp = pcall(require, "cmp")
		if cmp_status then
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
		local Rule = require("nvim-autopairs.rule")
		autopairs.add_rules({
			Rule("`", "`", "markdown")
				:with_pair(function(opts)
					local prev_char = string.sub(opts.line, opts.col - 1, opts.col - 1)
					return prev_char == "`"
				end),
		})
	end,
}
