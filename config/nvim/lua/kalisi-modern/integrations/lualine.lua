-- Kalisi Lualine Integration
-- Uses EXACT colors from original vim-kalisi lualine theme
-- Both outer AND inner segments preserved from original

return function(c)
  local is_light = vim.o.background == "light"

  if is_light then
    -- LIGHT THEME - EXACT from ~/.config/nvim/lua/vim-kalisi/lua/lualine/themes/kalisi.lua
    return {
      -- Normal mode: EXACT from original (green theme)
      lualine_a_normal = { fg = "#005f00", bg = "#afd700", bold = true },    -- t.greenDark, t.green
      lualine_b_normal = { fg = "#afd700", bg = "#005f00" },                -- t.green, t.greenDark
      lualine_c_normal = { fg = "#808080", bg = "#ededee" },                -- t.greyDark, t.grey3
      lualine_x_normal = { fg = "#808080", bg = "#ededee" },                -- Matching c
      lualine_y_normal = { fg = "#afd700", bg = "#005f00" },                -- Matching b
      lualine_z_normal = { fg = "#005f00", bg = "#afd700", bold = true },   -- Matching a

      -- Insert mode: EXACT from original (red theme)
      lualine_a_insert = { fg = "#ffffff", bg = "#e80000", bold = true },   -- t.white, t.red2
      lualine_b_insert = { fg = "#ff0000", bg = "#5f0000" },                -- t.red1, t.redDark
      lualine_c_insert = { fg = "#6D7281", bg = "#ededee" },                -- t.fg, t.grey3
      lualine_x_insert = { fg = "#6D7281", bg = "#ededee" },                -- Matching c
      lualine_y_insert = { fg = "#ff0000", bg = "#5f0000" },                -- Matching b
      lualine_z_insert = { fg = "#ffffff", bg = "#e80000", bold = true },   -- Matching a

      -- Visual mode: EXACT from original (blue theme)
      lualine_a_visual = { fg = "#ffffff", bg = "#0087ff", bold = true },   -- t.white, hardcoded blue
      lualine_b_visual = { fg = "#5fafff", bg = "#005faf" },                -- t.whiteBlue, hardcoded
      lualine_c_visual = { fg = "#6D7281", bg = "#d0e0ff" },                -- t.fg, hardcoded light blue
      lualine_x_visual = { fg = "#6D7281", bg = "#d0e0ff" },                -- Matching c
      lualine_y_visual = { fg = "#5fafff", bg = "#005faf" },                -- Matching b
      lualine_z_visual = { fg = "#ffffff", bg = "#0087ff", bold = true },   -- Matching a

      -- Replace mode: EXACT from original (purple theme)
      lualine_a_replace = { fg = "#ffffff", bg = "#7f00ff", bold = true },  -- t.white, t.purple
      lualine_b_replace = { fg = "#7f00ff", bg = "#5f005f" },               -- t.purple, hardcoded dark purple
      lualine_c_replace = { fg = "#6D7281", bg = "#ededee" },               -- t.fg, t.grey3
      lualine_x_replace = { fg = "#6D7281", bg = "#ededee" },               -- Matching c
      lualine_y_replace = { fg = "#7f00ff", bg = "#5f005f" },               -- Matching b
      lualine_z_replace = { fg = "#ffffff", bg = "#7f00ff", bold = true },  -- Matching a

      -- Command mode: EXACT from original (gray theme)
      lualine_a_command = { fg = "#808080", bg = "#e7e8e9", bold = true },  -- t.greyDark, t.grey5
      lualine_b_command = { fg = "#808080", bg = "#b9c2c6" },               -- t.greyDark, t.grey20
      lualine_c_command = { fg = "#6D7281", bg = "#899296" },               -- t.fg, t.grey30
      lualine_x_command = { fg = "#6D7281", bg = "#899296" },               -- Matching c
      lualine_y_command = { fg = "#808080", bg = "#b9c2c6" },               -- Matching b
      lualine_z_command = { fg = "#808080", bg = "#e7e8e9", bold = true },  -- Matching a

      -- Inactive: EXACT from original
      lualine_a_inactive = { fg = "#ededee", bg = "#b9c2c6" },              -- t.grey3, t.grey20
      lualine_b_inactive = { fg = "#808080", bg = "#e7e8e9" },              -- t.greyDark, t.grey5
      lualine_c_inactive = { fg = "#b9c2c6", bg = "#e7e8e9" },              -- t.grey20, t.grey5
      lualine_x_inactive = { fg = "#b9c2c6", bg = "#e7e8e9" },              -- Matching c
      lualine_y_inactive = { fg = "#808080", bg = "#e7e8e9" },              -- Matching b
      lualine_z_inactive = { fg = "#ededee", bg = "#b9c2c6" },              -- Matching a

      -- Component colors harmonized with original light theme
      lualine_git_added = { fg = "#005f00", bg = "#ededee" },               -- greenDark on grey3
      lualine_git_modified = { fg = "#e80000", bg = "#ededee" },            -- red2 on grey3
      lualine_git_removed = { fg = "#ff0000", bg = "#ededee" },             -- red1 on grey3

      lualine_diagnostic_error = { fg = "#e80000", bg = "#ededee" },        -- red2
      lualine_diagnostic_warn = { fg = "#ff8700", bg = "#ededee" },         -- orange
      lualine_diagnostic_info = { fg = "#0087ff", bg = "#ededee" },         -- blue from visual
      lualine_diagnostic_hint = { fg = "#007fff", bg = "#ededee" },         -- t.blue

      lualine_filename_modified = { fg = "#e80000", bg = "#ededee", bold = true },
      lualine_filename_readonly = { fg = "#808080", bg = "#ededee", italic = true },
      lualine_filename_new = { fg = "#005f00", bg = "#ededee", bold = true },

      -- Context/Breadcrumb harmonized with original light theme colors
      NavicIconsFile = { fg = "#6D7281", bg = "#ededee" },                  -- t.fg, t.grey3
      NavicIconsModule = { fg = "#6D7281", bg = "#ededee" },
      NavicIconsClass = { fg = "#7f00ff", bg = "#ededee" },                 -- t.purple
      NavicIconsMethod = { fg = "#0087ff", bg = "#ededee" },                -- visual blue
      NavicIconsFunction = { fg = "#0087ff", bg = "#ededee" },
      NavicIconsProperty = { fg = "#005f00", bg = "#ededee" },              -- t.greenDark
      NavicIconsField = { fg = "#005f00", bg = "#ededee" },
      NavicIconsVariable = { fg = "#6D7281", bg = "#ededee" },              -- t.fg
      NavicIconsConstant = { fg = "#e80000", bg = "#ededee" },              -- t.red2
      NavicText = { fg = "#383A42", bg = "#ededee" },                       -- t.normalFG
      NavicSeparator = { fg = "#b9c2c6", bg = "#ededee" },                  -- t.grey20
    }
  else
    -- DARK THEME - Using EXACT original kalisi lualine dark theme
    return {
      -- Normal mode: EXACT from original
      lualine_a_normal = { fg = "#005f00", bg = "#afd700", bold = true },   -- N1
      lualine_b_normal = { fg = "#afd700", bg = "#005f00" },               -- N2
      lualine_c_normal = { fg = "#b5b5b5", bg = "#222222" },               -- N3 (StatusLine)
      lualine_x_normal = { fg = "#b5b5b5", bg = "#222222" },
      lualine_y_normal = { fg = "#afd700", bg = "#005f00" },
      lualine_z_normal = { fg = "#005f00", bg = "#afd700", bold = true },

      -- Insert mode: EXACT from original
      lualine_a_insert = { fg = "#ffffff", bg = "#e80000", bold = true },  -- I1
      lualine_b_insert = { fg = "#ff0000", bg = "#5f0000" },               -- I2
      lualine_c_insert = { fg = "#b5b5b5", bg = "#222222" },               -- I3
      lualine_x_insert = { fg = "#b5b5b5", bg = "#222222" },
      lualine_y_insert = { fg = "#ff0000", bg = "#5f0000" },
      lualine_z_insert = { fg = "#ffffff", bg = "#e80000", bold = true },

      -- Visual mode: EXACT from original
      lualine_a_visual = { fg = "#0087ff", bg = "#ffffff", bold = true },  -- V1
      lualine_b_visual = { fg = "#005faf", bg = "#5fafff" },               -- V2
      lualine_c_visual = { fg = "#87d7ff", bg = "#005faf" },               -- V3
      lualine_x_visual = { fg = "#87d7ff", bg = "#005faf" },
      lualine_y_visual = { fg = "#005faf", bg = "#5fafff" },
      lualine_z_visual = { fg = "#0087ff", bg = "#ffffff", bold = true },

      -- Replace mode: EXACT from original
      lualine_a_replace = { fg = "#d75fff", bg = "#ffffff", bold = true }, -- R1
      lualine_b_replace = { fg = "#5f005f", bg = "#d75fff" },              -- R2
      lualine_c_replace = { fg = "#ff87ff", bg = "#8700af" },              -- R3
      lualine_x_replace = { fg = "#ff87ff", bg = "#8700af" },
      lualine_y_replace = { fg = "#5f005f", bg = "#d75fff" },
      lualine_z_replace = { fg = "#d75fff", bg = "#ffffff", bold = true },

      -- Command mode: EXACT from original
      lualine_a_command = { fg = "#ffffff", bg = "#e80000", bold = true },
      lualine_b_command = { fg = "#ff0000", bg = "#5f0000" },
      lualine_c_command = { fg = "#b5b5b5", bg = "#222222" },
      lualine_x_command = { fg = "#b5b5b5", bg = "#222222" },
      lualine_y_command = { fg = "#ff0000", bg = "#5f0000" },
      lualine_z_command = { fg = "#ffffff", bg = "#e80000", bold = true },

      -- Inactive: EXACT from original
      lualine_a_inactive = { fg = "#636D83", bg = "#221C19" },
      lualine_b_inactive = { fg = "#636D83", bg = "#221C19" },
      lualine_c_inactive = { fg = "#636D83", bg = "#221C19" },
      lualine_x_inactive = { fg = "#636D83", bg = "#221C19" },
      lualine_y_inactive = { fg = "#636D83", bg = "#221C19" },
      lualine_z_inactive = { fg = "#636D83", bg = "#221C19" },

      -- Navic/breadcrumbs for dark mode
      NavicIconsFile = { fg = "#b5b5b5", bg = "#222222" },
      NavicIconsModule = { fg = "#b5b5b5", bg = "#222222" },
      NavicIconsClass = { fg = "#d75fff", bg = "#222222" },
      NavicIconsMethod = { fg = "#87d7ff", bg = "#222222" },
      NavicIconsFunction = { fg = "#87d7ff", bg = "#222222" },
      NavicText = { fg = "#E8E0DB", bg = "#222222" },
      NavicSeparator = { fg = "#636D83", bg = "#222222" },
    }
  end
end