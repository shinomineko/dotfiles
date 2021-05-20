call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'editorconfig/editorconfig-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
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
Plug 'chriskempson/base16-vim'
call plug#end()

filetype plugin indent on
syntax on
set background=dark
set termguicolors
silent! colorscheme base16-gruvbox-dark-medium

let mapleader = ","
let g:mapleader = ","

nnoremap ; :
nnoremap Q <nop>
map q: :q

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader><space> :nohlsearch<CR>

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

" ====== file type settings ======
au BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.md setlocal noet ts=4 sw=4
au BufNewFile,BufRead *.yml,*.yaml setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.json setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.py setlocal expandtab ts=4 sw=4 sts=4
au FileType sh,gitconfig,toml set noet
au FileType dockerfile set noet
au BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
au FileType nginx setlocal noet ts=4 sw=4 sts=4

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

" ====== vim-go ======
let g:go_fmt_autosave = 1
let g:go_fmt_command = 'goimports'

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)

" ====== vim-multiple-cursors ======
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-i>'
let g:multi_cursor_prev_key='<C-y>'
let g:multi_cursor_skip_key='<C-b>'
let g:multi_cursor_quit_key='<Esc>'
