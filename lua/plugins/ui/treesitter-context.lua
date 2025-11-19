return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        enable = true,
        max_lines = 3,            -- 最多显示 3 行上下文
        min_window_height = 0,    -- 窗口太矮时不显示
        line_numbers = true,
        multiline_threshold = 20, -- 如果上下文超过 20 行（例如超大函数），则不显示
        trim_scope = 'outer',     -- 如果太长，裁剪外部（outer）还是内部（inner）
        mode = 'cursor',          -- 'cursor' (随光标移动) 或 'topline' (固定在顶部)
        separator = nil,          -- 上下文和代码之间的分隔符，例如 "-"
        zindex = 20,              -- 优先级，确保它在其他浮动窗口之下或之上
    },
}
