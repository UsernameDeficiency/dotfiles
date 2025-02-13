" Based on amix with additions from vim.fandom and dougblack.io 
" 	github.com/amix/vimrc/blob/master/vimrcs/basic.vimk
" 	vim.fandom.com/wiki/Example_vimrc
" 	dougblack.io/words/a-good-vimrc.html
" Note: Some commands below are commented out because they seem to have no effect in my
"       WSL install, you might want to turn those on.
" Binding:
"       0: ^
"       ¤: $
"       C-L: redraw AND clear search highlights
"       #: Search for highlighted text (visual mode)
"       ,tn: :tabnew<cr>
"       ,to: :tabonly<cr>
"       ,tc: :tabclose<cr>
"       ,tm: :tabmove
"       ,t,: :tabnext
"       ,bd: Close current buffer
"       ,ba: Close all buffers
"       ,l:  Next buffer
"       ,h:  Previous buffer
"       ,te: Open new tab with current buffer's path
"       ,cd: Change CWD to the current buffer's path
"       ,s:  Exit and save session, restore with vim -S
set mouse=a " Mouse support
set number  " Absolute line numbers
set ruler   " Show current position

set showcmd
set cmdheight=2
set wildmenu " Graphical autocomplete for command menu
set wildignore=*.o,*~,*.pyc

set laststatus=2 " Always show the status line
" Format the status line
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" 'Allow backspacing over autoindent, line breaks and start of insert action'
set backspace=eol,start,indent

"set whichwrap+=<,>,h,l,[,] " Arrow key and h, l wrap on line end (can't get this to work)

set ignorecase " Search ignores case...
set smartcase  " ... except when using capital letters
set hlsearch   " Search result highlighting
set incsearch  " Incremental search

set lazyredraw " Don't redraw during macros
set showmatch  " Highlight matching brackets 

set cursorline " Horizontal line under cursor

"set noerrorbells " No sound on errors (can't get this to work)
"set novisualbell
"set tm=500

" 'Ward of unexpected things that your distro might have made,
" as well as sanely reset options when re-sourcing .vimrc'
set nocompatible

" Stop certain movements from always going to the first character of a line.
set nostartofline

" Colors, language and fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable " Syntax highlighting 
filetype indent plugin on " Filetype detection 

" Make sure vim doesn't get any crazy ideas about the display language
let $LANG='en'
set langmenu=en
"source $VIMRUNTINE/delmenu.vim
source $VIMRUNTIME/menu.vim
set encoding=utf8

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
    "colorscheme badwolf
catch
endtry

" 'Set extra options when running in GUI mode'
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Text, tabs and indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use 4 spaces instead of tab
set expandtab
set shiftwidth=4
set smarttab " Be 'smart' when adding tabs to start of lines (?) 
"set tabstop=4 " Only change this if you want identical tabs and softtabs

set tw=0 " Make sure Vim doesn't destroy long lines 
set ai   " Auto indent
set si   " Smart indent
set wrap " Wrap lines

" Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hid " Allow hiding unsaved buffers

" Remap 0 to first non-blank character
map 0 ^
" Map ¤ to line end (no need for alt-gr on Swedish kb)
map ¤ $

" Map <C-L> (redraw screen) to also clear search highlighting
nnoremap <C-L> :nohl<CR><C-L>

let mapleader = ","

" Visual mode pressing # searches for the current selection
" From an idea by Michael Naumann
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Mappings for tabs and buffers
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 
" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT
" Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>
" Open new tab with current buffer's path, useful when editing files in the same dir
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Save session (vim -S to return to session)
nnoremap <leader>s :mksession<CR>

try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't close window when deleting buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

