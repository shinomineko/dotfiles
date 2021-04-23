call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'hashivim/vim-terraform'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'pgdouyon/vim-yin-yang'
call plug#end()

filetype plugin indent on
syntax on
colorscheme yang

let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1

nnoremap ; :
nnoremap Q <nop>

set encoding=utf-8
set autoread
set autoindent
set backspace=indent,eol,start
set incsearch
set hlsearch
set ignorecase
set smartcase
set mouse=a

set noerrorbells
set number
set rnu
set ruler
set showcmd
set nobackup
set fileformats=unix,dos,mac
set nocursorcolumn
set nocursorline
set nowrap

set tabstop=2
set shiftwidth=2
set expandtab

set laststatus=2
set statusline=%f%m%r%h%w
set statusline+=\ [%{&ff}]
set statusline+=%=
set statusline+=[%l/%L:%04v]
