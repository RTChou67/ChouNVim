return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			-- python = { "pylint" }, -- 禁用 pylint，因为 pyright (LSP) 已经提供了诊断，避免重复
			sh = { "shellcheck" },
			yaml = { "yamllint" }
		}

		-- 自动触发 Linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
