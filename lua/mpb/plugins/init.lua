return
{
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            vim.cmd.TSUpdate()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "lua", "vim", "rust", "typescript", "javascript", "python" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { 'python', 'c' }
                }
            }
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
            vim.keymap.set('n', '<leader><leader>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>wf', builtin.live_grep, {})
        end,
    },
    {
        "theprimeagen/harpoon",
        lazy = false,
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

            vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
            vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end)
            vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end)
            vim.keymap.set("n", "<leader>7", function() ui.nav_file(7) end)
            vim.keymap.set("n", "<leader>8", function() ui.nav_file(8) end)
            vim.keymap.set("n", "<leader>9", function() ui.nav_file(9) end)
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
            local lsp_format_on_save = function(bufnr)
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            local lsp = require("lsp-zero")
            local cmp = require('cmp')
            local cmp_action = lsp.cmp_action()

            lsp.preset("recommended")


            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                })
            })

            lsp.set_preferences({
                suggest_lsp_servers = true,
                sign_icons = {
                    error = '',
                    warn = '',
                    hint = '',
                    info = ''
                }
            })

            lsp.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "<C-b>", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>lws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>rf", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("n", "<leader>=", function() vim.lsp.buf.format() end, opts)

                lsp_format_on_save(bufnr)
            end)

            local ensure_installed = { 'lua_ls', 'prismals', 'tailwindcss', 'tsserver',
                'pyright' }

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed
            })

            lsp.setup_servers(require('mason-lspconfig').get_installed_servers())

            lsp.setup()

            vim.diagnostic.config({
                virtual_text = true
            })
        end,
    },
    {
        "tpope/vim-surround",
        lazy = false,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<A-l>",
                    next = "<A-]>",
                    prev = "<A-[",
                }
            },
            panel = {
                enabled = true,
                auto_refresh = true,

            }
        },
    },
    {
        "machakann/vim-highlightedyank",
        event = 'TextYankPost *',
        config = function()
            vim.g.highlightedyank_highlight_duration = 300
            vim.cmd [[highlight HighlightedyankRegion ctermbg=237 guibg=#5A90B9]]
        end
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require('nvim-treesitter.configs').setup({
                autotag = { enable = true }
            })
        end
    },
    {
        'voldikss/vim-floaterm',
        lazy = false,
        config = function()
            vim.keymap.set("n", "<F7>", function() vim.cmd.FloatermToggle() end)
            vim.keymap.set("t", "<F7>", function() vim.cmd.FloatermToggle() end)
            vim.keymap.set("t", "<C-n>", function() vim.cmd.FloatermNew() end)
            vim.keymap.set("t", "<C-[>", function() vim.cmd.FloatermPrev() end)
            vim.keymap.set("t", "<C-]>", function() vim.cmd.FloatermNext() end)

            vim.g.floaterm_width = 0.8
            vim.g.floaterm_height = 0.9
        end
    },
    {
        "mbbill/undotree",
        lazy = false,
        config = function()
            vim.keymap.set('n', '<leader>0', vim.cmd.UndotreeToggle)
            vim.keymap.set('n', '<F5>', vim.cmd.UndotreeToggle)
        end
    },
}
