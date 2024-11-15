HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/miq/.zshrc'

autoload -Uz compinit
compinit

eval "$(starship init zsh)"

path+=('/home/miq/.local/bin')
path+=('/home/miq/.dotnet/tools')
path+=('/home/miq/.dotnet/dotnet')
export path
export EDITOR='lvim'
export VISUAL='lvim'
export DOTFILES=$HOME/dotfiles


alias l='eza -al --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ..='cdls ..'
alias rgf='rg --files'
alias start='xdg-open'
alias vi='lvim'
alias v='lvim'
alias lsl='eza -l'
alias lsla='eza -lA'
alias weather='curl wttr.in'
alias cdls='function _cdls() { cd "$1" && ll }; _cdls'
alias mkcd='function _mkcd() { mkdir -p "$1" && cd "$1"; }; _mkcd'
alias reload='source ~/.zshrc'
alias zshrc='lvim ~/.zshrc'
alias home='cd $home && eza -l'
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

neofetch
