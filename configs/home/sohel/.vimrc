
syntax enable
set background=dark
colorscheme sublimemonokai
set rnu
set nu
set tabstop=2
set shiftwidth=2
set expandtab

let g:powerline_pycmd="py3"

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
call plug#end()
