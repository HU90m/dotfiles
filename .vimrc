" Terminal Escape
tnoremap <Esc><Esc> <C-\><C-n>

" Normal Mode Bindings
nnoremap <Leader><C-W>t <C-W>t
nnoremap <C-W>t <C-W>s<C-W>T

nnoremap <Leader>n n
nnoremap n nzz

nnoremap <Leader>N N
nnoremap N Nzz

" Remove tab bar
set showtabline=0

" Enables/disables changed buffers to be hidden
set hidden

" Show prompt when closing unsaved file
set confirm

" Enables/disables swap file
set swapfile

" Inserts spaces in lieu of tabs
set expandtab
" The number of spaces used to represent a tab
set tabstop=4
" The number of spaces inserted for indentation
set shiftwidth=4
" Set auto-indent for standard files
set autoindent

" Disables text wrapping
set nowrap

" Adds automatic new line (text width)
"set tw=80

" This sets custom white-space characters
set listchars=tab:>-,trail:-,extends:>,precedes:<

" Shows white-space
set list

" Shows the command as it is written
set showcmd

" Changes the language to proper English
set spelllang=en_gb

" Enables/disables spell-check
set nospell

" Activates/deactivates highlighting search results
set hlsearch

" Wildmenu
set wildmode=longest,list
set wildmenu

" Underlines current line
"set cursorline

" Activates/deactivates ruler
set noruler

" Activates/deactivates line numbers
set nonumber

" Let there be colour!
colorscheme ron

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
  set guifont=Monospace

  " Sets colorsheme
  colorscheme desert
endif
