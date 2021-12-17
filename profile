# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
/usr/bin/setxkbmap -option "ctrl:nocaps"

# Manual brew loading
# Note: without this guard the whole system may fail: if brew isn't installed, .profile will fail upon gnome shell
# login and result in an inescapable black screen.
test -x "$(which /home/linuxbrew/.linuxbrew/bin/brew)"
retVal=$?
if [ $retVal -eq 0 ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

. "$HOME/.cargo/env"

export XSECURELOCK_SAVER=saver_xscreensaver
export XSECURELOCK_FONT="Noto Mono"
export XSECURELOCK_PASSWORD_PROMPT="asterisks"
export XSECURELOCK_AUTH_BACKGROUND_COLOR="#550000"
