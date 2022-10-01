if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

function fish_prompt
    set_color purple
    set MY_PWD pwd
    set MY_PWD string replace $HOME '~' ($MY_PWD)
    echo (set_color blue)'fish' (set_color 7134eb)($MY_PWD)(set_color 34a8eb) ' '(set_color normal)
end

function fish_greeting
end

if status is-interactive
    set -gx PATH $HOME/tools $PATH
    set -gx PATH /home/bmiq/.local/bin $PATH
    alias v="nvim"
    alias cls="clear"
    alias emoji_fish="echo ' '"
    alias c_fish="v ~/.config/fish/config.fish"
    alias c_nvim="v ~/.config/nvim/init.vim"
    alias c_kitty="v ~/.config/kitty/kitty.conf"
    alias c_poly="v ~/.config/polybar/config.ini"
    alias s_bright="xrandr --output DP-3 --brightness 1 --output HDMI-0 --brightness 1"
    alias s_dark="xrandr --output DP-3 --brightness 0.5 --output HDMI-0 --brightness 0.5"
    alias r_poly=".config/polybar/launch.sh"
    alias prompt="rofi -show run"
    alias zap="firefox 'https://web.whatsapp.com/' &"
    alias sv="sudo v"
    alias c_alacritty="v ~/.config/alacritty/alacritty.yml"
    alias c_picom="v ~/.picom.conf"
    alias c_bspwm="v ~/.config/bspwm/bspwmrc"
    alias rgf="rg --files | rg"
    alias rgc="rg -v '^[# \\t]' | rg -v '^\\s*\$'"
    alias notes="code ~/Notes/"
    alias lastss="ls -d ~/Pictures/Screenshots/* -Art | tail -n 1"
    alias editss="gimp (ls -d ~/Pictures/Screenshots/* -Art | tail -n 1) &"
    alias ss="ffmpeg -f x11grab -video_size 1920x1080 -i $display -vframes 1 ~/ss/ss.png"
end

