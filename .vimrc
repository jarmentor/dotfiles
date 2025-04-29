set nocompatible
filetype plugin indent on
syntax on

" Leader key
let mapleader = ' '

" Basic UI
set number relativenumber
set cursorline
set signcolumn=yes
set showmode
set nowrap
set termguicolors
set mouse=a
set scrolloff=8 sidescrolloff=8

" Editing enhancements
set backspace=indent,eol,start
set clipboard=unnamedplus
set undofile
if has('persistent_undo')
  silent !mkdir -p ~/.vim/undodir
  set undodir=~/.vim/undodir
endif
set history=1000
set splitbelow splitright

" Indentation
set tabstop=2 shiftwidth=2 expandtab
set autoindent smartindent

" Search
set ignorecase smartcase
set incsearch
set hlsearch

" List display (tabs, trailing spaces)
set list
set listchars=tab:»\ ,trail:·,nbsp:␣

" Performance
set updatetime=250
set timeoutlen=300

" Folding
set foldmethod=indent foldlevelstart=99

" Key mappings
nnoremap <Esc> :nohlsearch<CR>
nnoremap <silent> W :w<CR>
nnoremap <silent> Q :q<CR>
nnoremap <Left> :echo "Use h to move!!"<CR>
nnoremap <Right> :echo "Use l to move!!"<CR>
nnoremap <Up> :echo "Use k to move!!"<CR>
nnoremap <Down> :echo "Use j to move!!"<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <S-j> :m .+1<CR>==
nnoremap <silent> <S-k> :m .-2<CR>==
inoremap <silent> <S-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <S-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <S-j> :m '>+1<CR>gv=gv
vnoremap <silent> <S-k> :m '<-2<CR>gv=gv

" Auto commands
augroup VimConf
  autocmd!
  " Trim trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e
  " Return to last cursor position on file open
  autocmd BufReadPost * silent! normal! g`"
augroup END

" User commands
command! -range=% TrimTrailingSpaces <line1>,<line2>s/\s\+$//e
command! ToggleLineNumbers set number! relativenumber!
command! SaveAll wa
function! BackupFile()
  let l:file = expand('%')
  let l:timestamp = strftime('%Y%m%d%H%M%S')
  let l:bak = l:file . '.' . l:timestamp . '.bak'
  silent execute '!cp ' . shellescape(l:file) . ' ' . shellescape(l:bak)
  echom 'Backup created at ' . l:bak
  edit!
endfunction
command! BackupFile call BackupFile()
function! GitResetBuffer()
  let l:confirm = confirm('Are you sure you want to reset the current buffer?', '&Yes\n&No', 2)
  if l:confirm == 1
    silent execute '!git checkout -- ' . shellescape(expand('%')) . ' | edit!'
    echom 'Buffer has been reset to the latest commit.'
  else
    echom 'Git reset cancelled.'
  endif
endfunction
command! GitResetBuffer call GitResetBuffer()
