-- Kalisi Light Palette
-- Exact colors from original kalisi/light.lua

return {
  -- Base colors from original
  -- bg = "#ffffff",  -- Original solid white background
  bg = "NONE",       -- Transparent background (NEW DEFAULT)
  fg = "#000000",

  -- Core colors from original t table
  orange = "#ffaf00",
  orangeDark = "#d88000",
  redOff = "#F92672",
  purple = "#7f00ff",  -- Eminence
  blue = "#007fff",

  -- Extracted exact colors from light.lua
  purpleComment = "#5f00df",  -- Comment
  purplePale = "#9054c7",     -- Character

  blueDark = "#0060a0",       -- String
  blueFunction = "#1177dd",   -- Function, Conditional, Repeat
  blueLight = "#70a0ff",      -- CommentURL
  blueSky = "#0070c0",        -- Number

  green = "#66b600",          -- Boolean, Statement
  greenDark = "#005f00",      -- DjangoBlock (from light.lua)
  greenBright = "#50f050",    -- Added (git)
  greenOk = "#82d322",        -- DiagnosticOk
  greenSignColumn = "#A6E22E", -- SignColumn
  greenDb = "#A6DB29",        -- WildMenu/PmenuSel

  orangeType = "#f47300",     -- Type

  -- Exact reds/magentas
  red = "#d80000",            -- Error, Macro
  magenta = "#d80050",        -- PreProc, Include, Define, Delimiter

  -- Other colors from original
  teal = "#00a0a0",           -- Float
  cyan = "#50c0ff",           -- Changed (git)

  yellow = "#ffff00",         -- Todo bg
  yellowSearch = "#EAFF90",   -- Search bg (exact from original)
  yellowSearchInc = "#B8EA00", -- IncSearch fg (exact)
  yellowGold = "#ffd030",     -- MatchParen bg
  yellowPale = "#fff8d8",     -- LspInlayHint bg (exact)

  -- Special colors from original
  slate = "#202090",          -- Identifier
  navyOperator = "#274aac",   -- Operator, Structure
  navyDark = "#0000d7",       -- StorageClass
  navyConstant = "#0000af",   -- Constant
  blueExc = "#005090",        -- Exception
  greenLabel = "#007700",     -- Label
  blueTitle = "#1060a0",      -- Title
  blueTag = "#0010ff",        -- Tag
  yellowDebug = "#ddb800",    -- Debug
  blueDocstring = "#004B84",  -- pythonDocstring

  -- Grays from original
  gray = "#707070",           -- LineNr, Folded
  grayLight = "#a0a0a0",      -- StatusLineNC, TabLineFill
  grayLighter = "#e0e0e0",    -- NonText, StatusLine, CursorLineNr
  grayLightest = "#9e9e9e",   -- SpecialKey fg
  graySignBg = "#c9c4c4",     -- CursorLineNr bg, SignColumn bg

  -- Background colors from original
  grayBg = "#e8e8e8",         -- Pmenu, Folded bg
  grayBgLight = "#e4e4e4",    -- SpecialKey bg
  grayBgLighter = "#f8f8f8",  -- NormalFloat bg
  grayBgLightest = "#fafafa", -- NonText bg
  bgConceal = "#e0e8e0",      -- Conceal bg

  -- Exact special backgrounds
  bgCursorLine = "#eaeaea",   -- CursorLine
  bgVisual = "#d0eeff",       -- Visual
  bgVisualNOS = "#d8d8d8",    -- VisualNOS
  bgDiffAdd = "#ddffdd",      -- DiffAdd
  bgDiffDelete = "#ffdddd",   -- DiffDelete
  bgDiffChange = "#e8e8e8",   -- DiffChange
  bgDiffText = "#ddddff",     -- DiffText bg
  bgError = "#d8d0d0",        -- Error bg

  -- Git colors from original
  gitRemoved = "#8080ff",     -- Removed fg
  gitRemovedBg = "#eff8ff",   -- Removed bg

  -- Spell check colors
  spellRed = "#d80000",       -- SpellBad
  spellBlue = "#274aac",      -- SpellCap
  spellGreen = "#006600",     -- SpellLocal
  spellGray = "#555555",      -- SpellRare

  -- Terminal colors (not in original, keeping for compatibility)
  terminal = {
    black = "#000000",
    red = "#d80000",
    green = "#66b600",
    yellow = "#ffaf00",
    blue = "#007fff",
    magenta = "#d80050",
    cyan = "#00a0a0",
    white = "#e0e0e0",
    brightBlack = "#707070",
    brightRed = "#F92672",
    brightGreen = "#82d322",
    brightYellow = "#ffd700",
    brightBlue = "#70a0ff",
    brightMagenta = "#9054c7",
    brightCyan = "#00d7ff",
    brightWhite = "#ffffff",
  }
}