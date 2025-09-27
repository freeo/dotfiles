-- Kalisi Miscellaneous Plugin Integrations
-- Various smaller plugin supports

return function(c)
  return {
    -- WhichKey
    WhichKey = { fg = c.blue, bold = true },
    WhichKeyGroup = { fg = c.purple },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeperator = { fg = c.gray },
    WhichKeySeparator = { fg = c.gray },
    WhichKeyFloat = { bg = c.grayBgLighter },
    WhichKeyValue = { fg = c.green },

    -- Leap/Flash motion plugins
    LeapMatch = { fg = vim.o.background == "light" and "#000000" or c.bg, bg = c.yellowSearch, bold = true },
    LeapLabel = { fg = vim.o.background == "light" and "#000000" or c.bg, bg = c.yellowGold, bold = true },
    LeapBackdrop = { fg = c.grayLight },
    FlashMatch = { link = "LeapMatch" },
    FlashLabel = { link = "LeapLabel" },
    FlashBackdrop = { link = "LeapBackdrop" },

    -- Notify
    NotifyERRORBorder = { fg = c.redOff },
    NotifyWARNBorder = { fg = c.orangeDark },
    NotifyINFOBorder = { fg = c.blue },
    NotifyDEBUGBorder = { fg = c.gray },
    NotifyTRACEBorder = { fg = c.purple },
    NotifyERRORIcon = { fg = c.redOff },
    NotifyWARNIcon = { fg = c.orangeDark },
    NotifyINFOIcon = { fg = c.blue },
    NotifyDEBUGIcon = { fg = c.gray },
    NotifyTRACEIcon = { fg = c.purple },
    NotifyERRORTitle = { fg = c.redOff, bold = true },
    NotifyWARNTitle = { fg = c.orangeDark, bold = true },
    NotifyINFOTitle = { fg = c.blue, bold = true },
    NotifyDEBUGTitle = { fg = c.gray, bold = true },
    NotifyTRACETitle = { fg = c.purple, bold = true },

    -- Noice (cmdline UI)
    NoiceCmdline = { fg = c.fg, bg = vim.o.background == "light" and "NONE" or c.bg },
    NoiceCmdlineIcon = { fg = c.blue },
    NoiceCmdlineIconSearch = { fg = c.orange },
    NoiceCmdlinePopup = { fg = c.fg, bg = c.grayBgLighter },
    NoiceCmdlinePopupBorder = { fg = c.gray, bg = c.grayBgLighter },
    NoiceConfirm = { fg = c.fg, bg = c.grayBgLighter },
    NoiceConfirmBorder = { fg = c.blue, bg = c.grayBgLighter },

    -- DAP (Debug Adapter Protocol)
    DapBreakpoint = { fg = c.red, bold = true },
    DapBreakpointCondition = { fg = c.orange, bold = true },
    DapBreakpointRejected = { fg = c.gray },
    DapLogPoint = { fg = c.blue },
    DapStopped = { bg = c.bgWarningLight },

    -- Mini.nvim suite
    MiniIndentscopeSymbol = { fg = c.grayLight },
    MiniIndentscopePrefix = { nocombine = true },
    MiniJump = { fg = "#ffffff", bg = c.orange, bold = true },
    MiniJump2dSpot = { fg = c.orange, bold = true, underline = true },
    MiniStarterCurrent = { bg = c.yellowSearch },
    MiniStarterFooter = { fg = c.gray, italic = true },
    MiniStarterHeader = { fg = c.blue, bold = true },
    MiniStarterInactive = { fg = c.grayLight },
    MiniStarterItem = { fg = c.fg },
    MiniStarterItemBullet = { fg = c.gray },
    MiniStarterItemPrefix = { fg = c.orange },
    MiniStarterSection = { fg = c.purple, bold = true },
    MiniStarterQuery = { fg = c.blue, bold = true },
    MiniSurround = { bg = c.yellowSearch },
    MiniTrailspace = { bg = vim.o.background == "light" and "#ffe0e0" or c.bgErrorLight },

    -- Startify
    StartifyBracket = { fg = c.cyan, bg = vim.o.background == "light" and "#005f87" or c.blueDark, bold = true },
    StartifyFile = { fg = vim.o.background == "light" and "#005fd7" or c.blue },
    StartifyHeader = { fg = vim.o.background == "light" and "#005fd7" or c.blue },
    StartifyFooter = { link = "StartifyHeader" },
    StartifyNumber = { fg = vim.o.background == "light" and "#00ff00" or c.greenBright, bg = vim.o.background == "light" and "#005f87" or c.blueDark, bold = true },
    StartifyPath = { fg = vim.o.background == "light" and "#878787" or c.gray },
    StartifySlash = { fg = c.fg },
    StartifySpecial = { fg = vim.o.background == "light" and "#666666" or c.gray, bg = vim.o.background == "light" and "#d7d7d7" or c.grayBgLight },

    -- CtrlP
    CtrlPMatch = { link = "Search" },

    -- Tagbar
    TagbarSignature = { link = "Comment" },
    TagbarScope = { fg = vim.o.background == "light" and "#0087d7" or c.blueDark, bold = true },
    TagbarType = { fg = c.green, bold = true },
    TagbarKind = { fg = vim.o.background == "light" and "#0000ff" or c.blue },

    -- vim-sneak
    SneakPluginTarget = { bg = c.orange, fg = c.yellow, bold = true },
    SneakPluginScope = { link = "Visual" },

    -- clever-f
    CleverFDefaultLabel = { bg = c.yellowGold, fg = vim.o.background == "light" and "#000000" or c.bg, bold = true },

    -- jedi-vim
    jediFunction = { bg = vim.o.background == "light" and "#878787" or c.gray, fg = vim.o.background == "light" and "#f0f0f0" or c.grayLighter },
    jediFat = { bg = vim.o.background == "light" and "#878787" or c.gray, fg = vim.o.background == "light" and "#afd700" or c.greenBright, bold = true },

    -- Markdown rendering
    RenderMarkdownCode = { bg = c.grayBgLight },
    RenderMarkdownCodeBorder = { bg = c.grayBgLighter },
    RenderMarkdownCodeInline = { fg = vim.o.background == "light" and "#00a900" or c.green, bg = c.grayBgLight },
    RenderMarkdownCodeInlineHighlight = { bg = vim.o.background == "light" and "#ffe0ff" or c.bgHintLight },

    -- Log highlighting
    logLvInfo = { fg = c.purple, bold = true },
    logLvWarning = { fg = c.orangeDark, bold = true },
    logLvError = { fg = c.redOff, bold = true },
    logLvBad = { fg = c.redOff, bold = true },
    logLvDebug = { fg = vim.o.background == "light" and "#A9A9A9" or c.gray, bold = true },
    logLvFailure = { fg = c.grayLighter, bg = vim.o.background == "light" and "#d70000" or c.red, bold = true },
    logPath = { fg = vim.o.background == "light" and "#376ACC" or c.blue },
    logBool = { fg = c.green, bold = true },
    logDate = { fg = vim.o.background == "light" and "#00A900" or c.green, bold = true },
    logTime = { fg = vim.o.background == "light" and "#b000b0" or c.purple, bold = true },
    logTimeZone = { fg = c.grayLight },
    logSeparatorLine = { fg = c.purpleComment, bold = true },

    -- Baleia colored logs
    BaleiaColorsLogsINFO = { fg = c.purple, bold = true },
    BaleiaColorsLogsWARN = { fg = c.orangeDark, bold = true },
    BaleiaColorsLogsERROR = { fg = c.redOff, bold = true },
    BaleiaColorsLogsDEBUG = { fg = vim.o.background == "light" and "#A9A9A9" or c.gray, bold = true },

    -- KittyScrollbackNvim
    KittyScrollbackNvimPasteWinNormal = { bg = vim.o.background == "light" and "#e0f0ff" or c.bgInfoLight },
    KittyScrollbackNvimPasteWinFloatBorder = { fg = vim.o.background == "light" and "#90b0ff" or c.blue, bg = vim.o.background == "light" and "#e0f0ff" or c.bgInfoLight },
    KittyScrollbackNvimPasteWinFloatTitle = { fg = vim.o.background == "light" and "#00a900" or c.green, bg = vim.o.background == "light" and "#ffaaff" or c.bgHintLight },
    KittyScrollbackNvimVisual = { bg = vim.o.background == "light" and "#50c0ff" or c.blueSky },
    KittyScrollbackNvimNormal = { fg = c.fg, bg = vim.o.background == "light" and "#f0f0ff" or c.bgInfoLight },

    -- Todo comments
    TodoSignWARN = { fg = c.orange },
  }
end