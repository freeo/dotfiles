return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        markdown = nil,
        markdownlint = nil,
        ["markdownlint-cli2"] = nil,
      },
    },
  },
  {
    "freeo/vim-kalisi",
    dev = true,
    lazy = false,
    -- dir = "~/wb/vim-kalisi",
    dir = "~/dotfiles/config/nvim/lua/vim-kalisi",
    config = function()
      require("kalisi").setup() -- Ensure this matches your folder structure
      vim.cmd.colorscheme("kalisi")
    end,
  },
}
