-- Kalisi Treesitter Integration
-- Enhanced treesitter-specific highlights

return function(c)
  return {
    -- Treesitter context
    TreesitterContext = { bg = vim.o.background == "light" and "#f8f8f8" or c.grayBg },
    TreesitterContextLineNumber = { fg = c.gray, bg = vim.o.background == "light" and "#f8f8f8" or c.grayBg },
    TreesitterContextBottom = { underline = true, sp = c.gray },

    -- Rainbow brackets
    RainbowDelimiterRed = { fg = c.redOff },
    RainbowDelimiterYellow = { fg = c.orange },
    RainbowDelimiterBlue = { fg = c.blue },
    RainbowDelimiterOrange = { fg = c.orangeDark },
    RainbowDelimiterGreen = { fg = c.green },
    RainbowDelimiterViolet = { fg = c.purple },
    RainbowDelimiterCyan = { fg = c.teal },

    -- Illuminate (word references)
    IlluminatedWordText = { bg = c.bgInfoLight },
    IlluminatedWordRead = { bg = c.bgInfoLight },
    IlluminatedWordWrite = { bg = vim.o.background == "light" and "#fff0f8" or c.bgHintLight },
    IlluminatedCurWord = { bg = vim.o.background == "light" and "#e8f4ff" or c.bgInfoLight },

    -- Semantic tokens (LSP)
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.macro"] = { link = "@macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { link = "@type" },
    ["@lsp.type.variable"] = { link = "@variable" },

    -- Indent guides
    IndentBlanklineChar = { fg = c.grayLighter },
    IndentBlanklineContextChar = { fg = c.grayLight },
    IndentBlanklineSpaceChar = { fg = c.grayLighter },
    IblIndent = { fg = c.grayLighter },
    IblScope = { fg = c.grayLight },
  }
end