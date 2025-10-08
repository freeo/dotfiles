-- Kalisi Core Syntax Highlights
-- Returns a function that generates highlights based on palette

return function(c)
  return {
    -- Comments
    Comment = { fg = c.purpleComment, bold = vim.o.background == "light" },
    CommentURL = { fg = c.blueLight, underline = true },
    CommentEmail = { fg = c.blueLight, underline = true },
    SpecialComment = { fg = c.blue, bold = true },

    -- Constants
    Constant = { fg = c.blueDark, bold = true },
    String = { fg = c.blueDark },
    Character = { fg = c.purplePale, bold = true },
    Number = { fg = c.blueSky },
    Boolean = { fg = c.green, bold = vim.o.background == "light" },
    Float = { fg = c.teal },

    -- Identifiers
    Identifier = { fg = vim.o.background == "light" and "#202090" or c.blueLight },
    Function = { fg = c.blueFunction },

    -- Statements
    Statement = { fg = c.green, bold = true },
    Conditional = { fg = c.blueFunction, bold = true },
    Repeat = { fg = c.blueFunction, bold = true },
    Label = { fg = vim.o.background == "light" and "#007700" or c.green, bold = true },
    Operator = { fg = vim.o.background == "light" and "#274aac" or c.blue },
    Exception = { fg = vim.o.background == "light" and "#005090" or c.blueLight, bold = true },
    Keyword = { fg = c.green },

    -- Preprocessor
    PreProc = { fg = c.magenta, bold = true },
    Include = { fg = c.magenta, bold = true },
    Define = { fg = c.magenta, bold = true },
    Macro = { fg = vim.o.background == "light" and c.red or c.redOff, bold = true },
    PreCondit = { fg = c.blueFunction },

    -- Types
    Type = { fg = c.orangeType },
    StorageClass = { fg = vim.o.background == "light" and "#0000d7" or c.blue, italic = true },
    Structure = { fg = vim.o.background == "light" and "#274aac" or c.blue },
    Typedef = { fg = vim.o.background == "light" and "#274aac" or c.blue, italic = true },

    -- Special
    Special = { fg = c.orange, bold = true },
    SpecialChar = { fg = c.redOff, bold = true },
    Tag = { fg = vim.o.background == "light" and "#0010ff" or c.blueLight, bold = true },
    Delimiter = { fg = c.magenta, bold = true },
    Debug = { fg = vim.o.background == "light" and "#ddb800" or c.yellow, bold = true },

    -- Underlined
    Underlined = { fg = c.fg, underline = true },

    -- Todo
    Todo = { fg = vim.o.background == "light" and "#000000" or c.todoFg, bg = vim.o.background == "light" and c.yellow or c.todoBg, bold = true },

    -- Error (exact from original)
    Error = { fg = vim.o.background == "light" and c.red or c.errorFg, bg = vim.o.background == "light" and c.bgError or c.errorBg, bold = true, underline = true },
    ErrorMsg = { fg = vim.o.background == "light" and c.red or c.errorMsgFg, bg = vim.o.background == "light" and c.bgError or c.errorMsgBg, bold = true },

    -- Treesitter modern syntax
    ["@variable"] = { fg = vim.o.background == "light" and "#000000" or c.fg },
    ["@variable.builtin"] = { fg = c.purplePale, italic = true },
    ["@variable.parameter"] = { fg = vim.o.background == "light" and "#202090" or c.blueLight },
    ["@variable.member"] = { fg = vim.o.background == "light" and "#000000" or c.fg },

    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { fg = vim.o.background == "light" and "#0000af" or c.blue, bold = true },
    ["@constant.macro"] = { link = "Macro" },

    ["@string"] = { link = "String" },
    ["@string.documentation"] = { fg = vim.o.background == "light" and "#004B84" or c.blueDark },
    ["@string.regexp"] = { fg = c.magenta },
    ["@string.escape"] = { fg = c.purplePale, bold = true },
    ["@string.special"] = { fg = c.orange, bold = true },
    ["@string.special.path"] = { fg = c.blueDark, underline = true },
    ["@string.special.url"] = { fg = c.blueLight, underline = true },

    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "SpecialChar" },

    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.orangeType, italic = true },
    ["@type.definition"] = { fg = vim.o.background == "light" and "#274aac" or c.blue, bold = true },

    ["@attribute"] = { fg = c.purplePale },
    ["@property"] = { fg = vim.o.background == "light" and "#202090" or c.blueLight },

    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = c.blueFunction, italic = true },
    ["@function.call"] = { fg = c.blueFunction },
    ["@function.macro"] = { link = "Macro" },
    ["@function.method"] = { fg = c.blueFunction },
    ["@function.method.call"] = { fg = c.blueFunction },

    ["@constructor"] = { fg = c.orangeType, bold = true },
    ["@operator"] = { link = "Operator" },

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.conditional"] = { link = "Conditional" },
    ["@keyword.repeat"] = { link = "Repeat" },
    ["@keyword.return"] = { fg = c.green, bold = true },
    ["@keyword.operator"] = { link = "Operator" },
    ["@keyword.function"] = { fg = c.green, bold = true },
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.exception"] = { link = "Exception" },

    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "SpecialComment" },
    ["@comment.todo"] = { link = "Todo" },
    ["@comment.warning"] = { fg = c.orangeDark, bg = c.bgWarningLight, bold = true },
    ["@comment.error"] = { fg = c.red, bg = c.bgErrorLight, bold = true },

    ["@punctuation.delimiter"] = { fg = c.magenta, bold = true },
    ["@punctuation.bracket"] = { fg = vim.o.background == "light" and "#000000" or c.fg },
    ["@punctuation.special"] = { fg = c.magenta, bold = true },

    ["@tag"] = { link = "Tag" },
    ["@tag.attribute"] = { fg = c.purple },
    ["@tag.delimiter"] = { fg = c.magenta },

["@module"] = { fg = vim.o.background == "light" and "#202090" or c.blueLight },
  ["@label"] = { link = "Label" },

  -- Markdown-specific comment highlights
  ["@markup.comment.markdown"] = { fg = c.purpleComment, bold = vim.o.background == "light" },
  ["@markup.comment.documentation.markdown"] = { fg = c.blueLight, bold = true },
  }
end