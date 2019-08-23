set et ts=2 sw=2

set nocompatible
filetype off

" set the runtime path to include vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/.vundle-packages')

" Let vundle manage vundle
Plugin 'VundleVim/Vundle.vim'

Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()
filetype plugin indent on

" Put swapfiles into a tmp directory
set backupdir=~/.tmp
set directory=~/.tmp
set undodir=~/.tmp

" Use the system clipboard for yank + pull
set clipboard=unnamed

set relativenumber

" Use key mappings for navigation between splits

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" More natural splitting

set splitbelow
set splitright
