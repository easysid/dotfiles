set nocompatible
filetype off

" plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" other plugins
Plugin 'bling/vim-airline'
Plugin 'davidhalter/jedi-vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'

call vundle#end()                  " required
filetype plugin indent on
" }}}


" general settings {{{
syntax on                          " syntax highlight
set autochdir                      " cd to current file
set autoread
set backspace=indent,eol,start
set clipboard=unnamedplus          " normal clipboard
set colorcolumn=80
set cursorline                     " highlight current line
set hidden
set laststatus=2                   " Always display status bar
set mouse=a
set nobackup                       " no swap and backup files
set noswapfile
set nowrap                         " do not wrap lines
set number
set showcmd
set splitbelow                     " new splits below and to the right
set splitright
" }}}

" tabs  {{{
set tabstop=4                      " Set tab=4 spaces
set shiftwidth=4
set expandtab                      " Use spaces instead of tabs
set smarttab
" }}}

" code folding  {{{
set foldmethod=indent
set foldnestmax=2
set nofoldenable
" }}}

" wildmode  {{{
set completeopt=longest,menuone
set wildignore+=*.bmp,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.exe,*.dll,*.manifest,*.gz
set wildignore+=*.so,*.swp,*.zip,*.o,*.pyc,*.javac,*.out,*.luac,*.class
set wildignore+=*/Downloads/*,*/temp/*,*/Documents/*,*/Pictures/*,*/Videos/*
set wildmenu
set wildmode=longest:full,full
" }}}

" search  {{{
set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
" }}}


" custom functions and commands {{{

" Removes trailing spaces
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

command! StripSpace :call TrimWhiteSpace()
"}}}


" autocommands

augroup vimrc   " vimrc autocommands {{{
    autocmd!
    " reload vimrc when it is changed
    autocmd! bufwritepost .vimrc source %
    " normal numbers in insert mode
    autocmd InsertEnter * :set norelativenumber
    " relative numbers in normal mode
    autocmd InsertLeave * :set relativenumber
augroup END
" }}}

augroup filetypes   " FileType specific autocommands {{{
    autocmd!
    " text files - enable wrapping and remove colorcolumn
    autocmd FileType text setlocal wrap linebreak nolist colorcolumn=
    " vim commentary
    autocmd FileType xdefaults setlocal commentstring=!\ %s
    autocmd FileType cpp setlocal commentstring=//\ %s
    " set conkyrc FileType
    autocmd BufNewFile,BufRead *conkyrc* set filetype=conkyrc
augroup END
"}}}


" keymappings  {{{

" remove keymaps
imap <F1>    <Nop>

" friendly keymaps
let mapleader="\<Space>"

noremap ; :
noremap : ;

inoremap jk <Esc>
inoremap kj <Esc>
vnoremap jk <Esc>gV
vnoremap kj <Esc>gV

" navigate wrapped lines
nnoremap <silent> j gj
nnoremap <silent> k gk

" split navigation
nnoremap <C-J> <C-W><C-j>
nnoremap <C-K> <C-W><C-k>
nnoremap <C-L> <C-W><C-l>
nnoremap <C-H> <C-W><C-h>

" Delete current buffer
nnoremap <C-q> :bd<CR>

" cycle through buffers
nnoremap <S-tab>   :bnext<CR>

" save with C-s
inoremap <C-s> <Esc>:update<CR>
nnoremap <C-s> :update<CR>

" Y consistent with D and C
nnoremap Y y$

" search and center
nnoremap n nzz
nnoremap N Nzz

" Clear search highlight
nnoremap <Leader><Space> :noh<CR>

" Substitution shortcut
nnoremap <Leader>s  :%s

" save file as root
cnoremap w!! w !sudo tee % > /dev/null

" Toggle numbering
nnoremap <F1>    :set relativenumber!<CR>

" Insert timestamp
nnoremap <F5> "=strftime("%A, %d %B %Y %H:%M %Z")<C-M>p
" }}}

" package specific keymaps {{{

" use TAB completion neocomplete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}


" package specific options

" airline  {{{
let g:airline_powerline_fonts = 1
" if !exists('g:airline_symbols')
" let g:airline_symbols = {}
" endif
" " unicode symbols
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_symbols.linenr = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.paste = ''
" let g:airline_symbols.whitespace = ''

let g:airline_theme = 'hybridline'
" }}}

" ctrl-p  {{{
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$|\/images',
            \ 'file': '\.(dat|DS_Store)$'
            \ }
" }}}

" Jedi  {{{
autocmd FileType python setlocal completeopt-=preview
" fix for neocomplete
let g:jedi#popup_select_first = 0
" }}}

" neocomplete  {{{
let g:neocomplete#enable_at_startup = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" }}}

" syntastic {{{
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_full_redraws = 1
let g:syntastic_auto_jump = 2     " Jump to syntax errors
let g:syntastic_auto_loc_list = 1 " Auto-open the error list
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=W391'
" }}}


" colorscheme and gui {{{
if has('gui_running')
    set guifont=ubuntu\ mono\ derivative\ powerline\ 9.5" set font
    set guioptions = " remove everything gui
    set guiheadroom=0
    " set background=light
endif
let g:hybrid_use_Xresources = 1
colorscheme hybrid
" }}}

" vim:foldmethod=marker:foldlevel=0:foldenable
