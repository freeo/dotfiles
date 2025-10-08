return {
  {
    -- For local development
    dir = "~/wb/nvim-dev/llm-functions",
    name = "llm-functions",
    dev = true,
    -- Or for git repo (replace with your repo)
    -- "yourusername/nvim-functions",
  },
  {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = function()
      -- conditionally use the correct build system for the current OS
      if vim.fn.has("win32") == 1 then
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      else
        return "make"
      end
    end,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- for example
      provider = "llamacpp",
      providers = {
        llamacpp = {
          __inherited_from = "openai",
          endpoint = "http://localhost:7000/v1",
          api_key_name = "durr",
          model = "doesthismatter",
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        moonshot = {
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or nvim-mini/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },

          -- just a reminder that this exists:
          -- anti_conceal = {
          -- enabled = true,
          -- ignore = {
          --   "...",
          -- },

          html = {
            -- Turn on / off all HTML rendering.
            enabled = true,
            -- Additional modes to render HTML.
            render_modes = false,
            comment = {
              -- Turn on / off HTML comment concealing.
              conceal = false,
              -- Optional text to inline before the concealed comment.
              text = nil,
              -- Highlight for the inlined text.
              highlight = "RenderMarkdownHtmlComment",
            },
            -- HTML tags whose start and end will be hidden and icon shown.
            -- The key is matched against the tag name, value type below.
            -- | icon            | optional icon inlined at start of tag           |
            -- | highlight       | optional highlight for the icon                 |
            -- | scope_highlight | optional highlight for item associated with tag |
            tag = {},
          },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
