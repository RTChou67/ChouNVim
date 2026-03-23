return {
	{
		"nvzone/volt",
		lazy = true,
	},
	{
		"nvzone/menu",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<RightMouse>", function()
				vim.cmd.exec('"normal! \\<RightMouse>"')

				local ft = vim.bo.ft
				local options = "default"

				if ft == "neo-tree" then
					options = "nvimtree"
				elseif ft == "markdown" or ft == "rmd" or ft == "org" then
					options = "markdown"
				end

				require("menu").open(options, { mouse = true })
			end, {})

			-- 自定义菜单高亮
			vim.api.nvim_set_hl(0, "MenuNormal", { link = "Normal" })
			vim.api.nvim_set_hl(0, "MenuSelected", { link = "PmenuSel" })
		end,
	},
}
