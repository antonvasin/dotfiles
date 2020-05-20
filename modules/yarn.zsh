yarn-list() {
  yarn list --depth=0 --pattern="$1"
}

yarn-upgrade-latest() {
  yarn upgrade "$@" --latest
}

alias yt='yarn test'
alias yb='yarn build'
alias yd='yarn dev'
alias y='yarn'
alias yu='yarn upgrade'
alias yU='yarn-upgrade-latest'
alias yls=yarn-list
alias yad='yarn add'
alias yaD='yarn add --dev'
