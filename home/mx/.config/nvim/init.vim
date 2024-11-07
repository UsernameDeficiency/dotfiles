set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
" Make nvim clipboard work with WSL (use system clipboard for yank/paste)
set clipboard+=unnamedplus
