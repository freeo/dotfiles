all *.sh files in this folder are sourced by .zshrc:

for file in $HOME/dotfiles/scripts/zshsource/*.sh; do
    source "$file"
done
