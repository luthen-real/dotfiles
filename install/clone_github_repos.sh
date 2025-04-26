#!/bin/sh

# Clones all repos on github into 
#
repos=(
  "git@github.com:zeno-nada/setup.git"
)

mkdir -p ~/projects
cd ~/projects

f=id_ed25519_github
[ -f ~/.ssh/$f.pub ] || ssh-keygen -t ed25519 -b 4096 -f ~/.ssh/$f
xdg-open https://github.com/settings/ssh/new

for repo in "${repos[@]}"; do
    git clone  $repo
done
