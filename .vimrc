" vim: set foldmethod=marker foldlevel=0 nomodeline:
" =============================================================================
"This is iturner72's version controlled .vimrc file {{{
" =============================================================================

" }}}
" =============================================================================
" MAPPINGS {{{
" =============================================================================
" general remaps
inoremap jk <esc>

" Git and vim integration
let mapleader = "\<Space>"
nmap <leader>gs :G<CR>
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Vim and tmux split/pane navigations
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

" Fzf remaps
function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()
nmap <leader>p :ProjectFiles<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>h :History<CR>
nmap <leader>P :FZF ~<CR>

" Terminal in vim
nmap <leader>t :terminal<CR>

" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" }}}
" =============================================================================
" GENERAL SETTINGS {{{
" =============================================================================
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

" }}}
" =============================================================================
" FUNCTIONS {{{
" =============================================================================
" Close all buffers except current one
command! BufOnly execute '%bdelete|edit #|normal `"'

" Same thing as ctrl-p... I think...
command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" Rg command with preview window enabled
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --hidden --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Make fzf search window appear in center
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'

" }}}
" =============================================================================
" FILE TYPE INDENTATION {{{
" =============================================================================
autocmd BufRead,BufNewFile *.launch setfiletype roslaunch
augroup FileTypeSpecificAutocommands
    autocmd FileType xml setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" }}}
" =============================================================================
" PLUGINS {{{
" =============================================================================
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'romainl/vim-cool'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

call plug#end()

" }}}
" =============================================================================
" AIRLINE {{{
" =============================================================================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" }}}
" =============================================================================
" NERDTREE {{{
" =============================================================================
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <leader>n :NERDTreeToggle<CR>
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

" Rip grep root directory stuff
if executable('rg')
    let g:rg_derive_root='true'
endif

" }}}
" =============================================================================
" COC {{{
" =============================================================================

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use commad ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <buffer> <leader>gd <Plug>(coc-definition)
nmap <buffer> <leader>gy <Plug>(coc-type-definition)
nmap <buffer> <leader>gi <Plug>(coc-implementation)
nmap <buffer> <leader>gr <Plug>(coc-references)
nnoremap <buffer> <leader>cr :CocRestart

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()

" }}}
" =============================================================================
" THEMES {{{
" =============================================================================
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
set background=dark
let g:gruvbox_invert_selection='0'

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" }}}
