-- vim.cmd('source ~/.config/nvim/vimrc')

local vimrc_path = vim.fn.stdpath('config') .. '/vimrc'

if vim.fn.filereadable(vimrc_path) == 1 then
    vim.cmd('source ' .. vimrc_path)
else
    print("vimrc file not found at: " .. vimrc_path)
end

-- require('init')
-- require('options')
-- require('plugins')
-- require('mappings')

if vim.g.vscode == nil then

  local function has_yamlls()
    return vim.fn.executable("yaml-language-server") == 1
  end

  -- SUDA - smarter auto-sudo
  vim.g.suda_smart_edit = 1

  local ls = require("luasnip")
  require("luasnip.loaders.from_snipmate").lazy_load()

  vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
  vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
  vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

  vim.keymap.set({"i", "s"}, "<C-E>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, {silent = true})

  -- Setup nvim-cmp.
  local cmp = require'cmp'


  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        ls.lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
      ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      -- { name = 'lspconfig' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'snippy' }, -- For snippy users.
    -- },
    -- {
    --   { name = 'buffer' },
    })
  })

  ------------
  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  ------------

  -- local lspconfig = require 'lspconfig'

  -- Setup lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- nvim-cmp supports additional completion capabilities
  -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

--     require'lspconfig'.pyright.setup{}
-- 
--     -- Enable the following language servers
--     local servers = { 'lua_ls', 'gopls', 'ts_ls', 'jsonls', 'bashls' }
--     for _, lsp in ipairs(servers) do
--         lspconfig[lsp].setup {
--             on_attach = on_attach_common,
--             capabilities = capabilities,
--         }
--     end
-- 
--     -- Set up yaml-companion separately, as it requires yaml-language-server and treesitter
    -- if has_yamlls() then
      -- vim.notify("has yamlls!")
      -- local yaml_companion = require("yaml-companion")
      -- yaml_companion.setup({
      --     lspconfig = {
      --         on_attach = on_attach_common,
      --         capabilities = capabilities,
      --     }
      -- })
    -- end

  vim.o.completeopt = 'menu,menuone,noselect'

  local navic = require("nvim-navic")

  local on_attach_common = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc',  'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>o', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<Leader>K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('v', '<Leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

    -- if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
    -- end
  end



--   require'lspconfig'.gopls.setup{
--
--     cmd = {"gopls", "serve"},
-- }
  -- GOPLS {{{
  -- require'lspconfig'.gopls.setup{
  --   on_attach = on_attach_vim,
  --   capabilities = capabilities,
  --   cmd = {"gopls", "serve"},
  --   settings = {
  --     gopls = {
  --       analyses = {
  --         unusedparams = true,
  --       },
  --       staticcheck = true,
  --       linksInHover = false,
  --       codelens = {
  --         generate = true,
  --         gc_details = true,
  --         regenerate_cgo = true,
  --         tidy = true,
  --         upgrade_depdendency = true,
  --         vendor = true,
  --       },
  --       usePlaceholders = true,
  --     },
  --   }
  -- }
  --

  -- require'lspconfig'.tsserver.setup{}
  -- require'lspconfig'.jsonnet_ls.setup{}
  -- require'lspconfig'.pyright.setup{}


  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }

--  lspconfig.yamlls.setup {
--    on_attach = function(client, bufnr)
--      -- Custom keybindings or other settings can be added here
--      on_attach_common(client, bufnr)
--    end,
--    flags = {
--      debounce_text_changes = 150,
--    },
--    settings = {
--      yaml = {
--        schemas = {
--                kubernetes = "k8s-*.yaml",
--                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
--                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
--                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
--                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
--                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
--                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
--                ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
--              },
--        -- schemas = {
--        --   ["file:///path/to/your/schema.json"] = "*.yaml",
--        -- },
--        format = {
--          enable = true,
--          singleQuote = false,
--          bracketSpacing = true,
--        },
--        validate = true,
--        completion = true,
--      },
--    },
--  }


-- YAML breadcrumbs in airline bottom bar
 navic.setup {
     lsp = {
         auto_attach = true,
         preference = { 'helm_ls', 'yamlls' },
     },
     -- highlight = false,
     separator = "",
     -- depth_limit = 0,
     -- depth_limit_indicator = "..",
     -- safe_output = true,
     -- lazy_update_context = false,
     -- click = false,
     -- format_text = function(text)
     --     return text
     -- end,
   -- defining icons to remove trailing whitespace after the icon to minimize space
   icons = {
       File          = "󰈙",
       Module        = "",
       Namespace     = "󰌗",
       Package       = "",
       Class         = "󰌗",
       Method        = "󰆧",
       Property      = "",
       Field         = "",
       Constructor   = "",
       Enum          = "󰕘",
       Interface     = "󰕘",
       Function      = "󰊕",
       Variable      = "󰆧",
       Constant      = "󰏿",
       String        = "󰀬",
       Number        = "󰎠",
       Boolean       = "◩",
       Array         = "󰅪",
       Object        = "󰅩",
       Key           = "󰌋",
       Null          = "󰟢",
       EnumMember    = "",
       Struct        = "󰌗",
       Event         = "",
       Operator      = "󰆕",
       TypeParameter = "󰊄",
   },
 }


-- lspconfig.helm_ls.setup {
--   settings = {
--     ['helm-ls'] = {
--       yamlls = {
--         path = "yaml-language-server",
--       }
--     }
--   }
-- }



require('goto-preview').setup {
  default_mappings = true,
}


vim.keymap.set('n', '<leader>r1', function()
    vim.cmd('edit /home/freeo/pcloud/cloudkoloss/wb_ck.org')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>r3', function()
    vim.cmd('edit /home/freeo/dotfiles/config/nvim/init.vim')
end, { noremap = true, silent = true })

-- OSC52 force system clipboard provider, for kitty ssh yank/copy & paste
-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     -- ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     -- ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   },
-- }
-- end

-- https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
-- vim.opt.timeoutlen = 500
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "file" }, -- group
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  { "<leader>fn", desc = "New File" },
  { "<leader>f1", hidden = true }, -- hide this keymap
  { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
  { "<leader>b", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    -- Nested mappings are allowed and can be added in any order
    -- Most attributes can be inherited or overridden on any level
    -- There's no limit to the depth of nesting
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  }
})
-- OLD which-key config
  -- require("which-key").setup {
  --  spelling = {
  --     enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
  --     suggestions = 20, -- how many suggestions should be shown in the list?
  --   },
  --  presets = {
  --     operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
  --     motions = true, -- adds help for motions
  --     text_objects = true, -- help for text objects triggered after entering an operator
  --     windows = true, -- default bindings on <c-w>
  --     nav = true, -- misc bindings to work with windows
  --     z = true, -- bindings for folds, spelling and others prefixed with z
  --     g = true, -- bindings for prefixed with g
  --   },
  -- win = {
  --   border = "none", -- none, single, double, shadow
  --   position = "bottom", -- bottom, top
  --   margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
  --   padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  --   winblend = 0
  -- },
  -- layout = {
  --   height = { min = 4, max = 25 }, -- min and max height of the columns
  --   width = { min = 20, max = 50 }, -- min and max width of the columns
  --   spacing = 3, -- spacing between columns
  --   align = "left", -- align columns left, center or right
  -- },
  -- }

  function goimports(timeout_ms)
    local context = { only = { "source.organizeImports" } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end

local t = require("telescope")
local z_utils = require("telescope._extensions.zoxide.utils")
-- XXX telescope-zoxide not working! When I try running ':Telescope zoxide' it throws an error in Telescopes' command.lua
-- revisit this in the future

-- Configure the extension
t.setup({
  extensions = {
    zoxide = {
      prompt_title = "[ Walking on the shoulders of TJ ]",
      mappings = {
        default = {
          after_action = function(selection)
            print("Update to (" .. selection.z_score .. ") " .. selection.path)
          end
        },
        ["<C-s>"] = {
          before_action = function(selection) print("before C-s") end,
          action = function(selection)
            vim.cmd("edit " .. selection.path)
          end
        },
        ["<C-q>"] = { action = z_utils.create_basic_command("split") },
      },
    },
  },
})

-- Load Telescope extensions
t.load_extension('zoxide')
t.load_extension("yaml_schema") -- yaml-companion

-- Add a mapping
vim.keymap.set("n", "<leader>cd", t.extensions.zoxide.list)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><space>', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
vim.keymap.set('n', '<leader>fr', builtin.registers, {})

local function has_compiler()
  return vim.fn.executable("cc") == 1 or
         vim.fn.executable("gcc") == 1 or
         vim.fn.executable("clang") == 1 or
         vim.fn.executable("cl") == 1 or
         vim.fn.executable("zig") == 1
end



if has_compiler() then
require'nvim-treesitter.configs'.setup {
    -- Don't use 'ensure_installed' or face this compile error:
    --     No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable.
    ensure_installed = "python", -- Or "all" to install parsers for all supported languages
    --ensure_installed = "json",
    highlight  = {
      enable = true,
    },
    refactor = {
            navigation = {
              enable = true,
              keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
                },
            },
      },
}

require('orgmode').setup({
  org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
  org_startup_folded = 'showeverything',
})

else
  -- vim.notify("No C compiler found. Treesitter disabled.", vim.log.levels.WARN)
  vim.api.nvim_echo({{"No C compiler found. Treesitter disabled.", "WarningMsg"}}, true, {})
end

-- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
-- add ~org~ to ignore_install
-- require('nvim-treesitter.configs').setup({
--   ensure_installed = 'all',
--   ignore_install = { 'org' },
-- })


-- Create a job to detect current gnome color scheme and set background
local Job = require("plenary.job")
local set_background = function()
	local j = Job:new({ command = "gsettings", args = { "get", "org.gnome.desktop.interface", "color-scheme" } })
	j:sync()
  local r = j:result()[1] 
	if r == "'prefer-light'" or r == "'default'" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end

  -- vim.api.nvim_echo({ { j:result()[1] } }, true, {})
end

-- Call imediately to set initially
set_background()

-- AUTO-DARK
-- Debounce to not call the method too often in case of multiple signals.
local debounce = function(ms, fn)
	local running = false
	return function()
		if running then
			return
		end
		vim.defer_fn(function()
			running = false
		end, ms)
		running = true
		vim.schedule(fn)
	end
end

-- Listen for SIGUSR1 signal to update background
local group = vim.api.nvim_create_augroup("BackgroundWatch", { clear = true })
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = debounce(500, set_background),
	group = group,
})

require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = "/home/freeo/wb/vscode-js-debug", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
      {
        type = "node-terminal",
        request = "launch",
        name = "SvelteKit VaVite ESM",
        command = "pnpm vavite-loader vite dev --port 3000",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require'dap.utils'.pick_process,
        cwd = "${workspaceFolder}",
      }
  }
end

end -- closes "not in vscode"
