return {
  {
    "freeo/vim-kalisi",
    dev = true,
    lazy = false,
    dir = "~/wb/vim-kalisi",
    config = function()
      require("kalisi").setup() -- Ensure this matches your folder structure
      vim.cmd.colorscheme("kalisi")
    end,
  },
}
