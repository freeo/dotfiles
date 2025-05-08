local M = {}

-- Function to format JSON in the current line
function M.format_json_in_line()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()

  -- Use a more robust pattern to find JSON content
  -- This looks for the leftmost { and the rightmost } in the line
  local start_idx = string.find(line, "{")
  local end_idx = string.find(string.reverse(line), "}")

  if not start_idx or not end_idx then
    vim.notify("No JSON object found in the current line", vim.log.levels.WARN)
    return
  end

  -- Convert the reversed index to the correct position
  end_idx = #line - end_idx + 1

  -- Extract the JSON string
  local json_str = string.sub(line, start_idx, end_idx)

  -- Debug output to check what we're parsing
  vim.notify("Extracted JSON: " .. json_str:sub(1, 50) .. "...", vim.log.levels.INFO)

  -- Try to parse and format the JSON
  local success, result = pcall(function()
    -- Parse the JSON string
    local parsed = vim.fn.json_decode(json_str)

    -- Format the JSON with proper indentation
    return parsed
  end)

  if not success then
    vim.notify("Failed to parse JSON: " .. tostring(result), vim.log.levels.ERROR)
    return
  end

  -- Generate formatted JSON
  local formatted_json = vim.fn.system("echo " .. vim.fn.shellescape(vim.fn.json_encode(result)) .. " | jq .")

  -- Remove trailing newline added by jq
  formatted_json = formatted_json:gsub("\n$", "")

  -- Split the line into before JSON, JSON, and after JSON
  local before_json = string.sub(line, 1, start_idx - 1)
  local after_json = string.sub(line, end_idx + 1)

  -- Get current cursor position
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  -- Create a table of lines to replace the current line
  local replacement_lines = {}
  table.insert(replacement_lines, before_json)

  -- Add formatted JSON lines
  for json_line in formatted_json:gmatch("[^\n]+") do
    table.insert(replacement_lines, json_line)
  end

  if after_json ~= "" then
    table.insert(replacement_lines, after_json)
  end

  -- Replace the current line with the formatted lines
  vim.api.nvim_buf_set_lines(0, cursor_row - 1, cursor_row, false, replacement_lines)

  vim.notify("JSON formatted successfully", vim.log.levels.INFO)
end

-- Set up the command and keybinding
function M.setup()
  -- Register the command
  vim.api.nvim_create_user_command("FormatInlineJSON", function()
    M.format_json_in_line()
  end, { desc = "Format JSON in the current line" })

  -- Register the keybinding (Ctrl+J)
  vim.keymap.set("n", "<C-j>", function()
    M.format_json_in_line()
  end, { desc = "Format JSON in the current line" })
end

return M
