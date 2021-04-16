# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim}
# }}} End configuration added by Zim install

#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# preview stolen from https://remysharp.com/2018/08/23/cli-improved
export FZF_DEFAULT_OPTS="--bind ctrl-j:down,ctrl-k:up --preview 'bat --color \"always\" {}' --bind='ctrl-o:execute(code {})+abort'"
export FZF_CTRL_R_OPTS="--no-preview"
export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='rg --files --follow 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

export XDG_CONFIG_HOME="$HOME/.config"

export PATH="/usr/local/bin:/usr/local/sbin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# code
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# doom-emacs
# export PATH="$HOME/.emacs.d/bin:$PATH"

# gnu utils
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gawk/libexec/gnubin:$PATH"

# npm
export NPM_CONFIG_PROGRESS=false
export NPM_CONFIG_SAVE=true

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export VOLTA_HOME="/Users/antonvasin/.volta"
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

# RMT_AC_ZSH_SETUP_PATH=/Users/antonvasin/Library/Caches/@rm/tool/autocomplete/zsh_setup && test -f $RMT_AC_ZSH_SETUP_PATH && source $RMT_AC_ZSH_SETUP_PATH; # rmt autocomplete setup
