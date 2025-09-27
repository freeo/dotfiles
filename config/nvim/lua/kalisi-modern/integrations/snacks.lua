-- Kalisi Snacks.nvim Integration
-- Support for the modern Snacks.nvim plugin

return function(c)
  return {
    -- Picker
    SnacksPicker = { fg = c.fg, bg = c.grayBgLighter },
    SnacksPickerBorder = { fg = vim.o.background == "light" and "#808080" or c.gray, bg = c.grayBgLighter },
    SnacksPickerInput = { fg = c.fg, bg = c.grayBgLighter },
    SnacksPickerPrompt = { fg = vim.o.background == "light" and "#ff0000" or c.redOff, bg = c.grayBgLighter, bold = true },
    SnacksPickerFile = { fg = c.fg },
    SnacksPickerDir = { fg = vim.o.background == "light" and "#686880" or c.blueLight, bold = true },
    SnacksPickerCursorLine = { bg = vim.o.background == "light" and "#afff00" or c.greenDark },
    SnacksPickerBoxCursorLine = { bg = vim.o.background == "light" and "#8fdf00" or c.greenDark },
    SnacksPickerListCursorLine = { bg = vim.o.background == "light" and "#afff00" or c.greenDark },
    SnacksPickerTotals = { fg = vim.o.background == "light" and "#303050" or c.grayLight },
    SnacksPickerMatch = { fg = vim.o.background == "light" and "#ff0000" or c.redOff },
    SnacksPickerCol = { fg = c.fg },
    SnacksPickerTree = { fg = c.fg },
    SnacksPickerIconFile = { fg = c.fg },
    SnacksPickerTitle = { fg = c.fg, bg = c.grayBgLighter, bold = true },

    -- Indent
    SnacksIndentScope = { fg = vim.o.background == "light" and "#c0c0c0" or c.grayLight },
    SnacksIndent = { fg = c.grayLighter },

    -- Dashboard
    SnacksDashboardNormal = { fg = c.fg, bg = c.bg },
    SnacksDashboardHeader = { fg = c.blue, bold = true },
    SnacksDashboardFooter = { fg = c.gray, italic = true },
    SnacksDashboardIcon = { fg = c.purple },
    SnacksDashboardDesc = { fg = c.fg },
    SnacksDashboardKey = { fg = c.orange, bold = true },

    -- Notifier
    SnacksNotifierInfo = { fg = c.blue },
    SnacksNotifierWarn = { fg = c.orangeDark },
    SnacksNotifierError = { fg = c.redOff },
    SnacksNotifierDebug = { fg = c.gray },
    SnacksNotifierTrace = { fg = c.purple },
  }
end