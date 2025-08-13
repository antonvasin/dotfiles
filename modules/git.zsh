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
  git worktree $1 $2
  if [ -e CLAUDE.md ] cp CLAUDE.md $1/
  if [ -e .env ] cp .env $1/
  if [ -e .claude ] cp -r .claude $1/
  cd $1
}
