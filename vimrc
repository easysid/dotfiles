set nocompatible
filetype off

" plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
" other plugins
Plugin 'davidhalter/jedi-vim'
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
set hidden
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

" statusline {{{
set laststatus=2
set statusline=\ [%n]\ %f\ %m%r%h\ %y\ [%{&ff}]    " buffer file flags type format
set statusline+=\ %#error#%{TrailingSpaceWarning()}%*    " trailing spaces
set statusline+=%=%l/%L,\ %-4v    " right hand side - line/total lines , column
" }}}

" custom functions and commands {{{

" Removes trailing spaces (vimcasts)
function! <SID>TrimWhiteSpace()
    " Save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Check trailing spaces for statusline
function! TrailingSpaceWarning()
    if !exists("b:trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:trailing_space_warning = '[trailing]'
        else
            let b:trailing_space_warning = ''
        endif
    endif
    return b:trailing_space_warning
endfunction
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
    " recheck trailing spaces when saving files
    autocmd bufwritepost * unlet! b:trailing_space_warning
augroup END
" }}}

augroup filetypes   " FileType specific autocommands {{{
    autocmd!
    " text files - enable wrapping
    autocmd FileType text setlocal wrap linebreak nolist
    " vim commentary
    autocmd FileType xdefaults setlocal commentstring=!\ %s
    autocmd FileType cpp setlocal commentstring=//\ %s
    " set conkyrc FileType
    autocmd BufNewFile,BufRead *conkyrc* set filetype=conkyrc
    " conky comments (from smancill/conky-syntax.vim)
    autocmd filetype conkyrc syn region ConkyrcText start=/^TEXT$/ end=/\%$/ contains=ConkyrcVar,ConkyrcComment
    " highlight long lines
    autocmd WinEnter,BufEnter,FileType c,cpp,python,sh call matchadd('Error', '\%>80v.\+', -1)
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

" goto end of line
nnoremap - $

" search and center
nnoremap n nzz
nnoremap N Nzz

" Clear search highlight
nnoremap <Leader><Space> :noh<CR>

" Substitution shortcut
nnoremap <Leader>s  :%s
vnoremap <Leader>s  :s

" save file as root
cnoremap w!! w !sudo tee % > /dev/null

" edit split in new tab
nnoremap <C-t>  :tab split <CR>

" Toggle numbering
nnoremap <F1>    :set relativenumber!<CR>

" Insert timestamp
nnoremap <F5> "=strftime("%A, %d %B %Y %H:%M %Z")<C-M>p

" Strip trailing space
nnoremap <F6> :call <SID>TrimWhiteSpace()<CR>

" }}}

" package specific keymaps {{{

" use TAB completion neocomplete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}


" package specific options

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
    set guifont=monospace\ 8 " set font
    set guioptions= " remove everything gui
    set guiheadroom=0
    " colorscheme hybrid
" else
"     colorscheme shblah_light
endif
set background=dark
colorscheme base16-mod
" }}}

" vim:foldmethod=marker:foldlevel=0:foldenable
