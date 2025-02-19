#!/usr/bin/zsh

# Where CMD1 & CMD2 came from:

# STDERR: works!
# ls -l /proc/$(pidof awesome)/fd/2
# /home/freeo/.local/share/sddm/xorg-session.log

# # very detailled! but probably a good idea while developing.
# sudo strace -p <PID> -s9999 -e write

# #STDOUT (empty?)
# sudo tail -f /proc/$(pidof awesome)/fd/1

# # Doesn't work, awesome tries to start, then goes back into sddm, although I saw a mouse cursor for a second.
# /usr/share/xsessions/awesome-debug.desktop
# Exec=sh -c 'exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr'


function awmdebug () {
    # Define the commands for each window
    CMD1="tail -f /proc/$(pidof awesome)/fd/1"
    CMD2="tail -f /home/freeo/.local/share/sddm/xorg-session.log"

    # Create a temporary session file
    SESSION_FILE=$(mktemp)

# Write the Kitty session configuration
cat << EOF > "$SESSION_FILE"
new_tab
layout vertical
launch --title "awm:stdout" bash -c "$CMD1"
launch --title "awm:sterr" bash -c "$CMD2"
EOF

    # Launch a new Kitty instance with the session file
    # hacky, but works like disown
    # (nohup kitty --session "$SESSION_FILE" >/dev/null 2>&1 &) &
    kitty --session "$SESSION_FILE" >/dev/null 2>&1 &
    sleep 1 # otherwise SESSION_FILE is deleted too quickly
    rm "$SESSION_FILE"
    disown
}

