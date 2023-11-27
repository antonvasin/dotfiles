!/usr/bin/env bash

# Run mac OS configuration
echo "Configuring mac OS…"
./macos.sh

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

echo "Restarting gpg-agent…"
killall gpg-agent && gpg-agent --daemon
