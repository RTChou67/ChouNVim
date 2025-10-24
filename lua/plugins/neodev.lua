return {
	"folke/neodev.nvim",
	lazy = true,
	ft = "lua",
	opts = {
		library = {
			enabled = true,
			runtime = true,
			types = true,
			plugins = true,
		},
		lspconfig = true, -- 自动配置 lua_ls
	},
}
