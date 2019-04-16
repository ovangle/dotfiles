#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function writeFiles() {
  rsync --exclude=".git/" \
        --exclude="install.sh" \
        --exclude="LICENCE" \
        --exclude="README.md" \
        -avh --no-perms . ~
  source ~/.bashrc
}



read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  writeFiles
fi;


unset writeFiles;

