#!/bin/bash

# kitty: sudo ranger can't read user $TERMINFO, therefore this file needs to be present in the default
# location reachable by root (sudo)
# After installing kitty
sudo cp /home/freeo/.local/kitty.app/lib/kitty/terminfo \
  /usr/share/terminfo/x/xterm-kitty
