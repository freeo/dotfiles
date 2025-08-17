return {
  "mikesmithgh/kitty-scrollback.nvim",
  enabled = true,
  lazy = true,
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth", "KittyScrollbackGenerateCommandLineEditing" },
  event = { "User KittyScrollbackLaunch" },
  -- dev = true,
  -- version = '*', -- latest stable version, may have breaking changes if major version changed
  -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
  config = function()
    -- vim.keymap.set({ "n" }, "<Esc>", "<Plug>(KsbCloseOrQuitAll)", {}) -- quit kitty-scrollback.nvim with Esc key
    -- vim.keymap.del("n", "q", { buffer = true })
    -- vim.g.mapleader = " "
    -- vim.g.maplocalleader = ","
    require("kitty-scrollback").setup()
    --   {
    --   -- global config
    --   {
    --     -- paste_window = {
    --     --   -- boolean? If true, the yank_register copies content to the paste window. If false, disable yank to paste window
    --     --   -- yank_register_enabled = false,
    --     --   -- boolean? If true, hide mappings in the footer when the paste window is initially opened
    --     --   -- hide_footer = true,
    --     -- },
    --   },
    -- -- })
  end,
}
