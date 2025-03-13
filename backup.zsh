#!/usr/bin/env zsh
DOTFILE_DIR="/Users/avsn/dotfiles"
OBSIDIAN_DIR="/Users/avsn/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/avsn-2022/"

cd "$DOTFILE_DIR" || exit

brew bundle dump --force --global

# Backup iTerm config
# cp "/Users/antonvasin/Library/Mobile Documents/com~apple~CloudDocs/com.googlecode.iterm2.plist" iTerm/

if ! git diff --quiet HEAD || git status --short; then
  git add --all
  git commit -m "Updating dotfiles on $(date -u)"
  git push origin main
fi

cd "$OBSIDIAN_DIR" || exit

if ! git diff --quiet HEAD || git status --short; then
  git add --all
  git commit -m "Vault backup $(date -u)"
  git push origin master
fi
