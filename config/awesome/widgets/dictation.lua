-- Nerd Dictation Handler
-- Contains state popup and handles the process
--
-- logfile: /home/freeo/workbench/awm_dict.log
--
-- debugging:
-- I kept htop open with a filter for nerd dictation
-- As long as the widget is showing this means there must be some sort of success because opening the process a single instance is more difficult than closing it. the pop up will only be displayed after successful spawn. closing is rather easy the and the pop up was reliable so far for both cases.
--
-- open:
-- hardcoded logfile
-- hardcoded Audio Contoller (can the pactl ID change?)
-- verbose: too many naughty notifications
--
-- how to extract the pulseaudio name:
-- pactl list short sources
-- 52 alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input	PipeWires32le 10ch 48000Hz


-- export self
local dictation = {}

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

local focused = awful.screen.focused()

local microphone = require("widgets.microphone")

local dictation_container = wibox({
  focused = awful.screen.focused(),
  x = (focused.geometry.width / 2) - 80,
  y = (focused.geometry.height) - 128,
  width = 160,
  height = 64,
  bg = beautiful.hud_panel_bg,
  shape = gears.shape.rounded_rect,
  visible = false,
  ontop = true,
  opacity = 1
})

local dictation_text = wibox.widget {


  widget = wibox.widget.textbox,
  valign = "center",
  halign = "center",
  markup = "<span foreground='#42239F'><b>voice type</b></span>",
  font = "sans 12",
}

local dictation_popup = wibox.widget {
  -- bg     = "#613AD4",
  bg               = "#9D6DCA",
  -- clip   = true,
  widget           = wibox.widget.background,
  -- shape = gears.shape.rounded_rect,
  shape            = gears.shape.rectangle,
  color            = beautiful.hud_slider_fg,
  background_color = beautiful.hud_slider_bg,
  forced_height    = 50,
  forced_width     = 50
}



dictation_container:setup {
  {
    -- forced_height = offsety,
    -- forced_width = offsetx,
    direction = "north",
    layout = wibox.container.rotate,
    -- dictation_popup,
    wibox.container.margin(
      dictation_popup, dpi(4), dpi(4), dpi(4), dpi(4), "#42239F"
    ),

    -- "#42239F"
    -- wibox.container.margin (widget, left, right, top, bottom, color, draw_empty)
  },
  {
    dictation_text,
    widget = wibox.container.place,
    -- widget = wibox.container.background,
  },
  layout = wibox.layout.stack
}

-- begin \
--pulse-device-name=alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input

function Handle_Error(pid_or_error)
  -- pid_or_error is only then a string, if it's an error. Otherwise it's int (PID of process)
  if (type(pid_or_error) == "string") then
    local err = pid_or_error
    naughty.notify({ title = "Dictation Error", text = err })
    return false
  end
  return true
end

function Dictate_begin()

  local script = [=[bash -c '

      # echo $$ >> "/home/freeo/wb/awm_dict.log"
      # ps -x | rg -v $$ >>  "/home/freeo/wb/awm_dict.log"
      DURR=$(ps -x | rg -v $$ | rg -v "/bin/zsh -c")
      # echo $DURR >> "/home/freeo/wb/awm_dict.log"
      # echo $DURR | rg "nerd-dictation"
      echo $DURR | rg "nerd-dictation begin"
      ret=$?
      echo $? >> "/home/freeo/wb/awm_dict.log"
      echo $ret
      if [ $ret -ne 0 ]; then
          echo "starting dict..." >> "/home/freeo/wb/awm_dict.log"
          cd /home/freeo/tools/nerd-dictation
          poetry run python ./nerd-dictation begin --pulse-device-name=alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input &
          echo "run in background" >> "/home/freeo/wb/awm_dict.log"
          echo "dictation started"
      else
        echo "dictation already running!" >> "/home/freeo/wb/awm_dict.log"
      fi
      exit 1

  ' & ]=]


  -- local script = [=[bash -c '

  --     # echo $$ >> "/home/freeo/wb/awm_dict.log"
  --     # ps -x | rg -v $$ >>  "/home/freeo/wb/awm_dict.log"
  --     DURR=$(ps -x | rg -v $$ | rg -v "/bin/zsh -c")
  --     # echo $DURR >> "/home/freeo/wb/awm_dict.log"
  --     # echo $DURR | rg "nerd-dictation"
  --     echo $DURR | rg "python3 /usr/bin/nerd-dictation begin"
  --     ret=$?
  --     echo $? >> "/home/freeo/wb/awm_dict.log"
  --     echo $ret
  --     if [ $ret -ne 0 ]; then
  --         echo "starting dict..." >> "/home/freeo/wb/awm_dict.log"
  --         cd /home/freeo/tools/nerd-dictation
  --         poetry run python ./nerd-dictation begin --pulse-device-name=alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input &
  --         echo "run in background" >> "/home/freeo/wb/awm_dict.log"
  --         echo "dictation started"
  --     else
  --       echo "dictation already running!" >> "/home/freeo/wb/awm_dict.log"
  --     fi
  --     exit 1

  -- ' & ]=]


          -- /usr/bin/nerd-dictation begin --pulse-device-name=alsa_input.usb-Focusrite_Scarlett_8i6_USB_F8V7G1C090917A-00.multichannel-input &

  -- # echo $DURR | rg "nerd-dictation" >> "/home/freeo/wb/awm_dict.log"
  -- ps -aux | grep python >> "/home/freeo/wb/awm_dict.log"
  -- naughty.notify({ title="Debug", text="exists:"..exists })

  -- awful.spawn.easy_async(script, function(stdout, stderr, reason, exit_code)
  --                          naughty.notify { text = "exitcode: "..tostring(exit_code) }
  --                          if (exit_code == 0) then
  --                             dictation_container.visible = true
  --                          end
  --                          return false
  -- end)

  awful.spawn.with_line_callback(script, {
    stdout = function(line)
      -- naughty.notify { text = "line: "..line }
      if (line == "dictation started") then
        dictation_container.visible = true
        microphone.On()
      end
    end,
    stderr = function(line)
      naughty.notify { text = "ERR:" .. line }
    end,
    exit = function(line)
      naughty.notify { text = "Exit: " .. line }
    end,
  })

  -- return Handle_Error(pid_or_error)
end

-- pgrep -f "nerd-dictation"
-- ret=$?
-- if [ $ret -ne 0 ]; then
--   echo "not running"
-- else
--   echo "running! dont do again"
-- fi


function Dictate_end()
  local script = [=[bash -c '
    cd /home/freeo/tools/nerd-dictation
    poetry run python ./nerd-dictation end
    echo "dictation ended"
   ' ]=]


  awful.spawn.with_line_callback(script, {
    stdout = function(line)
      if (line == "dictation ended") then
        dictation_container.visible = false
        microphone.Off()
      end
    end,
    stderr = function(line)
      naughty.notify { text = "ERR:" .. line }
    end,
    exit = function(line)
      naughty.notify { text = "Exit: " .. line }
    end,
  })

  -- return Handle_Error(pid_or_error)
end

-- function Dictate_end()
--   local pid_or_error = awful.spawn.with_shell(
--     "/usr/bin/nerd-dictation end")
--   return Handle_Error(pid_or_error)
-- end

function dictation.Toggle()
  naughty.notify({ title="Dict ", text="starting"})
  if (dictation_container.visible == false) then
    Dictate_begin()
  else
    pid_or_error = Dictate_end()
  end
  -- naughty.notify({ title="Dict", text="visible:"..tostring(dictation_container.visible)})
end

return dictation
