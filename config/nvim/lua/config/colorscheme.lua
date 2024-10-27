if not vim.g.vscode then
  vim.cmd.colorscheme('kalisi')
  vim.g.airline_theme = 'kalisi'

  if vim.env.SUDO_USER ~= "" or vim.env.HOME == "/root" then
    vim.g.airline_theme = 'molokai'
  end
end
-- vim.notify("loaded colorscheme.lua")
