" ~/.vimrc — sensible defaults

" --- Compatibility ---
set nocompatible
filetype plugin indent on
syntax on

" --- Encoding ---
set encoding=utf-8

" --- History & Undo ---
set history=1000
set undolevels=1000
set undofile
set undodir=~/.vim/undodir

" --- UI ---
set number
set relativenumber
set ruler
set showcmd
set showmode
set cursorline
set wildmenu
set laststatus=2

" --- Search ---
set hlsearch
set incsearch
set ignorecase
set smartcase

" --- Indentation ---
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" --- Visuals ---
set background=dark
set t_Co=256

" --- No swap/backup clutter (persistent undo replaces these) ---
set noswapfile
set nobackup
set nowb

" --- Keybinds ---
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader><space> :nohlsearch<CR>

" --- Splits (open below and to the right, which feels natural) ---
set splitbelow
set splitright
" Note: <C-l> overrides the built-in 'redraw screen' command
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Create undodir if it doesn't exist ---
if !isdirectory(&undodir)
  call mkdir(&undodir, "p")
endif
