call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'hashivim/vim-terraform'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/base16-vim'
call plug#end()

filetype plugin indent on
syntax on
colorscheme base16-grayscale-dark

let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1

nnoremap ; :
nnoremap Q <nop>

set noerrorbells
set encoding=utf-8
set autoread
set backspace=indent,eol,start
set showcmd
set nobackup

set incsearch
set hlsearch
set ignorecase
set smartcase

set number
set rnu
set ruler
set fileformats=unix,dos,mac
set showmatch

set nocursorcolumn
set nocursorline

set wrap
set textwidth=100
set formatoptions=qrn1

set conceallevel=0

set autoindent
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set noexpandtab

set notimeout
set ttimeout
set ttimeoutlen=10

set laststatus=2
set statusline=%f%m%r%h%w
set statusline+=\ [%{&ff}]
set statusline+=%=
set statusline+=[%l/%L:%04v]

if has('mouse')
  set mouse=a
endif
