" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
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
set expandtab 
set mouse=a

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set softtabstop=4
set tabstop=4                   " Leave default for printing etc
set shiftwidth=4
set guifont=Ubuntu\ Mono\ 14
colors koehler
syntax on

map <S-h> gT
map <S-l> gt

map <A-1> 1gt
map <A-2> 2gt
map <A-3> 3gt
map <A-4> 4gt
map <A-5> 5gt
map <A-6> 6gt
map <A-7> 7gt
map <A-8> 8gt
map <A-9> 9gt 

vmap <F11> :-1/^#/s///<CR>
vmap <F12> :-1/^/s//#/<CR>
vmap <S-F12> :-1/^/s//\/\//<CR>

" Make shift-insert work like in Xterm
map  <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>


" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


function! CHANGE_CURR_DIR()
let _dir = expand("%:p:h")
exec "cd " . _dir
unlet _dir
endfunction

autocmd BufEnter * call CHANGE_CURR_DIR() 

set backupdir=~/backups
set directory=~/backups
set encoding=utf-8

function! BytePercent()
  let CurByte = line2byte (line ( "." ) ) + col ( "." ) - 1
  let TotBytes = line2byte( line( "$" ) + 1) - 1
  return ( CurByte * 100 ) / TotBytes
endfunction

command! -nargs=0 -bar HowFar echo "Byte " . ( line2byte( line( "." ) ) + col( "." ) - 1 ) . " of " . ( line2byte( line( "$" ) + 1 ) - 1 ) . " (" . BytePercent() . "%)"

cnoreabbrev HF HowFar
:vmap ;' <Esc>'><Esc>'<ia = time.time()<enter><Esc>'>ob=time.time()<enter>logging.info((b-a, lineno()))<Esc> 

" sudo write
ca w!! w !sudo tee >/dev/null "%"

let @d="yypdwi  log.debug(('/(r'a, /:r)"

execute pathogen#infect()
highlight clear SignColumn



