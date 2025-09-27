-- Kalisi Telescope Integration
-- Only loads if telescope is detected

return function(c)
  return {
    TelescopeNormal = { fg = c.fg, bg = c.grayBgLighter },
    TelescopeBorder = { fg = c.gray, bg = c.grayBgLighter },
    TelescopePromptNormal = { fg = c.fg, bg = vim.o.background == "light" and "NONE" or c.bg },
    TelescopePromptBorder = { fg = c.blueFunction, bg = vim.o.background == "light" and "NONE" or c.bg },
    TelescopePromptTitle = { fg = c.blueFunction, bg = vim.o.background == "light" and "NONE" or c.bg, bold = true },
    TelescopePromptPrefix = { fg = c.blue },
    TelescopePromptCounter = { fg = c.gray },
    TelescopePreviewTitle = { fg = c.green, bg = c.grayBgLighter, bold = true },
    TelescopeResultsTitle = { fg = c.purple, bg = c.grayBgLighter, bold = true },
    TelescopeSelection = { bg = c.yellowSearch },
    TelescopeSelectionCaret = { fg = c.blue, bg = c.yellowSearch },
    TelescopeMultiSelection = { bg = vim.o.background == "light" and "#ffe0ff" or c.bgHintLight },
    TelescopeMatching = { fg = c.blue, bold = true },
    TelescopeResultsDiffAdd = { fg = c.green },
    TelescopeResultsDiffChange = { fg = c.orange },
    TelescopeResultsDiffDelete = { fg = c.red },
  }
end