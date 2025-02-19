return {
  {
    "lambdalisue/vim-suda",
    init = function()
      vim.g.suda_smart_edit = 1
    end,
  },
  {
    "kevinhwang91/rnvimr",
    enabled = vim.fn.has("win32") ~= 1,
    config = function()
      vim.g.rnvimr_enable_ex = 1
      vim.api.nvim_set_keymap("n", "-", ":RnvimrToggle<CR>", { noremap = true, silent = true })

      -- vim.g.rnvimr_vanilla = 1
      -- vim.api.nvim_set_keymap('n', '<C-B>', ':Explore!<CR>', { noremap = true, silent = true })

      -- Make Ranger replace Netrw and be the file explorer
      -- Make Ranger to be hidden after picking a file
      vim.g.rnvimr_enable_picker = 1

      -- Change the border's color
      vim.g.rnvimr_border_attr = { fg = 7, bg = -1 }

      -- Link CursorLine into RnvimrNormal highlight in the Floating window
      -- vim.cmd("highlight link RnvimrNormal CursorLine")
      -- vim.api.nvim_set_hl(0, "RnvimrNormal", { link = "CursorLine" })
      -- vim.api.nvim_set_hl(0, "RnvimrCurses", { link = "CursorLine" })

      vim.g.rnvimr_edit_cmd = "drop"
      vim.g.rnvimr_shadow_winblend = 50

      -- Map Rnvimr action
      vim.g.rnvimr_action = {
        ["<CR>"] = "NvimEdit edit",
        ["<C-s>"] = "NvimEdit split",
        ["<C-v>"] = "NvimEdit vsplit",
        ["<C-o>"] = "NvimEdit drop",
        ["<C-t>"] = "NvimEdit tabedit",
        ["gw"] = "JumpNvimCwd",
        ["yw"] = "EmitRangerCwd",
      }

      -- Add views for Ranger to adapt the size of floating window
      vim.g.rnvimr_ranger_views = {
        { minwidth = 90, ratio = {} },
        { minwidth = 50, maxwidth = 89, ratio = { 1, 1 } },
        { maxwidth = 49, ratio = { 1 } },
      }

      -- Customize the initial layout
      vim.g.rnvimr_layout = {
        relative = "editor",
        width = vim.o.columns,
        height = math.floor(0.95 * vim.o.lines),
        col = 0,
        row = math.floor(0.05 * vim.o.lines),
        style = "minimal",
      }
    end,
  },
  {
    -- true autosave
    "tmillr/sos.nvim",
    config = function()
      require("sos").setup({
        autowrite = true,
        save_on_cmd = "all",
        ---Save current buffer on `BufLeave`. See `:help BufLeave`.
        save_on_bufleave = true,
        ---Save all buffers when Neovim loses focus or is suspended.
        save_on_focuslost = true,
      })
    end,
  },
  { "nvim-orgmode/orgmode" },
}
