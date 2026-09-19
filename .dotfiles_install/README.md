Taken from: https://www.adamdehaven.com/articles/using-dotfiles-and-git-to-manage-your-development-environment-across-multiple-computers

This is a [bare Git repo](https://www.atlassian.com/git/tutorials/dotfiles) checked out onto `$HOME`. Use the `dotfiles` alias (not plain `git`) so you do not mix this repo up with other projects.

## Install on a new Ubuntu machine

```sh
git clone --bare git@github.com:Christopher-Collett/dotfiles.git "$HOME/.dotfiles"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local advice.addIgnoredFile false

# Back up any files that would conflict with checkout, then check out.
mkdir -p "$HOME/.dotfiles-backup"
dotfiles checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read -r file; do
    mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
    mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
done
dotfiles checkout

cp "$HOME/.dotfiles_local_settings.example" "$HOME/.dotfiles_local_settings"
# Edit ~/.dotfiles_local_settings with machine-specific PATH / aliases.

~/.dotfiles_install/install.sh
```

`install.sh` installs RobotoMono Nerd Font (Powerline glyphs + Starship icons), Starship, Powerline for tmux, and Terminator. Restart the terminal afterwards so the new font is picked up.

Optional LunarVim:

```sh
~/.dotfiles_install/install_lvim.sh
```

The terminal font must be **RobotoMono Nerd Font Light 11**. Terminator is configured that way by the install script. `fonts-powerline` from apt is only a tiny symbols fallback font — it is not a patched Roboto Mono.

## Day-to-day

```sh
dotfiles status
dotfiles add -u
dotfiles commit -m "..."
dotfiles push
```
