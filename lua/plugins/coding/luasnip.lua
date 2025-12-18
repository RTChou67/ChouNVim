return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {

			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		opts = {
			history = true,
			updateevents = "TextChanged,TextChangedI",
			delete_check_events = "TextChanged",
			enable_autosnippets = false,
		},
		config = function(_, opts)
			local luasnip = require("luasnip")
			luasnip.setup(opts)
		end,
	},
}
