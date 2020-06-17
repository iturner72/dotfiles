"This is iturner72's version controlled .vimrc file


"-------------------------------- Mappings ------------------------------------
" general remaps
inoremap jk <esc>

" Git and vim integration
let mapleader = "\<Space>"
nmap <leader>gs :G<CR>
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>

" Vim and tmux split/pane navigations 
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

"----------------------------- General Settings -------------------------------
syntax on
set guicursor=a:blinkon100
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set incsearch
set relativenumber
set encoding=utf8
set conceallevel=3

set colorcolumn=80 
highlight ColorColumn ctermbg=0 guibg=lightgrey

"-------------------------- Ros Syntax Highlighting ---------------------------
autocmd BufRead,BufNewFile *.launch setfiletype roslaunch

"-------------------------------- Plugins -------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

call plug#end()

"------------------------------- Airline ------------------------------------
let g:airline_powerline_fonts = 1

"------------------------------- NerdTree ------------------------------------
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" Get rid of arrows
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

if exists("g:loaded_webdevicons")
    call webdevicons#refresh()
endif
"NERDTrees File highlighting only the glyph/icon
"
"--------------------------------- Themes -------------------------------------
colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif
