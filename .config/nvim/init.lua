-- Set up leaders
vim.g.mapleader = '\\'
vim.g.maplocalleader = ','

-- Terminal Mode Maps
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-N><C-w>')

-- Normal Mode Maps
vim.keymap.set('n', '<Leader>h', ':noh<CR>', { silent = true })
vim.keymap.set('n', '<Leader>s', ':set spell!<CR>', { silent = true })
vim.keymap.set('n', '<Leader>%', ':let @*=@%<CR>', { silent = true })
vim.keymap.set('n', '<Leader>d', ':put =strftime(\'%F\', localtime())<CR>', { silent = true })
vim.keymap.set('n', '<Leader>b', ':ToggleBg<CR>', { silent = true })

vim.keymap.set('n', '<Leader>j', ':n<CR>', { silent = true })
vim.keymap.set('n', '<Leader>k', ':N<CR>', { silent = true })

vim.keymap.set('n', '<Leader>n', 'n')
vim.keymap.set('n', '<Leader>N', 'N')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')


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

-- Adds 6 lines of context when scrolling
vim.opt.scrolloff = 6

-- Show prompt when closing unsaved file
vim.opt.confirm = true

-- When saving, create a seperate backup and overwrite the original.
vim.opt.backupcopy = 'yes'

-- Enables/disables swap file
vim.opt.swapfile = false

-- For fear of madness
vim.opt.belloff = 'all'

-- Inserts spaces in lieu of tabs
vim.opt.expandtab = true

-- The number of spaces used to represent a tab
vim.opt.tabstop = 4

-- The number of spaces inserted for indentation
vim.opt.shiftwidth = 4

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
vim.opt.listchars = {tab = '▸-', trail = '·', extends = '>', precedes = '<' }

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
vim.opt.wildmode = {'longest', 'list'}
vim.opt.wildmenu = true

-- Don't underline current line
vim.opt.cursorline = false

-- Activates/deactivates ruler
vim.opt.ruler = true

-- Activates/deactivates line numbers
vim.opt.number = false

-- User Commands
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command(
    'ToggleBg',
    function()
        if 'light' == vim.opt.background:get() then
            vim.opt.background = 'dark'
        else
            vim.opt.background = 'light'
        end
    end,
    { nargs = 0 }
)

-- Autocommands
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern = {'*.S'},
    callback = function() vim.opt.filetype = 'asm' end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'gitcommit', 'gitrebase', 'gitconfig'},
    callback = function() vim.opt.bufhidden = 'delete' end,
})
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function() vim.opt.spell = false end,
})

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
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
    },
    {
        'shaunsingh/nord.nvim',
    },
    {
        'ellisonleao/gruvbox.nvim',
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
}
lazy.setup(plugins, opts)

-- LSP Setup
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup{} -- rust
lspconfig.jedi_language_server.setup{} -- python
lspconfig.marksman.setup{} -- markdown
lspconfig.clangd.setup{} -- c/cpp/objc

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)
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
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Treesitter
local treesitter_config = require('nvim-treesitter.configs')
treesitter_config.setup({
    ensure_installed = { "rust", "c", "python", "lua" },
    sync_install = false,
    auto_install = false,
    highlight = {
        enable = true,
        aditional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
    },
})

-- Colour Schemes
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    theme = "wave",              -- Load "wave" theme when 'background' option is not set
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",
        light = "lotus"
    },
})

function starts_with(str, pattern)
    return string.sub(str, 1, #pattern) == pattern
end

colorschemes = {
    'kanagawa',
    'catppuccin',
    'nord',
    'gruvbox',
}
vim.api.nvim_create_user_command(
    'ToggleColorscheme',
    function()
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
    end,
    { nargs = 0 }
)
vim.keymap.set('n', '<Leader>c', ':ToggleColorscheme<CR>', { silent = true })

vim.cmd.colorscheme(colorschemes[1])
