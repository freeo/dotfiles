return {
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      local baleia = require("baleia").setup({
        strip_ansi_codes = true, -- Keep ANSI codes (required for conceal)
        async = true, -- Process colors asynchronously
      })
      vim.api.nvim_create_user_command("BaleiaLogColorize", function()
        -- vim.bo.conceallevel = 2
        -- vim.bo.concealcursor = "nvic" -- Conceal in all modes
        -- vim.fn.matchadd("Conceal", "\\e\\[[0-9;]*m", 10, -1, { conceal = "" })
        -- buf = vim.api.nvim_get_current_buf()
        -- vim.bo[buf].conceallevel = 2
        -- vim.bo[buf].concealcursor = "nvic"
        -- vim.fn.matchadd("Conceal", "\\e\\[[0-9;]*m", 10, -1, { conceal = "" }, args.buf)
        -- baleia.once(buf)
        baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })
    end,
  },
  {
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup({
        extension = { "zap", "log" },
      })
    end,
  },
}
