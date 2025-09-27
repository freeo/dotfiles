-- Kalisi NvimTree/NeoTree Integration
-- Works with both NvimTree and NeoTree

return function(c)
  return {
    -- NvimTree
    NvimTreeNormal = { fg = c.fg, bg = c.grayBgLighter },
    NvimTreeNormalNC = { fg = c.fg, bg = c.grayBgLighter },
    NvimTreeRootFolder = { fg = c.purple, bold = true },
    NvimTreeFolderName = { fg = c.blueDark, bold = true },
    NvimTreeFolderIcon = { fg = c.blueDark },
    NvimTreeEmptyFolderName = { fg = c.gray },
    NvimTreeOpenedFolderName = { fg = c.blueFunction, bold = true },
    NvimTreeExecFile = { fg = c.green },
    NvimTreeOpenedFile = { fg = c.orange },
    NvimTreeSpecialFile = { fg = c.purplePale },
    NvimTreeImageFile = { fg = c.purple },
    NvimTreeMarkdownFile = { fg = c.blue },
    NvimTreeIndentMarker = { fg = c.grayLighter },
    NvimTreeGitDirty = { fg = c.orange },
    NvimTreeGitStaged = { fg = c.green },
    NvimTreeGitMerge = { fg = c.redOff },
    NvimTreeGitRenamed = { fg = c.purple },
    NvimTreeGitNew = { fg = c.greenBright },
    NvimTreeGitDeleted = { fg = c.red },
    NvimTreeGitIgnored = { fg = c.gray, italic = true },

    -- NeoTree (similar but slightly different naming)
    NeoTreeNormal = { fg = c.fg, bg = c.grayBgLighter },
    NeoTreeNormalNC = { fg = c.fg, bg = c.grayBgLighter },
    NeoTreeDirectoryName = { fg = c.blueDark, bold = true },
    NeoTreeDirectoryIcon = { fg = c.blueDark },
    NeoTreeFileName = { fg = c.fg },
    NeoTreeFileIcon = { fg = c.gray },
    NeoTreeRootName = { fg = c.purple, bold = true },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitDeleted = { fg = c.redOff },
    NeoTreeGitModified = { fg = c.orange },
    NeoTreeGitUntracked = { fg = c.grayLight, italic = true },
    NeoTreeIndentMarker = { fg = c.grayLighter },
    NeoTreeExpander = { fg = c.gray },

    -- Legacy NERDTree support
    NERDTreeDir = { fg = vim.o.background == "light" and "#0087d7" or c.blueDark, bold = true },
    NERDTreeDirSlash = { link = "NERDTreeDir" },
    NERDTreeOpenable = { link = "NERDTreeDir" },
    NERDTreeClosable = { fg = vim.o.background == "light" and "#008700" or c.green, bg = vim.o.background == "light" and "#5fd75f" or c.greenDark, bold = true },
    NERDTreePart = { fg = c.grayLight },
    NERDTreePartFile = { fg = c.fg, bold = true },
    NERDTreeLinkFile = { fg = c.orange },
    NERDTreeLinkDir = { fg = c.orange },
  }
end