#!/usr/bin/python3
#
# Select a rc config file with fzf and edit it

from pyfzf.pyfzf import FzfPrompt
import subprocess

RCF = {
    "zsh": "$EDITOR ~/.zshrc",
    "neovim": "$EDITOR ~/.config/nvim/init.vim",
    "awesome": "$EDITOR ~/.config/awesome/rc.lua",
    "kitty": "$EDITOR ~/.config/kitty/kitty.conf",
}

fzf = FzfPrompt()
SEL = fzf.prompt(list(RCF.keys()))[0]
subprocess.run(RCF[SEL], shell=True)
