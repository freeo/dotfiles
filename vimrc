"    ########################################################################
"  ##             /  .-',--.--. ,---.  ,---.  ,---. |  |,---.                ##
"  ##             |  `-,|  .--'| .-. :| .-. :| .-. |`-'(  .-'                ##
"  ##             |  .-'|  |   \   --.\   --.' '-' '   .-'  `)               ##
"  ##             `--'  `--'    `----' `----' `---'    `----'                ##
"  ##                                                                        ##
"  #########################  vim run commands file ###########################
"    ########################################################################
"
" Debugging mappings example
" :verbose map <c-j>
" ~/dotfiles/vimrc
"
" Plugin Ideas:
" better search:
" old syntax:
" /test/e+1
" new syntax:
" /test/el
" new options after /
" wbelge
" History of insertions! not yankring, but insertring!  Or even better: Repeat ring! '.' is repeat, <leader>. opens repeat ring, 
" lets you insert again your second insert or even older OR repeat previous
" actions instead of limiting to the last one!
"
" Intelligenteres marking up:
" F1 für *** === --- +++ switch 
" enter new buffer filetype txt
" emph und de-emph macros
" ä in der Suche fixen, ist ein <BS> statt nem ä.
"
" add to register
" let @v=""
" %s/MVP-\d*/\=setreg('V', [submatch(0),""])/n
" setreg('V', [submatch(0),"\n"])
 
" SMASH-Escape
imap jk <ESC>

let g:vimfiles = "~/.vim"
" let g:conemu = "C:\\Program Files\\ConEmu\\ConEmu64.exe /single -run"
let g:conemu = '"C:\Program Files\ConEmu\ConEmu64.exe" /single -run'

let $PATH .= ';C:/Program Files/Git/usr/bin'

set nocompatible
filetype off " required

" Last time it installed into bundle/vundle as well, two clones! issue?
" set runtimepath+=$HOME/.vim/bundle/Vundle.vim
" call vundle#rc('~/.vim/bundle')

call plug#begin('~/.vim/plugged')
 
Plug 'mhinz/vim-startify'
Plug 'mileszs/ack.vim'
Plug 'majutsushi/tagbar'
Plug 'rhysd/clever-f.vim'
Plug 'tomtom/tcomment_vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'luochen1990/rainbow'
Plug 'elzr/vim-json'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-markdown'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'matze/vim-move'
Plug 'justinmk/vim-sneak'
" Bundle 'https://github.com/xolox/vim-easytags'
" Bundle 'https://github.com/xolox/vim-misc'
" Bundle 'https://github.com/xolox/vim-shell'
" GNU R project
Plug 'jcfaria/Vim-R-plugin'
Plug 'kana/vim-vspec'
if has("win64")
  Plug 'vim-scripts/Windows-PowerShell-Syntax-Plugin'
endif
Plug 'paradigm/TextObjectify'
" Plug 'justinmk/TextObjectify
" Plug 'Shougo/unite.vim'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neoyank.vim'
if has("python3")
  Plug 'SirVer/ultisnips'
endif
Plug 'honza/vim-snippets'
Plug 'kchmck/vim-coffee-script'
Plug 'ervandew/supertab'
" Bundle 'https://github.com/lukaszkorecki/CoffeeTags'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'thinca/vim-ref'
Plug 'Chiel92/vim-autoformat'
" Has issues since WIN10 20161129
" Plug 'tomtom/quickfixsigns_vim'
Plug 'othree/html5.vim'
Plug 'gorkunov/smartpairs.vim'
Plug 'sukima/xmledit/'
Plug 'vim-scripts/restore_view.vim'
Plug 'rhysd/nyaovim-popup-tooltip'
Plug 'rhysd/nyaovim-markdown-preview'
Plug 'rhysd/nyaovim-mini-browser'
Plug 'AndrewRadev/sideways.vim'
Plug 'junegunn/vim-emoji'
" preserve from BundleClean deletion
" Plug 'Valloric/YouCompleteMe'
Plug 'ryanoasis/vim-devicons'
Plug 'jpalardy/vim-slime'
Plug 'statox/vim-compare-lines'
" Plug 'maralla/completor.vim' # vim 8 only
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'mattn/emmet-vim'
if has('nvim')
  " Plug 'Vigemus/iron.nvim', { 'branch': 'lua/replace' }
  " Plug 'wilywampa/vim-ipython' " vs iron.nvim
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'equalsraf/neovim-gui-shim'
  " If DIRVISH acts up or makes more trouble with autochdir, try defx.nvim
  " Plug 'Shougo/defx.nvim'
  Plug 'justinmk/vim-dirvish'
  Plug 'zchee/deoplete-jedi'
  Plug 'Shougo/deol.nvim'
  Plug 'Vigemus/iron.nvim'
  " luafile $HOME/.config/nvim/plugins.lua
else
  " Plug 'wilywampa/vim-ipython' " vs iron.nvim
  " netrw is broken in neovim, dirvish is a simple replacement with fewer functions
  Plug 'tpope/vim-vinegar'
  Plug 'roxma/nvim-yarp'
  if !has('mac')
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
endif
let g:deoplete#enable_at_startup = 1
Plug 'airblade/vim-gitgutter'
Plug 'ternjs/tern_for_vim'
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" Plug 'bfredl/nvim-ipy' " is this masking f5?
Plug 'cloudhead/neovim-fuzzy'
" neovim-fuzzyj uses
" https://github.com/jhawthorn/fzy
Plug 'christianrondeau/vim-base64'

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" https://github.com/Valloric/YouCompleteMe/wiki/Windows-Installation-Guide-for-Unix%E2%80%90like-Environments

" I forked this! Original repo is not maintained.
" Plug 'gorodinskiy/vim-coloresque.git'
Plug 'etdev/vim-hexcolor'
" Plug 'powerman/vim-plugin-AnsiEsc'  " used for nvimpager, but then I found out:
"   1. they don't share plugins
"   2. nvimpager bundles its own AnsiEsc using the old vim-scrips/AnsiEsc.vim package (which works fine)

" Own Plugins:
Plug 'freeo/vim-kalisi', { 'branch': 'dev-0.9'}
Plug 'freeo/vim-saveunnamed'
" Plug 'git@bitbucket.org:freeo/vimtext-projectsens.git'
" Plug 'hdima/python-syntax'
" until pull request is done
"https://github.com/hdima/python-syntax/pull/52
" Plug 'freeo/python-syntax'
Plug 'anntzer/python-syntax'

" Forked: pytest-2 and pytest-3 support
" Plug 'pytest-vim-compiler'
" Plug 'freeo/vim-makegreen'
" Plug 'freeo/vim-ipython' " not working with newer ipython version



" No remote repo, preserve from BundleClean deletion
" Plug 'python-syntax-master'
if !has("nvim")
  Plug 'plugin_colors'
else
  if !has("mac")
    let g:python3_host_prog = "C:/Python36/python.exe"
    let g:python_host_prog = "C:/Python27/python.exe"
  else
    " let g:python3_host_prog = "/usr/local/bin/python3"
    let g:python3_host_prog = "/Users/arthur.jaron/.pyenv/versions/neovim/bin/python"
    let g:python_host_prog = "/usr/local/bin/python"
  endif
endif
" outsourced kalisi colors, which belong to plugins

call plug#end()

" Problem Plugins:
" Closetag
" Github repos of the user 'vim-scripts'
" => can omit the username part
" Good idea, but incompatible... revisit sometime (today: 25.8.2014)
" Bundle 'https://github.com/caigithub/a_indent'
" Not Windows 7 ready:
" Bundle 'https://github.com/neilagabriel/vim-geeknote'

" non github repos
" Bundle 'git://git.wincent.com/command-t.git'
" ...

filetype plugin indent on     " required!

" ############################################################################
"
cnoremap s/ s/\v
nnoremap /  /\v


" Breaks TextObjectify behaviour!!!
" source $VIMRUNTIME/mswin.vim
" behave mswin

" TEMP XXX
" nnoremap <C-s> :w!<CR>
" nnoremap <C-s> :w!<CR>:color kalisi_dark<CR>

" autocmd BufWritePost ~/_vimrc :source ~/_vimrc | AirlineRefresh
" Temp Workaround
function! Workaround()
    execute "AirlineToggle"
    execute "AirlineToggle"
    execute "AirlineTheme ".g:airline_theme
endfunction

function! RefreshUI()
  if exists(':AirlineRefresh')
    AirlineRefresh
  else
    " Clear & redraw the screen, then redraw all statuslines.
    redraw!
    redrawstatus!
  endif
endfunction

" au BufWritePost .vimrc source $MYVIMRC | :call RefreshUI()

" autocmd BufWritePost ~/_vimrc :source ~/_vimrc | call Workaround()
" autocmd BufWritePost ~/_vimrc :source ~/_vimrc
" autocmd BufWritePost ~/_vimrc :source ~/_vimrc | call RefreshUI()


" disable, use deoplete-jedi with 
if has('nvim')
  let g:jedi#completions_enabled = 0
else
" OLD: Turn it off... it sucks without YCM
  let g:jedi#completions_enabled = 1
endif
" let g:jedi#auto_initialization = 1
" let g:jedi#use_tabs_not_buffers = 0 
" let g:jedi#force_py_version = 3 #deprecated?

let g:pypypath ='!C:/pypy-2.2.1-win32/pypy.exe'
exec("command! -nargs=1 Pypy ".g:pypypath." <args>")





" XXX
function! SeekAndDestroy(old, new)
  " Sounds fancier then SeekAndReplace
  " source: https://coderwall.com/p/7ol_ja
  " http://stackoverflow.com/questions/4792561/how-to-do-search-replace-with-ack-in-vim
  exe '!ack '.a:old.' -l --print0 | xargs -0 sed -i ''' 's/'.a:old.'/'.a:new.'/g'''
endfunction

set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set mousemodel=popup

"--- The following adds a sweet menu, press F4 to use it.
" source $VIMRUNTIME/menu.vim
set wildmenu
" set cpo-=<
set cpoptions=aABceFs
" set cpoptions=B
set wcm=<C-Z>

" set guioptions-=T " remove (T)oolbar from guioptions
" set guioptions-=m " and the (m)enu
" set guioptions-=e " remove guitabline, use non gui instead
" set guioptions=g
" set guioptions+=m
" set guioptions=
set guioptions=m
set shortmess+=I
set winaltkeys=no
set nocursorline
set wildmenu
set wildmode=list:longest,full
" Set 5 lines to the cursor - when moving vertically using j/k
set scrolloff=4 "abb: scrolloff
" For regular expressions turn magic on
set magic

" Remember info about open buffers on close, restore sessions 
set viminfo='1025,f1,%1024,h

" persistent-undo
" http://albertomiorin.com/
" set undodir=~/vimfiles/undo
" let &undodir=g:vimfiles.'/undo'
exec 'set undodir='.g:vimfiles.'/undo'
set undofile

" XXX
if has("directx")
  " set renderoptions=type:directx,gamma:1.0,contrast:0.2,level:1.0,geom:1,renmode:5,taamode:1
  set renderoptions=type:directx,gamma:1.0,contrast:0.1,level:1.0,geom:1,renmode:5,taamode:1
endif

" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Yankring OBSOLETE? XXX
" Support for yankring
set viminfo+=!
" if has("gui_running")
"   if has("gui_win32")
"     let g:yankring_history_dir="~/vimfiles/cache/"
"   elseif has("gui_gtk2")
"     let g:yankring_history_dir="~/.vim/cache/"
"   endif
" endif

"CtrlP
map <leader><Tab> :CtrlPBuffer<CR>
noremap <leader>` :CtrlPMRUFiles<CR>
" And default: <C-P> :CtrlP<CR>
"
" https://github.com/cloudhead/neovim-fuzzy
" disable until Santa is through
" nnoremap <C-p> :FuzzyOpen<CR>
"
" How to make this the default?
" Once inside the prompt:~
"   <c-d>
"     Toggle between full-path search and filename only search.
"     Note: in filename mode, the prompt's base is '>d>' instead of '>>>'
"
let g:ctrlp_show_hidden = 1

noremap <s-tab> :Startify<CR>

" User Interface
" --------------
" activate wildmenu, permanent ruler and disable Toolbar, and add line
" highlightng as well as numbers.
" And disable the sucking pydoc preview window for the omni completion
" also highlight current line and disable the blinking cursor.
set wildmenu
set ruler
"set guioptions-=T
"set completeopt-=preview
" set guicursor=a:blinkon0

" Statusbar and Linenumbers
" -------------------------
"  Make the command line two lines heigh and change the statusline display to
"  something that looks useful.
set cmdheight=1
"set laststatus=2
" set statusline=[%l,%c\ %P%M]\ %f\ %r%h%w

" Tab Settings
" set smarttab " XXX problems?
set tabstop=2
set shiftwidth=2
set softtabstop=2

" utf-8 default encoding
set encoding=utf-8
scriptencoding utf-8

" Better Search
" -------------
set hlsearch
set incsearch
set showmatch

" SATAN! set paste mach SMASH escape jk kaputt, wenn die Datei gesourced wurde!
" Warum???
set nopaste
" ist jetzt zwar für jeden Dateityp gesetzt, jedoch global besser....
set expandtab

set wrap linebreak nolist
" XXX new in 7.4.338, test thoroughly 

try
  set breakindent
  catch E518
endtry

" set textwidth=80
set textwidth=110
" set formatoptions=tcq
set formatoptions=cq
set showbreak=…

set ignorecase
set smartcase
"set commentstring = \ #\ %s
" set foldlevel=0
set clipboard+=unnamed " use clipboard for every yank and vice versa


" setglobal relativenumber "disables absolute numbers in ruler
set relativenumber "disables absolute numbers in ruler
" setglobal nonumber
set showmode
set showcmd
set hidden
set ttyfast
" XXX
set lazyredraw

set showtabline=1

if !has('mac')
  if !has('nvim')
    set cryptmethod=blowfish2
    " set pythonthreedll=python34.dll
    set pythonthreedll=python36.dll
  else
    set termguicolors
  endif
endif

" if has('mac') && !has('gui_running')
if has('mac')
  set termguicolors
  hi Cursor guifg=#ffffff guibg=#ff0000
  hi Cursor2 guifg=#ffffff guibg=#ff0000
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
                  \,a:blinkon0-Cursor/lCursor
                  \,sm:block-blinkwait175-blinkoff150-blinkon175

else
  set guicursor=a:blinkon0
endif

set spelllang=de_20,en

try
    language messages en
    language English_United States
    language messages en_US.UTF-8
    language en_US.UTF-8
catch /E197\|E319/
    " E197 wrong locale error
    " E319 nvim doesn't have this feature
endtry

set list
set listchars=tab:›\ ,trail:\ ,extends:…
" set listchars=tab:›…,trail:░,extends:
"░▒▓
set completefunc=emoji#complete
" https://vimways.org/2018/the-power-of-diff/
" set diffopt+=algorithm:internal " Default
" set diffopt+=algorithm:patience
set diffopt+=algorithm:histogram

" XXX autochdir doesn't work with dirvish, low prio, but it will come
" Python execution needs autochdir at numerous points
" set autochdir

"## REMAPPINGS ##########################################################

" specialkey TODO
" Delete in insert more
  " was already defined somewhere, but gave the idea for 
  " C-H; C-L delete
inoremap  <BS>
inoremap  <DEL>

" let isfname=@,48-57,/,\,.,-,_,+,,,#,$,%,{,},[,],:,@-@,!,~,=
" dirvish: invalid directory: 'C:/Users/arthur.jaron/OneDrive - Accenture/sherlock'




" Leader
" ------
" sets leader to ',' and localleader to "\"
" let mapleader=","
nnoremap <Space> <nop>
map <Space> \
let g:mapleader="\\"
" let  maplocalleader="\\"

" Re-select visal block after indenting
" http://vimrcfu.com/snippet/14
vnoremap < <gv
vnoremap > >gv


" Search
" 2 two command on one mapping
" nur noh
nnoremap <leader>/ :noh<CR>
nnoremap <ESC> :noh<CR>

" beide ausführen:
"nnoremap <leader>/ :noh<CR> :call Deactivate_Highlights()<CR>
"

" Highlight doublespaced keywords
" nnoremap <leader>hk /   [a-zA-ZäÄüÜöÖß.,;:()?!]\+   \
" nnoremap <leader>hk :call Toggle_HLite_Keywords()\
" nnoremap <leader>h :call Toggle_HLite_Keywords()\\
" TODO: Inspect why do I need this?
" nnoremap <leader>h :call Toggle_HLite_Keywords()<CR>

" Restore map increment number c-a ctrl-a
" nunmap <C-a>

" excluded leading whitespace
" 2 whitespaces make a special manual keyword
" http://superuser.com/questions/505727/is-there-a-pattern-like-in-vim
let g:keyword_bool = 0 

function! Toggle_HLite_Keywords()
  syn match spckeyword "\(^\s*\)\@<!  [a-zA-ZäÄüÜöÖß\-.,;()?!]\+" containedin=ALL
  if g:keyword_bool == 0 
    hi link spckeyword Type " Statement
    let g:keyword_bool = 1 
    echo "Highlight Keywords ON"
    " hi spckeyword  guifg=#94be54
  elseif g:keyword_bool == 1
    hi link spckeyword NONE
    let g:keyword_bool = 0
    echo "Highlight Keywords OFF"
  endif
endfunction


" too slow
" autocmd BufEnter * call Highlight_Keywords_BufEnter()

" function Highlight_Keywords_BufEnter()
"   " if exists("g:keyword_bool"):
"     if g:keyword_bool == 1 
"       " if !(syn list spckeyword)
"         " !exists("syn spckeyword")
"         " syn match spckeyword "\(^\s*\)\@<!  [a-zA-ZäÄüÜöÖß\-.,;()?!]\+" containedin=ALL
"         " endif
"       hi link spckeyword  Type " Statement
"     endif
" endfunction
" 

    " elseif g:keyword_bool == 0
    "   hi link spckeyword NONE

function! ReColor()
  hi CursorLineNr guifg=#bbbbbb guibg=#b02222 gui=bold
  hi Cursor guibg=#d80000 guifg=#ffffff 
  " hi MatchParen  guifg=#000000 guibg=#771111 gui=bold
  hi MatchParen  guifg=#444444 gui=bold ctermbg=1 guibg=#775555
endfunction

map <F11> :call ReColor()<CR>

" make spaces around word with surround, so they get highlighted
" two literal spaces at the end
"nmap <leader>kw ysaW  
" make single space Keyword binding and jump to end of the WORD
nmap <leader>h hEBi <Esc>E

function! SetWDToCurrentFile()
  " exe "!cd %:p:h" " doesn't work for python
  exe "cd %:h"
  exe "pwd"
endfunction

" change working directory to current files path
nnoremap <leader>cd :silent! call SetWDToCurrentFile()<bar>:pwd<CR>

" if has('nvim')
"   " avoid "press ENTER..."
"   nnoremap <leader>cd :call jobstart("cd %:p:h")<bar>:pwd<CR>
" endif

"Reselect pasted text, windows style pasting
"best for indentation
" nnoremap <leader>v V`]

nnoremap <leader>r :RainbowToggle<CR>
nnoremap <leader>a :Ack <C-r><C-w>

let g:ackprg = "ag"

"Marks
nnoremap <leader>m :marks<CR>

"faster scrolling with these shortcuts
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" nnoremap <C-j> <C-e>j
" nnoremap <C-k> <C-y>k

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
nmap Y y$
" OBSOLETE, yankring threwn out:
" for YANKRING to work LIKE the previous mapping:
" the usual way doesn't work with yankring!!!!
function! YRRunAfterMaps()
   nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

"EPIC INSERT AND COMMAND ESCAPE REMAP
" Press Shift-Space (may not work on your system).
" imap <S-Space> <Esc>
" vmap <S-Space> <Esc>
" nmap <S-Space> <Esc>
" cmap <S-Space> <Esc>

" im ap <S-Space> call exitInsert()
" nnoremap <S-Space> i
" nnoremap <S-Space> a


" Cripples visual mode totally! First select using j, oh too many lines...
" press k. What? Visual mode gone? Why???
" Having j bound also goes into operator pending mode: delay!
" vmap jk <ESC> " Don't ever use!

function! ExitInsert()
<Esc>
endfunction
" allow the . to execute once for each line of a visual selection
" EXAMPLE: // for commenting
vnoremap . :normal .<CR>

"CTRL K hightlights current word containing the cursor
"nnoremap <C-K> :call HighlightNearCursor()<CR>
function! HighlightNearCursor()
  if !exists("s:highlightcursor")
    match Todo /\k*\%#\k*/
    let s:highlightcursor=1
  else
    match None
    unlet s:highlightcursor
  endif
endfunction


autocmd FileType htmldjango inoremap {% {% %}<left><left><left>
autocmd FileType htmldjango inoremap {{ {{ }}<left><left><left>

" PYDICTION SETTINGS
" 'C:/vim/vimfiles/ftplugin/pydiction/complete-dict'
" let g:pydiction_location = 'C:/Program Files/Vim/vim73/ftplugin/pydiction/complete-dict'
" let g:pydiction_menu_height = 20

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Treat long lines as break lines (useful when moving around in them)
" http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
" nnoremap <expr> j v:count ? 'j' : 'gj'
" nnoremap <expr> k v:count ? 'k' : 'gk'
 
" Origins of the line, 
" Supplying a count to a map
" and help v:count
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_2)
" nnoremap <silent> j :<C-U>call Down(v:count)<CR>
" vnoremap <silent> j gj
"
" nnoremap <silent> k :<C-U>call Up(v:count)<CR>
" vnoremap <silent> k gk

function! Down(vcount)
  if a:vcount == 0
    exe "normal! gj"
  else
    exe "normal! ". a:vcount ."j"
  endif
endfunction

function! Up(vcount)
  if a:vcount == 0
    exe "normal! gk"
  else
    exe "normal! ". a:vcount ."k"
  endif
endfunction

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


"Folding
"
" set foldmethod=manual
"set foldmethod=indent

"use indent to create folds on file load, then set fold method to manual.
" tested, this sucks
" augroup vimrc
"   au BufReadPre * setlocal foldmethod=indent
"   au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
" 
" augroup END

" Folding visual selection with SPACE, or toggling inside a fold
" nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" vnoremap <Space> zf

" automatic Folding files, so folds won't get lost
set viewdir=~/.vim/view/
" let &viewdir= g:vimfiles ."/view/"

" set viewoptions=folds
" Restoring cursor is badly implemented in views. Restorting the cursors last
" position is realized with another method, 
" autocmd BufWinLeave *.* silent mkview
" autocmd BufWinEnter *.* silent loadview

" Works fine, but replaced by restore_view.vim plugin
" autocmd BufWinLeave ?* silent mkview
" autocmd BufWinEnter ?* silent loadview

" recommended by restore_vim.vim
" set viewoptions=cursor,folds,slash,unix
" set viewoptions=folds,slash,unix " removed cursor due to bad implementation
set viewoptions=slash,unix " removed cursor due to bad implementation

" FOLDTEXT
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  " return v:folddashes . sub
  return v:foldend - v:foldstart +1 .": " . sub
endfunction

nnoremap <leader><space> za


" Return to last edit cursor position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Buffers
" Close the current buffer
map <leader>q :Bclose<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" switched to vim-move, works for visual mode, not like these vmaps
" Move a line of text using ALT+[jk]
" nmap <M-j> mz:m+<cr>`z
" nmap <M-k> mz:m-2<cr>`z
" vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z "
" vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
" autocmd BufWrite *.py :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Vimgreps in the current file
map <leader><v> :vimgrep // %<left><left><left>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Visuals
" =====================





if has("gui_running")
  set go-=TlLrR
  set lines=55
  set columns=115
  " winpos 1132 0
  if has("gui_gtk2")
    set guifont=Liberation\ Mono\ for\ Powerline\ 9,
                \Liberation\ Mono\ 9,
  elseif has("gui_win32")
    set guifont=
\Cousine_Nerd_Font_Mono:h12:cANSI:qDRAFT,
" \Cousine_NF:h10:cANSI:qDRAFT,
\BitstreamVeraSansMono_NF:h10:cANSI:qDRAFT,
\LiterationMonoPowerline_NF:h13,
\Literation_Mono_Powerline:h10,
\Literation_Mono_for_Powerline:h10,
\Liberation_Mono_Powerline:h10,
\Liberation_Mono_for_Powerline:h10,
\DejaVuSansMono_NF:h10:cANSI:qDRAFT,
\DejaVu_Sans_Mono_for_Powerline:h11,
\DejaVu_Sans_Mono:h10,
\Liberation_Mono:h9,
\Consolas:h10,
\Lucida_Console:h10
  " endif
  elseif has("gui_macvim")
    set guifont=
\Cousine_Nerd_Font_Mono:h18,
\Roboto_Mono:h18
  endif
else
  if &term == "win32"
    let g:airline_powerline_fonts=1
    " let g:airline_left_sep=''
    " let g:airline_right_sep=''
    set visualbell
    " ConEmu only! Doesn't work with vanilla powershell.exe
    if $is_powershell 
        " cursor not working, unreliable, slow
        " $is_powershell is an ENV variable set in the powershell $profile
        " set term=xterm
        " set t_Co=256
        " let &t_AB="\e[48;5;%dm"
        " let &t_AF="\e[38;5;%dm"
    else
        colorscheme default
        let g:airline_theme=''
    endif

  " MinTTY mode-dependent cursor
  elseif &term == "xterm-256color"
    let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_te.="\e[0 q"
  endif
endif

syntax enable " Syntax Colors
set background=light
" set background=dark
colorscheme kalisi
set synmaxcol=200
let g:airline_theme='kalisi'
"
" if !has("nvim")
let g:airline_powerline_fonts = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
" else
  let g:airline_powerline_fonts = 1
" endif

  " probook 430g
  " let g:airline_left_sep=''
  " let g:airline_right_sep=''

  " not in user
  " let g:airline_left_sep=''
  " let g:airline_right_sep=''
  " let g:airline_left_sep=''
  " let g:airline_right_sep=''
  " let g:airline_left_sep=''
  " let g:airline_left_sep=''
  " let g:airline_right_sep=''
  " let g:airline_left_sep=''
  " let g:airline_right_sep=''
  " let g:airline_right_sep=''
  " let g:airline_left_sep=''
  " let g:airline_right_sep=''
  " let g:airline_powerline_fonts = 1 WIN10
"                                   



function! Reload256Kalisi()
  source $HOME/.vim/bundle/vim-kalisi/colors/kalisi.vim
  colorscheme kalisi
  syn include syntax/css/vim-coloresque.vim
  " call g:VimCssInit()
endfunction

command! RK call Reload256Kalisi()

" map <F2> :update<CR><bar>:call Reload256Kalisi()<CR> 
" map <F2> :call Reload256Kalisi()<CR> 
set backup
exec 'set backupdir='.g:vimfiles.'/backup'
exec 'set dir='.g:vimfiles.'/swap'


" Default Working Directory, not Win/System32
try
  cd E:/WorkDir/
  catch E344
  " XXX else?
endtry

" Highlight NBSP
" --------------
"  wanna see them, but it is annoying most of the time
function! HighlightNonBreakingSpace()
  syn match suckingNonBreakingSpace "\s\+\n" containedin=ALL
  hi suckingNonBreakingSpace guibg=#121277
endfunction
" autocmd BufEnter * :call HighlightNonBreakingSpace()

" Placeholders
" --------------
function! JumpToNextPlaceholder()
  let old_query = getreg('/')
  echo search("<++>")
  exec "norm! c/+>/e\<CR>"
  call setreg('/', old_query)
endfunction

nnoremap <M-p> :call JumpToNextPlaceholder()<CR>a
inoremap <M-p> <ESC>:call JumpToNextPlaceholder()<CR>a

" Insert Placeholder

function! HighlightPlaceholder()
  hi PlaceholderColor guifg=#ff0000 guibg=#FFc800 gui=bold
  syn match Placeholder "<++>" containedin=ALL
  hi def link Placeholder PlaceholderColor
endfunction

inoremap <C-p> <++><ESC>:call HighlightPlaceholder()<CR>a

" Tab page settings
" -----------------
function! GuiTabLabel()
  let label = ''
  let buflist = tabpagebuflist(v:lnum)
  if exists('t:title')
    let label .= t:title . ' '
  endif
  let label .= '[' . bufname(buflist[tabpagewinnr(v:lnum) - 1]) . ']'
  for bufnr in buflist
    if getbufvar(bufnr, '&modified')
      let label .= '+'
      break
    endif
  endfor
  return label
endfunction
set guitablabel=%{GuiTabLabel()}




" template language support (SGML / XML too)
" ------------------------------------------
"  and disable taht stupid html rendering (like making stuff bold etc)

function! s:SelectHTML()
  let n = 1
  while n < 50 && n < line("$")
    " check for django
    if getline(n) =~ '{%\s*\(extends\|block\|comment\|ssi\|if\|for\|blocktrans\)\>'
      set ft=htmldjango
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun


autocmd BufNewFile,BufRead *.s setlocal ft=asm
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
" autocmd BufNewFile,BufRead *.md setlocal ft=markdown
" autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()
let html_no_rendering=1

let g:closetag_default_xml=1
let g:closetag_html_style=1
autocmd FileType html,htmldjango,htmljinja,eruby,mako let b:closetag_html_style=1

"make <> matching parenthesis for %
set mps+=<:>



function! CompileJava()
  " F9 to compile Java 
  let b:compile_status = system('javac '.expand("%:p"))
  echom b:compile_status
  if b:compile_status == ''
    let b:classpath = expand("%:p:h")
    let b:classname = strpart(expand("%"), 0,strlen(expand("%"))-5)
    echom b:classpath
    echom b:classname
    exe '!java -classpath '.b:classpath.' '.b:classname
  endif
endfunction

" autocmd FileType txt setlocal tabstop=2 softtabstop=2 shiftwidth=2
" autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
" C#

" autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
let javascript_enable_domhtmlcss=1

autocmd FileType tsv setlocal noexpandtab tabstop=20 softtabstop=20 shiftwidth=20

" C, make
" autocmd FileType makefile setlocal 


"CSV Data autodetection

" autocmd BufRead,BufNewFile *.csv setfiletype csv


" AUTOSAVE 
"---------
"autmatic saving after buffer change, on loosing focus
" autocmd FocusLost * :wa
set nohidden 
" hidden = 1 disables autowrite!!! Annoying to find...
set autoread
set autowrite
set autowriteall


" nnoremap <C-TAB> :call Autosave()<CR><bar>:bn<CR>
" nnoremap <C-S-TAB> :call Autosave()<CR><bar>:bp<CR>
" for gui (doesn't work in iTerm2)
" nnoremap <C-TAB> :bn<CR>
" nnoremap <C-S-TAB> :bp<CR>
" for terminal, but maybe my new default
" <M-l>
" nnoremap ¬ :bn<CR>
" <M-h>
" nnoremap ˙ :bp<CR>

" nnoremap <M-h> :bn<CR>
" nnoremap <M-l> :bp<CR>

" move.txt
" To enable custom key maps you must disable the automatic key maps with >
let g:move_map_keys = 0

nmap <A-j> <Plug>MoveLineDown
nmap <A-k> <Plug>MoveLineUp
vmap <A-j> <Plug>MoveBlockDown
vmap <A-k> <Plug>MoveBlockUp
vmap <A-h> <Plug>MoveBlockLeft
vmap <A-l> <Plug>MoveBlockRight

" nnoremap <A-a> :bp<cr>
" nnoremap <A-s> :bn<cr>

nnoremap <A-h> :bp<cr>
nnoremap <A-l> :bn<cr>


" nnoremap <ESC>h :bn<CR>
" nnoremap <ESC>l :bp<CR>

" nnoremap <C-TAB> :exec "call Autosave()"<bar>:bn<CR>
" nnoremap <C-S-TAB> :exec "call Autosave()"<bar>:bp<CR>


" WITHOUT AUTOSAVE
" nnoremap <C-TAB> :bn<CR>
" nnoremap <C-S-TAB> :bp<CR>
" MinTTY sequences, switching windows has to be disabled
" if !has("mac")
nnoremap [1;5I :bn<CR>
nnoremap [1;6I :bp<CR>
" endif

" nnoremap <a-h> :SidewaysLeft<cr>
" nnoremap <a-l> :SidewaysRight<cr>

" File Browser
" ------------
" hide some files and remove stupid help
let g:explHideFiles='^\.,.*\.sw[po]$,.*\.pyc$'
let g:explDetailedHelp=0
map <C-B> :Explore!<CR>

" http://emanuelduss.ch/2011/04/meine-konfigurationsdatei-fur-vim-vimrc/
"
" map <F2> i############################################################################<ESC>:TComment<CR>

inoremap <F2> ♥<ESC>:call CommentLineTilEOL()<CR>
inoremap <S-F2> ♥<ESC>:call CommentLineTilEOL("replace")<CR>

function! CommentLineTilEOL(...)
  " java not working, TComment ignores all Whitespace (indentations)
  " TComment constant: Commenting out usually requires 1-2 chars
  " let l:minus1 = ['python', 'vim', 'txt']
  let l:minus2 = ['cpp', 'javascript', 'html', 'java']

  if index(l:minus2, &ft) > -1
    let l:tcomment_constant = 6
  else 
    let l:tcomment_constant = 2
  endif

  let l:charamount = 80 - virtcol('.') - l:tcomment_constant
  exec "normal! ".l:charamount."a#"
  TComment

  exec "normal 0f♥x"
  if a:0 > 0
    startreplace
  else
    startinsert!
  endif
endfunction

call tcomment#type#Define('text', '// %s')
call tcomment#type#Define('quakecfg', '// %s')
call tcomment#type#Define('c', '// %s')

" nmap <leader>t gcc
vmap <leader>t gc
nmap <C-t> gcc
vmap <C-t> gc
nmap <C-Space> gcc
vmap <C-Space> gc
nmap <C-@> gcc
vmap <C-@> gcc


" --------------------------------
" Powershell
command! PS silent exec '!start '.g:conemu.' /dir '.shellescape(expand("%:p:h")).' /cmd powershell'
" Explorer
" qt_newtab
" EXPLORER INTEGRATION with -
" WIN10 Migr issue
" Does 'where' find something?
" if qt_newtab isn't found, v:shell_error = 1
" (v:shell_error is builtin, which contains the status of the last external
" call, ! read or system)
"
if has("win32")
  let temp = system("where qt_newtab.exe")
  if v:shell_error
    echom "qt_newtab.exe not in $path"
  endif
  " this specific shortcut needs to be places  after the tcomment bindings!
  " command! EX silent! !start qt_newtab.exe %:p:h
  command! EX !start qt_newtab.exe %:p:h
  nnoremap <M-_> :EX<CR>
endif
" all silent tries are not working, because the C# app is generating the window, vim can't get past that. I
" need to compile a silent version of qt_newtab.exe

" map <F3> :call SwitchMinimize()<CR>
"
" let minimize = 0
" function! SwitchMinimize()
"     if g:minimize == 0
"         exe "set lines=5"
"         exe "normal zz"
"         let g:minimize = 1
"     else
"         exe "set lines=60"
"         exe "normal zz"
"         let g:minimize = 0
"     endif
" endfunction

" dual window switch(by freeo)
" map <F4> <C-W>v :winpos 250 0<CR> :set columns=180<CR> <C-W>=
let window_mode = 1

"keep left
map <F6> :call DualwindowSwitch(0)<CR>
"keep right
" map <F4> :call DualwindowSwitch(1)<CR>
" map <F4> :call HalveHorizontally()<CR>


" single = 1
function! DualwindowSwitch(right)
    if g:window_mode == 0
      if a:right == 1
        exe "normal \<C-W>h"
      else
        exe "normal \<C-W>l"
      endif
      exe "normal \<C-W>q"
      exe "winpos 1132 0"
      " exe "set columns=85"
      exe "set columns=115"
      exe "normal \<C-W>="
      let g:window_mode = 1
      echo "LEFT"
    elseif g:window_mode == 1
        exe "winpos 0 0"
        exe "set columns=115"
        exe "normal \<C-W>="
        let g:window_mode = 2
        echo "RIGHT"
    elseif g:window_mode == 2
        exe "normal \<C-W>v"
        " exe "winpos 0 0"
        exe "winpos 339 0"
        exe "set columns=242"
        " exe "set columns=212" " for 80
        exe "set columns=199"
        " exe "set columns=169" " for 80 textwidth
        exe "normal \<C-W>="
        let g:window_mode = 0
        echo "FULLSCREEN"
    endif
endfunction

function! HalveHorizontally()
  if &lines > 25 
    set lines=25
    set scrolloff=2 
    " set guifont=Liberation_Mono_for_Powerline:h9,
    "             \Liberation_Mono:h9,
    "             \Liberation\ Mono\ for\ Powerline\ 9,
    "             \Liberation\ Mono\ 9
  else
    set lines=55
    set scrolloff=4 
    " set guifont=Liberation_Mono_for_Powerline:h10,
    "             \Liberation_Mono:h10,
    "             \Liberation\ Mono\ for\ Powerline\ 10,
    "             \Liberation\ Mono\ 10
  endif
endfunction



" ## Dark Room Mode F11 ##################################################
" map <F11> :call DarkRoom()<cr>
" let DarkRoom_active = 0 " Default Off

function! DarkRoom()
  if !exists("g:DarkRoom_active")
    call DarkRoom_activate()
  else
    if g:DarkRoom_active
      call DarkRoom_deactivate()
    else
      call DarkRoom_activate()
    endif
  endif
  echo g:DarkRoom_active
endfunction

function! DarkRoom_activate()
  let g:DarkRoom_active = 1
  call libcallnr("vimtweak.dll", "SetAlpha", 220)
  " call libcallnr("vimtweak.dll", "EnableCaption", 0)
  set guioptions-=m
  winpos 630 -33
  set lines=100 columns=90
  winpos 630 -33
  set gcr=a:blinkon0
endfunction

function! DarkRoom_deactivate()
  let g:DarkRoom_active = 0
  call libcallnr("vimtweak.dll", "SetAlpha", 255)
  " call libcallnr("vimtweak.dll", "EnableCaption", 1)
  set guioptions+=m
  set lines=60 columns=105
  winpos 960 0
endfunction
" #######################################################################

" runtime! macros/matchit.vim
source $VIMRUNTIME/macros/matchit.vim
let b:match_words = &matchpairs

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
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



" AUTOSAVE ANTI MECHANISM
" Stop myself from pressing C-s all time!
" Configured persistent undo and autowrite. I hope to never rely on CTRL-S
" anymore in Vim and want to enforce this behaviour.

" nmap <C-s> :NyanMe<CR>

" # STARTIFY #################################################################



let g:startify_bookmarks = ['~/dotfiles/vimrc','C:/Users/arthur.jaron/Documents/viki','E:/GDrive/vocabulary.txt',g:vimfiles.'/plugged/vimtext-projectsens/syntax/text.vim', g:vimfiles.'/temp.txt', g:vimfiles.'/leftoff.txt', g:vimfiles.'/gemvs.txt']
" let g:startify_bookmarks = ['~/_vimrc','~/vimfiles/temp.txt','E:/dropbox/Master_Thesis/logs' ]
" let g:startify_session_autoload = 1
" let g:startify_session_persistence = 1
" let g:startify_list_order = ['files', 'bookmarks', 'sessions', 'dir']
let g:startify_list_order = ['files', 'bookmarks', 'sessions']

let g:startify_files_number = 14

let g:startify_header_begin = [
      \ ' __   ___ _ __ ___       ',
      \ ' \ \ / ( ) ,_ ` , \      ',
      \ '  \ V /| | | | | | |     ',
      \ '   \_/ |_|_| |_| |_|     ',
      \ '                         ']

" works: " read !awk "NR==1, NR==10" C:/Users/Ich/vimfiles/leftoff.txt
" split(execute 'read !awk "NR==1, NR==10" C:/Users/Ich/vimfiles/leftoff.txt', "\r")
" let g:startify_header_dynamic = split(system('awk "NR==1, NR==6" '.g:vimfiles.'/leftoff.txt'), '\n')
" let g:startify_header_dynamic = split(system('awk "NR==1, NR==6" %userprofile%/vimfiles/leftoff.txt'), '\n')
" let g:startify_header_dynamic =g:startify_header_begin + split(system('awk "NR==1, NR==6" %userprofile%/vimfiles/leftoff.txt'), '\n')

" let g:startify_header_end = [
      \ '                                                     ']

" let g:startify_custom_header = g:startify_header_begin + g:startify_header_dynamic + g:startify_header_end

" let g:startify_custom_header = ["hi freeo!"]

function! MakeHeaderStart()
  redir => version_output
    silent version
  redir end
  let myvimversion=split(version_output,"\n")
  " let result = [myvimversion[0], myvimversion[2]]
  let result = [myvimversion[2],]
  " let result = substitute(myvimversion[0],"\(IMproved \d.\d\) \(.\+compiled\)\(.\+\)", "submatch(0)", "")
  " .myvimversion[2]
  return result
endfunction

" let g:startify_header_start = MakeHeaderStart()
" let g:startify_custom_header = [g:startify_header_start] + g:startify_header_dynamic
" let g:startify_custom_header = MakeHeaderStart() + g:startify_header_dynamic
let g:startify_custom_header = MakeHeaderStart()


" vim-sneak
nmap <C-f> <Plug>SneakForward
nmap <C-g> <Plug>SneakBackward


" insert single Character. gi and ga are already taken
" so i use "s" for "single"
"http://vim.wikia.com/wiki/Insert_a_single_character
nnoremap s :exec "normal i".nr2char(getchar())."\e"<CR>
" I NEVER use this: 
" nnoremap S :exec "normal a".nr2char(getchar())."\e"<CR>
" Better use: Insert newline below
nnoremap S m`o<esc>``

nmap ü [
nmap Ü {
" nmap ä ' " interferes with nnoremap ä ,
nmap ä ,
nmap Ä "
nmap ö ;
nmap Ö :
nmap gö g;

vnoremap ä ,
vnoremap Ä "
vnoremap ö ;
vnoremap Ö :
vnoremap ü [
vnoremap Ü {

cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
" cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
" interferes with cmap ESC, ugly 1 sec delay... don't need that anyway
" cnoremap <Esc>b <S-Left>
" cnoremap <Esc>f <S-Right>
" cnoremap <Esc>d <S-right><Delete>
" cnoremap <C-g>  <C-c>

" Windows style: delete word backwards
inoremap <C-BS> <C-W>

" Change the color scheme from a list of color scheme names.
" Version 2010-09-12 from http://vim.wikia.com/wiki/VimTip341
" replaced:
"
nnoremap <F8> :call Next_scheme()<CR>

let current_scheme = 0
" let schemes = [ "bgum2", "kalisi"]
let schemes = [ "neovim", "kalisi"]

function! Next_scheme()
  if len(g:schemes) > g:current_scheme+1
    let g:current_scheme += 1
  else
    let g:current_scheme = 0
  endif
  execute 'color '.g:schemes[g:current_scheme]
  redraw
  " echo g:schemes[g:current_scheme]
  " call airline#reload_highlight()
endfunction

" if has("gui_running")
    " let g:airline_powerline_fonts = 1
    " let g:airline_theme='kalisi'
    " let g:airline_theme='powerlineish'
    " let g:airline_theme='sol'
    " let g:airline_theme='luna'
" endif

let g:airline_detect_paste=1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#branch#enabled = 1 " fugitive integration
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 0
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 0
" let g:airline#extensions#tabline#buffer_nr_format = '%s►'

" let g:airline_section_b = "%{branch()}%"
" let g:airline_section_y       (fileencoding, fileformat)
" let g:airline_section_y       (fileencoding, fileformat)
" let g:airline_section_warning (syntastic, whitespace)

set numberwidth=3

" Quickfixsigns
"  ORG
" let g:quickfixsigns#vcsdiff#vcs {'git': {'cmd': 'git diff --no-ext-diff -U0 %s', 'dir': '.git'}, 'bzr': {'cmd': 'bzr diff --diff-options=-U0 %s', 'dir': '.bzr'}, 'svn': {'cmd': 'svn diff --diff-cmd diff --extensions -U0 %s', 'dir': '.svn'}, 'hg': {'cmd': 'hg diff -U0 %s', 'dir': '.hg'}}

" Working 
let g:quickfixsigns#vcsdiff#vcs={'git': {'cmd': 'git diff --no-ext-diff -U0 HEAD~ %s', 'dir': '.git'}, 'bzr': {'cmd': 'bzr diff --diff-options=-U0 %s', 'dir': '.bzr'}, 'svn': {'cmd': 'svn diff --diff-cmd diff --extensions -U0 %s', 'dir': '.svn'}, 'hg': {'cmd': 'hg diff -U0 %s', 'dir': '.hg'}}

" Colors
" let g:quickfixsigns#vcsdiff#highlight = {'DEL': 'QuickFixSignsDiffDelete', 'ADD': 'QuickFixSignsDiffAdd', 'CHANGE': 'QuickFixSignsDiffChange'}


inoremap <A-a> \textcite{}<++><left><left><left><left><left>

" Format selected text, remove double spaces, join, remove highlights
" flag e: ignores errors in subst commands
vnoremap <leader>J :j<CR>gv:s/\(\S\)-\s/\1/ge<CR>gv :s/\s\{2,}/ /ge<CR>:noh<CR>

" XXX: open neovim issue?
" Get visual selection
" http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
" Author: Xolox

function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction


" Google
"----------------------
function! OpenUrlUnderCursor()
    let program="chrome"
    let google="chrome google.de/search?q="
    " let program="firefox -new-tab"
    " let google="firefox -new-tab google.de/search?q="
    execute "normal! hEBvEy"
    " let url=matchstr(@0, '[a-z]*:\/\/[^ >,;]*')
    let url=matchstr(@0, '\(http\|https\|ftp\)\(\w\|[\-&=,?\:\.\/]\)*') " verdammtes # funktioniert nicht
    if url != ""
        silent exec "!".program." \"".url."\"" | redraw! 
        echo "opened ".url
    else
        " echo "".@0." === FAILED "
        silent exec "!".google.@0 | redraw! 
        echo "googled ".@0
    endif
endfunction

" google visual selection

function! GoogleVisualSelection()
    let term=s:get_visual_selection()
    " let google="firefox -new-tab \"google.de/search?q="
    let google="chrome \"google.de/search?q="
    silent exec "!".google.term."\"" | redraw! 
endfunction

function! LookupDictLeo(visual)
    if a:visual
        let term=s:get_visual_selection()
    else
        execute "normal! yiw"
        let term=@0
        echom term
    endif
    let browse="chrome \"dict.leo.org/?lp=ende&search=".term
    silent exec "!".browse."\"" | redraw! 
endfunction

nmap <leader>g :call OpenUrlUnderCursor()<CR>
vmap <leader>g :call GoogleVisualSelection()<CR>
nmap <leader>l :call LookupDictLeo(0)<CR>
vmap <leader>l :call LookupDictLeo(1)<CR>


autocmd InsertEnter * :setlocal nohlsearch
autocmd InsertLeave * :setlocal hlsearch

" http://vim.1045645.n5.nabble.com/au-InsertEnter-noh-doesn-t-work-td5606959.html 

function! BreakSentences(...)
  '[,']s/B\@<!\.\s/\.\r/ge
  " '[,']s/\([^B]\)\.\s/\1\.\r/ge
endfunction

" nnoremap <leader>b :set operatorfunc=BreakSentences<CR>g@

nmap <leader>s :%s//gc<left><left><left>
vmap <leader>s :s//gc<left><left><left>

" call manually in a diffthis window
" echo DiffCount()
function! DiffCount()
    if !exists("g:diff_hunks") 
        call UpdateDiffHunks()
    endif
    let n_hunks = 0
    let curline = line(".")
    for hunkline in g:diff_hunks
        if curline < hunkline
            break
        endif
        let n_hunks += 1
    endfor
    return n_hunks . '/' . len(g:diff_hunks)
endfunction

function! UpdateDiffHunks()
    setlocal nocursorbind
    setlocal noscrollbind
    let winview = winsaveview() 
    let pos = getpos(".")
    sil exe 'normal! gg'
    let moved = 1
    let hunks = []
    while moved
        let startl = line(".")
        keepjumps sil exe 'normal! ]c'
        let moved = line(".") - startl
        if moved
            call add(hunks,line("."))
        endif
    endwhile
    call winrestview(winview)
    call setpos(".",pos)
    setlocal cursorbind
    setlocal scrollbind
    let g:diff_hunks = hunks
endfunction

" Swap Words Left and Right
" Replaced by Plugin: sideways
" https://github.com/AndrewRadev/sideways.vim
" XXX deactivated for now in favor of buffer switching bn and bp
" nnoremap <a-h> :SidewaysLeft<cr>
" nnoremap <a-l> :SidewaysRight<cr>
" http://vim.wikia.com/wiki/Swapping_characters,_words_and_lines
" LEFT
" nnoremap <silent> <A-h> "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:noh<CR>
" RIGHT
" nnoremap <silent> <A-l> "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:noh<CR>


" ctags integration
" set tags=./tags;~/vimfiles/tags/
let &tags='./tags;'.g:vimfiles.'/tags/'
set iskeyword=@,48-57,_,128-167,224-235,-
" Excluded . (dot), because it will jump over 'word', making it a 'WORD'
" Otherwise ctags would be broken, because it only searches for a 'word'

" default: 40
let g:tagbar_width = 35
setglobal updatetime=4000


" xolox/Easytags
" -----------------------
let g:easytags_python_enabled = 1
" let g:easytags_resolve_links = 1
" let g:easytags_dynamic_files = 2
" just in case. It will speed up easytags, if the global file ever reaches a
" critical size. Should be categorically ruled out, but will remind of the
" _vimtags file being functional!
let g:easytags_by_filetype = g:vimfiles.'/tags/'
" let g:easytags_events = ['BufWritePost']
let g:easytags_file = g:vimfiles.'/tags/global'
let g:python_highlight_file_headers_as_comments = 1

" nnoremap <silent> <F1>  :TagbarToggle<CR>
" nnoremap <silent> <F1> :NERDTreeToggle<CR>

" saving all updates all tags, because of the added event in easytags_events
nmap <leader><CR> :wa<CR>

" let g:easytags_suppress_ctags_warning = 1 " error in shell configuration?!
let g:easytags_suppress_report = 1

" Easytags Pythoncolors
" ---------------------
" hi pythonFunctionTag guifg=#008800 gui=bold
" hi pythonMethodTag guifg=#008866 gui=bold
" hi pythonClassTag guifg=#008899 gui=bold

" xolox/vim-shell
let g:shell_mappings_enabled = 0

" Shell
" ----------------------
" set shell=C:\MSYS2\usr\bin\zsh.exe
" set noshellslash 
" let &shellpipe="2>&1| tee"
" set shellredir=>&


function! QFixConditOpen()
  if len(getqflist()) > 0
    copen
  endif
endfunction

" The mighty F9 - Execute file section
"---------------------
" the last <CR> is to clear the vim command line from the 'press any key'
" dialog

let g:ipdb = "C:/Python35_64/scripts/ipdb3.exe"

" for history
" autocmd Filetype python nnoremap <buffer> <S-F9> :call SetWDToCurrentFile()<Bar>:update<Bar> execute '!start '.g:conemu.' py -3 '.shellescape(@%, 1).' -cur_console:c'<CR><CR>
" autocmd Filetype python nnoremap <buffer> <F9> :call SetWDToCurrentFile()<Bar>:update<Bar> execute '!start '.g:
" autocmd Filetype python nnoremap <buffer> <A-F9> :update<Bar>silent! execute '!C:/Python35_64/Scripts/ipython3 '.shellescape(@%, 1)<CR>

" "py -3 ./tuplecomp.py" -cur_console:c


" autocmd BufRead *.html,*.md nnoremap <buffer> <F9> :update<CR> :silent! !chrome -new-tab file:///"%:p"<CR>


let g:TEST_AHK = 0
function! GetAHKpath()
  let a:AHKpaths = [
      \ "C:/Program Files/AutoHotkey/AutoHotkey.exe", 
      \ "C:/Program Files (x86)/AutoHotkey/AutoHotkey.exe"
      \ ]
  for i in a:AHKpaths
    " TEST
    if g:TEST_AHK
      echo i
      echo filereadable(i)
    endif
    if filereadable(i)
      let g:AHKpath = i
    endif
  endfor
endfunction

if has("win64")
  call GetAHKpath()
endif

" TEST
if g:TEST_AHK
  echom g:AHKpath
endif
autocmd Filetype autohotkey nnoremap <buffer> <F9> :update<Bar>silent! execute '!start '.g:AHKpath.' '.shellescape(@%,1)<CR>

" if has("win64")
"   autocmd Filetype autohotkey nnoremap <buffer> <F9> :update<Bar>silent! execute '!start C:\Program Files (x86)\AutoHotkey\AutoHotkey.exe '.shellescape(@%,1)<CR>
" else 
"   autocmd Filetype autohotkey nnoremap <buffer> <F9> :update<Bar>execute '!start C:\Program Files\AutoHotkey\AutoHotkey.exe '.shellescape(@%,1)<CR>
"   " autocmd Filetype autohotkey nnoremap <buffer> <F9> :update<Bar>silent! execute '!start C:\Program Files\AutoHotkey\AutoHotkey.exe '.shellescape(@%,1)<CR>
" endif

autocmd Filetype dosbatch nnoremap <buffer> <F9> :update<Bar>silent! execute '!start '.shellescape(@%,1)<CR>

autocmd Filetype java nnoremap <buffer> <F9> :call CompileJava()<CR>
autocmd BufRead *.java call JavaRunShortcuts()

autocmd Filetype c nnoremap <buffer>  <F9> :update<bar> silent make %:r<CR>:redraw!<CR>:call QFixConditOpen()<CR>

" autocmd Filetype cs nnoremap <buffer> <F9> :call SetWDToCurrentFile()<Bar>:update<Bar>execute '!start C:/Windows/Microsoft.NET/v4.0.30319/csc.exe /t:exe /out:'.shellescape(%:h, 1).'.exe '.shellescape(@%, 1)<CR><CR>
" autocmd Filetype cs nnoremap <buffer> <F9> :call SetWDToCurrentFile()<Bar>:update<Bar>execute '!start C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe /t:exe /out:'.shellescape(expand(@%)).'.exe '.shellescape(@%, 1)<CR>

autocmd User Startified setlocal cursorline



" Old python-f9 notes:
" http://superuser.com/questions/20625/vim-execute-the-script-im-working-on-in-a-split-screen
" : oder weglassen vor !D... is egal, kommt alles in ein cdm window. Wenn
" jedoch ein . da steht, dann wird der output direkt an der cursor position
" eingefügt! :D Irgendwie cool und für das ursprüngliche Beispiel auch
" nötig:
" Vielleicht für literate Programming sinnvoll: kleiner Codeblock direkt
" gefolgt von output, korrekt formatiert.
"
" And lastly: :py3 and :py3file work, but they use python 3.2 (found in
" gvim.exe directly!). They output to a temporary vim buffer - not nice.


" ############################################################################
"
" Execute a selection of code (very cool!)
" Use VISUAL to select a range and then hit ctrl-h to execute it.

if has("python3")
python3 << EOL
import vim
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
vmap <F9> :py3 EvaluateCurrentRange()<CR>

" Use F7/Shift-F7 to add/remove a breakpoint (pdb.set_trace)
" Totally cool.

python3 << EOL
def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
      "%(space)spdb.set_trace() %(mark)s Breakpoint %(mark)s" %
        {'space':strWhite, 'mark': '#' * 30}, nLine - 1)

    for strLine in vim.current.buffer:
        if strLine == "import pdb":
            break
    else:
        vim.current.buffer.append( 'import pdb', 0)
        vim.command( 'normal j1')

vim.command( 'map <f7> :py3 SetBreakpoint()<cr>')

def RemoveBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == "import pdb" or strLine.lstrip()[:15] == "pdb.set_trace()":
            nLines.append( nLine)
        nLine += 1

    nLines.reverse()

    for nLine in nLines:
        vim.command( "normal %dG" % nLine)
        vim.command( "normal dd")
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( "normal %dG" % nCurrentLine)

vim.command( "map <s-f7> :py3 RemoveBreakpoints()<cr>")
EOL
endif

" vim:syntax=vim


" Multiple Cursors
" https://github.com/terryma/vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
" let g:multi_cursor_start_key='<F6>'

" Idee: S-H und S-L für line anfang und Ende, da ich das Standardmapping nie
" nutze...
" https://github.com/terryma/vim-multiple-cursors/issues/39
" nmap L $
" nmap H 0
nmap gH g0
nmap gL $


" Test-Driven-Development TDD section

" Finding root, run MakeGreen from there (run ALL the tests!)
" python-root: setup.py

function! FindProjectRoot(lookFor)
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.a:lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            return expand(pathMaker)
        endif
    endwhile
    return 0
endfunction

function! WalkUpWDToPythonProjectRoot()
  let a:project_root=FindProjectRoot("setup.py")
  exe "cd ".a:project_root
endfunction

function! RunAllPythonTests()
  " Main Entry point
  " echo "running all tests..."
  " to verify the compiler:
  "   let b:current_compiler
  compiler pytest
  call SetWDToCurrentFile()
  call WalkUpWDToPythonProjectRoot()
  " never open in new tab (default)
  call MakeGreen('T', '')
  " MakeGreen
  " let l:qf_errors = len(getqflist())
  if len(getqflist()) > 0
    copen
  endif
endfunction

" Changed makegreen.vim directly, because the highlight groups there overwrite
" the ones set in my colorscheme. I don't want to write that into /after,
" which is why I remark this here!
" MakeGreen has two highlight group: GreenBar and RedBar. I check them for
" existence with :hlexists({name}) and disable the naive overwrite.

" nmap <S-F9> :call RunAllPythonTests()<CR>

" map <leader>f :echo g:jedi#force_py_version<CR>
" map <leader>e :call jedi#force_py_version_switch()<CR>

" vim-project
" https://github.com/eyetracker/vim-project/

let g:project_enable_welcome = 0
let g:project_set_title = 0
let g:project_disable_tab_title = 1


" python proof of concept:
function! Airline_cwd_py()
python3 << EOL
import vim
import os
import re

full_cwd_slashed = os.getcwd()
full_cwd =  re.sub("\/", "\\\\", full_cwd_slashed )
if len(full_cwd) > 23:
    cwd_truncated = full_cwd[0:11] + '...' + full_cwd[-11:-1]
    cwd = '"' + cwd_truncated + '"'
else:
    cwd = '"' + full_cwd + '"'

vim.command(r'return %s' % cwd )
# no whitespace before {endmarker}!
EOL
endfunction 

function! Airline_cwd()
    let cwd = getcwd()
    if (len(cwd) > 22)
        let cwd_trunc = strpart(cwd, 0, 9)."..".strpart(cwd, strlen(cwd) - 12)
        return cwd_trunc
    else
        return cwd
    endif
endfunction

" let g:airline_section_a = '%{Airline_cwd()}'

command! Leave exe 'e '.g:vimfiles.'/leftoff.txt' |exe 'norm gg' | exe 'r! date /t' | exe 'r! time /t' | exe 'norm kJo' | start

" python syntax
let g:python_highlight_all = 1

" Toggle Quickfix
" XXX SLOW
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    botright copen
    let g:qfix_win = bufnr("$")
  endif
endfunction

command! -bang -nargs=? QFix call QFixToggle(<bang>0)
nmap <leader>x :QFix<CR>
" old:
" nmap <leader>x :copen<CR>

" Reverse |ins-completion-menu| tab cycling
let g:SuperTabMappingForward = '<s-tab>'
let g:SuperTabMappingBackward = '<tab>'

" /ivanov/vim-ipython
" disable default vim-ipython mappings: F9, <C-s>, ...
let g:ipy_perform_mappings = 0

autocmd FileType python nnoremap <buffer> <Enter> :py3 run_this_line()<CR>
autocmd FileType python vnoremap <buffer> <Enter> :py3 run_these_lines()<CR>
autocmd FileType python nnoremap <buffer> <S-Enter> vip :py3 run_these_lines()<CR>

" :IPython works only once, vim-ipython doesn't support multiple call at the
" moment (planned feature)
command! IPY execute 'silent !start /min c:/python35_64/scripts/ipython3 kernel' | :echo "Starting ipython3 kernel..." | :sleep 900m | execute 'IPython' | :redraw! | :echo "ipython3 kernel running!"
" explanation, line by line:
" /min starts minimized: doesn't steal focus (very shortly)
" echo... 1st msg
" sleep depending on the machine. has to wait until the external command has
" been fully initialized. 
" exec 'IPython' : to escape everything after it, so it won't take it as its
" argument.
" 2nd msg would skip the 1st. This invokes a "Hit ENTER to continue" prompt.
" This prompt gets forced off by :redraw! 
" echo... msg2
command! IPYT exe 'e '.g:vimfiles.'/ipytemp.py' | execute 'silent !start /min ipython3 kernel' | :echo "Starting ipython3 kernel..." | :sleep 900m | execute 'IPython' | :redraw! | :echo "ipython3 kernel running!"


" vim-addon-background-cmd
" https://github.com/MarcWeber/vim-addon-background-cmd/tree/master/doc
" for windows
let g:bg_use_python=1

cmap <F7> <C-\>eAppendSome()<CR>
function! AppendSome()
    let cmd = getcmdline() . " Some()"
    " place the cursor on the )
    call setcmdpos(strlen(cmd))
    return cmd
endfunc

function! HighlightEvery(lineNumber, lineEnd)
    highlight myhighlightpattern guibg=#ccffcc
    let pattern="/"
    let i = 0
    while i < a:lineE
        let i += a:lineNumber
        let pattern .= "\\%" . i . "l\\|"
    endwhile
    let pattern .= "\\%0l/"
    let commandToExecute = "match myhighlightpattern ".pattern
    execute commandToExecute
endfunction

command! -nargs=* Highlightevery call HighlightEvery(<f-args>)

" let g:netrw_ftp_cmd= 'c:\Windows\System32\ftp -s:C:\Users\Ich\78.143.5.182'
" let g:netrw_liststyle=3

" Unite
" =====================
" Intro to Unite's functions:
" http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/

let g:unite_source_history_yank_enable = 1
" $HOME is case sensitive under Linux
" let g:unite_source_history_yank_file =  $HOME.g:vimfiles[1:].'/yankring_history.tmp'
" dont need, only duplicates every entry in the yank history
let g:unite_source_history_yank_save_clipboard = 0 " default 0
" yankring style
"
" let g:neoyank#file = $HOME.'/.vim/yankring.txt'
let g:neoyank#file = $HOME.g:vimfiles[1:].'/yankring_history.tmp'
" nnoremap <C-p> :<C-u>Unite history/yank<CR>
nnoremap <C-0> :Denite neoyank<CR>

" Denite Mappings
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')


" UltiSnips
" =====================
if has("python3")
    let g:UltiSnipsUsePythonVersion = 3
endif


let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" vim-autoformat python
" =========================
" let g:formatprg_args_expr_python = ' --max-line-length 80'
" let g:formatprg_args_expr_python = ''

" let g:tester = "abc"
" echom g:tester[1:]

" GNU R project
" ===============
" http://www.lepem.ufc.br/jaa/r-plugin.html#r-plugin-use

"Identify the syntax highlighting group used at the cursor
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
" Helper: Syntax Highlight Under Cursor
map <F5> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


" Line Link to filename
function! CollectTasks()
execute "redir @i"
silent execute "g/ DOCS\\|todo\\|fixme\\|XXX\\|OPEN\\|PENDING\\|HOLD\\|INFO\\|DONE\\|PLAN\\|TODO\\|TASK\\|E-MAIL\\|TALK\\|MEETING\\|FEEDBACK\\|\\d\\{4}\\s---\\|NOTES"
execute "redir end"
execute "e C:/Users/arthur.jaron/Documents/TasklistOutput/tasklist_".  strftime("%Y-%m-%d %H-%M-%S").".txt"
execute 'normal "ip'
endfunction

command! Tasklist silent call CollectTasks()


function! RegistersCleanUp()
  let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"' | let i=0 | while (i<strlen(regs)) | exec 'let @'.regs[i].'=""' | let i=i+1 | endwhile | unlet regs
endfunction

command! RegClean silent call RegistersCleanUp()

redraw! " for various echom messages

function! CleanJQL()
    exec "g/^$/d"
    exec "%s/ /\r/g"
    exec "g/\\v^(GOLD_)@!&(TEST1_)@!&(TEST2_)@!&(RUNBOOK_)@!/d"
endfunction

function! TodaySeparator()
  exec "norm O"
  exec "norma I". strftime("%m%d %a") ." --------------------------------------------------------------"
endfunction

nmap <c-F1> :call TodaySeparator()<CR>
nmap <leader>t :call TodaySeparator()<CR>


let g:ycm_auto_trigger = 0


let g:pacman_string = "C:/Users/arthur.jaron/AI/pacman/p1search/pacman.py -l tinyMaze -p SearchAgent -a fn=depthFirstSearch "
" let g:pacman_string = "C:/Users/arthur.jaron/AI/pacman/p1search/pacman.py -l mediumMaze -p SearchAgent -a fn=depthFirstSearch "
" let g:pacman_string = "E:/AI/pacman/p1search/pacman.py -z 0.5 -l tinyMaze -p SearchAgent -a fn=depthFirstSearch "


augroup pygroup
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  autocmd Filetype python call PyAutocmd()
augroup end

function! PyAutocmd()
  silent call SetWDToCurrentFile()
  update
  let g:ipdb = "C:/Python36/scripts/ipdb3.exe"
  " XXX is -3 actually the default in system py settings? -3 here overrides shebang - not good...
  " nmap <F9> :execute '!start '.g:conemu.' py -3 '.shellescape(@%, 1).' -cur_console:c'<CR>
  "
  " WORKS
  if has('nvim')
    " ConEmu has to run BEFORE this is called, otherwise nvim is the main handler of the process and can't run
    " it asyncronously
    "
    nmap <F9> :call SetWDToCurrentFile()<Bar>update<BAR>call system(shellescape("C:\\Program Files\\ConEmu\\ConEmu64.exe") ." /single -run py.exe " . expand('%:S') ." -cur_console:c:t:".expand('%:t'))<CR>
    nmap <S-F9> :call SetWDToCurrentFile()<Bar>update<BAR>call system(shellescape("C:\\Program Files\\ConEmu\\ConEmu64.exe") ." /single -run py.exe -m ipdb " . expand('%:S') ." -cur_console:c:t:".expand('%:t'))<CR>

    " Workaround
    let g:py_conemu = "c:/users/arthur.jaron/dotfiles/conemu_nvim_curconsole.bat py ". expand("%")
    let g:ipdb_conemu = "c:/users/arthur.jaron/dotfiles/conemu_nvim_curconsole.bat py -m ipdb ". expand("%")

    " echom g:py_conemu
    " nmap <F9> :call jobstart(g:py_conemu)<CR>
    " nmap <S-F9> :call jobstart(g:ipdb_conemu)<CR>


  " don't work
  " let g:py_conemu = "C:/Program Files/ConEmu/ConEmu64.exe /single -run ".expand("%")." -cur_console:c"
  " let g:py_conemu = "C:/Program\ Files/ConEmu/ConEmu64.exe /single -run ".expand("%")." -cur_console:c"
  " nmap <F9> :call jobstart(shellescape(''.g:py_conemu))<CR>
  " nmap <F9> :call jobstart("c:/users/arthur.jaron/dotfiles/py_conemu.bat ". expand("%"))<CR>
  " MANGLED with \v at several points, but works - without the mapping
  " nmap <F9> :call jobstart(['c:/users/arthur.jaron/dotfiles/py_conemu.bat', expand("%")])<CR>
  " nmap <F9> :execute "call jobstart(".g:py_conemu." ".expand(%).")"<CR>
  
  " NOT IN NEOVIM
  else
    nmap <F9> :execute '!start '.g:conemu.' py '.shellescape(@%, 1).' -cur_console:c'<CR>
    " nmap <S-F9> :execute '!start '.g:conemu.' '.g:ipdb.' '.shellescape(@%, 1).' -cur_console:c'<CR>
    nmap <S-F9> :execute '!start '.g:conemu.' py -m ipdb '.shellescape(@%, 1).' -cur_console:c'<CR>
  endif
  " nmap <Enter> :execute '!start '.g:conemu.' py -m ipdb '. g:pacman_string .' -cur_console:c'<CR>
  " WORKING but dont do this for now - it's annoying
  " nmap <Enter> :execute '!'.shellescape('C:/Users/arthur.jaron/AI/pacman/p1search/CornersTiny_BFS.bat')<CR>
endfunction
" autocmd Filetype python nnoremap <buffer> <F9> :call SetWDToCurrentFile()<Bar>:update<Bar> execute '!start '.g:conemu.' py -3 '.shellescape(@%, 1).' -cur_console:c'<CR><CR>

" <Enter> :call SetWDToCurrentFile()<Bar>:update<Bar> execute '!start '.g:conemu.' py -3 '. g:pacman_string .' -cur_console:c'<CR><CR>

" nmap <F3> :e E:/AI/pacman/p1search/ai_workbench.txt<CR>

" nmap <Enter> ggVGy
"
"

autocmd Filetype cs call CsharpAutocmd()

function! CsharpAutocmd()
  silent call SetWDToCurrentFile()
  update
  let g:csc="C:\\Program Files\\Roslyn\\Microsoft.Net.Compilers.2.8.2\\tools\\csc.exe"
  let g:csc_conemu = "c:/users/arthur.jaron/dotfiles/conemu_nvim_curconsole.bat ".g:csc." ". expand("%")
  " don't know exactly why this works in cmd.exe and nvim, but it does!
  " %1 contains "...Program Files..." and isn't in quotes
  echom g:csc_conemu
  nmap <F9> :call jobstart(g:csc_conemu)<CR>
endfunction

" Javascript initiative 2018 04 10
" FLOW syntax hl by vim-javascript
let g:javascript_plugin_flow = 1
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"

autocmd FileType javascript setlocal conceallevel=1
" switch conceallevel
map <leader>c :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>

" Emmet mattn/emmet-vim HTML, CSS
let g:user_emmet_install_global = 0
" let g:user_emmet_leader_key='<C-Z>'
autocmd FileType html,css EmmetInstall

inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O

" deoplete
"

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<C-j>"
" let g:UltiSnipsJumpBackwardTrigger="<C-k>"
"
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif


" Deleted my plugin: vim-workbench
let g:localsettings= "~/localsettings.vim"
if filereadable(expand(g:localsettings))
  " source ~/localsettings.vim
  exec "source ".g:localsettings
else
  let g:vwb_f1=""
  let g:vwb_f2=""
  let g:vwb_f3=""
  let g:vwb_f4=""
endif

map <F1> :exec "e ".g:vwb_f1<CR>
map <F2> :exec "e ".g:vwb_f2<CR>
map <F3> :exec "e ".g:vwb_f3<CR>
map <S-F1> :exec "e ".g:vwb_f4<CR>

" nmap <S-F1> :call CropPaste(g:vwb_f1)<CR>
" nmap <S-F2> :call CropPaste(g:vwb_f2)<CR>
" nmap <S-F3> :call CropPaste(g:vwb_f3)<CR>
" nmap <S-F4> :call CropPaste(g:vwb_f4)<CR>

function! CropPaste(document)
  exec 'norm "tdip'
  exec "e ".a:document
  exec 'norm gg}o'
  exec 'norm "tP'
endfunction

" Copy Pasta from https://github.com/carlitux/deoplete-ternjs/
" Whether to include JavaScript keywords when completing something that is not 
" a property.
" Default: 0
let g:deoplete#sources#ternjs#include_keywords = 1
" Whether to use a case-insensitive compare between the current word and 
" potential completions.
" Default: 0
let g:deoplete#sources#ternjs#case_insensitive = 1
" Whether to include documentation strings (if found) in the result data.
" Default: 0
let g:deoplete#sources#ternjs#docs = 1
" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1
" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]


"iron.nvim config
" lua << EOF
" local iron = require("iron")
"
" iron.core.set_config{
"   repl_open_cmd = "vsplit"
" }
" EOF
"
"
" Quickopen

" incompatible with neovim
" source ~/quickopen/plugin/quickopen.vim

autocmd Filetype asm call AsmAutocmd()

" BGB
function! AsmAutocmd()
  silent call SetWDToCurrentFile()
  update
  " let g:compiler="D:/GDrive/GameBoyDev/BaneBoy/Source/make_bb.bat"
  let g:compiler=g:cloudpath."/GameBoyDev/BaneBoy/Source/make_bb.bat"
  nmap <F9> :call SetWDToCurrentFile()<Bar>update<BAR>call system(shellescape("C:\\Program Files\\ConEmu\\ConEmu64.exe") ." /single -run ".g:compiler." -cur_console:c:t:".expand('%:t'))<CR>
endfunction


if exists('$TMUX')
  let &t_SI = "\ePtmux;\e\e[5 q\e\\"
  let &t_EI = "\ePtmux;\e\e[2 q\e\\"
else
  let &t_SI = "\e[5 q"
  let &t_EI = "\e[2 q"
endif

" echom "correct vimrc!"
" End of my epic vimrc!



