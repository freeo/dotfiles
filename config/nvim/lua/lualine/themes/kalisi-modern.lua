-- Kalisi Modern Lualine Theme
-- EXACT colors from original vim-kalisi lualine theme

local light = {
  black = "#000000",
  bg = "#F9F9F9",
  fg = "#6D7281",
  normalFG = "#383A42",
  green = "#afd700",
  greenDark = "#005f00",
  red1 = "#ff0000",
  red2 = "#e80000",
  redDark = "#5f0000",
  purple = "#7f00ff",
  blue = "#007fff",
  blueDark = "#275FE4",
  whiteBlue = "#5fafff",
  white = "#ffffff",
  grey3 = "#ededee",
  grey5 = "#e7e8e9",
  grey7 = "#dee1e3",
  grey20 = "#b9c2c6",
  grey30 = "#899296",
  greyDark = "#808080",
}

local dark = {
  bg = "#282C34",
  fg = "#8691A3",
  normalFG = "#abb2bf",
  green = "#3FC56B",
  red = "#FF6480",
  purple = "#9F7EFE",
  blue = "#10B1FE",
  blueDark = "#3691FF",
  grey3 = "#2d333e",
  grey5 = "#333a48",
  grey7 = "#384252",
  grey20 = "#4a5a73",
}

local t = dark

if vim.o.background == "light" then
  t = light
end

-- Use exact kalisi airline colors for dark mode
if vim.o.background == "dark" then
  return {
    normal = {
      a = { bg = "#afd700", fg = "#005f00", gui = "bold" },  -- N1
      b = { bg = "#005f00", fg = "#afd700" },              -- N2
      c = { bg = "#222222", fg = "#b5b5b5" },              -- N3 (StatusLine)
    },
    insert = {
      a = { bg = "#e80000", fg = "#ffffff", gui = "bold" },  -- I1
      b = { bg = "#5f0000", fg = "#ff0000" },              -- I2
      c = { bg = "#222222", fg = "#b5b5b5" },              -- I3 (StatusLine)
    },
    visual = {
      a = { bg = "#ffffff", fg = "#0087ff", gui = "bold" },  -- V1
      b = { bg = "#5fafff", fg = "#005faf" },              -- V2
      c = { bg = "#005faf", fg = "#87d7ff" },              -- V3
    },
    replace = {
      a = { bg = "#ffffff", fg = "#d75fff", gui = "bold" },  -- R1
      b = { bg = "#d75fff", fg = "#5f005f" },              -- R2
      c = { bg = "#8700af", fg = "#ff87ff" },              -- R3
    },
    command = {
      a = { bg = "#e80000", fg = "#ffffff", gui = "bold" },  -- Same as insert
      b = { bg = "#5f0000", fg = "#ff0000" },
      c = { bg = "#222222", fg = "#b5b5b5" },
    },
    inactive = {
      a = { bg = "#221C19", fg = "#636D83" },
      b = { bg = "#221C19", fg = "#636D83" },
      c = { bg = "#221C19", fg = "#636D83" },
    },
  }
else
  -- EXACT LIGHT THEME from original kalisi lualine
  return {
    normal = {
      a = { bg = t.green, fg = t.greenDark },          -- #afd700 bg, #005f00 fg
      b = { bg = t.greenDark, fg = t.green },          -- #005f00 bg, #afd700 fg
      c = { bg = t.grey3, fg = t.greyDark },           -- #ededee bg, #808080 fg
    },
    insert = {
      a = { bg = t.red2, fg = t.white },               -- #e80000 bg, #ffffff fg
      b = { bg = t.redDark, fg = t.red1 },             -- #5f0000 bg, #ff0000 fg
      c = { bg = t.grey3, fg = t.fg },                 -- #ededee bg, #6D7281 fg
    },
    visual = {
      a = { bg = "#0087ff", fg = t.white },            -- Hardcoded blue, #ffffff fg
      b = { bg = "#005faf", fg = t.whiteBlue },        -- Hardcoded, #5fafff fg
      c = { bg = "#d0e0ff", fg = t.fg },               -- Hardcoded light blue, #6D7281 fg
    },
    replace = {
      a = { bg = t.purple, fg = t.white },             -- #7f00ff bg, #ffffff fg
      b = { bg = "#5f005f", fg = t.purple },           -- Hardcoded, #7f00ff fg
      c = { bg = t.grey3, fg = t.fg },                 -- #ededee bg, #6D7281 fg
    },
    command = {
      a = { bg = t.grey5, fg = t.greyDark },           -- #e7e8e9 bg, #808080 fg
      b = { bg = t.grey20, fg = t.greyDark },          -- #b9c2c6 bg, #808080 fg
      c = { bg = t.grey30, fg = t.fg },                -- #899296 bg, #6D7281 fg
    },
    inactive = {
      a = { bg = t.grey20, fg = t.grey3 },             -- #b9c2c6 bg, #ededee fg
      b = { bg = t.grey5, fg = t.greyDark },           -- #e7e8e9 bg, #808080 fg
      c = { bg = t.grey5, fg = t.grey20 },             -- #e7e8e9 bg, #b9c2c6 fg
    },
  }
end