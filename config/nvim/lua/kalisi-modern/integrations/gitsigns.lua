-- Kalisi GitSigns Integration
-- Only loads if gitsigns is detected

return function(c)
  return {
    -- Git colors base
    Added = { fg = vim.o.background == "light" and "#50f050" or c.greenBright },
    Changed = { fg = vim.o.background == "light" and "#50c0ff" or c.blueSky },
    Removed = { fg = vim.o.background == "light" and "#8080ff" or c.redOff, bg = vim.o.background == "light" and "#eff8ff" or nil },

    -- GitSigns
    GitSignsAdd = { link = "Added" },
    GitSignsChange = { link = "Changed" },
    GitSignsDelete = { link = "Removed" },
    GitSignsAddNr = { link = "Added" },
    GitSignsChangeNr = { link = "Changed" },
    GitSignsDeleteNr = { link = "Removed" },
    GitSignsAddLn = { link = "Added" },
    GitSignsChangeLn = { link = "Changed" },
    GitSignsDeleteLn = { link = "Removed" },
    GitSignsCurrentLineBlame = { fg = c.grayLight, italic = true },
    GitSignsAddInline = { bg = c.bgDiffAdd },
    GitSignsDeleteInline = { bg = c.bgDiffDelete },
    GitSignsChangeInline = { bg = vim.o.background == "light" and "#e8e8ff" or c.bgDiffText },
  }
end