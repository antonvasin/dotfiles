#!/usr/bin/env zsh
DOTFILE_DIR="/Users/antonvasin/dotfiles"

cd "$DOTFILE_DIR" || exit

if ! git diff --quiet HEAD || git status --short; then
  git add --all
  git commit -m "updating dotfiles on $(date -u)"
  git push origin master
fi
