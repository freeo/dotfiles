# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/arthur.jaron/.oh-my-zsh"
# export NODE_PATH="/usr/local/lib/node_modules"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="miloshadzic"
# ZSH_THEME="philips"
ZSH_THEME="spaceship"
# # kphoen

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  poetry
  notify
  zsh-autosuggestions
)


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/arthurj/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/arthurj/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/arthurj/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/arthurj/google-cloud-sdk/completion.zsh.inc'; fi

# export pgstorage=gs://drebes-playground-storage-users

# export PATH="$PATH:~/flutter/bin"

export PATH

alias pcat='pygmentize -f terminal256 -O style=native -g'


freeohelp () {
  echo "pcat     - syntax-colored cat output (pygmentize-cat). Requires pip3 install Pygments"
  # echo "mdv      - markdown viewer"
}


setopt ZLE
setopt vi

# https://dougblack.io/words/zsh-vi-mode.html
# bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history

bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
# bindkey '^w' backward-kill-word

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) $EPS1"
#     zle reset-prompt
# }

# zle -N zle-line-init
# zle -N zle-keymap-select



# https://emily.st/2013/05/03/zsh-vi-cursor/
function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

bindkey jk vi-cmd-mode


export KEYTIMEOUT=6

zstyle ':notify:*' error-icon "https://media3.giphy.com/media/10ECejNtM1GyRy/200_s.gif"
zstyle ':notify:*' error-title "wow such #fail"
zstyle ':notify:*' success-icon "https://s-media-cache-ak0.pinimg.com/564x/b5/5a/18/b55a1805f5650495a74202279036ecd2.jpg"
zstyle ':notify:*' success-title "very success. wow"

bindkey '^r' history-incremental-search-backward

# interactive completion for jenkins x (zsh only)
source <(jx completion zsh)

# source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell

# echo "if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi" >> ~/.zshrc # add autocomplete permanently to your zsh shellif [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias vim="nvim"
alias vi="nvim"

export PATH=~/.npm-global/bin:$PATH
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export SONARQ_USER=arjaron
export SONARQ_PASS=freeosonarqube

export PATH=~/go/bin:$PATH

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# interchange-app

export PGP_PRIVATE_KEY=$(<~/milkyway/interchange-app/tests/test-keys.asc)



### Microservices
export DSPL_INTERCHANGE_FIRESTORE_PROJECT_ID=dspl-dev-fs
export DSPL_INTERCHANGE_DSPL_PRIVATE_KEY_PATH=~/milkyway/secrets/PGP_PrivateKey_DSPL2019.asc
# export DSPL_INTERCHANGE_DSPL_PRIVATE_KEY_PATH=~/milkyway/interchange-app/tests/test-keys.asc
export DSPL_INTERCHANGE_DSPL_PRIVATE_KEY_PASSPHRASE_PATH=/Users/arthur.jaron/milkyway/tfcluster-dairyforge/secrets/crypto-passphrase.key
# export GOOGLE_APPLICATION_CREDENTIALS=~/milkyway/secrets/dspl-dev-google-application-credentials.json
export BASICAUTH_CREDENTIALS=ewogICAgInVzZXJuYW1lIjogInNhcC1kc3BsLXNlcnZpY2UtdXNlciIsCiAgICAicGFzc3dvcmQiOiAiTXYsUHA4TlRObkBuPTQ9LGRAZncuU1B1Igp9
export PGP_PASSPHRASE=milchmachtmuedemaennermunter
export DSPL_INTERCHANGE_BASICAUTH_FILE=~/milkyway/secrets/dspl_interchange_basicauth_file.key.json
export DSPL_INTERCHANGE_STORAGE_BUCKET=interchange-app-localdev
# dspl-production-fs
# export GOOGLE_APPLICATION_CREDENTIALS=/Users/arthur.jaron/milkyway/secrets/dspl-production-fs-firebase-adminsdk-8whuq-49c1e66611.json
# dspl-dev-fs
export GOOGLE_APPLICATION_CREDENTIALS=/Users/arthur.jaron/milkyway/secrets/dspl-dev-fs-firebase-adminsdk-8xs5b-9bcd8a5514.json

export DSPL_INTERCHANGE_LOCALDEV=True

# used in fn-create-mitarbeiter
export KEYPATH_DSPL_PRODUCTION_FS=/Users/arthur.jaron/milkyway/secrets/dspl-production-fs-firebase-adminsdk-8whuq-49c1e66611.json
export KEYPATH_DSPL_DEV_FS=/Users/arthur.jaron/milkyway/secrets/dspl-dev-fs-firebase-adminsdk-8xs5b-9bcd8a5514.json


# terraform: NECESSARY, otherwise GOOGLE_APPLICATION_CREDENTIALS gets used by defaul! clash!
# export GOOGLE_APPLICATION_CREDENTIALS=/Users/arthur.jaron/milkyway/tfcluster-dairyforge/svacc-dspl-development-dairyforge.key.json
# interchange-app: dspl-dev/datastore
# export GOOGLE_APPLICATION_CREDENTIALS=/Users/arthur.jaron/milkyway/secrets/dspl-dev-google-application-credentials.json

export GNUPGHOME=~/gpghome

alias k='kubectl'
alias gs='git status'

[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh


export LC_ALL=en_US.UTF-8

export EDITOR=nvim
export KUBE_EDITOR=nvim

alias jxl='jx get build logs'
alias jxw='jx get activities -w'
alias jxc='jx context'
alias jxn='jx ns'
alias jxa='jx get applications'
alias jxui='jx ui -p 10001'


# zsh-autosuggestions
bindkey '^[[Z' autosuggest-accept

export PATH=~/.poetry/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias gm="gitmoji -c"
alias gl="git log -5 --oneline | cat"
alias fbtoken='python3 ~/milkyway/firebase-id-token-generator-python/firebase_token_generator.py'
alias sz='source ~/.zshrc'

# alias tokenprod='fbtoken kPhO4cHvN4zMj02NvOBw | tee /dev/tty | pbcopy'
# alias tokenstg='fbtoken Vgh2NzS9yIWcPwunB5IE | tee /dev/tty | pbcopy'
alias tokenprod='fbtoken kPhO4cHvN4zMj02NvOBw'
alias tokenstg='fbtoken Vgh2NzS9yIWcPwunB5IE'

export PYTHONBREAKPOINT=ipdb.set_trace

source /Users/arthur.jaron/milkyway/secrets/firebase_projects_envvars.sh

alias hb='hub browse'
