" Terminal Mode Maps
tnoremap <Esc><Esc> <C-\><C-n>

" Terminal Mode Remaps
tnoremap <Leader><C-W>t <C-W>t
tnoremap <C-W>t <C-W>v<C-W>T

" Normal Mode Maps
nnoremap <silent> <Leader>t :tabs<CR>
nnoremap <silent> <Leader>s :set spell!<CR>

" Normal Mode Remaps
nnoremap <Leader>n n
nnoremap n nzz

nnoremap <Leader>N N
nnoremap N Nzz

nnoremap <Leader><C-W>t <C-W>t
nnoremap <C-W>t <C-W>v<C-W>T

" Insert Mode Remaps
inoremap {<Enter> {<Enter><Enter>}<Esc>ki<Tab>

" Commands
command SaveSesh mksession! ~/.vim/sesh.vim

" Splitting Preferences
set splitright
set splitbelow

" Folding Stuff
set foldenable
set foldmethod=indent
set foldcolumn=0
set foldtext=FoldText()

function! FoldText()
    " Pre-body
    let level = v:foldlevel
    let pre_body = '(' . level . ') '

    " Post-body
    let lnum = v:foldend - v:foldstart + 1
    let post_body = ' [' . lnum . '] '

    " Body
    let line = getline(v:foldstart)
    let len_body = winwidth(0) - (len(pre_body) + len(post_body))
    if (len(line) > len_body)
        let body = line[0:(len_body - 4)] . '...'
    else
        let body = line . repeat(' ', len_body - len(line))
    endif

    " Return
    return pre_body . body . post_body
endfunction

" Tab bar verbosity
set showtabline=0

" Status bar verbosity
set laststatus=1

" Enables/disables changed buffers to be hidden
set hidden

" Adds 6 lines of context when scrolling
set scrolloff=6

" Show prompt when closing unsaved file
set confirm

" Enables/disables swap file
set noswapfile

" For fear of madness
set belloff=all

" Inserts spaces in lieu of tabs
set expandtab

" The number of spaces used to represent a tab
set tabstop=4

" The number of spaces inserted for indentation
set shiftwidth=4

" Set auto-indent for standard files
set autoindent

" Enables text wrapping
set wrap

" Wrap on breatat character
set linebreak

" Enable Backspace
set bs=2

" This sets custom white-space characters
set listchars=tab:>-,trail:-,extends:>,precedes:<

" Shows white-space
set list

" Shows the command as it is written
set showcmd

" Changes the language to proper English
set spelllang=en_gb

" Activates/deactivates spell-check
set spell

" Activates/deactivates highlighting search results
set hlsearch

" Wildmenu
set wildmode=longest,list
set wildmenu

" Underlines current line
"set cursorline

" Activates/deactivates ruler
set ruler

" Activates/deactivates line numbers
set nonumber

" Set syntax highlighting
syntax on

" GVim settings
if has('gui_running')
    " Remove tool-bar
    set go-=T

    " Remove menu-bar
    set go-=m

    " Remove scroll-bar
    set go-=r

    " Sets font
    set guifont=Droid\ Sans\ Mono\ 13

    " Set the size
    set lines=40 columns=90

    " Sets colorsheme
    colorscheme peachpuff

    " Creates a 'ruler' to be used as guide at column 80
    "highlight ColorColumn ctermbg=0 guibg=#e3c1a5
    "set colorcolumn=80
else
    " Let there be colour!
    colorscheme ron

    " Adds automatic new line (text width)
    set tw=80

    " Creates a 'ruler' to be used as guide at column 80
    highlight ColorColumn ctermbg=0 guibg=lightgrey
    set colorcolumn=80

endif
