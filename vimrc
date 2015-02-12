set nocompatible
filetype off

" plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" other plugins
Plugin 'bling/vim-airline'
Plugin 'chrisbra/Colorizer'
Plugin 'davidhalter/jedi-vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'junegunn/vim-easy-align'
Plugin 'kien/ctrlp.vim'
Plugin 'mhinz/vim-startify'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete.vim'
Plugin 'smancill/conky-syntax.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'

call vundle#end()                  " required
filetype plugin indent on
" }}}


" general settings {{{
syntax on                          " syntax highlight
set autoread
set clipboard=unnamedplus          " normal clipboard
set hidden
set nobackup                       " no swap and backup files
set noswapfile
" }}}

" UI  {{{
if has('gui_running')
    set guifont=inconsolata-dz\ for\ Powerline\ 8" set font
    set guioptions = " remove everything gui
    set guiheadroom=0
    set background=light
endif

set t_Co=256
colorscheme solarized

set autochdir                      " cd to current file
set backspace=indent,eol,start
set cursorline                     " highlight current line
set laststatus=2                   " Always display status bar
set mouse=a
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


" keymappings  {{{

" remove keymaps
imap <F1>    <Nop>

" friendly keymaps
let mapleader="\<Space>"

" noremap ; :
" noremap : ;

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

" Clear search highlight
nnoremap <Leader><Space> :noh<CR>

" Substitution shortcut
nnoremap <Leader>s  :%s
vnoremap <Leader>s  :s

" Toggle numbering
nnoremap <F1>    :set relativenumber!<CR>

" Insert timestamp
nnoremap <F5> "=strftime("%A, %d %B %Y %H:%M %Z")<C-M>p
" }}}

" package specific keymaps {{{

" use TAB completion neocomplete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" use Enter for EasyAlign
nnoremap ga :EasyAlign
vnoremap <Enter> :EasyAlign
" }}}

" package specific options

" airline  {{{
let g:airline_powerline_fonts = 1
"let g:airline_theme = 'wombat'
" }}}

" ctrl-p  {{{
let g:ctrlp_reuse_window  = 'startify'
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
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
" }}}

" neocomplete  {{{
let g:neocomplete#enable_at_startup = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Fix for jedi-vim
autocmd FileType python setlocal omnifunc=jedi#completions
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
" }}}

" startify {{{
autocmd FileType startify setlocal buftype=
let g:startify_bookmarks = [
            \ '~/xcomp_confs',
            \ '~/.vimrc',
            \ ]
let g:startify_list_order = [
            \ ['   Bookmarks:'],
            \ 'bookmarks',
            \ ['   Recently used:'],
            \ 'files',
            \ ['   Sessions:'],
            \ 'sessions',
            \ ]
" }}}

" syntastic {{{
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'
let g:syntastic_full_redraws = 1
let g:syntastic_auto_jump = 2 " Jump to syntax errors
let g:syntastic_auto_loc_list = 1 " Auto-open the error list
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=W391'
" }}}

" vim commentary {{{
autocmd FileType xdefaults setlocal commentstring=!%s
"}}}


" custom functions {{{

" Removes trailing spaces
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
"}}}


" autocommands

augroup vimrc_au " vimrc autocommands {{{
    autocmd!

    " reload vimrc when it is changed
    autocmd! bufwritepost .vimrc source %

    " normal numbers in insert mode
    autocmd InsertEnter * :set norelativenumber
    " relative numbers in normal mode
    autocmd InsertLeave * :set relativenumber

    " Remove trailing whitespace
    autocmd BufWritePre * :call TrimWhiteSpace()

augroup END
" }}}

augroup filetypes " FileType specific autocommands {{{
    autocmd!

    " Programming languages
    " mark the 80th column
    autocmd FileType c,cpp,java,lua,python,sh setlocal colorcolumn=80

    " Text files
    " enable wrapping text files
    autocmd FileType text setlocal wrap linebreak nolist
augroup END
"}}}

" vim:foldmethod=marker:foldlevel=0:foldenable
