alias glnm="git lnm"
alias gst='git status -sb'
alias gdiff='git diff'
alias git-delete-merged dm='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gpft='git push --follow-tags'
alias gpd='git push --delete'
alias gsd='git diff --staged'
alias gpf='git push --force-with-lease'
alias ghv="gh repo view --web"
alias ghpr="gh pr view --web"

ghR() {
  remote_url="$(gh repo view $1 --json url --jq .url).git"
  git remote add origin $remote_url
}

gWA() {
  git branch $2
  git worktree add $1 $2
  if [[ -f CLAUDE.md ]] cp CLAUDE.md $1/
  if [[ -e .env ]] cp .env $1/
  if [[ -d .claude ]] cp -r .claude $1/
  if [[ -d node_modules ]] cp -r node_modules $1/
  if [[ -n *.pem ]] cp *.pem $1/
  if [[ -n *.key ]] cp *.key $1/
  cd $1
}
