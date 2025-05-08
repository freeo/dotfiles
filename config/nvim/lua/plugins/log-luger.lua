return {
  "luger",
  dev = true,
  dir = vim.fn.stdpath("config") .. "/lua/custom/luger",
  config = function()
    -- local luger = require("luger")
    local luger = require("custom.luger.lua.format-inline-json")
    -- Register the command
    vim.api.nvim_create_user_command("FormatInlineJSON", function()
      luger.format_json_in_line()
    end, { desc = "Format JSON in the current line" })

    -- Register the keybinding (Ctrl+J)
    -- fMt, f is taken so use m, similar to emx 'm'arkup
    -- l for log
    vim.keymap.set("n", "<leader>ml", function()
      luger.format_json_in_line()
    end, { desc = "Format JSON in the current line" })
  end,
}
