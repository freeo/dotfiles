-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<Esc>") -- SMASH Escape

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

-- Jump to treesitter context upward
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Go to context upward", silent = true })

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

-- WIP: overlap with projects picker?
-- old, works for now: yanky.nvim gone? this throws an error:
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

vim.keymap.set("n", "<leader>r1", function()
  -- vim.cmd("edit " .. vim.fn.expand("$mypath") .. "~/pcloud/cloudkoloss/wb_mac.org")
  vim.cmd("edit " .. "~/pcloud/cloudkoloss/wb_mac.org")
end, { desc = "open wb_mac" })

-- vim.keymap.set("n", "<leader>k", function()
vim.keymap.set("n", "<C-A-r>", function()
  -- vim.cmd("call ReloadKalisi()")
  -- vim.cmd("source /home/freeo/wb/vim-kalisi/colors/kalisi.lua")

  vim.api.nvim_command("write")
  package.loaded["kalisi"] = nil
  package.loaded["kalisi.light"] = nil
  package.loaded["kalisi.dark"] = nil

  -- Re-require the module
  local ok, _ = pcall(require, "kalisi")
  if not ok then
    vim.notify("Failed to reload colorscheme module: kalisi", vim.log.levels.ERROR)
    return
  end

  -- Reapply the colorscheme using the :colorscheme command
  vim.cmd.colorscheme("kalisi")
  vim.notify("Colorscheme 'kalisi' reloaded successfully", vim.log.levels.INFO)
  -- vim.cmd("colorscheme kalisi")
end, { desc = "ReloadKalisi" })

local function get_treesitter_highlight_groups()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Validate window ID
  if not vim.api.nvim_win_is_valid(winid) then
    vim.notify("Invalid window ID: " .. winid, vim.log.levels.ERROR)
    return
  end

  -- Validate buffer ID
  if not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify("Invalid buffer ID: " .. bufnr, vim.log.levels.ERROR)
    return
  end

  -- Retrieve Treesitter captures at cursor position
  local captures = vim.treesitter.get_captures_at_cursor(bufnr)
  if #captures == 0 then
    print("No Treesitter captures found!")
    return
  end

  print("Treesitter Highlight Groups:")
  for _, capture in ipairs(captures) do
    print("- " .. capture)
  end
end

local function get_syntax_highlight_groups()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")

  local syn_id = vim.fn.synID(line, col, true)
  if syn_id == 0 then
    print("No syntax group found under cursor.")
    return
  end

  local syn_name = vim.fn.synIDattr(syn_id, "name")
  local trans_name = vim.fn.synIDattr(vim.fn.synIDtrans(syn_id), "name")

  print("Highlight Group: " .. syn_name .. " -> Linked Group: " .. trans_name)
end

-- Keymap to trigger this function
vim.keymap.set("n", "<C-g>", get_syntax_highlight_groups, { desc = "Get Syntax Highlight Groups" })

-- Keymap to trigger this function
-- vim.keymap.set("n", "<C-g>", get_treesitter_highlight_groups, { desc = "Get Treesitter Highlight Groups" })
