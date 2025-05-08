-- Changes to the lazyvim core plugins

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- example to override a default core plugin
  -- opts will be merged with the parent spec
  -- {
  --   "folke/trouble.nvim",
  --   opts = { indent_guides = false },
  -- },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "sqlfluff",
        "gotestsum",
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>z",
        function()
          -- require("snacks").picker.zoxide({ layout = { preset = "vscode" } })
          require("snacks").picker.zoxide()
        end,
        desc = "Zoxide!",
      },
      {
        -- M-x approximation like in Doomemacs
        "<C-;>",
        function()
          require("snacks").picker.keymaps()
        end,
        desc = "Keymaps",
      },
    },
    opts = function(_, opts)
      opts.picker = {
        win = {
          input = {
            keys = {
              ["<c-l>"] = { "cycle_win", mode = { "i", "n" } },
              ["<c-y>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-e>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-l>"] = "cycle_win",
            },
          },
          preview = {
            keys = {
              ["<c-l>"] = "cycle_win",
            },
            -- minimal = true,
            wo = {
              number = false, -- Disable line numbers
              relativenumber = false, -- Disable relative line numbers
              signcolumn = "no", -- Disable sign column
              foldcolumn = "0", -- Disable fold column
            },
          },
        },
        -- preview = {
        -- number = false,
        -- relativenumber = false,
        -- signcolumn = "no",
        -- setup = function(buffer, _)
        --   local options = {
        --     number = false, -- Disable line numbers
        --     relativenumber = false, -- Disable relative line numbers
        --     signcolumn = "no", -- Disable sign column
        --     foldcolumn = "0", -- Disable fold column
        --   }
        --   for k, v in pairs(options) do
        --     vim.api.nvim_buf_set_option(buffer, k, v)
        --   end
        -- end,
        -- },
      }
      opts.layout = {
        width = 0.99,
        height = 0.99,
      }
      opts.keys = {
        "<leader>fz",
        function()
          require("snacks").picker.files({ layout = { preset = "ivy" } })
        end,
        desc = "Find Files (Ivy)",
      }
    end,
  },
  -- {
  --   "ibhagwan/fzf-lua",
  --   opts = {
  --     winopts = {
  --       height = 0.98,
  --       width = 0.98,
  --       fullscreen = true,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("fzf-lua").setup(opts)
  --     -- Override the files command
  --     require("fzf-lua").register_ui_select()
  --   end,
  -- },
  {
    "folke/noice.nvim",
    opts = {},
  },
  {
    "stevearc/conform.nvim",
    -- sqlfluff can't be found with the default settings! Temporary workaround.
    opts = {
      formatters_by_ft = {
        sql = { "sqlfluff" },
        pgsql = { "sqlfluff" },
        -- yaml = {},
      },
      formatters = {
        sqlfluff = {
          --  command = "sqlfluff",
          --  args = { "format", "--dialect=postgres", "-" },
          args = {
            "fix",
            "--dialect=postgres",
            "--processes=-1",
            "-",
          },
          cwd = function()
            return vim.fn.getcwd()
          end,
          stdin = true,
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    -- NOTE: verified to work with colorize_test_output, but the runner gotestsum isn't applied correctly. Who's fault is that? Maybe mason, because it can't install gotestsum, it tries an outdated version. Just wait for now.
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- runner = "go",
          runner = "gotestsum",
          gotestsum_args = { "--format-icons=hivis", "--format=testdox" },
          -- colorize_test_output = false,
        },
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = {
        insert = true,
        command = false, -- Disable in command mode (affects `/` search)
        terminal = false, -- WIP: Check if zsh overlaps with "true"
      },
    },
  },
}
-- { "freeo/vim-kalisi", branch = "dev-0.9" },
-- {
--   "f-person/auto-dark-mode.nvim",
--   opts = {
--     update_interval = 3000,
--     set_dark_mode = function()
--       vim.api.nvim_set_option_value("background", "dark", {})
--       vim.cmd("colorscheme catppuccin-mocha") -- or your preferred dark theme
--       -- colorscheme = "kalisi"
--     end,
--     set_light_mode = function()
--       vim.api.nvim_set_option_value("background", "light", {})
--       vim.cmd("colorscheme kalisi") -- or your preferred light theme
--       -- colorscheme = "kalisi"
--     end,
--   },
-- },
-- {
--   "LazyVim/LazyVim",
--   opts = {
--     colorscheme = function()
--       require("auto-dark-mode").init()
--     end,
--   },
-- },
-- }
