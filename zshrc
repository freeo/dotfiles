#!/bin/zsh
# PROFILING this .zshrc:
# NOTE: Last line of this script is necessary to know when to stop
# zmodload zsh/zprof 

# don't execute the rest of this .zshrc if connecting via emacs TRAMP
[[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return

# https://unix.stackexchange.com/questions/608538/how-to-use-256-colors-for-background-color-in-terminal
print -rP '%K{#303030}'

if hash fortune 2>/dev/null && hash lolcat 2>/dev/null ; then
  fortune | lolcat
fi
# echoti setab [%?%p1%{8}%<%t4%p1%d%e%p1%{16}%<%t10%p1%{8}%-%d%e48;5;%p1%d%;m

zi_home="${HOME}/.zi"
source "${zi_home}/bin/zi.zsh"

autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export ZSH="$HOME/.oh-my-zsh"

# p10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle :compinstall filename '/home/freeo/.zshrc'



if [[ $TERM = "xterm-kitty" ]]; then
  # BLOCK & LINE tested in Linux and macOS
  BLOCK="\033[1 q"
  LINE="\033[5 q"
  # Completion for kitty
  autoload -Uz compinit
  compinit
  kitty + complete setup zsh | source /dev/stdin
  # awesome, fixes multiple ssh problems using kitty
  alias ssh="kitty +kitten ssh"
fi

# Common settings ###################
export NVM_LAZY_LOAD=true # for zsh-nvm

export AUTO_NOTIFY_THRESHOLD=10
# export AUTO_NOTIFY_EXPIRE_TIME=3000 # milliseconds, linux only
AUTO_NOTIFY_IGNORE+=("ranger")
# export BAT_THEME="Monokai Extended Light"
export KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code --filter=metadata.managedFields"

alias md='mkdir'
alias sz='source ~/.zshrc'
alias l='exa -la'
# function la () {
  # exa -la
# }
alias pcat='pygmentize -f terminal256 -O style=native -g'

export PATH="$PATH:$HOME/.cargo/env"

typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯❯❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='😎❮'

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
  xset r rate 180 40

  export EDITOR=nvim
  export VISUAL=nvim
  # export EDITOR="snap run nvim"
  # export VISUAL="snap run nvim"

  # ra = reset audio
  alias ra="pulseaudio -k"
  # reset capslock to ctrl
  alias caps="setxkbmap -option ctrl:nocaps"
  alias win10h="systemctl hibernate --boot-loader-entry=Windows10.conf"
  alias win10="systemctl reboot --boot-loader-entry=Windows10.conf"

  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'


  # snap requires the dirty sudo workaround. snap alias also breaks autocomplete
  # ---
  # tricking shells into scanning commands after sudo for other aliases as well
  # most notably: `sudo nvim`, where alias nvim='/home/linuxbrew/.linuxbrew/bin/nvim'
  # alias sudo='sudo '
  # alias nvim="snap run nvim"
  alias nvim='/home/linuxbrew/.linuxbrew/bin/nvim' # tested, works
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
  # export GRAALVM_HOME=/usr/lib/jvm/graalvm-ce-java8-20.3.0
  # export JAVA_HOME=$GRAALVM_HOME
  export ANDROID_HOME=$HOME/Android/Sdk
  # export PATH=$GRAALVM_HOME/bin:$PATH
  # for adb
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH=$PATH:~/bin
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$PATH:$XDG_CONFIG_HOME/rofi/rofi-power-menu

  export PATH=$PATH:$HOME/go/bin

  # since I started with tiling window managers (currently awesome)
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
# successor: zoxide
  # [ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh


}

source $HOME/.config/broot/launcher/bash/br

zinit light Tarrasch/zsh-bd
zinit light darvid/zsh-poetry
zinit light fdw/ranger-zoxide
zinit light lukechilds/zsh-nvm
zinit light zdharma/fast-syntax-highlighting
zinit light zimfw/archive
zinit light zimfw/git
zinit light zsh-users/zsh-autosuggestions
zinit ice wait'1' lucid
zinit light mellbourn/zabb

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
      zinit light marzocchi/zsh-notify
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


# Git aliases, additionally on top of zimfw/git
# upper case f for same shortcut, as magit uses
alias GF="git pull"
alias GFr="git pull --rebase"
alias GFm="git pull --no-rebase"
alias Gfa="git fetch --all"


# TODO: Moved down here, otherwise I can't see installation progress... Observe if it's ok to stay here.
# ---
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

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


# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/arthurj/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/arthurj/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/arthurj/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/arthurj/google-cloud-sdk/completion.zsh.inc'; fi

# export pgstorage=gs://drebes-playground-storage-users

# export PATH



freeohelp () {
  echo "pcat     - syntax-colored cat output (pygmentize-cat). Requires pip3 install Pygments"
  # echo "mdv      - markdown viewer"
}

setopt zle
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

# from omz, not in use
# alwaystoend
# autopushd
# completeinword
# interactive
# promptsubst
# pushdignoredups
# pushdminus

HISTFILE=~/.zsh_history
HISTSIZE=1000000   # the number of items for the internal history list
SAVEHIST=1000000   # maximum number of items for the history file

# Fuzzy Finder needs to be loaded *after* ZLE, otherwise it won't be available on
# startup, but only after manually sourcing this .zshrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# NOTE: run this if the file above doesn't exist:
# $(brew --prefix)/opt/fzf/install

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
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

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

# in use by fzf default keybindings
# bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# interactive completion for jenkins x (zsh only)
# source <(jx completion zsh)

# source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell

# echo "if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi" >> ~/.zshrc # add autocomplete permanently to your zsh shellif [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
# if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi


export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias vim="nvim"

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
export PAGER=nvimpager

eval "$(direnv hook zsh)"

# source <(manage completion)


export PATH="$PATH:$(go env GOPATH)/bin"
export GOPATH=$(go env GOPATH)


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/arthur.jaron/.sdkman"
[[ -s "/Users/arthur.jaron/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/arthur.jaron/.sdkman/bin/sdkman-init.sh"

# for scalafmt, installed by coursier (cs)
# export PATH="$PATH:/Users/arthur.jaron/Library/Application Support/Coursier/bin"


export PASSWORD_STORE_DIR=$HOME/bmwcode/infra-base/secrets

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

source ~/dotfiles/private/corp_vpn.sh
source ~/dotfiles/private/variables_functions.sh


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

eval "$(zoxide init zsh)"

alias j='echo "use z for zoxide! or r for ranger+zoxide! doing the jump anyway..." && z '
alias kd="kitty +kitten diff"
alias argopass="kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d"
alias pkg-config="/usr/bin/pkg-config"

source $HOME/.cargo/env
# function timer () {
# TIMER_TITLE="Default Timer Title"
# TIMER_TITLE="Default Timer Text"
# sleep $1 & && notify-send -t 5000 -i "/home/freeo/icons/dogeOk.jpg" "$TIMER_TITLE" "$TIMER_TEXT"
# }
#
#

# /home/freeo/.emacs.d/.local/straight/build-28.0.60/vterm/etc/emacs-vterm-zsh.sh

# ranger_cd
rcd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}
# zle -N ranger-cd rcd

# This binds Ctrl-O to ranger_cd:
# bindkey ^o ranger-cd
bindkey -s "^o" "rcd\n"



bindkey -s "^p" "br\n"

function virtcam () {
  sudo modprobe -r v4l2loopback
  sudo modprobe v4l2loopback devices=1 video_nr=13 card_label='OBS Virtual Camera' exclusive_caps=1
}

eval `ssh-agent -s` > /dev/null 2>&1
ssh-add $HOME/.ssh/id_ed25519 > /dev/null 2>&1
ssh-add $HOME/.ssh/id_bmw > /dev/null 2>&1
# https://superuser.com/questions/284374/ssh-keys-ssh-agent-bash-and-ssh-add

[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver

eval $(thefuck --alias)

# zinit light-mode for \
#   z-shell/z-a-meta-plugins \
#   @annexes # <- https://z-shell.pages.dev/docs/ecosystem/annexes
# # examples here -> https://z-shell.pages.dev/docs/gallery/collection
# zicompinit # <- https://z-shell.pages.dev/docs/gallery/collection#minimal


# These SOPS variables override .sops.yaml
# export SOPS_AZURE_KEYVAULT_URL="https://wakakeyvault..."
# export SOPS_AGE_KEY_FILE=~/secrets/freeo.agekey
# export SOPS_AGE_RECIPIENTS=$(cat ~/secrets/freeo.agekey | rg "public key" | cut -c 15-)


# PROFILING endpoint:
# zprof
