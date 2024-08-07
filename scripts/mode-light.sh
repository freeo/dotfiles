#!bash
gsettings set org.gnome.desktop.interface color-scheme  'prefer-light'

cp $HOME/.config/kitty/lightmode.conf $HOME/.config/kitty/kitty.conf
TO_FILE=$HOME/.config/kitty/kitty.conf
sed -i '1i\# Generated by dotfiles/scripts/mode-light.sh' $TO_FILE
kill -SIGUSR1 $(pidof kitty)
# sleep 2
kill -SIGUSR1 $(pidof nvim)

K9S=$HOME/.config/k9s/config.yaml
cp $K9S $K9S.bak
sed -i 's/skin:.*$/skin: navy-transparent/' $K9S.bak
cp $K9S.bak $K9S
