 
" SMASH-Escape
imap jk <ESC>

let g:vimfiles = "~/.vim"

let g:rnvimr_vanilla = 1

call plug#begin('~/.vim/plugged')
  Plug 'kevinhwang91/rnvimr'
call plug#end()


" File Browser
" ------------
" hide some files and remove stupid help
let g:explHideFiles='^\.,.*\.sw[po]$,.*\.pyc$'
let g:explDetailedHelp=0
let g:rnvimr_edit_cmd = 'drop'

" map <C-B> :Explore!<CR>
nmap - :RnvimrToggle<CR>
" Make Ranger replace Netrw and be the file explorer
let g:rnvimr_enable_ex = 1

" Make Ranger to be hidden after picking a file
let g:rnvimr_enable_picker = 1

" Change the border's color
let g:rnvimr_border_attr = {'fg': 7, 'bg': -1}
" Link CursorLine into RnvimrNormal highlight in the Floating window
highlight link RnvimrNormal CursorLine

nnoremap <silent> <C-r> :RnvimrToggle<CR>
tnoremap <silent> <C-r> <C-\><C-n>:RnvimrToggle<CR>


" Map Rnvimr action
"
let g:rnvimr_action = {
            \ '<CR>': 'NvimEdit drop',
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
            \ }


