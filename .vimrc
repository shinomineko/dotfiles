call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'chr4/nginx.vim'
Plug 'jvirtanen/vim-hcl'
Plug 'hashivim/vim-terraform'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'elzr/vim-json'
Plug 'wgwoods/vim-systemd-syntax'
Plug 'itchyny/lightline.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'google/vim-jsonnet'
Plug 'timakro/vim-yadi'
call plug#end()

autocmd BufRead * DetectIndent
filetype plugin indent on
syntax on
set background=dark
" set termguicolors

let mapleader = ","
let g:mapleader = ","

nnoremap Q <nop>
nnoremap ; :
map q: :q

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader><space> :nohlsearch<CR>
nmap <leader>w :w!<CR>

set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4

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
set textwidth=0
set formatoptions=qrn1

set conceallevel=0

set notimeout
set ttimeout
set ttimeoutlen=10

set noshowmode
set laststatus=2

if has('mouse')
  set mouse=a
endif

set complete-=i
set complete=.,w,b,u,t
set completeopt=longest,menuone

nnoremap <C-x> :bnext<CR>
nnoremap <C-z> :bprev<CR>

set splitright
set splitbelow
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

set wildmenu

set wildignore+=.hg,.git,.svn
set wildignore+=*.bmp,*.jpg,*.jpeg,*.png,*.gif
set wildignore+=*.o,*.obj,*.dll,*.exe
set wildignore+=*.sw?
set wildignore+=*.DS_Store
set wildignore+=*.pyc
set wildignore+=*.orig
set wildignore+=*.so

" ====== ctrlp ======
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_height = 10
let g:ctrlp_max_files = 10000
let g:ctrlp_mruf_max = 250
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

" ====== vim-markdown ======
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1

" ====== vim-json ======
let g:vim_json_syntax_conceal = 0

" ====== vim-terraform ======
let g:terraform_fmt_on_save = 1

" ====== lightline ======
let g:lightline = {
  \ 'colorscheme': '16color',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'indentstyle' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ 'component': {
  \   'indentstyle': '%{&expandtab?shiftwidth()." sp":"tabs"}'
  \ },
  \ }

" ====== vim-table-mode ======
nnoremap <leader>tm :TableModeToggle

" vim:ts=2:sw=2:et
