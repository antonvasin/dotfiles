export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH="$HOME/.cargo/bin:$PATH"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
eval $(/opt/homebrew/bin/brew shellenv)

export PATH="$PATH:$HOME/.zig/zls-latest:$HOME/.zig/latest"

# Created by `pipx` on 2025-03-01 21:16:25
export PATH="$PATH:/Users/avsn/.local/bin"
