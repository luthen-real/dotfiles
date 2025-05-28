# Packages



# Dotfiles

to install/link the dotfiles, make sure `stow` is installed and then run

```zsh
stow --dotfiles --verbose --target=$HOME stow
# or
make dotfiles
```
```zsh
```

The goal is that from a fresh installation, only curl is needed to install and setup everything.


# NOTE

If you want to move the location of the cloned repo, you have to unstow everything. This can be done manually (not recommended) or via running the following command:
```zsh
stow -D --dotfiles --verbose --target=$HOME stow
# or
make clean
```

