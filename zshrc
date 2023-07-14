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


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

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

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

zstyle ':zim:git' aliases-prefix 'g'
# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

for module in ~/dotfiles/modules/*.zsh; do
  source ${module}
done

# Source Iterm2 integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh


# Remove lag when switching between vi and regular zsh modes
export KEYTIMEOUT=1

# use carets as normal symbols
unsetopt nomatch

#### Alias
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias nv='neovide'

alias vmore='nvim -u ~/.config/nvim/more.vim'
alias less='less -R'
alias mkdir='mkdir -p'
alias xz='source ~/.zshrc'
alias help='tldr'
alias top='sudo htop'
alias j='fasd_cd -d'

# Do not confirm rm
unalias rm 2>/dev/null

#### Override standart stuff
# ls -> exa
if [[ -f /usr/local/bin/exa ]]; then
  alias l="exa -la --no-user --no-permissions --git --group-directories-first"
else
  alias l="ls -lah"
fi

# cat -> bat
if [[ -f /usr/local/bin/bat ]]; then
  alias cat='bat'
  export BAT_THEME='gruvbox'
fi

# ping -> prettyping
# [[ -f /usr/local/bin/prettyping ]] && alias ping='prettyping --nolegend'

# find -> fd
[[ -f /usr/local/bin/fd ]] && alias find='fd'


#### fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^F' fzf-cd-widget

fpath=(/usr/local/share/zsh-completions $fpath)

export PURE_CMD_MAX_EXEC_TIME=999

find-alias() {
  local found_alias
  found_alias=$(alias | fzf | sed -n 's/\(=.*\)$//p') && print -z $found_alias
}

zle -N find-alias
alias za=find-alias

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
eval "$(op completion zsh)"; compdef _op op
compinit
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Go
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# GPG
export GPG_TTY=$(tty)

# enable visual fx
export NEOVIDE_MULTIGRID='true'

# DNS Toys
dy() {
  dig +noall +answer +additional "$1" @dns.toys
}

source /Users/antonvasin/.config/op/plugins.sh
eval
RMT_AC_ZSH_SETUP_PATH=/Users/antonvasin/Library/Caches/@rm/tool/autocomplete/zsh_setup && test -f $RMT_AC_ZSH_SETUP_PATH && source $RMT_AC_ZSH_SETUP_PATH; # rmt autocomplete setup
