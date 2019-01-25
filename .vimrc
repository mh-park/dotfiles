
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Sep 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'fatih/molokai'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'

call plug#end()

let g:go_fmt_command = "goimports"
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai
let g:go_auto_sameids = 1

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')

" ----------------------------------------------------------------------------
"  General Configuration {{{1
" ----------------------------------------------------------------------------

set nocp                " Don't need compatibility with vi
set nobk                " Don't make backups
set ru                  " Show the cursor position all the time
set rnu                 " Relative line numbering
set nu                  " Absolute line number for current line
set et                  " Use spaces to insert tabs
set sw=4                " Number of spaces to use for each indent
set ts=4                " Number of spaces tab will count for
set bg=dark             " We have a dark background
set so=3                " leave 3 lines below cursor
set mouse=a             " Mouse support
set so=10               " 10 lines of context when scrolling
set rtp+=/usr/local/opt/fzf

" NerdTREE shortcuts
nmap <silent> <C-n>      :call <sid>ToggleNERDTree()<CR>

" ToggleNERDTree opens a NERDTree in the parent directory of the current file
" or in the current directory if a file isn't open.
function! s:ToggleNERDTree() " {{{2
    if expand('%') == ''
        exec 'NERDTreeToggle'
    else
        exec 'NERDTreeToggle %:h'
    endif
endfunction

" fzf
nmap <silent> <C-P> :Files<CR>
