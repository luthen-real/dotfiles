-- https://github.com/hrsh7th/nvim-cmp
local cmp = require('cmp')
require("luasnip.loaders.from_vscode").lazy_load()


cmp.setup({
    sources = cmp.config.sources({
        enable = true,
        { name = "nvim_lsp" }, -- For nvim-lsp
        { name = "luasnip" },
        { name = "path" },     -- For path completion
        { name = "treesitter" },
        { name = "buffer" },   -- For buffer word completion
    }),

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping =

        cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            -- Jump to the next snippet placeholder
            ['<C-f>'] = cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            -- Jump to the previous snippet placeholder
            ['<C-b>'] = cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            -- Super tab
            ['<Tab>'] = cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                local col = vim.fn.col('.') - 1

                if cmp.visible() then
                    cmp.select_next_item({ behavior = 'select' })
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                    fallback()
                else
                    cmp.complete()
                end
            end, { 'i', 's' }),

            -- Super shift tab
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                local luasnip = require('luasnip')

                if cmp.visible() then
                    cmp.select_prev_item({ behavior = 'select' })
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),

        }),

    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },




})

-- cmp.setup.cmdline(":", {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = "path" },
--     }, {
--         {
--             name = "cmdline",
--             option = {
--                 ignore_cmds = { "Man", "!" },
--             },
--         },
--     }),
-- })
--
-- cmp.setup.cmdline({ "/", "?" }, {
--     -- view = {
--     -- 	entries = { name = "wildmenu", separator = "|" },
--     -- },
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = "buffer" },
--     },
-- })
