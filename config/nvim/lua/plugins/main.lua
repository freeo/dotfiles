return {
  {'freeo/vim-kalisi', branch='dev-0.9'},
  'mhinz/vim-startify',
  'rhysd/clever-f.vim',
  'tomtom/tcomment_vim',
  'ctrlpvim/ctrlp.vim',
  'bling/vim-airline',
  'vim-airline/vim-airline-themes',
  'Shougo/denite.nvim',
  -- TODO: do I need this if I use denite?,
  'cloudhead/neovim-fuzzy',
  'Shougo/neoyank.vim',
  'mileszs/ack.vim',
  'majutsushi/tagbar', -- TagbarToggle, side buffer with all tags. ,
  -- Plug 'davidhalter/jedi-vim',
  'luochen1990/rainbow',
  'elzr/vim-json',
  'tpope/vim-fugitive',
  'tpope/vim-markdown',
  'kana/vim-vspec',
  'ervandew/supertab',
  'vim-scripts/restore_view.vim',
  'junegunn/vim-emoji',
  'ryanoasis/vim-devicons',
  'airblade/vim-gitgutter',
  'etdev/vim-hexcolor',
  'jpalardy/vim-slime',
  'Chiel92/vim-autoformat',
  'mattn/emmet-vim', -- completion doesn't work ootb with vscode,
  'towolf/vim-helm',
  'machakann/vim-highlightedyank',
  'google/vim-jsonnet',
  'Shougo/defx.nvim',
  'lambdalisue/fern.vim',
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-telescope/telescope.nvim',
  'junegunn/fzf.vim',
  {'nvim-treesitter/nvim-treesitter', build=':TSUpdate'},
  'nvim-treesitter/nvim-treesitter-refactor',
  -- Plug 'neovim/nvim-lspconfig',
  -- Plug 'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'mfussenegger/nvim-dap',
  'mxsdev/nvim-dap-vscode-js',
  {'fatih/vim-go', build=':GoUpdateBinaries' },
  'folke/which-key.nvim',
  'shime/vim-livedown',
  'fourjay/vim-password-store',
  'nanotee/zoxide.vim',
  -- Plug 'liuchengxu/vim-clap',
  'jvgrootveld/telescope-zoxide',
  {'mg979/vim-visual-multi', branch='master'},
  'lambdalisue/vim-suda',
  'ojroques/vim-oscyank', -- OSC52,

  -- neovim only, old distinguishment

  'equalsraf/neovim-gui-shim',
  'Shougo/deol.nvim',
  'nvim-orgmode/orgmode',
  'mtdl9/vim-log-highlighting',
  'SmiteshP/nvim-navic',
  'rmagatti/goto-preview',
  -- Plug 'someone-stole-my-name/yaml-companion.nvim'
  {'msvechla/yaml-companion.nvim', branch='kubernetes_crd_detection'},
  -- {'L3MON4D3/LuaSnip', tag='v2.*', build='make install_jsregexp'},
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*", 
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  'saadparwaiz1/cmp_luasnip',

  -- Plug 'SirVer/ultisnips' " move to luasnip
  'honza/vim-snippets',
  'thinca/vim-ref',

  -- Syntax
  -- Plug 'git@bitbucket.org:freeo/vimtext-projectsens.git'
  'anntzer/python-syntax',
  'othree/html5.vim',
  'octol/vim-cpp-enhanced-highlight',
  'leafgarland/typescript-vim',
  'pangloss/vim-javascript',
  'hashivim/vim-terraform',
  'evanleck/vim-svelte',
  {
    enabled = vim.fn.has("win64") == 1,
    'vim-scripts/Windows-PowerShell-Syntax-Plugin',
  },
  {
    enabled = vim.fn.has("win32") == 1,
    'obaland/vfiler.vim',
  },
  {
    enabled = vim.fn.has("win32") ~= 1,
    'kevinhwang91/rnvimr',
  }
}

-- no neovim, fallback

-- 'tpope/vim-vinegar'
-- 'roxma/nvim-yarp'
-- if !has('mac')
--   -- Plug 'Shougo/deoplete.nvim'
--   'roxma/vim-hug-neovim-rpc'
-- endif
