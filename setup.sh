#!/bin/zsh
mkdir -p $HOME/g
mkdir -p $HOME/p
mkdir -p $HOME/dev
mkdir -p $HOME/src
mkdir -p $HOME/tmp
mkdir -p $HOME/assets

DOTFILES=$HOME/dotfiles

if [ -z "$DOTFILES" ]; then
    echo "Error: DOTFILES variable is not set."
    exit 1
fi

install_package() {
    if command -v yay &> /dev/null; then
        yay -S --needed $@
    else
        sudo pacman -S --needed $@
    fi
}

setup_yay() {
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git $HOME/tmp/yay
    cd $HOME/tmp/yay
    makepkg -si
    echo "✅ Yay installed"
}

setup_sddm_autologin() {

    current_user=$(whoami)
    sudo tee -a $HOME/tmp/sddm.conf > /dev/null <<EOL
[Autologin]
User=$current_user
Session=plasma
EOL
    sed -i '2s/$/auth        sufficient  pam_succeed_if.so user ingroup nopasswdlogin/' /etc/pam.d/sddm
    sed -i '2s/$/auth        sufficient  pam_succeed_if.so user ingroup nopasswdlogin/' /etc/pam.d/kde
    sudo groupadd -r nopasswdlogin
    sudo gpasswd -a $(whoami) nopasswdlogin
    echo "✅ SDDM Autologin installed"
}

setup_fun_tools() { 
    install_package asciiquarium lolcat neofetch nsnake cmatrix fortune-mod cowsay
    echo "✅ Fun installed"
}

setup_dev_tools() { 
    # Install tool pkg
    install_package git docker rust visual-studio-code-bin wapiti yarn npm python-pip openssh

    # cfg vs-code
    code --install-extension catppuccin.catppuccin-vsc catppuccin.catppuccin-vsc-icons eamodio.gitlens ms-dotnettools.csdevkit
    
    # cfg dotnet
    wget https://dot.net/v1/dotnet-install.sh -O $HOME/tmp/dotnet-install.sh
    chmod +x $HOME/tmp/dotnet-install.sh
    $HOME/tmp/dotnet-install.sh --channel 9.0

    # cfg git
    # git clone https://github.com/bMiquelin/dotfiles
    git config --global user.email "bruno.b.miquelin@gmail.com"
    git config --global user.name (whoami)
    git config --global credential.helper store   
    ssh-keygen -t ed25519 -C "bruno.b.miquelin@gmail.com"   
    echo "✅ Dev installed"
}

setup_admin_tools() { 
    install_package bat btop cmake dust eza gdu htop jq neovim nano ripgrep unzip wget zsh ffmpeg lsof p7zip unrar imagemagick inotify-tools
    curl -sS https://starship.rs/install.sh | sh
    echo "✅ Fun installed"
}

setup_user_tools() { 
    install_package discord pavucontrol remmina qbittorrent steam via-bin vlc chromium miru-bin spectacle mpv
    echo "✅ Tools installed"
}

setup_bin() { 
    for script in $DOTFILES/bin/*.sh; do
        script_name=$(basename "$script" .sh)
        ln -sf "$script" $HOME/.local/bin/"$script_name"
        chmod +x "$script"
        echo "$script_name mapped to $HOME/.local/bin"
    done
    echo "✅ Script from dotfiles/bin linked to $HOME/.local/bin"
}

setup_zsh() { 
    install_package zsh
    chsh -s $(which zsh)
    ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
    source $HOME/.zshrc
    echo "✅ Zsh installed"
}

setup_fonts() { 
    if ls $HOME/.local/share/fonts/Hack* 1> /dev/null 2>&1; then
        echo "Fonts are already installed"
    fi
    install_package noto-fonts-cjk noto-fonts-emoji
    font_dir=$HOME/tmp/Hack.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -O $font_dir
    unzip $font_dir '*.ttf' -d $HOME/.local/share/fonts/
    rm $font_dir
    sudo cp $DOTFILES/fonts/local.conf /etc/fonts/local.conf
    fc-cache -f -v
    echo "✅ Hack fonts installed"
}

setup_lvim() {
    #install_package python-nvim
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
    ln -sf $DOTFILES/lvim/config.lua $HOME/.config/lvim/config.lua
}

setup_kde_theming() { 
    # OS Theme
    cd $HOME/tmp
    git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde
    cd catppuccin-kde
    ./install.sh

    # Konsole Theme
    cd $HOME/.local/share/konsole && wget https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

    # Icon Theme
    cd $HOME/.local/share/icons
    git clone https://github.com/m4thewz/dracula-icons
    echo "Check $HOME/.config/kdeglobals for icon config"

    # Window Decorations
    echo "Window Decorations -> Pick Scratchy"
}

setup_picom() { 
    install_package picom
    mkdir -p $HOME/.config/picom 
    ln -sf $DOTFILES/picom/picom.conf $HOME/.config/picom.conf
    echo "✅ Picom installed"
}

setup_alacritty() {
    install_package alacritty
    mkdir -p $HOME/.config/alacritty
    curl -LO --output-dir ~/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml
    ln -sf $DOTFILES/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml
    echo "✅ Alacritty installed"
}

setup_polybar() {
    install_package polybar
    mkdir -p $HOME/.config/polybar
    ln -sf $DOTFILES/polybar/config.ini $HOME/.config/polybar/config.ini
    echo "✅ Polybar installed"
}

setup_feh() {
    install_package feh
    feh --bg-fill $DOTFILES/wallpaper/wallpaper1.jpg
    echo "✅ Feh installed"
}

setup_gtk() {
    yay -S catppuccin-gtk-theme-mocha
    mkdir -p $HOME/.config/gtk-3.0
    ln -sf $DOTFILES/gtk/settings.ini $HOME/.config/gtk-3.0/settings.ini
    echo "✅ GTK installed"
}

setup_i3() {
    install_package i3 dmenu dunst thunar
    mkdir -p $HOME/.config/i3
    ln -sf $DOTFILES/i3/config $HOME/.config/i3/config
    
    setup_picom
    setup_alacritty
    setup_polybar
    setup_feh

    echo "✅ i3 installed"
}

setup_konsole() { 
    cd $HOME/.local/share/konsole && wget https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme
    ln -sf $DOTFILES/konsole/konsolerc $HOME/.config/konsolerc
    ln -sf $DOTFILES/konsole/zsh.profile $HOME/.local/share/konsole/zsh.profile
    echo "✅ Konsole installed"
}

setup_camera() { 
    install_package v4l2loopback-dkms v4l2-utils
    sudo modprobe v4l2loopback video_nr=5 card_label="Virtual Camera" exclusive_caps=1
    v4l2-ctl --list-devices
    #ffmpeg -i /dev/video0 -f v4l2 -vcodec rawvideo -pix_fmt rgb24 /dev/video5
    install_package obs-studio-git obs-backgroundremoval
    echo "✅ Camera installed"
}

setup_keyboard() { 
    setxkbmap -layout us -variant intl -option

    echo "Fixing xkb symbols file to remove dead_diaeresis from us-intl"
    file="/usr/share/X11/xkb/symbols/us"
    line_number=129
    new_line='key <AC11> { [ dead_acute, quotedbl, apostrophe ] };'
    current_line=$(sed -n "${line_number}p" "$file")

    # If the current line doesn't match the desired one, update it
    if [[ "$current_line" != "$new_line" ]]; then
        sudo sed -i "${line_number}s/.*/$new_line/" "$file"
        echo "Line $line_number updated successfully."
    else
        echo "Line $line_number is already correct."
    fi
}


prompt_setup() {
    local prompt_message=$1
    local setup_command=$2
    echo "$prompt_message (y/n):"
    read -r x && [[ "$x" =~ ^[Yy]$ ]] && eval "$setup_command"
}

prompt_setup "Setup yay?" "setup yay"
prompt_setup "Setup sddm autologin?" "setup_sddm_autologin"
prompt_setup "Setup fun tools?" "setup_fun_tools"
prompt_setup "Setup dev tools?" "setup_dev_tools"
prompt_setup "Setup admin tools?" "setup_admin_tools"
prompt_setup "Setup user ools?" "setup_user_tools"
prompt_setup "Setup bin?" "setup_bin"
prompt_setup "Setup zsh?" "setup_zsh"
prompt_setup "Setup fonts?" "setup_fonts"
prompt_setup "Setup lvim?" "setup_lvim"
prompt_setup "Setup kde theming?" "setup_kde_theming"
prompt_setup "Setup i3?" "setup_i3"
prompt_setup "Setup konsole?" "setup_konsole"
prompt_setup "Setup camera?" "setup_camera"
prompt_setup "Setup keyboard?" "setup_keyboard"
