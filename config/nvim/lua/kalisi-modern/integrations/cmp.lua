-- Kalisi nvim-cmp Integration
-- Only loads if cmp is detected

return function(c)
  return {
    -- Base
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrDeprecated = { fg = c.gray, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.blue, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.blue },
    CmpItemMenu = { fg = c.gray },
    CmpItemKind = { fg = c.purple },

    -- Item kinds
    CmpItemKindText = { fg = c.fg },
    CmpItemKindMethod = { fg = c.blueFunction },
    CmpItemKindFunction = { fg = c.blueFunction },
    CmpItemKindConstructor = { fg = c.orangeType },
    CmpItemKindField = { fg = vim.o.background == "light" and "#202090" or c.blueLight },
    CmpItemKindVariable = { fg = c.fg },
    CmpItemKindClass = { fg = c.orangeType },
    CmpItemKindInterface = { fg = vim.o.background == "light" and "#274aac" or c.blue },
    CmpItemKindModule = { fg = vim.o.background == "light" and "#202090" or c.blueLight },
    CmpItemKindProperty = { fg = vim.o.background == "light" and "#202090" or c.blueLight },
    CmpItemKindUnit = { fg = c.blueSky },
    CmpItemKindValue = { fg = c.green },
    CmpItemKindEnum = { fg = vim.o.background == "light" and "#274aac" or c.blue },
    CmpItemKindKeyword = { fg = c.green },
    CmpItemKindSnippet = { fg = c.purplePale },
    CmpItemKindColor = { fg = c.orange },
    CmpItemKindFile = { fg = c.blueDark },
    CmpItemKindReference = { fg = c.blueLight },
    CmpItemKindFolder = { fg = c.blueDark, bold = true },
    CmpItemKindEnumMember = { fg = c.teal },
    CmpItemKindConstant = { fg = vim.o.background == "light" and "#0000af" or c.blue },
    CmpItemKindStruct = { fg = vim.o.background == "light" and "#274aac" or c.blue },
    CmpItemKindEvent = { fg = c.orange },
    CmpItemKindOperator = { fg = vim.o.background == "light" and "#274aac" or c.blue },
    CmpItemKindTypeParameter = { fg = vim.o.background == "light" and "#0000d7" or c.blue },
    CmpItemKindCopilot = { fg = c.purple, italic = true },
  }
end