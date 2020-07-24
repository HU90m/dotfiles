" Terminal Mode Maps
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-N><C-w>

" Normal Mode Maps
nnoremap <silent> <Leader>t :tabs<CR>

nnoremap <silent> <Leader>w :up<CR>
nnoremap <silent> <Leader>h :noh<CR>

nnoremap <silent> <Leader>l :set list!<CR>
nnoremap <silent> <Leader>s :set spell!<CR>

nnoremap <silent> <Leader>j :n<CR>
nnoremap <silent> <Leader>k :N<CR>

nnoremap <silent> <Leader>n n
nnoremap <silent> <Leader>N N

nnoremap n nzz
nnoremap N Nzz

" Insert Mode Remaps
inoremap {<Enter> {<Enter><Enter>}<Esc>ki<Tab>

" Commands
command PandocToPDF !pandoc % -o %:r.pdf -V geometry:margin=6em -V fontsize=12pt
command SaveSesh mksession! ~/.vim/sesh.vim
command RemoveTrailing %s/\s\+$//g
command W w

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
    let num_lines = v:foldend - v:foldstart + 1
    let pre_body = '< ' . num_lines . ' > '

    " Post-body
    let level = v:foldlevel
    let post_body = ' (' . level . ') '

    " Body
    let len_body = winwidth(0) - (len(pre_body) + len(post_body))
    let body = repeat(' ', len_body)

    " Body with line
    "let len_body = winwidth(0) - (len(pre_body) + len(post_body))
    "let line = getline(v:foldstart)
    "if (len(line) > len_body)
    "    let body = line[0:(len_body - 4)] . '...'
    "else
    "    let body = line . repeat(' ', len_body - len(line))
    "endif

    " Return
    return pre_body . body . post_body
endfunction

" Number of milliseconds to wait for a key sequence
set timeout
set timeoutlen=400

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

" Disables automatic new line (text width)
set tw=0

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

" UI dependant settings
if has('gui_running')
    " Remove tool-bar
    set go-=T

    " Remove menu-bar
    set go-=m

    " Remove scroll-bar
    set go-=r

    " Sets font
    set guifont=Droid\ Sans\ Mono\ 17

    " Set the size
    set lines=40 columns=90

    " Sets colorsheme
    colorscheme peachpuff
else
    " Let there be colour!
    colorscheme ron

    " Creates a 'ruler' to be used as guide at column 80
    set colorcolumn=80
endif

" Colours
highlight ColorColumn ctermbg=0 guibg=lightgrey
highlight Folded ctermbg=NONE guibg=NONE
