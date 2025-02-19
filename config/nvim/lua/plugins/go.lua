return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
      vscode.getconfigs()
    end,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "delve" } },
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
        -- https://github.com/leoluz/nvim-dap-go/issues/43
        config = function()
          require("dap-go").setup({

            -- require('dap.ext.vscode').load_launchjs(nil, {})
            -- global port
            -- delve = {
            --   port = "2346",
            -- },
            dap_configurations = {
              {
                type = "go",
                name = "Attach remote 2345",
                mode = "remote",
                request = "attach",
                debugAdapter = "dlv-dap",
                port = "2345",
                host = "127.0.0.1",
                -- args = require("dap-go").get_arguments,
                -- buildFlags = require("dap-go").get_build_flags,
                -- doesn't work properly! Don't use dlv debug, rather dlv exec
                -- substitutePath = {
                --   {
                --     from = "${workspaceFolder}",
                --     to = "/app",
                --     -- to = "/app",
                --     -- to = "/app/cmd/server",
                --   },
                -- },
              },
              {
                type = "go",
                name = "Attach remote 2346",
                mode = "remote",
                request = "attach",
                -- cwd = "${workspaceRoot}",
                -- host = "127.0.0.1",
                -- debugAdapter = "dlv-dap",
                port = "2346",
                substitutePath = {
                  {
                    from = "${workspaceRoot}",
                    to = "/app",
                  },
                  {
                    from = "/app",
                    to = "${workspaceRoot}",
                  },
                },
              },
              {
                type = "go",
                name = "Debug (Build Flags)",
                request = "launch",
                program = "${file}",
                buildFlags = require("dap-go").get_build_flags,
              },
              {
                type = "go",
                name = "Debug (Build Flags & Arguments)",
                request = "launch",
                program = "${file}",
                args = require("dap-go").get_arguments,
                buildFlags = require("dap-go").get_build_flags,
              },
            },
          })
        end,
      },
    },
  },
  -- {
  --   "ray-x/guihua.lua",
  --   lazy = true,
  --   build = "cd lua/fzy && make",
  -- },
  --
  -- -- Navigator (Code Navigation Tool)
  -- {
  --   "ray-x/navigator.lua",
  --   dependencies = {
  --     "ray-x/guihua.lua",
  --   },
  --   config = function()
  --     -- require("navigator").setup({
  --     --   debug = false, -- log output, set to true and log path: ~/.cache/nvim/gh.log
  --     --   -- slowdownd startup and some actions
  --     --   width = 0.75, -- max width ratio (number of cols for the floating window) / (window width)
  --     --   height = 0.3, -- max list window height, 0.3 by default
  --     --   preview_height = 0.35, -- max height of preview windows
  --     --   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
  --     --   -- 'shadow', or a list of chars which defines the border
  --     --   on_attach = function(client, bufnr)
  --     --     -- your hook
  --     --   end,
  --     --   -- put a on_attach of your own here, e.g
  --     --   -- function(client, bufnr)
  --     --   --   -- the on_attach will be called at end of navigator on_attach
  --     --   -- end,
  --     --   -- The attach code will apply to all LSP clients
  --     --
  --     --   ts_fold = {
  --     --     enable = false,
  --     --     comment_fold = true, -- fold with comment string
  --     --     max_lines_scan_comments = 20, -- only fold when the fold level higher than this value
  --     --     disable_filetypes = { "help", "guihua", "text" }, -- list of filetypes which doesn't fold using treesitter
  --     --   }, -- modified version of treesitter folding
  --     --   default_mapping = true, -- set to false if you will remap every key
  --     --   keymaps = { { key = "gK", func = vim.lsp.declaration, desc = "declaration" } }, -- a list of key maps
  --     --   -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
  --     --   -- please check mapping.lua for all keymaps
  --     --   -- rule of overriding: if func and mode ('n' by default) is same
  --     --   -- the key will be overridden
  --     --   treesitter_analysis = true, -- treesitter variable context
  --     --   treesitter_navigation = true, -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
  --     --   --lang using TS navigation
  --     --   treesitter_analysis_max_num = 100, -- how many items to run treesitter analysis
  --     --   treesitter_analysis_condense = true, -- condense form for treesitter analysis
  --     --   -- this value prevent slow in large projects, e.g. found 100000 reference in a project
  --     --   transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
  --     --
  --     --   lsp_signature_help = true, -- if you would like to hook ray-x/lsp_signature plugin in navigator
  --     --   -- setup here. if it is nil, navigator will not init signature help
  --     --   signature_help_cfg = nil, -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
  --     --   icons = { -- refer to lua/navigator.lua for more icons config
  --     --     -- requires nerd fonts or nvim-web-devicons
  --     --     icons = true,
  --     --     -- Code action
  --     --     code_action_icon = "🏏", -- note: need terminal support, for those not support unicode, might crash
  --     --     -- Diagnostics
  --     --     diagnostic_head = "🐛",
  --     --     diagnostic_head_severity_1 = "🈲",
  --     --     fold = {
  --     --       prefix = "⚡", -- icon to show before the folding need to be 2 spaces in display width
  --     --       separator = "", -- e.g. shows   3 lines 
  --     --     },
  --     --   },
  --     --   mason = false, -- set to true if you would like use the lsp installed by williamboman/mason
  --     --   lsp = {
  --     --     enable = true, -- skip lsp setup, and only use treesitter in navigator.
  --     --     -- Use this if you are not using LSP servers, and only want to enable treesitter support.
  --     --     -- If you only want to prevent navigator from touching your LSP server configs,
  --     --     -- use `disable_lsp = "all"` instead.
  --     --     -- If disabled, make sure add require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client}) in your
  --     --     -- own on_attach
  --     --     code_action = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
  --     --     code_lens_action = { enable = true, sign = true, sign_priority = 40, virtual_text = true },
  --     --     document_highlight = true, -- LSP reference highlight,
  --     --     -- it might already supported by you setup, e.g. LunarVim
  --     --     format_on_save = true, -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
  --     --     -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
  --     --     -- enable: a whitelist of language that will be formatted on save
  --     --     -- disable: a blacklist of language that will not be formatted on save
  --     --     -- function: function(bufnr) return true end to enable/disable lsp format on save
  --     --     format_options = { async = false }, -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
  --     --     disable_format_cap = { "sqlls", "lua_ls", "gopls" }, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
  --     --     -- If you using null-ls and want null-ls format your code
  --     --     -- you should disable all other lsp and allow only null-ls.
  --     --     -- disable_lsp = {'pylsd', 'sqlls'},  -- prevents navigator from setting up this list of servers.
  --     --     -- if you use your own LSP setup, and don't want navigator to setup
  --     --     -- any LSP server for you, use `disable_lsp = "all"`.
  --     --     -- you may need to add this to your own on_attach hook:
  --     --     -- require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client})
  --     --     -- for e.g. denols and tsserver you may want to enable one lsp server at a time.
  --     --     -- default value: {}
  --     --     diagnostic = {
  --     --       underline = true,
  --     --       virtual_text = true, -- show virtual for diagnostic message
  --     --       update_in_insert = false, -- update diagnostic message in insert mode
  --     --       float = { -- setup for floating windows style
  --     --         focusable = false,
  --     --         sytle = "minimal",
  --     --         border = "rounded",
  --     --         source = "always",
  --     --         header = "",
  --     --         prefix = "",
  --     --       },
  --     --     },
  --     --
  --     --     hover = {
  --     --       enable = true,
  --     --       -- fallback when hover failed
  --     --       -- e.g. if filetype is go, try godoc
  --     --       go = function()
  --     --         local w = vim.fn.expand("<cWORD>")
  --     --         vim.cmd("GoDoc " .. w)
  --     --       end,
  --     --       -- if python, do python doc
  --     --       python = function()
  --     --         -- run pydoc, behaviours defined in lua/navigator.lua
  --     --       end,
  --     --       default = function()
  --     --         -- fallback apply to all file types not been specified above
  --     --         -- local w = vim.fn.expand('<cWORD>')
  --     --         -- vim.lsp.buf.workspace_symbol(w)
  --     --       end,
  --     --     },
  --     --
  --     --     diagnostic_scrollbar_sign = { "▃", "▆", "█" }, -- experimental:  diagnostic status in scroll bar area; set to false to disable the diagnostic sign,
  --     --     --                for other style, set to {'╍', 'ﮆ'} or {'-', '='}
  --     --     diagnostic_virtual_text = true, -- show virtual for diagnostic message
  --     --     diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
  --     --     display_diagnostic_qf = true, -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
  --     --     -- set to 'trouble' to show diagnostcs in Trouble
  --     --     ts_ls = {
  --     --       filetypes = { "typescript" }, -- disable javascript etc,
  --     --       -- set to {} to disable the lspclient for all filetypes
  --     --     },
  --     --     ctags = {
  --     --       cmd = "ctags",
  --     --       tagfile = "tags",
  --     --       options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number",
  --     --     },
  --     --     gopls = { -- gopls setting
  --     --       on_attach = function(client, bufnr) -- on_attach for gopls
  --     --         -- your special on attach here
  --     --         -- e.g. disable gopls format because a known issue https://github.com/golang/go/issues/45732
  --     --         print("i am a hook, I will disable document format")
  --     --         client.resolved_capabilities.document_formatting = false
  --     --       end,
  --     --       settings = {
  --     --         gopls = { gofumpt = false }, -- disable gofumpt etc,
  --     --       },
  --     --     },
  --     --     -- the lsp setup can be a function, .e.g
  --     --     gopls = function()
  --     --       local go = pcall(require, "go")
  --     --       if go then
  --     --         local cfg = require("go.lsp").config()
  --     --         cfg.on_attach = function(client)
  --     --           client.server_capabilities.documentFormattingProvider = false -- efm/null-ls
  --     --         end
  --     --         return cfg
  --     --       end
  --     --     end,
  --     --
  --     --     lua_ls = {
  --     --       sumneko_root_path = vim.fn.expand("$HOME") .. "/github/sumneko/lua-language-server",
  --     --       sumneko_binary = vim.fn.expand("$HOME")
  --     --         .. "/github/sumneko/lua-language-server/bin/macOS/lua-language-server",
  --     --     },
  --     --     servers = { "cmake", "ltex" }, -- by default empty, and it should load all LSP clients available based on filetype
  --     --     -- but if you want navigator load  e.g. `cmake` and `ltex` for you , you
  --     --     -- can put them in the `servers` list and navigator will auto load them.
  --     --     -- you could still specify the custom config  like this
  --     --     -- cmake = {filetypes = {'cmake', 'makefile'}, single_file_support = false},
  --     --   },
  --     -- })
  --   end,
  -- },

  -- Go.nvim (Go Development Plugin)
  -- {
  --   "ray-x/go.nvim",
  --   dependencies = { -- optional packages
  --     "ray-x/guihua.lua",
  --     "neovim/nvim-lspconfig",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     require("go").setup()
  --   end,
  --   event = { "CmdlineEnter" },
  --   ft = { "go", "gomod" },
  --   build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  -- },
}
