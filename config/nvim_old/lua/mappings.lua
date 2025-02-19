
-- xnoremap Y "+y
-- visual mode:
-- Y: yank to clipboard
-- D: delete to clipboard
vim.keymap.set('x', 'Y', '"+y', { noremap = true })
vim.keymap.set('x', 'D', '"+d', { noremap = true })
-- instead of unnamedplus, which is a source of many issues, especially ssh:
-- vim.opt.clipboard = "unnamedplus"
