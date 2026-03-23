local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local user_yank = augroup("user-highlight-yank", { clear = true })
autocmd("TextYankPost", {
	group = user_yank,
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

local user_cursor = augroup("user-restore-cursor", { clear = true })
autocmd("BufReadPost", {
	group = user_cursor,
	desc = "Restore last cursor position",
	callback = function(args)
		local exclude = {
			gitcommit = true,
			["neo-tree"] = true,
		}
		local ft = vim.bo[args.buf].filetype
		local bt = vim.bo[args.buf].buftype

		if bt ~= "" or exclude[ft] then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

local user_writing = augroup("user-writing-buffers", { clear = true })
autocmd("FileType", {
	group = user_writing,
	pattern = { "gitcommit", "markdown", "text" },
	desc = "Enable local writing-friendly options",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.linebreak = true
	end,
})
