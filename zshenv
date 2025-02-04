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
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g '!.git' 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

export XDG_CONFIG_HOME="$HOME/.config"

export PATH="/usr/local/bin:/usr/local/sbin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# link unversioned python commands
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

# code
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# gnu utils
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gawk/libexec/gnubin:$PATH"

# npm
export NPM_CONFIG_PROGRESS=false
export NPM_CONFIG_SAVE=true

# RMT_AC_ZSH_SETUP_PATH=/Users/antonvasin/Library/Caches/@rm/tool/autocomplete/zsh_setup && test -f $RMT_AC_ZSH_SETUP_PATH && source $RMT_AC_ZSH_SETUP_PATH; # rmt autocomplete setup

export MNML_MAGICENTER=''

export DENO_INSTALL="/Users/avsn/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export HOMEBREW_NO_AUTO_UPDATE=1

export JAVA_HOME="/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home"

export PATH="/Users/avsn/.volta/bin:$PATH"

# Setup private env
if [[ -f ~/.private.zshenv ]]; then
  source ~/.private.zshenv
fi

