-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.number, vim.opt.relativenumber = false, false
vim.g.lazygit_config = false

-- Mason installs fail with shims currently:
-- https://github.com/williamboman/mason.nvim/issues/1657
-- Workaround: comment shim path until the binaries are installed
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.lazyvim_python_ruff = "ruff"

-- explicitly required, otherwise fzf-lua will be autoselected because of "siawkz/nvim-cheatsh" dependency
vim.g.lazyvim_picker = "snacks"
