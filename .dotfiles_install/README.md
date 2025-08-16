Taken from: https://www.adamdehaven.com/articles/using-dotfiles-and-git-to-manage-your-development-environment-across-multiple-computers

To install on a new system:
```sh
git clone --bare git@github.com:Christopher-Collett/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
mv .bashrc .bashrc.bak # and any other conflicting files
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local advice.addIgnoredFile false
cp $HOME/.dotfiles_local_settings.example $HOME/.dotfiles_local_settings
```
