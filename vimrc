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
 Bundle 'davidhalter/jedi-vim'
 Bundle 'ervandew/supertab'
 Bundle 'jiangmiao/auto-pairs'
 Bundle 'kien/ctrlp.vim'
 Bundle 'bling/vim-airline'
 Bundle 'xuhdev/SingleCompile'
 Bundle 'smancill/conky-syntax.vim'


" general settings
autocmd! bufwritepost .vimrc source % " apply changes to vimrc

set clipboard=unnamedplus " normal clipboard

filetype plugin indent on
syntax on " syntax highlight
set number " Line mumbers

set tabstop=4 " Set tab=4 spaces
set shiftwidth=4
set expandtab " Use spaces instead of tabs

" code folding settings
set foldmethod=indent
set foldnestmax=2
set nofoldenable

set laststatus=2 " Always display status bar
set showcmd

set splitbelow
set splitright

" no swap and backup files
set nobackup
set noswapfile

set wildignore+=*.so,*.swp,*.zip,*.o,*.pyc,*.javac,*.out
set wildmenu
set wildmode=longest:full,full

if has('gui_running')
    set guioptions = " remove everything gui
    set guioptions +=m " now add menubar
    set guifont=Droid\ Sans\ Mono\ Slashed\ 10 " set font
endif

" keymappings

" friendly keymaps
let mapleader=","
" let maplocalleader=","
nnoremap ; :
inoremap jk <Esc>
inoremap kj <Esc>

" navigate wrapped lines
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up> <C-o>gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk
nnoremap <silent> j gj
nnoremap <silent> k gk

" split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" tab navigation like firefox
nnoremap <C-tab>   :tabnext<CR>
inoremap <C-tab> <C-o>:tabnext<CR>
nnoremap <C-t>     :tabnew<CR>

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

colorscheme zenburn " Zenburn theme
