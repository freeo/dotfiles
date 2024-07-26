#!/bin/bash

current_hour=$(date +%H)

# only works with absolute paths!
day_config="/home/freeo/dotfiles/config/kitty/lightmode.conf"
night_config="/home/freeo/dotfiles/config/kitty/darkmode.conf"

start_kitty() {
  if [ "$current_hour" -ge 22 ] || [ "$current_hour" -lt 10 ]; then
    kitty --config "$night_config" "$@"
  else
    kitty --config "$day_config" "$@"
  fi
}

start_kitty "$@"

