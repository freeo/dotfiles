#!/bin/zsh
# PROFILING this .zshrc:
# NOTE: Last line of this script is necessary to know when to stop
# zmodload zsh/zprof 

# don't execute the rest of this .zshrc if connecting via emacs TRAMP
[[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return

# Background Color for more readable lolcat
# https://unix.stackexchange.com/questions/608538/how-to-use-256-colors-for-background-color-in-terminal
# print -rP '%K{#303030}'

# template: if app x exists
# if hash x 2>/dev/null ; then

# if hash fortune 2>/dev/null && hash lolcat 2>/dev/null ; then
#   # seed to avoid unreadable green
#   fortune | lolcat --seed 1337 --spread 4
# fi
# echoti setab [%?%p1%{8}%<%t4%p1%d%e%p1%{16}%<%t10%p1%{8}%-%d%e48;5;%p1%d%;m

# Outdated!
# careful: zi not zinit
# https://github.com/z-shell/zi
# zi_home="${HOME}/.zi"
# source "${zi_home}/bin/zi.zsh"
# autoload -Uz _zi
# (( ${+_comps} )) && _comps[zi]=_zi

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-    …continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export ZSH="$HOME/.oh-my-zsh"

# p10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
# zstyle :compinstall filename '/home/freeo/.zshrc'



if [[ $TERM = "xterm-kitty" ]]; then
  # BLOCK & LINE tested in Linux and macOS
  BLOCK="\033[1 q"
  LINE="\033[5 q"
  # Completion for kitty
  autoload -Uz compinit
  compinit
  # kitty + complete setup zsh | source /dev/stdin
  # awesome, fixes multiple ssh problems using kitty
  alias ssh="kitty +kitten ssh"
fi

# Common settings ###################
# export NVM_LAZY_LOAD=true # for zsh-nvm

export AUTO_NOTIFY_THRESHOLD=10
# export AUTO_NOTIFY_EXPIRE_TIME=3000 # milliseconds, linux only
AUTO_NOTIFY_IGNORE+=("ranger")
# export BAT_THEME="Monokai Extended Light"

if hash dyff 2>/dev/null ; then
  export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code --filter=metadata.managedFields"
fi

alias md='mkdir'
alias sz='source ~/.zshrc'
alias l='eza -la'
# function la () {
  # exa -la
# }
alias pcat='pygmentize -f terminal256 -O style=native -g'

export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
export PATH="$PATH:$HOME/.config/emacs/bin"
export PATH="$PATH:$HOME/.cargo/env"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/dotfiles/scripts"
export PATH="$PATH:$HOME/.linkerd2/bin"



alias RC='python3 $HOME/dotfiles/scripts/rcselect.py'
alias RCZ='nvim ~/.zshrc'
alias RCV='nvim ~/.config/nvim/init.vim'
alias RCA='nvim ~/.config/awesome/rc.lua'
alias RCK='nvim ~/.config/kitty/kitty.conf'

typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯❯❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='😎❮'
typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=true

# this SKIM_DEFAULT_COMMAND: 1.37 seconds for ~1.4 million files, faster than fd
export SKIM_DEFAULT_COMMAND="rg --files --no-ignore --hidden"
function skind() {
  file="$(sk --bind "ctrl-p:toggle-preview" --ansi -i --cmd-query "$*" -c 'rg --ignore-case --color=always --line-number --column {}' --preview-window 50%:wrap --preview 'bat --color=always --style=header,numbers --highlight-line "$(echo {1}|cut -d: -f2)" --line-range "$(($(echo {1}|cut -d: -f2)-5 > 1 ? $(echo {1}|cut -d: -f2)-5 : 1)):$(($(echo {1}|cut -d: -f2)+50))" "$(echo {1}|cut -d: -f1)"')"; [[ $? -eq 0 ]] && echo "opening $file" && emacsclient -n "+$(echo "$file"|cut -d: -f2):$(echo "$file"|cut -d: -f3)" "$(echo "$file"|cut -d: -f1)"
}
zle -N skind
# C-/ equals ^_
bindkey -s "^_" "skind\n"



find_file() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

say() {
    vterm_cmd message "%s" "$*"
}

# Linux settings ###################
# if ostype == Linux
function linuxSettings () {
  export SHELL=/usr/bin/zsh

  function xset_rate_freeo() {
    xset r rate 230 40
  }

  if hash xset 2>/dev/null ; then
    xset_rate_freeo
  fi

  export EDITOR=nvim
  export VISUAL=nvim
  # export EDITOR="snap run nvim"
  # export VISUAL="snap run nvim"

  # ra = reset audio
  alias ra="pulseaudio -k"
  # reset capslock to ctrl
  alias nocaps="setxkbmap -option ctrl:nocaps"
  alias NOCAPS="xdotool key Caps_Lock; setxkbmap -option ctrl:nocaps"
  alias CAPSLOCK="xdotool key Caps_Lock"
  alias capslock="xdotool key Caps_Lock"
  alias win10h="systemctl hibernate --boot-loader-entry=Windows10.conf"
  alias win10="systemctl reboot --boot-loader-entry=Windows10.conf"

  alias chmod="chmod --preserve-root -v"
  alias chown="chown --preserve-root -v"

  HASVLC=$(flatpak run org.videolan.VLC --version 2>/dev/null)
  if [ $? -eq 0 ]; then
      alias vlc="flatpak run org.videolan.VLC"
  fi

  HASDRAWIO=$(flatpak run com.jgraph.drawio.desktop --version 2>/dev/null)
  if [ $? -eq 0 ]; then
      alias draw.io="flatpak run com.jgraph.drawio.desktop"
  fi

  alias tosh2='xrandr --output HDMI-0 --mode 1920x1080 --rate 50.00 --pos 0x0'
  alias ng92='xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144'

  alias tosh='xrandr --output DP-0 --off \
              --output HDMI-0 --mode 1920x1080 --pos 0x0 --rate 50.00 --dpi 96'
  alias ng9='xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 --output HDMI-0 --off'
  alias xboth='xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 --output HDMI-0 --mode 1920x1080 --rate 60 --pos 5120x180 --dpi 96'
  alias xdp0='xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 --output HDMI-0 --mode 1920x1080 --rate 60 --pos 5120x180 --dpi 96'

  alias a8="bash /home/freeo/dotfiles/scripts/toggle_neog9.sh"
  alias a9="xrandr --listactivemonitors | grep HDMI-0 >/dev/null && xrandr --output HDMI-0 --off || xrandr --output HDMI-0 --mode 1920x1080 --rate 50 --pos 5120x0 --dpi 96"

  # snap requires the dirty sudo workaround. snap alias also breaks autocomplete
  # ---
  # tricking shells into scanning commands after sudo for other aliases as well
  # most notably: `sudo nvim`, where alias nvim='/home/linuxbrew/.linuxbrew/bin/nvim'
  # alias sudo='sudo '
  # alias nvim="snap run nvim"
  # XXX guard! what before linuxbrew?
  # alias nvim='/home/linuxbrew/.linuxbrew/bin/nvim' # tested, works
  alias pbcopy='xclip -selection clipboard'
  alias clip='xclip -selection clipboard'
  alias clipboard='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'


  # export GRAALVM_HOME=/usr/lib/jvm/graalvm-ce-java8-20.3.0
  # export JAVA_HOME=$GRAALVM_HOME
  export ANDROID_HOME=$HOME/Android/Sdk
  # export ANDROID_HOME=/opt/android-sdk
  # export PATH=$GRAALVM_HOME/bin:$PATH
  # for adb
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH=$PATH:~/bin
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$PATH:$XDG_CONFIG_HOME/rofi/rofi-power-menu

  export PATH=$PATH:$HOME/go/bin

  # QT HiDPI Scaling
  # These two don't work on Krita
  # export QT_SCALE_FACTOR=1
  # export QT_AUTO_SCREEN_SCALE_FACTOR=0.7
  # Works on Krita
  export QT_SCREEN_SCALE_FACTORS="1.5;1.5"
  export QT_QPA_PLATFORMTHEME=qt5ct

  if hash paru 2>/dev/null ; then
    alias PS='sudo paru -S'
    alias PA='paru -S'
    alias PR='sudo paru -R'
  fi

  # workaround to restart network adapter
  alias fkasus="echo 1 | sudo tee "/sys/bus/pci/devices/$(lspci -D | grep 'Ethernet Controller I225-V' | awk '{print $1}')/remove" && sleep 1 && echo 1 | sudo tee /sys/bus/pci/rescan"

  alias fkdhcp="echo 1 | sudo tee "/sys/bus/pci/devices/$(lspci -D | grep 'Ethernet Controller I225-V' | awk '{print $1}')/remove" && sleep 1 && echo 1 | sudo tee /sys/bus/pci/rescan"

  alias fkdhcp="echo 1 | sudo tee "/sys/bus/pci/devices/{}/remove" && sleep 1 && echo 1 | sudo tee /sys/bus/pci/rescan"

# 0000:05:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
# 0000:05:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)

# echo 1 | sudo tee "/sys/bus/pci/devices/0000:05:00.0/remove" && sleep 1 && echo 1 | sudo tee /sys/bus/pci/rescan

# lspci -D | grep '10-Gigabit X540-AT2' | awk '{print $1}'
# lspci -D | grep '10-Gigabit X540-AT2' | awk '{print $1}' | xargs -I {} echo "/yay/{}/remove"
# lspci -D | grep '10-Gigabit X540-AT2' | awk '{print $1}' | xargs -I {} echo 1 | sudo tee "/sys/bus/pci/devices/{}/remove" && sleep 1 && echo 1 | sudo tee /sys/bus/pci/rescan


  # since I started with tiling window managers (currently awesome)
  export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
# GTK2_RC_FILES=/usr/share/themes/Raleigh/gtk-2.0/gtkrc
}

# Linux Environment Variables, not conflicting with Darwin
export GREP_COLORS="1;97;102"


# macOS settings ###################
# if ostype == darwin
function darwinSettings () {
  export SHELL=/bin/zsh
  export PATH=/usr/local/bin:$PATH
  # . $(brew --prefix asdf)/asdf.sh

  export EDITOR=nvim
  export VISUAL=nvim
  # export JAVA_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.2.0/Contents/Home
  # export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.2.0/Contents/Home
  # export PATH=$GRAALVM_HOME/bin:$PATH
  export PATH=~/go/bin:$PATH
  export PATH=/usr/local/opt/avr-gcc@7/bin:$PATH

  export GREP_COLOR=$GREP_COLORS
  # nvim: rnvimr (ranger-vim popup) workaround: fix Ctrl-V not requiring 2x presses
  stty lnext undef
  # successor: zoxide
  # [ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh
  #
  alias gdu="echo 'ALIAS NOTE: gdu is a core utility and gdu-go is the actual application name.'; gdu-go"
}

br_exists=$HOME/.config/broot/launcher/bash/br
[ -f $br_exists ] && source $br_exists

zinit light Tarrasch/zsh-bd
zinit light darvid/zsh-poetry
zinit light fdw/ranger-zoxide # provides: r "input"
# zinit light lukechilds/zsh-nvm
zinit light zdharma/fast-syntax-highlighting

# Issue:
# _zsh_highlight-zle-buffer:25: permission denied:
# _zsh_highlight-zle-buffer:27: not an identifier:
# zinit light trapd00r/zsh-syntax-highlighting-filetypes

# provides:
#   archive
#   unarchive
#   lsarchive : lists content of archives
zinit light zimfw/archive
zinit light zimfw/git
zinit light zimfw/input # try out: maybe fixes some nested prompt issues, like in pdb, where I can't DEL and BACKSPACE properly
# zinit light zimfw/magic-enter # incompatible with p10k
zinit light zsh-users/zsh-autosuggestions
zinit ice wait'1' lucid
zinit light mellbourn/zabb
# zinit load wfxr/forgit # XXX checkout "grc"
zinit light zsh-users/zsh-completions # XXX
# zinit light zimfw/completion
zinit light MichaelAquilina/zsh-you-should-use


# zi light zimfw/exa # creates bad aliases

# Add wisely, as too many plugins slow down shell startup.
case "$OSTYPE" in
  darwin*)
    # ...`
    zinit light MichaelAquilina/zsh-auto-notify

    darwinSettings
  ;;
  linux*)
    # ...
    # zi light MichaelAquilina/zsh-auto-notify
    # silence notify inside of emacs, as EVERY cmd triggers a notification!
    if [[ -z "$INSIDE_EMACS" ]]; then
      if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
        # don't load in vagrant and other ssh environments!
      else
        zinit light marzocchi/zsh-notify
      fi
    fi
    # plugins=(
    #   git
    #   # auto-notify
    #   notify
    #   zsh-autosuggestions
    # )
    linuxSettings
  ;;
esac



# emacs-vterm

if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
  source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh

# TODO NOTE: Undo this line, which breaks zsh-autosuggest
# file: ~/.emacs.d/.local/straight/repos/emacs-libvterm/etc/emacs-vterm-zsh.sh
# add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }

  # for gruvbox-light
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a89984" #dark4
  # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#000088,bold"

  # this line doesn't work due to p10k owning "PROMPT"
  #   PROMPT=$PROMPT:'%{$(vterm_prompt_end)%}'
  # and needs to be replaced with this function, which is registered in
  # `~/.p10k.zsh` as simply "trackdir", "prompt_" is ignored
  function prompt_trackdir() {
    # the icon is required as a workaround! vterm_prompt_end doesn't work in an empty segment
    # the icon is just a simple way to fill the segment.
    p10k segment -i "" -t "%{$(vterm_prompt_end)%}"
  }

  # 😇😈✂✏
  # ❯01❮
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='😈'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='VIS✂'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='RWR✏'

  # typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=50
  export EDITOR=emacsclient
  export VISUAL=emacsclient
  export GIT_EDITOR=emacsclient


fi

zstyle ':completion:*' menu select

# TODO: Moved down here, otherwise I can't see installation progress... Observe if it's ok to stay here.
# ---
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Git aliases, additionally on top of zimfw/git
# upper case f for same shortcut, as magit uses
alias GF="git pull"
alias GFr="git pull --rebase"
alias GFm="git pull --no-rebase"
alias Gfa="git fetch --all"


# source $ZSH/oh-my-zsh.sh


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"


export PATH=/opt/local/bin:/opt/local/sbin:$PATH

SPACESHIP_PROMPT_ADD_NEWLINE="true"
SPACESHIP_CHAR_SYMBOL="\uf0e7"
# SPACESHIP_CHAR_PREFIX=”\uf296"
SPACESHIP_CHAR_PREFIX="\uf296"
# SPACESHIP_CHAR_SUFFIX=(" ")
SPACESHIP_CHAR_COLOR_SUCCESS="yellow"
SPACESHIP_PROMPT_DEFAULT_PREFIX="$USER"
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true"
SPACESHIP_USER_SHOW="true"

SPACESHIP_DIR_COLOR="green"
SPACESHIP_GOLANG_COLOR="blue"
SPACESHIP_DOCKER_COLOR="green"
# SPACESHIP_KUBECONTEXT_COLOR="5f00ff"
SPACESHIP_KUBECONTEXT_COLOR="blue"
SPACESHIP_VI_MODE_COLOR="black"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# export PATH



freeohelp () {
  echo "pcat     - syntax-colored cat output (pygmentize-cat). Requires pip3 install Pygments"
  # echo "mdv      - markdown viewer"
}

# guard for justfile, which can't deal with these settings
if [[ -o interactive ]]; then
    setopt zle
fi
setopt aliases
setopt no_nomatch
setopt vi
setopt autocd
setopt extendedhistory
setopt noflowcontrol
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt interactivecomments
setopt longlistjobs
# shares .zsh_history among tabs. Try without for a while, what feels more natural
# off seems more sensible
# setopt sharehistory
setopt autopushd
# use with: cd -<tab>

# from omz, not in use
# alwaystoend
# completeinword
# interactive
# promptsubst
# pushdignoredups
# pushdminus

HISTFILE=~/.zsh_history
HISTSIZE=1000000   # the number of items for the internal history list
SAVEHIST=1000000   # maximum number of items for the history file

if [[ -f ~/.atuin/bin/atuin ]]; then
  export PATH=~/.atuin/bin:$PATH
fi

# atuin: before fzf!
# So that the default atuin mapping "arrow up" can be overwritten by fzf
if hash atuin 2>/dev/null; then
  zinit load atuinsh/atuin
fi


# Fuzzy Finder needs to be loaded *after* ZLE, otherwise it won't be available on
# startup, but only after manually sourcing this .zshrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# NOTE: run this if the file above doesn't exist:
# $(brew --prefix)/opt/fzf/install
#
# Load key-bindings (pacman package provides this file), most notably CTRL-R
FZFKEYBINDINGS=/usr/share/fzf/key-bindings.zsh
# ^K doubles as literal 'k' and arrow up. Nice, because I can use the same keypress to go up.
bindkey -M viins '^K' fzf-history-widget
bindkey -M vicmd '^K' fzf-history-widget
bindkey -M viins '^[[A' fzf-history-widget
bindkey -M vicmd '^[[A' fzf-history-widget


[ -f $FZFKEYBINDINGS ] && source $FZFKEYBINDINGS
# configures fzf to use fd, rg
zinit light zimfw/fzf
# fallback if fzf not installed:
if ! typeset -f fzf-history-widget &>/dev/null; then
  bindkey '^r' history-incremental-search-backward
  bindkey '^K' history-incremental-search-backward
fi


# atuin: after fzf!
# overwrite default fzf keybindings
if hash atuin 2>/dev/null; then
  bindkey -M viins '^R' _atuin_search_widget
  bindkey -M vicmd '^R' _atuin_search_widget
  bindkey -M viins '^K' _atuin_up_search_widget
  bindkey -M vicmd '^K' _atuin_up_search_widget
  bindkey -M viins '^[[A' _atuin_up_search_widget
  bindkey -M vicmd '^[[A' _atuin_up_search_widget
fi



zinit light Aloxaf/fzf-tab

bindkey '^s' history-incremental-search-forward

# https://dougblack.io/words/zsh-vi-mode.html
# bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history

bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
#TRAMP XXX

# bindkey '^w' backward-kill-word

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) $EPS1"
#     zle reset-prompt
# }

# zle -N zle-line-init
# zle -N zle-keymap-select



# # https://emily.st/2013/05/03/zsh-vi-cursor/
# function zle-keymap-select zle-line-init
# {
#     # change cursor shape in iTerm2
#     case $KEYMAP in
#         vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
#         viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
#     esac
#
#     zle reset-prompt
#     zle -R
# }
#
#
# # block cursor
# function zle-line-finish
# {
#     print -n -- "\E]50;CursorShape=0\C-G"
# }


# Mode dependant cursor in tmux+zsh in alacritty
# https://www.reddit.com/r/zsh/comments/7pji2e/tmux_focus_events_and_cursor_shape_manipulation/
# Decide cursor shape escape sequence
# BLOCK="\E]50;CursorShape=0\C-G"
# LINE="\E]50;CursorShape=1\C-G"
# if [[ -n $TMUX ]]; then
#   BLOCK="\EPtmux;\E\E]50;CursorShape=0\x7\E\\"
#   LINE="\EPtmux;\E\E]50;CursorShape=1\x7\E\\"
# fi

# replacing by zoxide! rust ftw
# # Tested OK in Linux Kitty, Terminator, Alacritty
# if [[ $OSTYPE =~ "linux" ]]; then
#   # Sourcing here necessary due to Debian Policy
# . /usr/share/autojump/autojump.sh
# fi

# Use a line cursor for insert mode, block for normal

function zle-keymap-select zle-line-init {
  case $KEYMAP in
    vicmd)      print -n -- "$BLOCK";; # block cursor
    viins|main) print -n -- "$LINE";; # line cursor
  esac
  zle reset-prompt
  zle -R
}

# Always default to block on ending a command
function zle-line-finish {
  print -n -- "$BLOCK"
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

bindkey jk vi-cmd-mode

# vi mode
# bindkey -v

# Yank to the system clipboard
function vi-yank-clipboard {
  zle vi-yank
  if [[ -n $KITTY_WINDOW_ID ]]; then
    echo "$CUTBUFFER" | kitten clipboard
  elif command -v pbcopy &> /dev/null; then
    echo "$CUTBUFFER" | pbcopy
  elif command -v xclip &> /dev/null; then
    echo "$CUTBUFFER" | xclip -selection clipboard
  else
    print "No clipboard utility available" >&2
  fi
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# https://doronbehar.com/articles/ZSH-easter-eggs/
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done


export KEYTIMEOUT=6

# TODO: Expire not working
zstyle ':notify:*' error-sound "/usr/share/sounds/gnome/default/alerts/bark.ogg"
zstyle ':notify:*' success-sound "/home/freeo/.local/share/sounds/Enchanted/stereo/bell.ogg"
# Enchanged sound theme: https://www.gnome-look.org/p/1332121
# included system fallback: zstyle ':notify:*' success-sound "/usr/share/sounds/freedesktop/stereo/message.oga"
zstyle ':notify:*' expire-time 3000
zstyle ':notify:*' command-complete-timeout 4
zstyle ':notify:*' enable-on-ssh yes
zstyle ':notify:*' blacklist-regex 'find|git|ranger|sk'

case "$OSTYPE" in
  darwin*)
    zstyle ':notify:*' error-icon "https://media3.giphy.com/media/10ECejNtM1GyRy/200_s.gif"
    zstyle ':notify:*' success-icon "https://s-media-cache-ak0.pinimg.com/564x/b5/5a/18/b55a1805f5650495a74202279036ecd2.jpg"
  ;;
  linux*)
    zstyle ':notify:*' success-icon "/home/freeo/icons/dogeOk.jpg"
    zstyle ':notify:*' error-icon "/home/freeo/icons/dogeFail.gif"
  ;;
esac

zstyle ':notify:*' error-title "wow such #fail"
zstyle ':notify:*' success-title "very success. wow"


# interactive completion for jenkins x (zsh only)
# source <(jx completion zsh)

# source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell

# echo "if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi" >> ~/.zshrc # add autocomplete permanently to your zsh shellif [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
# if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

# danielfoehrKn/kubeswitch
# requires compdef, loaded by compinit
if hash switcher 2>/dev/null; then
  source <(switcher init zsh)
  # optionally use alias `s` instead of `switch`
  # source <(alias s=switch)
  alias s=switch
  # optionally use command completion
  source <(switch completion zsh)
fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


export PATH=~/.npm-global/bin:$PATH
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"


# export PATH="/home/$USER/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# export PGP_PRIVATE_KEY=$(<~/milkyway/interchange-app/tests/test-keys.asc)

# terraform: NECESSARY, otherwise GOOGLE_APPLICATION_CREDENTIALS gets used by defaul! clash!
# export GOOGLE_APPLICATION_CREDENTIALS=

# export GNUPGHOME=~/gpghome
# otherwise this messes with sops pass
unset GNUPGHOME

alias k='kubectl'
alias gs='git status'

alias scu='systemctl --user'
alias scus='sudo systemctl --type=service --user'
alias sc='sudo systemctl'
alias scs='sudo systemctl --type=service'

if hash lazydocker 2>/dev/null ; then
  alias lazypodman='DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker'
  # NOTE: this MASKS "lp": "print files", it sends print jobs to CUPS.
  alias lp=lazypodman
fi

alias docker=podman
# fdr: fd in root
alias fdr="fd --exclude /mnt --exclude /home -uu"



export LC_ALL=en_US.UTF-8

export KUBE_EDITOR=nvim

# alias jxl='jx get build logs'
# alias jxw='jx get activities -w'
# alias jxc='jx context'
# alias jxn='jx ns'
# alias jxa='jx get applications'
# alias jxui='jx ui -p 10001'


# zsh-autosuggestions
bindkey '^[[Z' autosuggest-accept
bindkey '^ ' forward-word

export PATH=~/.poetry/bin:$PATH

# XXX Probably delete, using mise now
# outsourced to powerlevel10k in general
# lazy load nvm with zsh-nvm
# https://armno.in.th/2020/08/24/lazyload-nvm-to-reduce-zsh-startup-time/
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias gm="gitmoji -c"
alias fbtoken='python3 ~/milkyway/firebase-id-token-generator-python/firebase_token_generator.py'
alias sz='source ~/.zshrc'

# GLP: git log pretty, devmoji
# glp is defined by the git plugin for "_git_log_prettily", which doesn't work currently anyway. 2020/04/28
# issue only in kitty
# unalias glp
function glp() {
  if [ "$1" -eq "" ]
  then
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --decorate --date=short | devmoji --log | nvimpager
  else 
    git log $1 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --decorate --date=short | devmoji --log
  fi
}

# GLPD: git log pretty detail
function glpd() {
  if [ "$1" -eq "" ]
  then
    git log --graph --decorate | devmoji --log | nvimpager
  else 
    git log $1 --graph --decorate | devmoji --log
  fi
}



export PYTHONBREAKPOINT=ipdb.set_trace

alias hb='hub browse'
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/.local/bin"
# this pager has its downsides, especially shortcuts
# export PAGER=most man ls
#
if hash nvimpager 2>/dev/null ; then
  export PAGER=nvimpager
fi

if hash delta 2>/dev/null ; then
  export DELTA_PAGER=less
fi

if hash direnv 2>/dev/null; then
  eval "$(direnv hook zsh)"
  alias da="direnv allow"
fi

# ubuntu compatibility for package fd-find
if hash fdfind 2>/dev/null; then
  alias fd="fdfind"
fi

# source <(manage completion)


if hash go 2>/dev/null ; then
  export PATH="$PATH:$(go env GOPATH)/bin"
  export GOPATH=$(go env GOPATH)
fi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/arthur.jaron/.sdkman"
[[ -s "/Users/arthur.jaron/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/arthur.jaron/.sdkman/bin/sdkman-init.sh"

# for scalafmt, installed by coursier (cs)
# export PATH="$PATH:/Users/arthur.jaron/Library/Application Support/Coursier/bin"


# export PASSWORD_STORE_DIR=$HOME/bmwcode/infra-base/secrets

export XDG_CONFIG_HOME=$HOME/.config

## NativeScript
###-tns-completion-start-###
if [ -f /home/freeo/.tnsrc ]; then 
    source /home/freeo/.tnsrc 
fi
###-tns-completion-end-###

alias printaliases="print -rl -- ${(k)aliases}"
# print -rl -- ${(k)aliases} ${(k)functions} ${(k)parameters}


# source ~/secrets/secrets.zsh
# source ~/bmwcode/rc_pulumi_settings.zsh

alias plrc="source ~/bmwcode/rc_pulumi_settings.zsh"

alias grep='grep --color=auto'

function git-alias-lookup () {
  local gprefix
  zstyle -s ':zim:git' aliases-prefix 'gprefix' || gprefix=G

  local -A gdoc
  local gline galias
  local -r gmodule_home=${1}
  shift
  # read one-line documentations from README.md
  for gline in ${(f)"$(command sed -n 's/^ *\* `G\([^`]*\)` /\1=/p' ${gmodule_home}/README.md)"}; do
    gdoc[${gline%%=*}]=${gline#*=}
  done
  # read aliases from init.zsh
  for gline in ${(f)"$(command sed -n 's/^ *alias ${gprefix}//p' ${gmodule_home}/init.zsh)"}; do
    galias=${(Q)gline%%=*}
    print -R ${gprefix}${galias}'%'${aliases[${gprefix}${galias}]}'%'${gdoc[${galias}]}
  done | command grep "${(j:.*:)@}" | command column -s '%' -t
}

function git-branch-current (){
  command git symbolic-ref -q --short HEAD
}

function git-branch-delete-interactive () {
  local -a remotes
  if (( ${*[(I)(-r|--remotes)]} )); then
    remotes=(${^*:#-*})
  else
    remotes=(${(f)"$(command git rev-parse --abbrev-ref ${^*:#-*}@{u} 2>/dev/null)"}) || remotes=()
  fi
  if command git branch --delete ${@} && \
      (( ${#remotes} )) && \
      read -q "?Also delete remote branch(es) ${remotes} [y/N]? "; then
    print
    local remote
    for remote (${remotes}) command git push ${remote%%/*} :${remote#*/}
  fi
}


alias df='df -h'
alias du='du -h'


source_folder() {
  local folder="$1"
  # Check if folder exists and is a directory
  if [[ -d "$folder" ]]; then
    # Use an array to safely handle no matches
    local sh_files=("$folder"/*.sh)
    # If no .sh files, the array will contain the literal pattern
    if [[ -e "${sh_files[1]}" ]]; then
      for file in "$folder"/*.sh; do
        source "$file"
      done
      # echo "sourced $file"
    fi
  fi
}


# SECURE functions, aliases, envvars
source_folder ~/dotfiles_private/

# if [[ $(hostname) = "cloudkoloss" ]]; then
#   source ~/dotfiles_private/k8s-port-forwards.sh
# elif [[ $(hostname) == "pop-os" ]]; then
#   source ~/dotfiles_private/corp_vpn.sh
#   source ~/dotfiles_private/variables_functions.sh
# elif [[ $(hostname) == freeo-mba* ]]; then
# fi

function updateprodip () {
  current_ips=$(az aks show -n $PRIVATE_CLUSTERNAME -g $PRIVATE_CLUSTER_RG | jq -r '.apiServerAccessProfile.authorizedIpRanges | join(",")')
  myNewIPv4=$(curl -s https://ipv4.icanhazip.com/)
  new_ips="$current_ips,$myNewIPv4/32"
  az aks update -n $PRIVATE_CLUSTERNAME -g $PRIVATE_CLUSTER_RG --api-server-authorized-ip-ranges $new_ips
}

function vpndnsfix () {
  sudo resolvectl dns ppp0 $CORP_IP
  sudo resolvectl domain ppp0 $CORP_DOMAIN
  sudo resolvectl default-route ppp0 false
  sudo resolvectl default-route enp6s0 true
}

alias vpncon='nmcli con up id catenate && vpndnsfix'
alias vpndis='nmcli con down id catenate'
alias vpnconask='nmcli --ask con up id catenate && vpndnsfix'

# --no-cmd skips initializing zinit=zi but requires manual aliases
eval "$(zoxide init zsh --no-cmd)"
alias z=__zoxide_z
alias zz=__zoxide_zi

# zinit conflict: this function ALWAYS overwrites zinit!
# DO NOT USE! as long as I'm using zinit package manager
# alias zi=__zoxide_zi

# alias vim="nvim"
alias v='nvim'
alias vk="$(where kitten) edit-in-kitty"
alias j=just
alias jc="just --choose"
alias kd="kitty +kitten diff"
alias argopass="kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d"
alias pkg-config="/usr/bin/pkg-config"
alias emx="emacsclient -c -a 'emacs'"
alias rg="rg -i -uu -L"
alias warp=warp-terminal

if hash cargo 2>/dev/null ; then
  if test -f "$HOME/.cargo/env" ; then
    source $HOME/.cargo/env
  fi
fi

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# /home/freeo/.emacs.d/.local/straight/build-28.0.60/vterm/etc/emacs-vterm-zsh.sh

## Preventing nested ranger instances
unset -f ranger 2>/dev/null   # suppress first run, only required when running sz in same session
RANGER_BIN=$(which ranger) # /usr/bin/ranger
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        $RANGER_BIN "$@"
    else
        exit
    fi
}

# ranger_cd
rcd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}" $1
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}
# zle -N ranger-cd rcd

# This binds Ctrl-O to ranger_cd:
# bindkey ^o ranger-cd
# bindkey -s "^o" "rcd\n"
# yazi
# bindkey -s "^o" "^E^Uyy^M"
# ranger
bindkey -s "^o" "^E^Urcd^M"
# Ctrl+Alt+o : sudo ranger .
bindkey -s "^[^o" "^E^Usudo ranger .^M"

bindkey -s "^p" "zz\n"
# XXX doesn't work yet
# bindkey -s "^p" "^E^Urcd --cmd=zi^M"

# broot
# bindkey -s "^p" "br\n"

zle-empty-enter-ranger() {
  if [[ -z "$BUFFER" ]]; then
    BUFFER="rcd"
    zle accept-line  # Simulates pressing 
  else
    zle accept-line
  fi
}
zle -N zle-empty-enter-ranger
bindkey '^M' zle-empty-enter-ranger

function alias_expand {
  if [[ $ZSH_VERSION ]]; then
    # shellcheck disable=2154  # aliases referenced but not assigned
    [ ${aliases[$1]+x} ] && printf '%s\n' "${aliases[$1]}" && return
  else  # bash
    [ "${BASH_ALIASES[$1]+x}" ] && printf '%s\n' "${BASH_ALIASES[$1]}" && return
  fi
  false  # Error: alias not defined
}


function virtcam () {
  sudo modprobe -r v4l2loopback
  sudo modprobe v4l2loopback devices=1 video_nr=13 card_label='OBS Virtual Camera' exclusive_caps=1
}

eval `ssh-agent -s` > /dev/null 2>&1
ssh-add $HOME/.ssh/id_ed25519 > /dev/null 2>&1
ssh-add $HOME/.ssh/id_bmw > /dev/null 2>&1
# https://superuser.com/questions/284374/ssh-keys-ssh-agent-bash-and-ssh-add

[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver


if hash thefuck 2>/dev/null; then
  eval $(thefuck --alias)
  alias fk=fuck
  alias doh=fuck
fi

# zinit light-mode for \
#   z-shell/z-a-meta-plugins \
#   @annexes # <- https://z-shell.pages.dev/docs/ecosystem/annexes
# # examples here -> https://z-shell.pages.dev/docs/gallery/collection
# zicompinit # <- https://z-shell.pages.dev/docs/gallery/collection#minimal


# These SOPS variables override .sops.yaml
# export SOPS_AZURE_KEYVAULT_URL="https://wakakeyvault..."
function enableage () {
  export SOPS_AGE_KEY_FILE=~/secrets/freeo.agekey
  export SOPS_AGE_RECIPIENTS=$(cat ~/secrets/freeo.agekey | rg "public key" | cut -c 15-)
}

function sync_mba () {
  echo "pCloud!"
  # HOSTNAME=$(hostname)
  # if [[ $HOSTNAME == "pop-os" ]]; then
  #   osync.sh ~/.config/osync/popos-to-mba.conf
  # elif [[ $HOSTNAME == freeo-mba* ]]; then
  #   osync.sh ~/.config/osync/mba-to-popos.conf
  # fi
}

# WIP, create awesomewm UI
function notifyinminutes () {
  if [[ -z $1 ]]; then
    echo 'usage: notifyinminutes "message" 5 '
    echo 'will create a "message" popup via notify-send in 5 minutes'
  else
    # echo 'notify-send -t 60000 --icon="/home/freeo/icons/alarm-clock.jpg" "$1"' | at now +$2 minutes
    echo 'notify-send -t 60000 "$1"' | at now +$2 minutes
  fi
}



if hash xsetwacom 2>/dev/null ; then
  HASWACOM=$(xsetwacom --list devices | wc -l)
  if [[ $HASWACOM -gt 0 ]]; then
    WACOM="Wacom Intuos4 6x9 Pen stylus"
    # full display
    # xsetwacom set $WACOM MapToOutput 5120x1440+0+0
    # right half
    # xsetwacom set $WACOM MapToOutput 2560x1440+2560+0
    # left half
    xsetwacom set $WACOM MapToOutput 2560x1440+0+0
    # echo "Wacom set to left screen 2560x1440"
  fi
fi

OLDM2=$HOME/oldm2.sh
if [[ -f $OLDM2 ]]; then
	source $OLDM2
fi

# ******************
# NON-CORE CONFIG
# ******************
#

function neog9retry () {
  NG9LOG=$HOME/logs/neog9retry.log
  date >> $NG9LOG
  for ((i = 0 ; i < 3; i++)); do
    xrandr --output DP-0 --mode 5120x1440 --rate 120 --dpi 144 --output HDMI-0 --off
    sleep 0.5
    xrandr --listactivemonitors | tee -a $NG9LOG | grep DP-0 && break
  done
  echo "" >> $NG9LOG
}

function morelinuxSettings () {

  if hash xrandr 2>/dev/null ; then


  fi

  # if conda is installed...
  [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh


  # when ComfyUI doesn't start, no CUDA device available:
  # RuntimeError: CUDA unknown error - this may be due to an incorrectly set up environment, e.g. changing env variable CUDA_VISIBLE_DEVICES after program start. Setting the available devices to be zero.
  function nvidia_restart (){
    sudo modprobe -r nvidia_uvm && sudo modprobe nvidia_uvm
  }

}


case "$OSTYPE" in
  darwin*)

  ;;
  linux*)
    morelinuxSettings
  ;;
esac



# pnpm
export PNPM_HOME="/home/freeo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


function timer () {
TIMER_TITLE="Default Timer Title"
TIMER_TITLE="Default Timer Text"
let "minutes=$1 * 60"
sleep $minutes && notify-send -t 5000 -i "/home/freeo/icons/dogeOk.jpg" "$TIMER_TITLE" "$TIMER_TEXT"
}


function automatic1111 () {
  cd /home/freeo/stable-diffusion-webui/
  # source venv/bin/activate
  # export python_cmd=python3.10; ./webui.sh
  ./webui.sh
}

alias a11=automatic1111

# pyenv shell integration, required for "pyenv shell 3.10.6"

if hash pyenv 2>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi


function hue (){
echo "TODO: Gate: hueadm can connect to bridge?"
cat << EOF | tv | zsh
echo "VaporWave   = Violet    yellow   (pleasant!)        "; hueadm group 200 scene=PabuZd2VKFG6mhb
echo "BluePlanet = Green     RealBlue (video self illum)  "; hueadm group 200 scene=5suARnK-Aiinak0
echo "Magneto     = yellow    green/turq                  "; hueadm group 200 scene=1WKjP6Y8eG49e5S
echo "Hal         = RedViolet yellow                      "; hueadm group 200 scene=cB4y9U2uNsGrSqW
echo "CK          = RED       VIOLET                      "; hueadm group 200 scene=nJlNrTw8CfcZOyzG
echo "Disturbia   = red       violet                      "; hueadm group 200 scene=M8f7eeYRIYBWmWt
echo "Tyrell      = Green     LightBlue                   "; hueadm group 200 scene=HXiHuBbAKjeyCku
echo "Energize    = White x2                              "; hueadm group 200 scene=3ZjGyKkArZKgrMx
echo "Concentrate = WarmWhite x2                          "; hueadm group 200 scene=Y0uEZz5dblWdv1u
echo "Relax       = flux x2                               "; hueadm group 200 scene=p3LtLU4Mc3TP6Qa
echo "Off.                                                "; hueadm group 0 off
EOF
}

alias huehuehue=hue

alias hueVaporWave="hueadm group 200 scene=PabuZd2VKFG6mhb"
alias hueBluePlanet="hueadm group 200 scene=5suARnK-Aiinak0"
alias hueMagneto="hueadm group 200 scene=1WKjP6Y8eG49e5S"
alias hueHal="hueadm group 200 scene=cB4y9U2uNsGrSqW"
alias hueCK="hueadm group 200 scene=nJlNrTw8CfcZOyzG"
alias hueDisturbia="hueadm group 200 scene=M8f7eeYRIYBWmWt"
alias hueTyrell="hueadm group 200 scene=HXiHuBbAKjeyCku"
alias hueEnergize="hueadm group 200 scene=3ZjGyKkArZKgrMx"
alias hueOff="hueadm group 0 off"

function huehuehue_old (){
cat << EOF
VaporWave   = Violet    yellow   (pleasant!)
BluePlanet = Green     RealBlue (video self illum)
Magneto     = yellow    green/turq
Hal         = RedViolet yellow
CK          = RED       VIOLET
Disturbia   = red       violet
Tyrell      = Green     LightBlue
Energize    = White x2
Concentrate = WarmWhite x2
Relax       = flux x2
EOF
}


function meet () {
  /home/freeo/dotfiles/scripts/meet.sh
}

alias lackit="kitten ssh vagrant@lackit.local"
alias lvidia="kitten ssh lvidia@lvidia.local"
alias alpine="kubectl exec -it pod/alpine -- /bin/sh"
alias alpineCreate="set -x; kubectl apply -f /home/freeo/cubecloud/gitops-int/dev/alpine.yaml; sleep 3; set +x; kubectl exec -it pod/alpine -- /bin/sh; "
alias alpineDelete="kubectl delete -f /home/freeo/cubecloud/gitops-int/dev/alpine.yaml"



HOST=$(hostname)

case "$HOST" in
  "cloudkoloss")
    # default kubeconfig/context
    export KUBECONFIG="/home/$USER/.kube/nztint1.mk8s.yaml"
    # export KUBECONFIG="/home/$USER/.kube/lackit.k3s.yaml"
    # export KUBECONFIG="/home/$USER/.kube/lvidia.k3s.yaml"
    ;;
  "lackit")
    export KUBECONFIG="/home/$USER/.kube/config.yaml"
    alias sukitten="sudo /home/vagrant/.local/share/kitty-ssh-kitten/kitty/bin/kitten"
    alias cpk3scfg="sukitten transfer /etc/rancher/k3s/k3s.yaml /home/freeo/.kube/lackit.k3s.yaml"
    ;;
  "lvidia")
    export KUBECONFIG="/home/$USER/.kube/config.yaml"
    alias sukitten="sudo /home/$USER/.local/share/kitty-ssh-kitten/kitty/bin/kitten"
    alias cpk3scfg="sukitten transfer /etc/rancher/k3s/k3s.yaml /home/freeo/.kube/lvidia.k3s.yaml"
    ;;
  *)
    # messes with root
    # export KUBECONFIG="/home/$USER/.kube/config.yaml"
    alias sukitten="sudo /home/$USER/.local/share/kitty-ssh-kitten/kitty/bin/kitten"
    alias cpk3scfg="sukitten transfer /etc/rancher/k3s/k3s.yaml /home/freeo/.kube/$(hostname).k3s.yaml"
    ;;
esac

export ATAC_KEY_BINDINGS=$XDG_CONFIG_HOME/atac/vim_key_bindings.toml


MOUSE() {
  local onoff="$1"
  xinput_list=$(xinput list)
  # Extract the IDs of all devices
  device_ids=$(echo "$xinput_list" | rg -i "cooler master.*mm" | grep -oP 'id=\K\d+')
  # bash: for id in $device_ids; do
  # ZSH style loop! device_ids output is different from bash
  for id in ${(f)device_ids}; do
      xinput $onoff $id
      if [[ -z $ERRORCODE ]]; then
        echo "$onoff device with ID: $id"
      else
        echo "error: $onoff device with ID: $id"
        echo $xinput_list | rg $id
      fi
  done
}

alias chmodquery='stat -c "%a %n"'
alias mouse="MOUSE enable"
# context files must contain "current-context: mycontext"
alias k9v='k9s --kubeconfig ~/.kube/lvidia.k3s.yaml'
alias k9l='k9s --kubeconfig ~/.kube/lackit.k3s.yaml'
alias k9h='k9s --kubeconfig ~/.kube/hcube.k3s.yaml'
alias k9i='k9s --kubeconfig ~/.kube/nztint1.mk8s.yaml'
alias k9i1='k9s --kubeconfig ~/.kube/nztint1.mk8s.yaml'
alias k9i2='k9s --kubeconfig ~/.kube/nztint2.mk8s.yaml'
alias k9n='k9s --kubeconfig ~/.kube/nebiusdev.k8s.yaml'
alias k9d='k9stunnelsmcdev && export HTTPS_PROXY=socks5://localhost:1080 && k9s --kubeconfig ~/.kube/smchead1.mk8s.yaml'

if hash go-task 2>/dev/null ; then
  alias task=go-task
fi

if hash lazygit 2>/dev/null ; then
  # alias lg=lazygit
  # alias lg="lazygit --use-config-file ~/dotfiles/config/lazygit/config-dark.yml"
  alias lgl=lazygit
  alias lgd="lazygit --use-config-file ~/dotfiles/config/lazygit/config-dark.yml"
  alias lg='if [ "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'\''prefer-dark'\''" ]; then \
              lazygit --use-config-file ~/dotfiles/config/lazygit/config-dark.yml; \
           else \
              lazygit --use-config-file ~/dotfiles/config/lazygit/config-light.yml; \
           fi'
fi



function grafanatunnel() {
  k port-forward -n monitoring svc/kpromstack-grafana 1081:80

  local SSH_CMD=(/usr/bin/ssh -L 1081:localhost:1081 kusuo@hcube -N -f)
}




# gpu="0000:01:00.0"
# aud="0000:01:00.1"
# gpu_vd="$(cat /sys/bus/pci/devices/$gpu/vendor) $(cat /sys/bus/pci/devices/$gpu/device)"
# aud_vd="$(cat /sys/bus/pci/devices/$aud/vendor) $(cat /sys/bus/pci/devices/$aud/device)"

function bind_vfio {
  echo "$gpu" > "/sys/bus/pci/devices/$gpu/driver/unbind"
  echo "$aud" > "/sys/bus/pci/devices/$aud/driver/unbind"
  echo "$gpu_vd" > /sys/bus/pci/drivers/vfio-pci/new_id
  echo "$aud_vd" > /sys/bus/pci/drivers/vfio-pci/new_id
}

function unbind_vfio {
  echo "$gpu_vd" > "/sys/bus/pci/drivers/vfio-pci/remove_id"
  echo "$aud_vd" > "/sys/bus/pci/drivers/vfio-pci/remove_id"
  echo 1 > "/sys/bus/pci/devices/$gpu/remove"
  echo 1 > "/sys/bus/pci/devices/$aud/remove"
  echo 1 > "/sys/bus/pci/rescan"
}

amdg9() {
  xrandr --output HDMI-A-0 --mode 5120x1440 --rate 59.98 --dpi 144 --pos 0x0 --output DisplayPort-0 --off
}

amdtv() {
  xrandr --output HDMI-A-0 --off --output DisplayPort-0 --mode 1920x1080 --rate 60 --pos 5120x0 --dpi 96
}

amdboth() {
  xrandr --output HDMI-A-0 --mode 5120x1440 --rate 59.98 --dpi 144 --pos 0x0 --output DisplayPort-0 --mode 1920x1080 --rate 60 --pos 5120x0 --dpi 96
}

function gots () {
timestamp=$1
# timestamp="1723491985.0371428"

# Extract the integer part
seconds=${timestamp%.*}

# Convert to human-readable format
human_readable_date=$(date -d @$seconds "+%Y-%m-%d %H:%M:%S")

# Print the result
echo "$human_readable_date"
}


function argocurrentcommit () {
ARGO_OUTPUT=$(argocd app get $1 -o json)
COMMIT_SHA=$(echo $ARGO_OUTPUT | jq -r '.status.sync.revision')
COMMIT_SHA=$(echo $ARGO_OUTPUT | jq -r '.status.sync.revision')

if [ -z "$COMMIT_SHA" ]; then
  echo "Failed to retrieve commit SHA for application $APPNAME."
  exit 1
fi

echo "Application $1 is currently synced to commit $COMMIT_SHA."

# Change directory to your local clone of the Git repository
cd /path/to/your/repo || exit

# Get the commit message
COMMIT_MESSAGE=$(git show -s --format=%B $COMMIT_SHA)

echo "The commit message is: $COMMIT_MESSAGE"

}

if [[ -n $SSH_CONNECTION ]]; then
  # Currently in an SSH session
  # edit-in-kitty works well, but it breaks file navigation inside of nvim.
  # export VISUAL="$(where kitten) edit-in-kitty"
else
  # NOT in an SSH session
fi


# for file in $HOME/dotfiles/scripts/zshsource/*.sh; do
# FOLDER="$HOME/dotfiles/scripts/zshsource"
source_folder "$HOME/dotfiles/scripts/zshsource"
# if [ -d "$FOLDER" ] && [ "$(ls -A "$FOLDER")" ]; then
  # for file in "$FOLDER"/*.sh; do
    # source "$file"
  # done
# fi


# SMCKOHYA=$HOME/pcloud/cubecloud/smckohya.sh
# if [ -f $SMCKOHYA ]; then
#     source $SMCKOHYA
# fi

export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

export PATH="$PATH:$HOME/.nebius/bin/"
# The next line enables shell command completion for Nebius CLI.
if [ -f '/home/freeo/.nebius/completion.zsh.inc' ]; then source '/home/freeo/.nebius/completion.zsh.inc'; fi

# PROFILING endpoint:
# zprof

fpath+=~/.zfunc


# echo "hueadm group 200 scene=PabuZd2VKFG6mhb" | tv | zsh
# zsh -c "hueadm group 200 scene=1WKjP6Y8eG49e5S"


# The next line updates PATH for Nebius CLI.
if [ -f '/home/freeo/.nebius/path.zsh.inc' ]; then source '/home/freeo/.nebius/path.zsh.inc'; fi

# cocogitto
if hash cog 2>/dev/null ; then
  cog generate-completions zsh > ~/.zfunc/_cog
fi

# mise-en-place
case "$OSTYPE" in
  darwin*)
    MISE_BIN=/opt/homebrew/bin/mise
  ;;
  linux*)
    MISE_BIN=/usr/bin/mise
  ;;
esac
eval "$($MISE_BIN activate zsh)"

export MASON_BIN="/home/freeo/.local/share/nvim/mason/bin"
case ":$PATH:" in
  *":$MASON_BIN:"*) ;;
  *) export PATH="$MASON_BIN:$PATH" ;;
esac

function leftvscreen (){
echo "TODO: make this into a function"
cat << EOF | tv | zsh
echo "LeftVScreen OFF "; xrandr --delmonitor LeftVScreen
echo "LeftVScreen ON "; xrandr --setmonitor LeftVScreen 2560/0x1440/1+0+0 none
EOF
}

for dir in ~/scripts/*(/); do
  PATH="$dir:$PATH"
done
export PATH

# temporary: conda error:
# Error while loading conda entry point: conda-content-trust (OpenSSL 3.0's legacy provider failed to load. This is a fatal error by default, but cryptography supports running without legacy algorithms by setting the environment variable CRYPTOGRAPHY_OPENSSL_NO_LEGACY. If you did not expect this error, you have likely made a mistake with your OpenSSL configuration.)
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# alias kyust="uv run ~/tools/kyutai-stt/stt_from_mic_rust_server.py"

# careful: the kitty command opens a window that has the moshi-server command baked in! after closing moshi, the kitty instance is still found by pgrep! False-positive! TODO: shutdown the kitty tab: don't run via zsh, no --hold, just run directly. awesome: start minimized?
kyust () {
  # moshi-server worker --config config-stt-en-hf.toml
    local server_cmd="moshi-server worker --config config-stt-en-hf.toml --port 5455"
    local final_cmd="uv run ~/tools/kyutai-stt/stt_from_mic_rust_server.py --url ws://127.0.0.1:5455"

    # Check if the moshi-server worker is already running with the specific config
    if pgrep -f "$server_cmd" > /dev/null; then
        echo "Moshi server is already running."
    else
        echo "Starting moshi server..."
        kitty --detach --hold --directory=~/tools/kyutai-stt zsh -c "$server_cmd"

        # Wait a moment for the server to start
        sleep 2

        # Verify the server started successfully
        if pgrep -f "$server_cmd" > /dev/null; then
            echo "Moshi server started successfully."
        else
            echo "Failed to start moshi server."
            return 1
        fi
    fi

    # Execute the final command only if server is running
    if pgrep -f "$server_cmd" > /dev/null; then
        echo "Executing final command..."
        eval "$final_cmd"
    else
        echo "Server is not running. Cannot execute final command."
        return 1
    fi
}


# Function to open streaming commands in Neovim as read-only
# Properly handles sudo authentication by running in foreground first
nvim_tail() {
    local temp_file=$(mktemp)
    local needs_sudo=false
    
    if [[ $# -eq 0 ]]; then
        echo "Usage: nvim_tail <command> [args...]"
        echo "Example: nvim_tail sudo journalctl -xe -f"
        echo "Example: nvim_tail tail -f /var/log/syslog"
        return 1
    fi
    
    # Check if this is a sudo command
    if [[ "$1" == "sudo" ]]; then
        needs_sudo=true
    fi
    
    echo "Starting: $*"
    
    if [[ "$needs_sudo" == true ]]; then
        echo "This command requires sudo. You'll be prompted for your password..."
        echo "The command will run in foreground first for authentication."
        
        # Test sudo authentication and cache credentials
        echo "Authenticating..."
        if ! sudo -v; then
            echo "Authentication failed"
            rm -f "$temp_file"
            return 1
        fi
        
        echo "Authentication successful. Starting background process..."
    fi
    
    # Now run the command in background - sudo credentials should be cached
    "$@" > "$temp_file" 2>&1 &
    local bg_pid=$!
    
    # Give the command a moment to start
    sleep 1
    
    # Check if process is still running
    if ! kill -0 "$bg_pid" 2>/dev/null; then
        echo "Command failed to start or terminated early"
        rm -f "$temp_file"
        return 1
    fi
    
    cleanup() {
        if kill -0 "$bg_pid" 2>/dev/null; then
            kill "$bg_pid" 2>/dev/null
            sleep 0.5
            kill -9 "$bg_pid" 2>/dev/null
        fi
        rm -f "$temp_file"
    }
    
    trap cleanup EXIT INT TERM
    
    echo "Command running (PID: $bg_pid). Opening in Neovim..."
    echo "In Neovim: use '/' to search, 'G' to go to end, ':q' to quit"
    
    nvim -R \
        -c "set autoread" \
        -c "set updatetime=250" \
        -c "autocmd CursorHold,CursorHoldI * checktime" \
        -c "autocmd FileChangedShell * execute 'normal! G'" \
        "$temp_file"
}

# Alternative version that prompts for password upfront
nvim_tail_auth() {
    local temp_file=$(mktemp)
    
    if [[ $# -eq 0 ]]; then
        echo "Usage: nvim_tail_auth <command> [args...]"
        echo "Example: nvim_tail_auth sudo journalctl -xe -f"
        return 1
    fi
    
    echo "Starting: $*"
    
    # If it's a sudo command, authenticate first
    if [[ "$1" == "sudo" ]]; then
        echo "Authenticating with sudo..."
        if ! sudo -v; then
            echo "Authentication failed"
            rm -f "$temp_file"
            return 1
        fi
        echo "Authentication successful!"
    fi
    
    # Start the command in background
    "$@" > "$temp_file" 2>&1 &
    local bg_pid=$!
    
    sleep 1
    
    if ! kill -0 "$bg_pid" 2>/dev/null; then
        echo "Command failed to start"
        rm -f "$temp_file"
        return 1
    fi
    
    cleanup() {
        kill "$bg_pid" 2>/dev/null || true
        sleep 0.5
        kill -9 "$bg_pid" 2>/dev/null || true
        rm -f "$temp_file"
    }
    
    trap cleanup EXIT INT TERM
    
    echo "Process started (PID: $bg_pid). Opening Neovim..."
    
    nvim -R \
        -c "set autoread" \
        -c "set updatetime=200" \
        -c "autocmd CursorHold,CursorHoldI * checktime" \
        -c "autocmd FileChangedShell * execute 'normal! G'" \
        -c "normal! G" \
        "$temp_file"
}

# Version using named pipes for real-time streaming
nvim_tail_pipe() {
    local temp_file=$(mktemp)
    local pipe_file=$(mktemp -u)
    
    if [[ $# -eq 0 ]]; then
        echo "Usage: nvim_tail_pipe <command> [args...]"
        echo "Example: nvim_tail_pipe sudo journalctl -xe -f"
        return 1
    fi
    
    # Create named pipe
    mkfifo "$pipe_file"
    
    cleanup() {
        # Kill background jobs
        jobs -p | xargs -r kill 2>/dev/null
        sleep 0.5
        jobs -p | xargs -r kill -9 2>/dev/null
        rm -f "$temp_file" "$pipe_file"
    }
    
    trap cleanup EXIT INT TERM
    
    echo "Starting: $*"
    
    # Handle sudo authentication if needed
    if [[ "$1" == "sudo" ]]; then
        echo "Authenticating..."
        if ! sudo -v; then
            echo "Authentication failed"
            cleanup
            return 1
        fi
    fi
    
    # Start command writing to pipe
    "$@" > "$pipe_file" 2>&1 &
    local cmd_pid=$!
    
    # Copy from pipe to file
    cat "$pipe_file" > "$temp_file" &
    local cat_pid=$!
    
    sleep 1
    
    if ! kill -0 "$cmd_pid" 2>/dev/null; then
        echo "Command failed to start"
        cleanup
        return 1
    fi
    
    echo "Command running (PID: $cmd_pid). Opening Neovim..."
    
    nvim -R \
        -c "set autoread" \
        -c "set updatetime=100" \
        -c "autocmd CursorHold,CursorHoldI * checktime" \
        -c "autocmd FileChangedShell * execute 'normal! G'" \
        -c "normal! G" \
        "$temp_file"
}

# Simple version for commands that don't need sudo
nvim_tail_simple() {
    local temp_file=$(mktemp)
    
    if [[ $# -eq 0 ]]; then
        echo "Usage: nvim_tail_simple <command> [args...]"
        echo "Example: nvim_tail_simple tail -f /var/log/syslog"
        echo "Note: This version doesn't handle sudo"
        return 1
    fi
    
    if [[ "$1" == "sudo" ]]; then
        echo "This version doesn't handle sudo. Use nvim_tail instead."
        return 1
    fi
    
    "$@" > "$temp_file" 2>&1 &
    local bg_pid=$!
    
    cleanup() {
        kill "$bg_pid" 2>/dev/null || true
        rm -f "$temp_file"
    }
    
    trap cleanup EXIT INT TERM
    
    sleep 0.5
    
    nvim -R \
        -c "set autoread" \
        -c "set updatetime=100" \
        -c "autocmd CursorHold,CursorHoldI * checktime" \
        -c "autocmd FileChangedShell * execute 'normal! G'" \
        -c "normal! G" \
        "$temp_file"
}

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/freeo/.lmstudio/bin"
# End of LM Studio CLI section

