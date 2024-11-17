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
export WIN=/mnt/windows
export WINBAK=/mnt/windows/bak

alias lastss="ls -d ~/Pictures/Screenshots/* -Art | tail -n 1"
alias editss="gimp (ls -d ~/Pictures/Screenshots/* -Art | tail -n 1) &"
alias ss="ffmpeg -f x11grab -video_size 1920x1080 -i $display -vframes 1 ~/ss/ss.png"
alias c_dunst='v $DOTFILES/dunst/dunstrc'
alias c_poly='v $DOTFILES/polybar/config.ini'
alias c_alacritty="v $DOTFILES/alacritty/alacritty.toml"
alias i3c='lvim $DOTFILES/i3/config'
alias backup='sudo timeshift --create --tags D'
alias l='eza -al --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ..='cdls ..'
alias h='cdls $HOME'
alias rgf='rg --files | rg'
alias rgc="rg -v '^[# \\t]' | rg -v '^\\s*\$'"
alias start='xdg-open'
alias vim='lvim'
alias vi='lvim'
alias v='lvim'
alias lsl='eza -l'
alias lsla='eza -lA'
alias weather='curl wttr.in'
alias cdls='function _cdls() { cd "$1" && ll }; _cdls'
alias mkcd='function _mkcd() { mkdir -p "$1" && cd "$1"; }; _mkcd'
alias reload='source ~/.zshrc'
alias zshrc='lvim ~/.zshrc'
alias codedot='code $DOTFILES'
alias home='cd $home && eza -l'
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

neofetch
