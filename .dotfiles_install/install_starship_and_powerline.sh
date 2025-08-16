#!/bin/bash
set -e # ensure script terminates on failures

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/powerline/fonts/blob/master/RobotoMono/Roboto%20Mono%20Light%20for%20Powerline.ttf
cd -

curl -sS https://starship.rs/install.sh | sh

pip install --break-system-packages pygit2 powerline-status
