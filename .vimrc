" Terminal Escape
tnoremap <Esc><Esc> <C-\><C-n>

" Remove tab bar
set showtabline=0

" Disable swap file
set noswapfile

" Inserts spaces in lieu of tabs
set expandtab

" The number of spaces used to represent a tab
set tabstop=4

" The number of spaces inserted for indentation
set shiftwidth=4

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

" Activates spell-check
set spell

" Activates/deactivates highlighting search results
set hlsearch
"set nohlsearch

" Wildmenu
set wildmode=longest,list
set wildmenu

" Underlines current line
"set cursorline

" Activates/deactivates ruler
"set ruler
set noruler

" Activates/deactivates line numbers
"set number
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
