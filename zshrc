# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install


for module in ~/dotfiles/modules/*.zsh; do
  source ${module}
done

# Remove lag when switching between vi and regular zsh modes
export KEYTIMEOUT=1

# use carets as normal symbols
unsetopt nomatch

#### Alias
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

alias less='less -R'
alias mkdir='mkdir -p'
alias xz='source ~/.zshrc'
alias top='sudo htop'
alias j='fasd_cd -d'
alias l="ls -lah"

# Do not confirm rm
unalias rm 2>/dev/null
# zimfw conflicts with GitHub CLI
unalias gh

# cat -> bat
if [[ -f /opt/homebrew/bin/bat ]]; then
  export BAT_THEME_LIGHT="Coldark-Cold"
  export BAT_THEME_DARK="Coldark-Dark"
  alias cat="bat"
fi

# find -> fd
if [[ -f /opt/homebrew/bin/fd ]]; then
  alias find='fd'
fi

# llm aliases
if [[ -f /opt/homebrew/bin/llm ]]; then
  alias llmC="llm -m claude-3.7-sonnet -o thinking 1"
fi

#### fzf
eval "$(fzf --zsh)"

export PURE_CMD_MAX_EXEC_TIME=999

find-alias() {
  local found_alias
  found_alias=$(alias | fzf | sed -n 's/\(=.*\)$//p') && print -z $found_alias
}

zle -N find-alias
alias za=find-alias

eval "$(op completion zsh)"; compdef _op op

# Go
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# GPG
export GPG_TTY=$(tty)

# source /Users/antonvasin/.config/op/plugins.sh

# Put homebrew java first
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# bun completions
[ -s "/Users/antonvasin/.bun/_bun" ] && source "/Users/antonvasin/.bun/_bun"
# eval "$(register-python-argcomplete pipx)"
alias python=python3

# Created by `pipx` on 2025-03-01 21:16:25
export PATH="$PATH:/Users/avsn/.local/bin"
