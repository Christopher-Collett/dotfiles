#!/bin/bash
set -e # ensure script terminates on failures

sudo apt-get -y update
sudo apt-get -y install terminator

mv $HOME/.config/terminator/example.background.jpg $HOME/.config/terminator/background.jpg
mv $HOME/.config/terminator/example.config $HOME/.config/terminator/config

sed -i "s|HOME_DIR|${HOME}|g" $HOME/.config/terminator/config
