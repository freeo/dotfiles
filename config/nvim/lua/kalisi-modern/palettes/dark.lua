-- Kalisi Dark Palette
-- Exact colors from original kalisi/dark.lua

return {
  -- Base colors from original (warm reading theme)
  bg = "#221C19",  -- Warm dark background
  fg = "#E8E0DB",  -- Warm light foreground

  -- Alternative backgrounds from comments
  -- bg = "#404042",  -- long-standing old standard
  -- bg = "#1A1512",  -- Low-light warm reading
  -- bg = "#29221E",  -- Ultra-soft night reading

  -- Core colors from original t table
  orange = "#ffaf00",
  orangeDark = "#d88000",
  redOff = "#F92672",
  purple = "#7f00ff",  -- Eminence
  blue = "#007fff",

  -- Exact colors from dark.lua
  comment = "#8a8a8a",         -- Comment
  commentUrl = "#6090c0",      -- CommentURL

  constantYellow = "#ffaf00",  -- Constant
  string = "#ffc63f",          -- String
  character = "#c85bff",       -- Character
  number = "#ffad3f",          -- Number
  boolean = "#94be54",         -- Boolean
  float = "#fff650",           -- Float

  identifier = "#29a3ac",      -- Identifier
  func = "#7ad6ff",            -- Function

  statement = "#94be54",       -- Statement
  conditional = "#7aa6c2",     -- Conditional
  labelGreen = "#409a50",      -- Label
  operator = "#658aa5",        -- Operator
  exception = "#2080c0",       -- Exception

  preproc = "#2288ee",         -- PreProc/Include/Define
  macro = "#a68ad2",           -- Macro

  type = "#5d8fbe",            -- Type
  storageClass = "#55aa85",    -- StorageClass
  structure = "#557a95",       -- Structure
  typedef = "#55aa85",         -- Typedef

  special = "#e7f6da",         -- Special
  specialChar = "#6a96ff",     -- SpecialChar
  tag = "#00c0ff",             -- Tag
  delimiter = "#7a9acd",       -- Delimiter
  debug = "#ddb800",           -- Debug

  -- UI colors
  normal = "#d0d0d0",          -- Alternative normal fg
  normalFloat = "#b5b5b5",     -- NormalFloat fg

  -- Backgrounds from original
  bgFloat = "#303032",         -- NormalFloat bg
  bgCursorLine = "#2a2a2c",    -- CursorLine (was #4a4a4c)
  bgCursorCol = "#4a4a4c",     -- CursorColumn
  bgVisual = "#274670",        -- Visual (bluloco selection)
  bgVisualNOS = "#4a4d4e",     -- VisualNOS
  bgMatchParen = "#8fca24",    -- MatchParen bg

  -- Search colors (exact)
  bgSearch = "#7c9500",        -- Search bg
  fgSearchInc = "#7c6700",     -- IncSearch fg

  -- StatusLine colors for lualine
  statusLineFg = "#000000",    -- StatusLine fg
  statusLineBg = "#A6DB29",    -- StatusLine bg (bright green)
  statusLineNCFg = "#636D83",  -- StatusLineNC fg
  statusLineNCBg = "#221C19",  -- StatusLineNC bg

  -- Diff colors
  bgDiffAdd = "#384b38",       -- DiffAdd
  bgDiffChange = "#383a4b",    -- DiffChange
  bgDiffText = "#484898",      -- DiffText bg
  bgDiffDelete = "#3b3b3b",    -- DiffDelete bg
  fgDiffDelete = "#484848",    -- DiffDelete fg

  -- Error colors
  errorFg = "#e5a5a5",         -- Error fg
  errorBg = "#602020",         -- Error bg
  errorMsgFg = "#f5c5c5",      -- ErrorMsg fg
  errorMsgBg = "#901010",      -- ErrorMsg bg

  -- Todo
  todoFg = "#fff63f",          -- Todo fg
  todoBg = "#736a3f",          -- Todo bg

  -- Misc colors
  keyword = "#adffdd",         -- Keyword
  title = "#d0d0d0",           -- Title
  nonText = "#958b7f",         -- NonText fg
  nonTextBg = "#282828",       -- NonText bg (was #3a3a3a)
  concealFg = "#f6f3e8",       -- Conceal fg
  concealBg = "#303030",       -- Conceal bg

  -- Special key
  specialKeyFg = "#767676",    -- SpecialKey fg
  specialKeyBg = "#3a3a3a",    -- SpecialKey bg

  -- Grays
  gray = "#707070",            -- NERDTreePart
  grayLight = "#949494",       -- StartifyPath
  grayDark = "#767676",        -- jediFunction fg
  graySign = "#535D63",        -- SignColumn fg (bluloco comment)
  grayLineNr = "#636D83",      -- LineNr fg

  -- Tab colors
  tabFg = "#afd700",           -- TabLine fg
  tabBg = "#005f00",           -- TabLine bg
  tabFillFg = "#303030",       -- TabLineFill fg
  tabFillBg = "#a0a0a0",       -- TabLineFill bg

  -- Fold colors
  foldedFg = "#727780",        -- Folded fg
  foldedBg = "#373d43",        -- Folded bg
  foldColumnFg = "#b0b8c0",    -- FoldColumn fg

  -- Warning
  warningFg = "#edc830",       -- WarningMsg

  -- Git colors from original
  gitAddedFg = "#177F55",      -- bluloco added
  gitChangedFg = "#1B6E9B",    -- bluloco changed
  gitRemovedFg = "#A14D5B",    -- bluloco deleted

  -- Diagnostic colors (from original)
  diagnosticError = "#e83030",  -- DiagnosticError (from SpellBad)
  diagnosticWarn = "#edc830",   -- DiagnosticWarn (from WarningMsg)
  diagnosticInfo = "#476afc",   -- DiagnosticInfo (from SpellCap)
  diagnosticHint = "#48b040",   -- DiagnosticHint (from SpellLocal)
  diagnosticOk = "#94be54",     -- DiagnosticOk (from Boolean)

  -- Spell colors
  spellBad = "#e83030",
  spellCap = "#476afc",
  spellLocal = "#48b040",
  spellRare = "#eeeeee",

  -- Lualine explicit colors (from original)
  lualineNormalA = "#005f00",
  lualineNormalB = "#afd700",
  lualineNormalC = "#b5b5b5",
  lualineNormalBg = "#222222",

  lualineInsertA = "#ffffff",
  lualineInsertB = "#ff0000",
  lualineInsertBg1 = "#e80000",
  lualineInsertBg2 = "#5f0000",

  lualineVisualA = "#0087ff",
  lualineVisualB = "#005faf",
  lualineVisualC = "#87d7ff",
  lualineVisualBg1 = "#ffffff",
  lualineVisualBg2 = "#5fafff",

  lualineReplaceA = "#d75fff",
  lualineReplaceB = "#5f005f",
  lualineReplaceC = "#ff87ff",
  lualineReplaceBg1 = "#ffffff",
  lualineReplaceBg2 = "#8700af",

  -- Plugin colors
  ctrlpMatch = "#f8cf00",      -- CtrlPMatch bg
  nerdTreeDir = "#5d8fbe",     -- NERDTreeDir
  nerdTreeClosableFg = "#66b600",  -- NERDTreeClosable fg
  nerdTreeClosableBg = "#385038",  -- NERDTreeClosable bg
  tagbarScope = "#0087d7",     -- TagbarScope
  tagbarType = "#66b600",      -- TagbarType
  tagbarKind = "#7ad6ff",      -- TagbarKind
  sneakTargetFg = "#ffff00",   -- SneakPluginTarget fg
  sneakTargetBg = "#ff5f00",   -- SneakPluginTarget bg
  cleverFBg = "#5fd700",       -- CleverFDefaultLabel bg
  cleverFFg = "#404040",       -- CleverFDefaultLabel fg

  -- Startify colors
  startifyBracketFg = "#0087d7",
  startifyBracketBg = "#303030",
  startifyFile = "#00afff",
  startifyNumber = "#00d700",
  startifyPath = "#949494",
  startifySlash = "#dadada",
  startifySpecialFg = "#b2b2b2",
  startifySpecialBg = "#606060",

  -- Jedi colors
  jediFunctionFg = "#767676",
  jediFunctionBg = "#303030",
  jediFatFg = "#afd700",

  -- Quickfix signs
  qfMarkFg = "#ffc63f",
  qfMarkBg = "#202020",
  qfAddFg = "#108f4f",
  qfAddBg = "#324832",
  qfChangeFg = "#336fdf",
  qfChangeBg = "#20385f",
  qfDeleteFg = "#d75f5f",
  qfDeleteBg = "#872222",

  -- Indent colors (subtle)
  indentChar = "#2A2A2A",      -- Very subtle indent
  indentScope = "#4A4A4A",     -- Active indent scope

  -- Kitty scrollback
  kittyVisualBg = "#602020",
  kittyNormalFg = "#d0d0d0",
  kittyNormalBg = "#2a1010",

  -- Terminal colors (exact mapping would need checking original)
  terminal = {
    black = "#000000",
    red = "#e83030",
    green = "#94be54",
    yellow = "#ffaf00",
    blue = "#007fff",
    magenta = "#c85bff",
    cyan = "#29a3ac",
    white = "#d0d0d0",
    brightBlack = "#8a8a8a",
    brightRed = "#F92672",
    brightGreen = "#8fca24",
    brightYellow = "#ffc63f",
    brightBlue = "#7ad6ff",
    brightMagenta = "#a68ad2",
    brightCyan = "#6090c0",
    brightWhite = "#ffffff",
  }
}