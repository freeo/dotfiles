return {
  -- Override the yaml-language-server configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              format = {
                enable = false,
                singleQuote = false,
                bracketSpacing = true,
                proseWrap = "preserve", -- Important for keeping your structure
                printWidth = 120, -- Adjust as needed
              },
            },
          },
        },
      },
    },
  },

  -- If you're using conform.nvim, disable its yaml formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        yaml = {}, -- Empty array disables formatters for yaml
      },
    },
  },

  -- If you're using none-ls.nvim, disable its yaml formatter
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      if opts.sources then
        -- Filter out any yaml formatters
        opts.sources = vim.tbl_filter(function(source)
          return not (source.name == "yamlfmt" or source.name == "prettier")
        end, opts.sources)
      end
      return opts
    end,
  },
}
