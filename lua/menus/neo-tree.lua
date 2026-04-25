local manager = require("neo-tree.sources.manager")
local common_commands = require("neo-tree.sources.common.commands")

local function get_state()
	local state = manager.get_state_for_window()
	assert(state)
	state.config = state.config or {}
	return state
end

local function call(command_name)
	return vim.schedule_wrap(function()
		local state = get_state()
		local source_commands = require("neo-tree.sources." .. state.name .. ".commands")
		local command = source_commands[command_name] or common_commands[command_name]
		command(state)
	end)
end

local function copy_path(modifier)
	return function()
		local node = get_state().tree:get_node()
		if node.type == "message" then
			return
		end
		local path = vim.fn.fnamemodify(node.path, modifier)
		vim.fn.setreg('"', path)
		vim.fn.setreg("+", path)
	end
end

local function open_in_terminal()
	return function()
		local node = get_state().tree:get_node()
		if node.type == "message" then
			return
		end
		local stat = vim.uv.fs_stat(node.path)
		local directory = stat and stat.type == "directory" and node.path or vim.fn.fnamemodify(node.path, ":h")
		vim.cmd("enew")
		vim.fn.termopen({ vim.o.shell, "-c", "cd " .. vim.fn.shellescape(directory) .. " ; " .. vim.o.shell })
	end
end

return {
	{ name = "  Open in window", cmd = call("open"), rtxt = "o" },
	{ name = "  Open in vertical split", cmd = call("open_vsplit"), rtxt = "v" },
	{ name = "  Open in horizontal split", cmd = call("open_split"), rtxt = "s" },
	{ name = "󰓪  Open in new tab", cmd = call("open_tabnew"), rtxt = "O" },
	{ name = "separator" },
	{ name = "  New file", cmd = call("add"), rtxt = "a" },
	{ name = "  New folder", cmd = call("add_directory"), rtxt = "A" },
	{ name = "  Delete", hl = "ExRed", cmd = call("delete"), rtxt = "d" },
	{ name = "   File details", cmd = call("show_file_details"), rtxt = "i" },
	{ name = "  Rename", cmd = call("rename"), rtxt = "r" },
	{ name = "  Rename basename", cmd = call("rename"), rtxt = "b" },
	{ name = "  Copy", cmd = call("copy_to_clipboard"), rtxt = "y" },
	{ name = "  Cut", cmd = call("cut_to_clipboard"), rtxt = "x" },
	{ name = "  Paste", cmd = call("paste_from_clipboard"), rtxt = "p" },
	{ name = "separator" },
	{ name = "Toggle hidden", cmd = call("toggle_hidden"), rtxt = "H" },
	{ name = "Refresh", cmd = call("refresh"), rtxt = "R" },
	{
		name = "Sort by...",
		rtxt = "o",
		items = {
			{ name = "Sort the tree by created date.", cmd = call("order_by_created"), rtxt = "c" },
			{ name = "Sort by diagnostic severity.", cmd = call("order_by_diagnostics"), rtxt = "d" },
			{ name = "Sort by git status.", cmd = call("order_by_git_status"), rtxt = "g" },
			{ name = "Sort by last modified date.", cmd = call("order_by_modified"), rtxt = "m" },
			{ name = "Sort by name (default sort).", cmd = call("order_by_name"), rtxt = "n" },
			{ name = "Sort by size.", cmd = call("order_by_size"), rtxt = "s" },
			{ name = "Sort by type.", cmd = call("order_by_type"), rtxt = "t" },
		},
	},
	{ name = "Fuzzy finder", cmd = call("fuzzy_finder"), rtxt = "/" },
	{ name = "Fuzzy finder directory", cmd = call("fuzzy_finder_directory"), rtxt = "D" },
	{ name = "Fuzzy sorter", cmd = call("fuzzy_sorter"), rtxt = "#" },
	{ name = "separator" },
	{ name = "󰴠  Copy absolute path", cmd = copy_path(":p"), rtxt = "gy" },
	{ name = "  Copy relative path", cmd = copy_path(":~:."), rtxt = "Y" },
	{ name = "  Open in terminal", hl = "ExBlue", cmd = open_in_terminal() },
}
