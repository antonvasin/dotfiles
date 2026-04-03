!/usr/bin/env bash

# Run mac OS configuration
echo "Configuring mac OS…"

# Check and install homebrew if needed
if ! which -s brew > /dev/null; then
  echo "Installing Homebrew…"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo 'Installing homebrew software…'
brew bundle

echo "Setting zsh as default shell…"
chsh -s $(which zsh)

echo "Installing zim…"
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

echo "Installing dotfiles…"
rcup

echo "Bootstrapping backup launch agent…"
# mkdir -p ~/Library/LaunchAgents
# ln -sf "$HOME/dotfiles/Library/LaunchAgents/DotfilesBackup.plist" ~/Library/LaunchAgents/DotfilesBackup.plist
launchctl bootout gui/$(id -u)/DotfilesBackup 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/DotfilesBackup.plist

# echo "Restarting gpg-agent…"
# killall gpg-agent && gpg-agent --daemon
