return {
	"akinsho/toggleterm.nvim",
	version = "*", -- 或者一个具体的版本
	config = function()
		require("toggleterm").setup({
			-- 设置终端窗口大小 (可以是数字，也可以是百分比)
			size = 20,

			-- 默认打开时的方向 ( 'float', 'horizontal', 'vertical', 'tab' )
			direction = "float",

			-- 在 Normal 模式下，按 <C-/> (Ctrl + /) 时自动切换到 Insert 模式
			start_in_insert = true,

			-- 终端打开时自动切换到该终端窗口
			insert_mappings = true,

			-- 按 Esc 键时自动关闭终端
			close_on_exit = true,

			-- 悬浮窗口的边框样式
			float_opts = {
				border = "rounded",
			},
		})

		-- 定义一个函数，用于在 Normal 模式下切换 ToggleTerm
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("n", "tgt", "<cmd>ToggleTerm<cr>", opts)
		end

		-- 当终端打开时，运行上面的函数来设置快捷键
		vim.cmd("autocmd TermOpen * lua set_terminal_keymaps()")
	end,

	-- 为 ToggleTerm 设置一个全局快捷键
	-- 无论何时何地，按 <C-/> 都会打开/关闭终端
	keys = {
		{ "tgt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
	},
}
