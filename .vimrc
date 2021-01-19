" VimPlug
" Install vim-plug if we don't already have it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

if $GO_BIN_PATH != ""
  let g:go_bin_path=$GO_BIN_PATH
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

  augroup vimrc_ft_hooks
    autocmd!
    autocmd filetype go call s:SetupGo()
  augroup end

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
Plug 'ctrlpvim/ctrlp.vim'
Plug 'garyburd/go-explorer', {'for': 'go', 'do': 'go get -u github.com/garyburd/go-explorer/src/getool'}

call plug#end()



let g:go_fmt_command = "goimports"
let g:go_rename_command = "gopls"
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

" ctrl-p
let g:ctrlp_map = '<C-p>' " Ctrl P to C-p
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra' "Search in the current directory
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_root_markers = ['README.md']
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color never'
endif

" ToggleNERDTree opens a NERDTree in the parent directory of the current file
" or in the current directory if a file isn't open.
function! s:ToggleNERDTree() " {{{2
    if expand('%') == ''
        exec 'NERDTreeToggle'
    else
        exec 'NERDTreeToggle %:h'
    endif
endfunction

" Space = leader
let mapleader = "\<Space>"

function! s:SetupGo() " {{{2
    setlocal noet
    nmap <buffer> <leader>d <Plug>(go-def)

    " Search for declarations in the current file or directory.
    nmap <buffer> <leader>ss :GoDecls<CR>
    nmap <buffer> <leader>sd :GoDeclsDir<CR>

    call s:ClosePreviewOnMove()
endfunction

" ClosePreviewOnMove sets up an autocmd to close the preview window once the
" cursor moves.
function! s:ClosePreviewOnMove() " {{{2
    autocmd CursorMovedI <buffer> call s:ClosePreview()
    autocmd InsertLeave  <buffer> call s:ClosePreview()
endfunction

function! s:ClosePreview() " {{{2
    if pumvisible() == 0 && bufname('%') != "[Command Line]"
        silent! pclose
    endif
endfunction

" fzf
nmap <silent> <C-P> :Files<CR>

" Quick switch buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

