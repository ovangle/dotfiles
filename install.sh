#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function installPackages() {
  sudo apt-get update -qq 
  sudo apt-get install -y xclip socat
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

gitConfigConfirm='N'

while ! [[ $gitConfigConfirm =~ ^[Yy] ]]; do
  ## Allow the installer to configure the git name and email
  ## Rather than binding them in the .gitconfig
  read -p "Your name as you would like it to appear in git commit messages: " gitName;
  read -p "Your email as you would like it to appear in git commit message: " gitEmail;

  echo "git username: \"$gitName\" git email: \"$gitEmail\""
  read -p "Is this correct (y/n) " -n 1 $git_config_correct gitConfigConfirm;
  echo ""
done


if [[ $REPLY =~ ^[Yy]$ ]]; then
  mkdir -p "$HOME/.tmp"

  installPackages
  installVundle
  writeFiles

  git config --global user.name "$gitName";
  git config --global user.email "$gitEmail";
fi;

unset installPackages;
unset installVundle;
unset writeFiles;

