" This is iturner72's version controlled .vimrc file

" Get rid of annoying bell sound, replace w visual bell
set visualbell

" Simple highlighting 
syntax on

" Remap the escape key to jk
inoremap jk <esc>

"-------------------------------- Movement ------------------------------------

" Vim and tmux split/pane navigations 
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

"----------------------------- General Settings -------------------------------
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set incsearch

set colorcolumn=80 
highlight ColorColumn ctermbg=0 guibg=lightgrey

"-------------------------------- Plugins -------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
Plug 'mbbill/undotree'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif
