# Packages



# Dotfiles

to install/link the dotfiles, make sure `stow` is installed and then run

```zsh
stow --dotfiles --verbose --target=$HOME stow
```

alternatively, run

```zsh
make dotfiles
```


The goal is that from a fresh installation, only curl is needed to install and setup everything.


# Moving the location of the repo

Before moving the repo, unstow everything:
```zsh

stow -D --dotfiles --verbose --target=$HOME stow
```
