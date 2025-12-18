return {
	"nvzone/showkeys",
	event = "VeryLazy",
	opts = {
		timeout = 1,
		maxkeys = 5,
		position = "bottom-left",
	},
	config = function(_, opts)
		local showkeys = require("showkeys")
		showkeys.setup(opts)
		showkeys.toggle()
	end,
}
