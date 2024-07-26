#!/bin/zsh

# echo "${@:-$PWD}"
# temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
# kitty zsh -ic 'ranger --choosedir="$temp_file" -- "${@:-$PWD}"'
# if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
#     cd -- "$chosen_dir"
# fi
# rm -f -- "$temp_file"

# RANGERCD=true; kitty

# kitty "zsh -ic 'ranger ${@:-$PWD}'"
# kitty zsh -ic ranger
