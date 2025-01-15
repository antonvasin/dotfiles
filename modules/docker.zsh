alias dps='docker ps'
alias dbd='docker build --rm -t "${PWD##*/}:latest"'

alias dcu='docker compose up -d'
alias dcU='docker compose up'
alias dcd='docker compose down'
alias dcs='docker compose stop'
alias dcb='docker compose build'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f --tail=50'
alias dcx='docker compose exec'
alias dls='docker compose ls'

alias kc='kubectl'

# Run docker container with current host directory mounted to /src
grr() {
  if [[ $# -eq 0 ]]; then
    echo "Missing argument"
  else
    name=$1
    docker run -it --rm --name=$name -v="${PWD}:/src" "${name}:latest" bash
  fi
}
