set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

 " let Vundle manage Vundle
 " required!
 Bundle 'gmarik/vundle'

 " other plugins
 Bundle 'scrooloose/syntastic'
 Bundle 'scrooloose/nerdtree'
 Bundle 'scrooloose/nerdcommenter'
 Bundle 'davidhalter/jedi-vim'
 Bundle 'ervandew/supertab'
 Bundle 'jiangmiao/auto-pairs'
 Bundle 'kien/ctrlp.vim'
 Bundle 'bling/vim-airline'
 Bundle 'xuhdev/SingleCompile'
 Bundle 'smancill/conky-syntax.vim'


" general settings
"
autocmd! bufwritepost .vimrc source %   " apply changes to vimrc
set clipboard=unnamedplus               " normal clipboard
filetype plugin indent on
syntax on                               " syntax highlight
set number                              " Line mumbers
set nowrap                              " do not wrap lines
set tabstop=4                           " Set tab=4 spaces
set shiftwidth=4
set expandtab                           " Use spaces instead of tabs
set foldmethod=indent                   " code folding settings
set foldnestmax=2
set nofoldenable
set laststatus=2                        " Always display status bar
set showcmd
set splitbelow                          " new splits below and to the right
set splitright
set nobackup                            " no swap and backup files
set noswapfile
set wildignore+=*.so,*.swp,*.zip,*.o,*.pyc,*.javac,*.out
set wildmenu
set wildmode=longest:full,full
set incsearch
set mouse=a

if has('gui_running')
    set guioptions = " remove everything gui
    set guioptions +=m " now add menubar
    set guifont=Droid\ Sans\ Mono\ Slashed\ 10 " set font
endif

" keymappings

" friendly keymaps
let mapleader=","
nnoremap ; :
inoremap jk <Esc>
inoremap kj <Esc>

" navigate wrapped lines
"inoremap <silent> <Down> <C-o>gj
"inoremap <silent> <Up> <C-o>gk
"nnoremap <silent> <Down> gj
"nnoremap <silent> <Up> gk
nnoremap <silent> j gj
nnoremap <silent> k gk

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Delete current buffer
inoremap <C-d> <Esc>:bp\|bd #<CR>
nnoremap <C-d> :bd<CR>

" tab and buffer navigation like firefox
nnoremap <C-tab>   :bnext<CR>
inoremap <C-tab>   <C-o>:bnext<CR>

nnoremap <C-S-tab> :tabnext<CR>
inoremap <C-S-tab> <C-o>:tabnext<CR>
nnoremap <C-t>     :tabnew<CR>

" create splits
" nnoremap <C-u> :vsp<CR>
" nnoremap <C-2> :sp<CR>


" save with C-s
noremap <C-s> :update<CR>
inoremap <C-s>  <C-o>:update<CR>

" cd to current file
nnoremap <Leader>cd :lcd%:p:h<CR>:pwd<CR>

" Toggle folding
nnoremap f za


" package specific keymappings

map <F2> :NERDTreeToggle<CR>

" Single compile
nnoremap <F9> :SCCompile<cr>
nnoremap <F10> :SCCompileRun<cr>


" package specific options

" jedi
autocmd FileType python setlocal completeopt-=preview

" airline options
let g:airline_powerline_fonts = 1

" ctrl-p
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_cmd = 'CtrlPMRU'

" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$|Downloads|Documents',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$|\.pyc$'
  \ }

" color theme
colorscheme jellybeans
