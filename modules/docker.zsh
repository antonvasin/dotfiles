alias dps='docker ps'

alias dcom='docker-compose'

alias dbd='docker build --rm -t "${PWD##*/}:latest" .'

alias dcu='docker-compose up -d'
alias dcU='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcr='docker-compose restart'
alias dcl='docker-compose logs -f --tail=50'
alias dcx='docker-compose exec'
