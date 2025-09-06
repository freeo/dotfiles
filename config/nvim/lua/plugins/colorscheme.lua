return {
  {
    -- https://github.com/uloco/bluloco.nvim
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      require("bluloco").setup({
        style = "auto", -- "auto" | "dark" | "light"
        transparent = false,
        italics = false,
        terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
        guicursor = true,
      })

      vim.opt.termguicolors = true
      -- vim.cmd("colorscheme bluloco")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        -- vim.cmd("colorscheme bluloco")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        -- vim.cmd("colorscheme kalisi") -- or your preferred light theme
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- vim.cmd("colorscheme bluloco")
        vim.cmd("colorscheme kalisi")
        require("auto-dark-mode").init()
      end,
    },
  },
}
