-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-t>", "gcc", { remap = true })
vim.keymap.set("v", "<C-t>", "gc", { remap = true })
vim.keymap.set("n", "<leader>k", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>fi", function()
  require("snacks").picker.files({ layout = { preset = "ivy" } })
end, { desc = "Find files, ivy" })

-- vim.keymap.set("n", "<leader>st", function()
--   require("snacks").picker.todo_comments({ keywords = { "TODO", "WARN", "NOTE" } })
-- end, { desc = "Todo/Warn/Note" })

vim.keymap.set("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "next" })

vim.keymap.set("n", "<F1>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer", remap = true })
vim.keymap.set("n", "<F2>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer", remap = true })

-- vim.keymap.set("n", "<F3>", function()
--   Snacks.explorer(opts({}))
-- end, { desc = "Next Buffer", remap = true })

vim.keymap.set("n", "<leader>pp", function()
  Snacks.picker.projects()
end, { desc = "Projects picker", remap = true })

vim.keymap.del("n", "<leader>p") -- yanky.nvim default: yankring history
vim.keymap.set("n", "<leader>yp", function()
  vim.cmd([[YankyRingHistory]])
end, { desc = "Yanky Ring History" })

vim.keymap.set("n", "<C-i>", function()
  local cursor_bak = vim.opt.guicursor
  vim.opt.guicursor = "n-v-c:ver25,i-ci-ve:ver25"
  local char = vim.fn.nr2char(vim.fn.getchar())
  vim.api.nvim_put({ char }, "c", false, true)
  vim.opt.guicursor = cursor_bak
end, { desc = "Insert Single Character" })
