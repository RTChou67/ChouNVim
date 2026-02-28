-- Autocmds configuration

-- Add Markdown Preview to Right-Click (PopUp) Menu
local augroup = vim.api.nvim_create_augroup("MarkdownContextMenu", { clear = true })

_G.PreviewMarkdownRaw = function()
	local src_buf = vim.api.nvim_get_current_buf()
	local rm = require("render-markdown")
	rm.enable()
	rm.preview()
	
	vim.defer_fn(function()
		local preview_core = require("render-markdown.core.preview")
		local dst_buf = preview_core.buffers[src_buf]
		if dst_buf then
			vim.api.nvim_create_autocmd("BufWipeout", {
				buffer = dst_buf,
				callback = function()
					vim.schedule(function()
						rm.disable()
					end)
				end,
			})
		end
	end, 50)
end

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "rmd", "org" },
	callback = function()
		-- Setup a right-click menu item that triggers render-markdown split preview
		vim.cmd([[
			nnoremenu PopUp.Preview\ Markdown :lua _G.PreviewMarkdownRaw()<CR>
			vnoremenu PopUp.Preview\ Markdown <Esc>:lua _G.PreviewMarkdownRaw()<CR>
		]])
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "*",
	callback = function()
		local ft = vim.bo.filetype
		if ft ~= "markdown" and ft ~= "rmd" and ft ~= "org" then
			pcall(vim.cmd, [[aunmenu PopUp.Preview\ Markdown]])
		end
	end,
})
