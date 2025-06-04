-- Set to false if you don't want to use plugins.
use_plugins = true

-- Number of milliseconds to wait for a key sequence
vim.opt.timeout = true
vim.opt.timeoutlen = 600

-- Make the clipboard (the * register) the default register.
vim.opt.clipboard = 'unnamed'

-- Splitting Preferences
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Folding Stuff
vim.opt.foldlevelstart = 1
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent'
vim.opt.foldcolumn = '0'
vim.opt.foldtext = 'FoldText()'
vim.cmd([[
    function! FoldText()
        " Pre-body
        let num_lines = v:foldend - v:foldstart + 1
        let pre_body = ' <' . num_lines . '>'

        " Post-body
        let level = v:foldlevel
        let post_body = '(' . level . ') '

        " Body
        let len_body = winwidth(0) - (len(pre_body) + len(post_body))
        let body = repeat('·', len_body)

        return pre_body . body . post_body
    endfunction
]])

-- Tab bar verbosity
vim.opt.showtabline = 0

-- Status bar verbosity
vim.opt.laststatus = 1

-- Enables/disables changed buffers to be hidden
vim.opt.hidden = true

-- Adds 10 lines of context when scrolling
vim.opt.scrolloff = 10

-- Show prompt when closing unsaved file
vim.opt.confirm = true

-- When saving, create a separate backup and overwrite the original.
vim.opt.backupcopy = 'yes'

-- Enables/disables swap and backup files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- For fear of madness
vim.opt.belloff = 'all'

-- Inserts spaces in lieu of tabs
vim.opt.expandtab = true

-- The number of spaces used to represent a tab
vim.opt.tabstop = 4

-- The number of spaces inserted for indentation
vim.opt.shiftwidth = 2

-- Set auto-indent for standard files
vim.opt.autoindent = true

-- Enables text wrapping
vim.opt.wrap = true

-- Disables automatic new line (text width)
vim.opt.tw = 0

-- Wrap on a 'break-at' character
vim.opt.linebreak = true

-- Enable Backspace
vim.opt.bs = '2'

-- This sets custom white-space characters
vim.opt.listchars = { tab = '▸-', trail = '·', extends = '>', precedes = '<' }

-- Shows white-space
vim.opt.list = true

-- Shows the command as it is written
vim.opt.showcmd = true

-- Changes the language to proper English
vim.opt.spelllang = 'en_gb'

-- Activates/deactivates spell-check
vim.opt.spell = true

-- Ignore case if all characters used are lower-case.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Activates/deactivates highlighting search results
vim.opt.hlsearch = true

-- Wild Menu
vim.opt.wildmode = { 'longest', 'list' }
vim.opt.wildmenu = true
vim.opt.wildoptions = { 'pum', 'tagfile' }

-- Don't underline current line
vim.opt.cursorline = false

-- Activates/deactivates ruler
vim.opt.ruler = true

-- Activates/deactivates line numbers
vim.opt.number = false

-- User Commands
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('ToggleBg', function()
    if 'light' == vim.opt.background:get() then
        vim.opt.background = 'dark'
    else
        vim.opt.background = 'light'
    end
end, { nargs = 0 })

vim.api.nvim_create_user_command('Float', function(args)
    api = vim.api
    if table.getn(api.nvim_list_wins()) < 2 then
        vim.print("The last window doesn't float.")
        return
    end
    ui = api.nvim_list_uis()[1]
    vim.print(args.count)
    width = args.count > 0 and args.count or ui.width - 12
    height = ui.height - 12
    api.nvim_win_set_config(0, {
        relative = 'editor',
        width = width,
        height = height,
        col = (ui.width / 2) - (width / 2),
        row = (ui.height / 2) - (height / 2),
        border = 'rounded',
    })
end, { desc = 'Floats the current window.', count = true })

-- Autocommands
function delete_when_hidden()
    vim.opt.bufhidden = 'delete'
end
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitcommit', 'gitrebase', 'gitconfig' },
    callback = delete_when_hidden,
})
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '/tmp/bash-fc.*' }, -- Bash GNU Readlines Vi Visual Mode
    callback = delete_when_hidden,
})
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt.spell = false
    end,
})

-- Filetypes
vim.filetype.add({ extension = { typ = 'typst' } })
vim.filetype.add({ extension = { core = 'yaml' } })
vim.filetype.add({ extension = { S = 'asm' } })
vim.filetype.add({ extension = { djot = 'djot' } })

-- Lua Specific Setup
math.randomseed(vim.fn.localtime())

-- Install and Setup Plug-ins
if use_plugins then
    -- If not already installed, install lazy.
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Setup lazy
    local lazy = require('lazy')
    local plugins = {
        {
            'rebelot/kanagawa.nvim',
            -- This is the default colour scheme,
            -- so we should priorities it's loading.
            priority = 1000,
        },
        {
            'ellisonleao/gruvbox.nvim',
        },
        {
            'catppuccin/nvim',
            name = 'catppuccin',
        },
        {
            'shaunsingh/nord.nvim',
        },
        {
            'miikanissi/modus-themes.nvim',
        },
        {
            'jeffkreeftmeijer/vim-dim',
        },
        {
            'RRethy/base16-nvim',
        },
        {
            'neovim/nvim-lspconfig',
        },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope-live-grep-args.nvim',
            },
        },
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
        },
    }
    lazy.setup(plugins, opts)

    -- LSP Setup
    local lspconfig = require('lspconfig')
    lspconfig.rust_analyzer.setup({}) -- rust
    lspconfig.marksman.setup({
        root_dir = function(fname)
            return lspconfig.util.root_pattern('.marksman.toml')(fname)
        end,
        --cmd = {'marksman', 'server', '-v1000'}, -- Used for debugging issues
    }) -- markdown
    lspconfig.dotls.setup({}) -- graphviz dot
    lspconfig.clangd.setup({}) -- c/cpp/objc
    lspconfig.nil_ls.setup({}) -- Nix
    --lspconfig.pyright.setup({}) -- python
    --lspconfig.veridian.setup({}) -- System Verilog

    -- Treesitter
    local treesitter_config = require('nvim-treesitter.configs')
    treesitter_config.setup({
        ensure_installed = {
            'vimdoc',
            'rust',
            'verilog',
            'c',
            'cpp',
            'python',
            'lua',
            'markdown',
            'markdown_inline',
        },
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            aditional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
    })

    -- Colour Schemes
    require('kanagawa').setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        theme = 'wave', -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
            dark = 'wave',
            light = 'lotus',
        },
    })

    -- Posh Colorscheme Commands

    function starts_with(str, pattern)
        return string.sub(str, 1, #pattern) == pattern
    end

    colorschemes = {
        'kanagawa',
        'gruvbox',
        'catppuccin',
        'nord',
        'modus',
    }
    vim.api.nvim_create_user_command('ToggleColorscheme', function()
        local new_colorscheme_idx = 1
        for i, colorscheme in ipairs(colorschemes) do
            if starts_with(vim.g.colors_name, colorscheme) then
                new_colorscheme_idx = i + 1
            end
        end
        if new_colorscheme_idx > #colorschemes then
            new_colorscheme_idx = 1
        end
        vim.cmd.colorscheme(colorschemes[new_colorscheme_idx])
    end, { nargs = 0 })

    vim.opt.termguicolors = true
    vim.cmd.colorscheme(colorschemes[1])

    -- Base16 Colorscheme Commands
    colorschemes_base16 = vim.fn.getcompletion('base16-', 'color')
    prev_colorschemes_base16 = {}

    vim.api.nvim_create_user_command('RandomBase16Colorscheme', function()
        vim.opt.termguicolors = true
        local next = colorschemes_base16[math.random(table.getn(colorschemes))]
        table.insert(prev_colorschemes_base16, vim.g.colors_name)
        vim.print(next)
        vim.cmd.colorscheme(next)
    end, { nargs = 0 })

    vim.api.nvim_create_user_command('PreviousBase16Colorscheme', function()
        local prev = table.remove(prev_colorschemes_base16)
        vim.print(prev)
        if prev then
            vim.cmd.colorscheme(prev)
        end
    end, { nargs = 0 })
end

-- Set up leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Terminal Mode Maps
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-[><C-[>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-N><C-w>')

-- Normal Mode Maps
vim.keymap.set('n', '<Space>', '<Nop>')
vim.keymap.set('n', '<C-l>', ':nohl<CR><C-l>', { silent = true })

vim.keymap.set('n', '<Leader>s', ':set spell!<CR>', { silent = true })
vim.keymap.set('n', '<Leader>%', ':let @*=@%<CR>', { silent = true })
vim.keymap.set('n', '<Leader>d', ":put =strftime('%F', localtime())<CR>kJ$", { silent = true })

vim.keymap.set('n', '<Leader>j', ':n<CR>', { silent = true })
vim.keymap.set('n', '<Leader>k', ':N<CR>', { silent = true })

vim.keymap.set('n', '<Leader>l', ':cn<CR>', { silent = true })
vim.keymap.set('n', '<Leader>h', ':cN<CR>', { silent = true })

vim.keymap.set('n', '<Leader>n', 'n')
vim.keymap.set('n', '<Leader>N', 'N')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '<Leader>b', ':ToggleBg<CR>', { silent = true })
vim.keymap.set('n', '<Leader>p', ':Float<CR>', { silent = true }) -- p for popup

if use_plugins then
    -- Telescope
    local telescope = require('telescope')
    local tele_builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', tele_builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {})
    vim.keymap.set('n', '<leader>fb', tele_builtin.buffers, {})
    vim.keymap.set('n', '<leader>fr', tele_builtin.resume, {})

    vim.keymap.set('n', '<Leader>c', ':ToggleColorscheme<CR>', { silent = true })

    -- Disable folding in the telescope picker
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'TelescopeResults',
        command = [[setlocal foldlevelstart=42 scrolloff=0]],
    })

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<Leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<Leader>fmt', function()
                vim.lsp.buf.format({ async = true })
            end, opts)
            vim.keymap.set('n', '<Leader>U', function()
                vim.print(colors)
            end, opts)
        end,
    })
end
