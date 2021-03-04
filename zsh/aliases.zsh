alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command
alias tunaplease='lsof -i'

nngrep () {
    sudo ngrep -d any $2 -q -W byline port $1
}
