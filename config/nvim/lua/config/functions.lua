-- function AnonymizeLLM()

--[[
Lua functions and keybindings for Neovim to execute a predefined
set of Ex commands on a specified range (visual selection or whole file).
]]

function AnonymizeForLLM(range_prefix)
  local hardcoded_commands = {
    "s/Nebius/Moebius/g",
    "s/nebius/moebius/g",
    "s/neuzeit\\.cloud/newcube.com/g",
    "s/neuzeit/newcube/g",
    "s/Neuzeit/Newcube/g",
    "s/freeo/username/g",
    -- "s/\\s\\+$//e", -- Example 3: Remove trailing whitespace (e flag suppresses errors if no match)
  }
  Apply_commands(range_prefix, hardcoded_commands)
end

function DeanonymizeForLLM(range_prefix)
  local hardcoded_commands = {
    "s/Moebius/Nebius/g",
    "s/moebius/nebius/g",
    "s/newcube\\.com/neuzeit.cloud/g",
    "s/newcube/neuzeit/g",
    "s/Newcube/Neuzeit/g",
    "s/username/freeo/g",
    -- "s/\\s\\+$//e", -- Example 3: Remove trailing whitespace (e flag suppresses errors if no match)
  }
  Apply_commands(range_prefix, hardcoded_commands)
end

--- Helper function to execute a predefined list of commands on a range
-- @param range_prefix string The range prefix (e.g., "%", "10,20").

function Apply_commands(range_prefix, commands)
  -- Define the hardcoded commands here

  local success_count = 0
  local error_count = 0
  local cmds_executed_str = "" -- Keep track of commands attempted

  -- vim.notify("Executing hardcoded commands on range [" .. range_prefix .. "]...", vim.log.levels.INFO)

  for i, cmd in ipairs(commands) do
    -- Construct the full command with the range prefix
    -- Example: If range_prefix is '%' and cmd is 's/foo/bar/g',
    -- full_cmd becomes '%s/foo/bar/g'
    local full_cmd = range_prefix .. cmd
    cmds_executed_str = cmds_executed_str .. "\n - " .. full_cmd

    -- Execute the command using pcall for error handling
    local ok, err = pcall(vim.cmd, full_cmd)
    if not ok then
      -- vim.notify("Error executing: " .. full_cmd .. "\n" .. tostring(err), vim.log.levels.ERROR)
      error_count = error_count + 1
      -- break -- Optional: Uncomment this line to stop on the first error
    else
      -- Optional: Could check if any substitution actually happened if needed,
      -- but vim.cmd doesn't directly return that info easily.
      success_count = success_count + 1 -- Count successful executions attempt
    end
  end

  -- Report final status
  local final_message = string.format(
    "Finished executing %d commands on range [%s].\nSuccess: %d, Errors: %d.\nCommands:%s",
    #commands,
    range_prefix,
    success_count,
    error_count,
    cmds_executed_str
  )
  local level = vim.log.levels.INFO
  if error_count > 0 then
    level = vim.log.levels.WARN
  end
  if success_count == 0 then
    level = vim.log.levels.ERROR
    vim.notify(final_message, level, { title = "AnonymizeForLLM Report" })
  end
end

--- Keybindings Setup ---

-- Normal mode: Execute hardcoded commands on the whole file ('%')
-- Example keymap: <leader>xf (leader, x, f for file)
vim.keymap.set("n", "<leader>a", function()
  AnonymizeForLLM("%")
end, { noremap = true, silent = true, desc = "Execute hardcoded Ex cmds on File" })

-- Visual mode: Execute hardcoded commands on the visual selection ('<,'>)
-- Example keymap: <leader>x (leader, x) - works in visual mode
vim.keymap.set("v", "<leader>a", function()
  -- Get visual selection line numbers
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  -- Ensure positions are valid (getpos returns [bufnum, lnum, col, off])
  -- if start_pos[2] == 0 or end_pos[2] == 0 then
  --   vim.notify("Invalid visual selection.", vim.log.levels.WARN)
  --   return
  -- end
  local start_line = start_pos[2]
  local end_line = end_pos[2]
  -- Construct the range string like '10,20' or just '15' if it's one line
  local range_prefix = start_line .. "," .. end_line
  AnonymizeForLLM(range_prefix)
end, { noremap = true, silent = true, desc = "Execute hardcoded Ex cmds on Selection" })

-- Note: The original M.execute_commands_on_range function that prompted
-- for input has been removed as it's not used by these keybindings.
-- If you need both functionalities, you would keep both the original
-- function and these new keybindings (assigning them to different keys).

vim.api.nvim_create_user_command(
  "AnonymizeForLLM",
  function(opts)
    -- opts contains information about the command invocation:
    -- opts.line1: starting line number of the range
    -- opts.line2: ending line number of the range
    -- opts.range: number of items in the range (0: none, 1: cursor line, 2: range/visual/%)

    -- Construct the range prefix string based on the provided range
    -- Vim translates % to 1,last_line and visual '<,'> to start,end
    -- If no range is given, opts.range is 0, but line1/line2 are the current line.
    -- So, simply using line1,line2 works for all cases handled by -range=%
    local range_prefix = opts.line1 .. "," .. opts.line2

    -- Call the main logic function
    AnonymizeForLLM(range_prefix)
  end,
  -- Command options
  {
    -- Description shown in command-line completion
    desc = "Execute hardcoded substitution commands on a range to anonynmize string for public LLM usage",
    -- Allow the command to be executed with a range (e.g., :%, :'<,'>, :10,20)
    -- % means it defaults to the current line if no range is specified.
    range = "%",
    -- nargs = 0 -- No additional arguments needed after the command name (default)
  }
)

vim.api.nvim_create_user_command(
  "DeanonymizeForLLM",
  function(opts)
    -- opts contains information about the command invocation:
    -- opts.line1: starting line number of the range
    -- opts.line2: ending line number of the range
    -- opts.range: number of items in the range (0: none, 1: cursor line, 2: range/visual/%)

    -- Construct the range prefix string based on the provided range
    -- Vim translates % to 1,last_line and visual '<,'> to start,end
    -- If no range is given, opts.range is 0, but line1/line2 are the current line.
    -- So, simply using line1,line2 works for all cases handled by -range=%
    local range_prefix = opts.line1 .. "," .. opts.line2

    -- Call the main logic function
    DeanonymizeForLLM(range_prefix)
  end,
  -- Command options
  {
    -- Description shown in command-line completion
    desc = "Execute hardcoded substitution commands on a range to anonynmize string for public LLM usage",
    -- Allow the command to be executed with a range (e.g., :%, :'<,'>, :10,20)
    -- % means it defaults to the current line if no range is specified.
    range = "%",
    -- nargs = 0 -- No additional arguments needed after the command name (default)
  }
)
