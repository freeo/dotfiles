
set nonumber nolist showtabline=0 foldcolumn=0
autocmd TermOpen * normal G" -c "map q :qa!<CR>
set clipboard+=unnamedplus
silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - 
set ignorecase
set smartcase

" colorscheme kalisi

if &background ==# 'light'
" set background=light

" The colors link to these statements are somehow ignored
" hi Special          guifg=#ffaf00 guibg=NONE    gui=bold cterm=bold ctermfg=214
" hi Identifier       guifg=#202090 guibg=NONE    gui=none ctermfg=18
" hi Constant         guifg=#0000af guibg=NONE    gui=bold cterm=bold ctermfg=19
" hi PreProc          guifg=#d80050 guibg=NONE    gui=bold cterm=bold ctermfg=161
" hi Type             guifg=#f47300 guibg=NONE    gui=none ctermfg=202
" hi Statement        guifg=#66b600 guibg=NONE    gui=bold cterm=bold ctermfg=70
" hi Comment          guifg=#70a0d0 guibg=NONE    gui=NONE ctermfg=110

hi diffRemoved      guifg=#ff0a0b guibg=NONE    gui=bold cterm=bold ctermfg=124
hi diffAdded        guifg=#a0ff50 guibg=#384b38 gui=bold cterm=bold ctermfg=70
hi diffChanged      guifg=#0000cc guibg=#383a4b ctermbg=254
hi diffComment      guifg=#70a0d0 guibg=NONE    gui=NONE ctermfg=110
hi diffLine         ctermfg=20    cterm=bold
hi diffSubname      ctermfg=92    cterm=bold
hi link diffOldFile diffRemoved
hi link diffNewFile diffRemoved
hi link diffFile    diffAdded

" Kalisi light diff colors (for diffthis)
" " hi DiffAdd                        guibg=#384b38 ctermbg=194
hi DiffDelete guifg=#484848 guibg=#3b3b3b
hi DiffText   cterm=bold    ctermbg=189 ctermfg=17
hi DiffDelete cterm=bold    ctermbg=224 ctermfg=252

" All Diff groups
" diffOnly       
" diffIdentical  
" diffDiffer     
" diffBDiffer    
" diffIsA
" diffNoEOL
" diffCommon
" diffSubname
" diffLine
" diffFile
" diffIndexLine

" else " dark mode
elif &background ==# 'dark'

hi Normal           guibg=#242010
hi diffRemoved      guifg=#ff0a0b guibg=NONE    gui=bold cterm=bold ctermfg=124
hi diffAdded        guifg=#a0ff50 guibg=#384b38 gui=bold cterm=bold ctermfg=70
hi diffChanged      guifg=#0000cc guibg=#383a4b ctermbg=254
hi diffComment      guifg=#70a0d0 guibg=NONE    gui=NONE ctermfg=110
hi diffLine         ctermfg=20    cterm=bold
hi diffSubname      ctermfg=92    cterm=bold
hi link diffOldFile diffRemoved
hi link diffNewFile diffRemoved
hi link diffFile    diffAdded

" Kalisi light diff colors (for diffthis)
hi DiffDelete guifg=#484848 guibg=#3b3b3b
hi DiffText   cterm=bold    ctermbg=189 ctermfg=17
hi DiffDelete cterm=bold    ctermbg=224 ctermfg=252

endif
