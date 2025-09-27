-- Kalisi Core Editor Highlights
-- UI elements and editor interface

return function(c)
  return {
    -- Basic
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { link = "Normal" },
    NormalFloat = { fg = vim.o.background == "light" and "#909090" or c.normalFloat, bg = vim.o.background == "light" and c.grayBgLighter or c.bgFloat },

    -- Cursor (exact colors from original)
    Cursor = { fg = "#ffffff", bg = vim.o.background == "light" and "#ff0000" or "#d80000" },
    lCursor = { fg = "#ffffff", bg = vim.o.background == "light" and "#ff0000" or "#d80000" },
    TermCursor = { fg = "#ffffff", bg = vim.o.background == "light" and "#ff0000" or "#d80000" },
    TermCursorNC = { fg = "#ffffff", bg = c.gray },
    CursorLine = { bg = c.bgCursorLine },
    CursorColumn = { bg = vim.o.background == "light" and c.bgCursorLine or c.bgCursorCol },
    CursorLineNr = { fg = vim.o.background == "light" and c.grayLighter or c.normal, bg = vim.o.background == "light" and c.graySignBg or "#482020", bold = true },

    -- Visual
    Visual = { bg = c.bgVisual },
    VisualNOS = { bg = vim.o.background == "light" and c.bgVisualNOS or c.bgVisualNOS },

    -- Search (exact colors from original)
    Search = { fg = vim.o.background == "light" and "#000000" or "#000000", bg = vim.o.background == "light" and c.yellowSearch or c.bgSearch, bold = vim.o.background == "dark" },
    IncSearch = { fg = vim.o.background == "light" and c.yellowSearchInc or c.fgSearchInc, bg = "#000000" },
    CurSearch = { link = "IncSearch" },

    -- Match
    MatchParen = { fg = vim.o.background == "light" and "#ffffff" or "#202020", bg = vim.o.background == "light" and c.yellowGold or c.bgMatchParen, bold = vim.o.background == "light" },

    -- Diff
    DiffAdd = { bg = c.bgDiffAdd },
    DiffChange = { bg = c.bgDiffChange },
    DiffDelete = { fg = vim.o.background == "light" and "#eecccc" or c.fgDiffDelete, bg = c.bgDiffDelete },
    DiffText = { fg = vim.o.background == "light" and "#000055" or c.grayLighter, bg = c.bgDiffText },

    -- Spell (exact colors from original)
    SpellBad = { sp = vim.o.background == "light" and c.spellRed or c.spellBad, undercurl = true },
    SpellCap = { sp = vim.o.background == "light" and c.spellBlue or c.spellCap, undercurl = true },
    SpellLocal = { sp = vim.o.background == "light" and c.spellGreen or c.spellLocal, undercurl = true },
    SpellRare = { sp = vim.o.background == "light" and c.spellGray or c.spellRare, undercurl = true },

    -- Status & Lines (exact colors from original)
    StatusLine = { fg = vim.o.background == "light" and c.grayLighter or c.statusLineFg, bg = vim.o.background == "light" and c.gray or c.statusLineBg },
    StatusLineNC = { fg = vim.o.background == "light" and c.grayLighter or c.statusLineNCFg, bg = vim.o.background == "light" and c.grayLight or c.statusLineNCBg },
    WinBar = { fg = c.fg, bg = c.grayBgLight },
    WinBarNC = { fg = c.gray, bg = c.grayBgLighter },
    VertSplit = { fg = vim.o.background == "light" and "#d0d0d0" or "#222222", bg = vim.o.background == "light" and "NONE" or "#2b2b2b" },
    WinSeparator = { link = "VertSplit" },
    LineNr = { fg = vim.o.background == "light" and c.gray or c.grayLineNr, bg = "NONE" },
    SignColumn = { fg = vim.o.background == "light" and c.greenSignColumn or c.graySign, bg = vim.o.background == "light" and "NONE" or c.bg },

    -- Folds
    Folded = { fg = vim.o.background == "light" and c.gray or c.foldedFg, bg = vim.o.background == "light" and c.grayBg or c.foldedBg },
    FoldColumn = { fg = vim.o.background == "light" and c.gray or c.foldColumnFg, bg = vim.o.background == "light" and "#b0b0b0" or c.foldedBg, bold = true },

    -- Tabs (exact from original)
    TabLine = { fg = c.tabFg or "#afd700", bg = c.tabBg or "#005f00" },
    TabLineSel = { fg = c.tabBg or "#005f00", bg = c.tabFg or "#afd700" },
    TabLineFill = { fg = c.tabFillFg or "#303030", bg = c.tabFillBg or "#a0a0a0" },

    -- Popup Menu
    Pmenu = { fg = vim.o.background == "light" and c.fg or c.fg, bg = vim.o.background == "light" and c.grayBg or c.grayBg },
    PmenuSel = { fg = vim.o.background == "light" and "#000000" or c.bg, bg = c.greenDb or c.statusLineBg or "#A6DB29", bold = true },
    PmenuSbar = { bg = "#a0a0a0" },
    PmenuThumb = { bg = "#555555" },

    -- Float windows
    FloatBorder = { fg = c.gray, bg = c.grayBgLighter },
    FloatTitle = { fg = c.fg, bg = c.grayBgLighter, bold = true },
    FloatFooter = { fg = c.gray, bg = c.grayBgLighter },

    -- Messages
    MsgArea = { link = "Normal" },
    ModeMsg = { fg = vim.o.background == "light" and "#000000" or c.bg, bg = c.greenDb or c.statusLineBg or "#A6DB29" },
    MoreMsg = { fg = vim.o.background == "light" and "#000000" or "#000000", bg = c.greenDb or c.statusLineBg or "#A6DB29" },
    Question = { fg = vim.o.background == "light" and "#000000" or "#000000", bg = c.greenDb or c.statusLineBg or "#A6DB29" },
    WarningMsg = { fg = vim.o.background == "light" and "#d82020" or c.warningFg or "#edc830", bg = "NONE", bold = vim.o.background == "light" },

    -- Wild Menu
    WildMenu = { fg = vim.o.background == "light" and "#000000" or "#000000", bg = c.greenDb or c.statusLineBg or "#A6DB29" },

    -- Directory
    Directory = { fg = vim.o.background == "light" and c.blueDark or c.normalFloat or "#b5b5b5", bg = "NONE", bold = true },

    -- Title
    Title = { fg = vim.o.background == "light" and c.blueTitle or c.title or "#d0d0d0", bg = "NONE", bold = true },

    -- Non-text
    NonText = { fg = vim.o.background == "light" and c.grayLighter or c.nonText, bg = vim.o.background == "light" and c.grayBgLightest or c.nonTextBg },
    EndOfBuffer = { link = "NonText" },
    Whitespace = { fg = c.bg },
    SpecialKey = { fg = vim.o.background == "light" and c.grayLightest or c.specialKeyFg, bg = vim.o.background == "light" and c.grayBgLight or c.specialKeyBg },

    -- Conceal
    Conceal = { fg = vim.o.background == "light" and "#303030" or c.concealFg, bg = vim.o.background == "light" and c.bgConceal or c.concealBg },

    -- QuickFix
    QuickFixLine = { bg = vim.o.background == "light" and "#e8f4ff" or c.bgInfoLight },

    -- Diagnostics (exact from original)
    DiagnosticError = { fg = vim.o.background == "light" and c.redOff or c.diagnosticError },
    DiagnosticWarn = { fg = vim.o.background == "light" and c.orangeDark or c.diagnosticWarn },
    DiagnosticInfo = { fg = vim.o.background == "light" and c.purple or c.diagnosticInfo },
    DiagnosticHint = { fg = vim.o.background == "light" and c.blue or c.diagnosticHint },
    DiagnosticOk = { fg = vim.o.background == "light" and c.greenOk or c.diagnosticOk },

    DiagnosticVirtualTextError = { fg = c.redOff, bg = c.bgErrorLight },
    DiagnosticVirtualTextWarn = { fg = c.orangeDark, bg = c.bgWarningLight },
    DiagnosticVirtualTextInfo = { fg = c.purple, bg = c.bgInfoLight },
    DiagnosticVirtualTextHint = { fg = c.blue, bg = c.bgHintLight },
    DiagnosticVirtualTextOk = { fg = c.greenOk, bg = vim.o.background == "light" and "#f0fff0" or c.bgDiffAdd },

    DiagnosticUnderlineError = { undercurl = true, sp = c.redOff },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.orangeDark },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.purple },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.blue },
    DiagnosticUnderlineOk = { undercurl = true, sp = c.greenOk },

    -- LSP
    LspReferenceText = { bg = c.bgInfoLight },
    LspReferenceRead = { bg = c.bgInfoLight },
    LspReferenceWrite = { bg = vim.o.background == "light" and "#fff0f8" or c.bgHintLight },
    LspSignatureActiveParameter = { fg = c.orange, bold = true },
    LspCodeLens = { fg = c.grayLight },
    LspCodeLensSeparator = { fg = c.grayLighter },
    LspInlayHint = { fg = vim.o.background == "light" and "#4050c0" or c.blueDark, bg = c.yellowPale },
  }
end