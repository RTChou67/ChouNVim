return {
	"nvzone/showkeys",
	event = "VeryLazy",
	opts = {
		timeout = 3,
		maxkeys = 5,
		position = "top-right",
	},
	config = function(_, opts)
		local showkeys = require("showkeys")
		showkeys.setup(opts)
		showkeys.toggle()
	end,
}
