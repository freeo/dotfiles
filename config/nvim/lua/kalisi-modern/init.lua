-- Kalisi Modern - Zero-configuration theme with automatic dark mode
-- Modular architecture inspired by Catppuccin, simplicity inspired by Kalisi
--
-- Usage: require("kalisi-modern").setup()
-- That's it! No configuration needed.

local M = {}

-- Cache for loaded integrations
local loaded_integrations = {}

-- Get the appropriate palette based on background
local function get_palette()
  local bg = vim.o.background
  return require("kalisi-modern.palettes." .. bg)
end

-- Check if a plugin is available (without loading it)
local function has_plugin(plugin)
  -- First check if it's already in package.loaded (already loaded)
  if package.loaded[plugin] then
    return true
  end

  -- Check common vim globals for plugin detection
  if plugin == "gitsigns" then
    return vim.fn.exists("*gitsigns#*") == 1 or vim.g.loaded_gitsigns ~= nil
  elseif plugin == "telescope" then
    return vim.fn.exists("*telescope#*") == 1 or vim.g.loaded_telescope ~= nil
  elseif plugin == "nvim-cmp" or plugin == "cmp" then
    return vim.fn.exists("*cmp#*") == 1 or vim.g.loaded_cmp ~= nil
  elseif plugin == "nvim-tree" then
    return vim.g.loaded_nvim_tree ~= nil or vim.g.NvimTreeSetup ~= nil
  elseif plugin == "neo-tree" then
    return vim.fn.exists("g:neo_tree_remove_legacy_commands") == 1
  elseif plugin == "nvim-treesitter" then
    return vim.g.loaded_nvim_treesitter ~= nil
  elseif plugin == "snacks.nvim" or plugin == "snacks" then
    return vim.g.loaded_snacks ~= nil
  elseif plugin == "lualine" or plugin == "lualine.nvim" then
    return package.loaded["lualine"] ~= nil or vim.g.loaded_lualine ~= nil
  elseif plugin == "nvim-navic" then
    return package.loaded["nvim-navic"] ~= nil
  end

  -- Fallback: check if plugin directory exists (for lazy.nvim)
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/" .. plugin
  if vim.fn.isdirectory(lazy_path) == 1 then
    return true
  end

  return false
end

-- Lazy load plugin integrations
local function load_integration(name, palette)
  if loaded_integrations[name] then
    return loaded_integrations[name]
  end

  local ok, integration = pcall(require, "kalisi-modern.integrations." .. name)
  if ok then
    loaded_integrations[name] = integration(palette)
    return loaded_integrations[name]
  end
  return {}
end

-- Get all plugin integrations (lazy loaded)
local function get_integrations(palette)
  local highlights = {}

  -- Map of plugin checks to integration names
  local plugin_map = {
    ["gitsigns"] = "gitsigns",
    ["telescope"] = "telescope",
    ["nvim-cmp"] = "cmp",
    ["cmp"] = "cmp",
    ["nvim-tree"] = "nvimtree",
    ["neo-tree"] = "nvimtree",
    ["nvim-treesitter"] = "treesitter",
    ["snacks.nvim"] = "snacks",
    ["snacks"] = "snacks",
    ["lualine"] = "lualine",
    ["lualine.nvim"] = "lualine",
  }

  -- Auto-detect and load plugin integrations
  for plugin, integration_name in pairs(plugin_map) do
    if has_plugin(plugin) then
      local ok, plugin_highlights = pcall(load_integration, integration_name, palette)
      if ok and plugin_highlights then
        highlights = vim.tbl_extend("force", highlights, plugin_highlights or {})
      end
    end
  end

  -- Always load misc integrations (they have checks inside)
  local ok, misc_highlights = pcall(load_integration, "misc", palette)
  if ok and misc_highlights then
    highlights = vim.tbl_extend("force", highlights, misc_highlights or {})
  end

  -- Always load lualine integration for consistent statusline
  local ok_lualine, lualine_highlights = pcall(load_integration, "lualine", palette)
  if ok_lualine and lualine_highlights then
    highlights = vim.tbl_extend("force", highlights, lualine_highlights or {})
  end

  return highlights
end

-- Apply highlights
local function apply_highlights(highlights)
  -- Clear existing highlights
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end

  -- Set Neovim options
  vim.o.termguicolors = true
  vim.g.colors_name = "kalisi-modern"

  -- Apply each highlight
  for group, opts in pairs(highlights) do
    if opts.link then
      vim.api.nvim_set_hl(0, group, { link = opts.link })
    else
      vim.api.nvim_set_hl(0, group, opts)
    end
  end

  -- Set terminal colors if available
  local palette = get_palette()
  if palette.terminal then
    for i = 0, 15 do
      local colors = {
        palette.terminal.black,
        palette.terminal.red,
        palette.terminal.green,
        palette.terminal.yellow,
        palette.terminal.blue,
        palette.terminal.magenta,
        palette.terminal.cyan,
        palette.terminal.white,
        palette.terminal.brightBlack,
        palette.terminal.brightRed,
        palette.terminal.brightGreen,
        palette.terminal.brightYellow,
        palette.terminal.brightBlue,
        palette.terminal.brightMagenta,
        palette.terminal.brightCyan,
        palette.terminal.brightWhite,
      }
      vim.g["terminal_color_" .. i] = colors[i + 1]
    end
  end
end

-- Main setup function
function M.setup()
  -- Get current palette
  local ok, palette = pcall(get_palette)
  if not ok then
    vim.notify("kalisi-modern: Failed to load palette", vim.log.levels.ERROR)
    return
  end

  -- Build highlights
  local highlights = {}

  -- Load core highlights with error handling
  local ok_syntax, syntax = pcall(require, "kalisi-modern.core.syntax")
  if ok_syntax and syntax then
    local syntax_highlights = syntax(palette)
    highlights = vim.tbl_extend("force", highlights, syntax_highlights or {})
  end

  local ok_editor, editor = pcall(require, "kalisi-modern.core.editor")
  if ok_editor and editor then
    local editor_highlights = editor(palette)
    highlights = vim.tbl_extend("force", highlights, editor_highlights or {})
  end

  -- Load plugin integrations (lazy)
  local integrations = get_integrations(palette)
  highlights = vim.tbl_extend("force", highlights, integrations)

  -- Apply all highlights
  apply_highlights(highlights)

  -- Set lualine theme if lualine is loaded
  if package.loaded["lualine"] then
    pcall(function()
      require("lualine").setup({
        options = {
          theme = "kalisi-modern"
        }
      })
    end)
  end

  -- Clear cache when background changes
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      -- Clear integration cache
      loaded_integrations = {}
      -- Reapply theme
      M.setup()
    end,
  })
end

-- Backward compatibility: allow direct call
function M.load()
  M.setup()
end

-- Auto-load if called directly
setmetatable(M, {
  __call = function(_, ...)
    M.setup(...)
  end,
})

return M