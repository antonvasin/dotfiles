alias glnm="git lnm"
alias gst='git status -sb'
alias gdiff='git diff'
alias git-delete-merged dm='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'
alias gpft='git push --follow-tags'
alias gpd='git push --delete'
alias gsd='git diff --staged'
alias gpf='git push --force-with-lease'
alias ghv="gh repo view -w"

ghR() {
  remote_url="$(gh repo view $1 --json url --jq .url).git"
  git remote add origin $remote_url
}
