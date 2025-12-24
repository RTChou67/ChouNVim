return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" }, -- 精确的懒加载时机
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }), -- 简化：只确认已选择的
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip",  priority = 750 },
                { name = "buffer",   priority = 500, keyword_length = 3 }, -- 3个字符以上才提示 buffer 内容
                { name = "path",     priority = 250 },
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = '...',
                }),
            },
        })
        cmp.setup.cmdline(":", {
            completion = { autocomplete = { "TextChanged" } },
            mapping = cmp.mapping.preset.cmdline({
                ["<Tab>"] = {
                    c = function()
                        if cmp.visible() then cmp.select_next_item() else cmp.complete() end
                    end,
                },
            }),
            sources = cmp.config.sources({
                { name = "path" }
            }, {
                { name = "cmdline", option = { ignore_cmds = { 'Man', '!' } } }
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } }
        })
    end,
}
