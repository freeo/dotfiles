vim.cmd('source ~/.config/nvim/vimrc')

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

end -- closes "not in vscode"


