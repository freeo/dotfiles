return {
  -- TMP: suda: go declarations can't dive into nested definitions because of suda.
  -- TODO: look into vim-suda issues.
  -- {
  --   "lambdalisue/vim-suda",
  --   init = function()
  --     vim.g.suda_smart_edit = 1
  --   end,
  -- },
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
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })
    end,
  },
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      { "folke/snacks.nvim" }, -- optional
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" }, -- optional
    opts = {},
  },
}
