" vimrc
" plugins
call plug#begin()
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
call plug#end()

" general settings
set autoread
set backspace=indent,eol,start
set clipboard=unnamedplus    " normal clipboard
set ttimeoutlen=50           " fast escape
set cursorline
set hidden
set mouse=a
set nowrap                   " do not wrap lines
set showcmd
set nobackup noswapfile      " no swap and backup files
set number relativenumber
set splitbelow splitright    " new splits below and to the right
set tabstop=4                " Set tab=4 spaces
set shiftwidth=4
set expandtab                " Use spaces instead of tabs
set foldmethod=indent        " code folding
set foldnestmax=2
set nofoldenable
" search
set incsearch
set hlsearch
set ignorecase
set smartcase
set showmatch
" wildmode
set completeopt=noinsert,menuone,noselect
set wildignore+=*.so,*.o,*.pyc,*.javac,*.out,*.luac,*.class,*.bmp,*.jpg,*.jpeg,*.png
set wildmenu
set wildmode=longest:full,full

" statusline
" file flags [trail] [mixed] <-> unix | utf-8 | filetype line/total, column
set laststatus=2
set statusline=\ %F                                            " filename
set statusline+=\ %m%r%h                                       " flags
set statusline+=\ %#error#%{TrailingSpaceWarning()}%*
set statusline+=\ %#error#%{MixedIndentWarning()}%*
set statusline+=%=                                             " goto right hand side
set statusline+=%{&ff!='unix'?&ff.'\ \|\ ':''}                 " format if not unix
set statusline+=%{&fenc!='utf-8'&&&fenc!=''?&fenc.'\ \|\ ':''} " encoding if not utf-8
set statusline+=%{&ft}\                                        " filetype
set statusline+=%5l/%L,\ %-4v                                  " line/total, col

" custom functions and commands
" Removes trailing spaces (vimcasts)
function! TrimWhiteSpace()
    " Save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
    update
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

" Check mixed indent
function! MixedIndentWarning()
    if !exists("b:mixed_indent_warning")
        if (search('^\t', 'nw') != 0 && search('^\s', 'nw') != 0)
            let b:mixed_indent_warning = '[mixed]'
        else
            let b:mixed_indent_warning = ''
        endif
    endif
    return b:mixed_indent_warning
endfunction

" Higlight long lines
function! HlLongLines()
    " display a colorcolumn only if there are long lines
    if search('\%>80v.\+', 'nw') != 0
        setlocal colorcolumn=80
    else
        setlocal colorcolumn=
    endif
endfunction

augroup vimrc
    autocmd!
    " recheck trailing spaces and indent when saving files
    autocmd BufWritePost * unlet! b:trailing_space_warning
    autocmd BufWritePost * unlet! b:mixed_indent_warning
    " text files - enable wrapping
    autocmd FileType text setlocal wrap linebreak nolist
    " vim commentary
    autocmd FileType xdefaults setlocal commentstring=!\ %s
    autocmd FileType cpp setlocal commentstring=//\ %s
    " display a colorcolumn if there are long lines
    autocmd BufEnter,BufWritePost  *.{c,cpp,lua,py,sh} call HlLongLines()
augroup END

augroup Python
    autocmd!
    " highlight self keyword
    autocmd FileType python syn keyword pythonBuiltin self
    " use yapf for formatting
    autocmd FileType python setlocal equalprg=yapf
    " abbreviation snippet
    autocmd FileType python iabbrev <buffer> ifm if __name__ == "__main__":
augroup END

" keymappings
" remove keymaps
imap <F1>    <Nop>
" friendly keymaps
let mapleader="\<Space>"
inoremap jk <Esc>
inoremap kj <Esc>
" navigate wrapped lines
nnoremap <silent> j gj
nnoremap <silent> k gk
" split navigation
nnoremap <C-J> <C-W><C-j>
nnoremap <C-K> <C-W><C-k>
nnoremap <C-L> <C-W><C-l>
nnoremap <C-H> <C-W><C-h>
" Quickfix
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
" Location List
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
" buffer navigation
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
" goto buffer /r/vim
nnoremap gb :ls<CR>:buffer<Space>
" Delete current buffer
nnoremap <C-q> :bd<CR>
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
" show total matches
nnoremap * *<C-O>:%s///gn<CR>``
nnoremap <Leader>m :%s///gn<CR>
" Clear search highlight
nnoremap <Leader><Space> :noh<CR>
" Substitution shortcut
nnoremap <Leader>s  :%s
vnoremap <Leader>s  :s
" Strip trailing space
nnoremap <F1> :call TrimWhiteSpace()<CR>
" Toggle numbering
nnoremap <F2> :set relativenumber!<CR>
" Autoclose braces
inoremap {<CR> {<CR>}<Esc>O
" Tab completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" Insert timestamp
iabbrev _date <C-r>=strftime("%A, %d %B %Y %H:%M %Z")

" package specific options
" ALE
let g:ale_sign_column_always = 1
let g:ale_open_list='on_save'

" colorscheme
if (&t_Co == 256)
    set termguicolors
    " cursor shape. insert - ibeam, normal - block, replace - underline
    let &t_SI = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[2 q"
    let &t_SR = "\<Esc>[4 q"
endif
" set background=light
" colorscheme solarized8
