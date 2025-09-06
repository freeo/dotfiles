return {
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
      backend = "kitty",
      scale_factor = 2, -- Scale images to 1.5x for retina display
      integrations = {
        markdown = {
          enabled = true,
        },
        neorg = {
          enabled = true,
        },
        org = {
          enabled = true,
        },
      },
    },
  },
}
