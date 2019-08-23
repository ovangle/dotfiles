#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function installPackages() {
  sudo apt-get update -qq 
  sudo apt-get install -y xclip
}

function writeFiles() {
  rsync --exclude=".git/" \
        --exclude="install.sh" \
        --exclude="LICENCE" \
        --exclude="README.md" \
        -avh --no-perms . ~
  source ~/.bashrc
}

function installVundle() {
  vundle_install="$HOME/.vim/bundle/Vundle.vim"
  if [[ -d "$vundle_install" ]]; then
    (
      cd "$vundle_install"
      git pull
    )
  else
    git clone "https://github.com/VundleVim/Vundle.vim.git" \
             "$HOME/.vim/bundle/Vundle.vim"
  fi
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  installPackages
  installVundle
  writeFiles
fi;

unset installVundle;
unset writeFiles;

