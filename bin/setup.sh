#!/bin/bash
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

options=(
    "AUR Helper (yay)|is_installed yay|setup_yay"
    "Custom Scripts|check_setup_bin|setup_bin"
    "Fun Tools|is_installed asciiquarium lolcat neofetch nsnake cmatrix fortune cowsay|install_package asciiquarium lolcat neofetch nsnake cmatrix fortune-mod cowsay"
    "Development Tools|is_installed git code wapiti yarn npm|setup_dev_tools"
    "Admin Utilities|is_installed bat btop cmake dust eza gdu htop jq nvim nano rg unzip wget zsh ffmpeg lsof 7z unrar convert inotifywait|bat btop cmake dust eza gdu htop jq neovim nano ripgrep unzip wget zsh ffmpeg lsof p7zip unrar imagemagick inotify-tools"
    "User Tools|is_installed discord pavucontrol remmina qbittorrent steam via vlc chromium miru mpv|install_packages discord pavucontrol remmina qbittorrent steam via-bin vlc chromium miru-bin mpv"
    "Fonts|is_fonts_ok|setup_fonts"
    "LunarVim|is_installed lvim|setup_lvim"
    "Setup GTK theme|symlink_exists $HOME/.config/gtk-3.0/settings.ini|setup_gtk"
    "Picom|symlink_exists $HOME/.config/picom.conf|setup_picom"
    "Alacritty|symlink_exists $HOME/.config/alacritty/alacritty.toml|setup_alacritty"
    "Polybar|symlink_exists $HOME/.config/polybar/config.ini|setup_polybar"
    "Feh|is_feh_ok|setup_feh"
    "zsh|symlink_exists $HOME/.zshrc|setup_zsh"
    "Starship Prompt|is_installed starship|curl -sS https://starship.rs/install.sh | sh"
    "Setup Camera|is_installed v4l2loopback-dkms|setup_camera"
    "Setup Keyboard|is_keyboard_ok|setup_keyboard"
    "Mount Windows partitions|is_windows_ok|setup_windows"
)
if [[ "$XDG_CURRENT_DESKTOP" == "KDE" || "$XDG_CURRENT_DESKTOP" == "Plasma" ]]; then
    options+=("Setup kde theming|is_kde_theming_ok|setup_kde_theming")
    options+=("Setup autologin|is_installed sddm|setup_sddm_autologin")
    options+=("Setup konsole|symlink_exists $HOME/.config/konsolerc|setup_konsole")
else
    
    options+=("i3 Window Manager|is_installed i3|setup_i3")
fi

menu() {
    echo "--------------------------------------------------"
    echo "|                  Setup Menu                   |"
    echo "--------------------------------------------------"
    for i in "${!options[@]}"; do
        label=$(echo "${options[$i]}" | cut -d'|' -f1)
        check_func=$(echo "${options[$i]}" | cut -d'|' -f2)
        action_func=$(echo "${options[$i]}" | cut -d'|' -f3-)
        
        if [[ $($check_func) -eq 1 ]]; then
            status="[X]"
        else
            status="[ ]"
        fi
        
        printf "| %-45s |\n" "$status $i) $label"
    done
    echo "--------------------------------------------------"
    echo -n "Choose an option:"
    read -r choice
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 0 ] || [ "$choice" -gt "${#options[@]}" ]; then
        echo "Invalid choice. Please select a valid number between 1 and ${#options[@]}."
        return
    fi
    eval "${options[$choice]##*|}"
}

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

setup_dev_tools() { 
    install_package git docker rust visual-studio-code-bin wapiti yarn npm python-pip openssh
    code --install-extension catppuccin.catppuccin-vsc catppuccin.catppuccin-vsc-icons eamodio.gitlens ms-dotnettools.csdevkit GitHub.copilot shakram02.bash-beautify
    wget https://dot.net/v1/dotnet-install.sh -O $HOME/tmp/dotnet-install.sh
    chmod +x $HOME/tmp/dotnet-install.sh
    $HOME/tmp/dotnet-install.sh --channel 9.0
    git config --global user.email "bruno.b.miquelin@gmail.com"
    git config --global user.name $(whoami)
    git config --global credential.helper store   
    ssh-keygen -t ed25519 -C "bruno.b.miquelin@gmail.com"   
    echo "✅ Dev installed"
}

check_setup_bin() {
    for script in $DOTFILES/bin/*.sh; do
        script_name=$(basename "$script" .sh)
        if [ ! -f "$HOME/.local/bin/$script_name" ]; then
            echo 0
            return
        fi
    done
    echo 1
}

setup_bin() { 
    for script in $DOTFILES/bin/*.sh; do
        script_name=$(basename "$script" .sh)
        if [ ! -f "$HOME/.local/bin/$script_name" ]; then
            ln -sf "$script" $HOME/.local/bin/"$script_name"
            chmod +x "$script"
            echo "✅ $script_name mapped to $HOME/.local/bin"
        fi
    done
}

setup_zsh() { 
    install_package zsh
    chsh -s $(which zsh)
    ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
    zsh
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

is_fonts_ok() {
    if ls $HOME/.local/share/fonts/Hack* 1> /dev/null 2>&1; then
        echo 1
    else
        echo 0
    fi
}

setup_lvim() {
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
    ln -sf $DOTFILES/lvim/config.lua $HOME/.config/lvim/config.lua
}

is_kde_theming_ok() {
    if [ -f "$HOME/.local/share/konsole/catppuccin-mocha.colorscheme" ]; then
        echo 1
    else
        echo 0
    fi
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

is_feh_ok() {
    if command -v feh &>/dev/null && grep -q '^feh' $HOME/.xinitrc; then
        echo 1
    else
        echo 0
    fi
}

setup_feh() {
    install_package feh
    wallpaper_cmd="feh --bg-fill $DOTFILES/wallpaper/wallpaper1.jpg"
    $wallpaper_cmd
    if ! grep -Fxq "$wallpaper_cmd" $HOME/.xinitrc; then
        sed -i "\$i $wallpaper_cmd" $HOME/.xinitrc
        echo "Wallpaper command added to .xinitrc"
    fi
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

is_keyboard_ok() {
    if grep -q 'dead_diaeresis' /usr/share/X11/xkb/symbols/us; then
        echo 0
    else
        echo 1
    fi
}

setup_keyboard() { 
    echo "Fixing xkb symbols file to remove dead_diaeresis from us-intl"
    file="/usr/share/X11/xkb/symbols/us"
    line_number=129
    new_line='key <AC11> { [ dead_acute, quotedbl, apostrophe ] };'
    current_line=$(sed -n "${line_number}p" "$file")
    if [[ "$current_line" != "$new_line" ]]; then
        sudo sed -i "${line_number}s/.*/$new_line/" "$file"
        echo "Line $line_number updated successfully."
    else
        echo "Line $line_number is already correct."
    fi
    setxkbmap -layout us -variant intl -option
}

is_windows_ok() {
    if command -v ntfs-3g &>/dev/null && grep -q '/dev/sda3 /mnt/windows' /proc/mounts; then
        echo 1
    else
        echo 0
    fi
}

setup_windows() {
    install_package ntfs-3g
    sudo mkdir -p /mnt/windows
    sudo mount -t ntfs-3g /dev/sda3 /mnt/windows
}

is_installed() {
    for pkg in "$@"; do
        if ! command -v "$pkg" &>/dev/null; then
            echo 0
            return
        fi
    done
    echo 1
}

symlink_exists() {
    for path in "$@"; do
        if [ -L "$path" ] && [ -e "$path" ]; then
            echo 1
        else
            echo 0
            return
        fi
    done
}

cat <<'EOF'
 _     __  __ _
| |__ |  \/  (_) __ _
| '_ \| |\/| | |/ _` |
| |_) | |  | | | (_| |
|_.__/|_|  |_|_|\__, |
                   |_|
         _       _    __ _ _
      __| | ___ | |_ / _(_) | ___  ___
     / _` |/ _ \| __| |_| | |/ _ \/ __|
    | (_| | (_) | |_|  _| | |  __/\__ \
   (_)__,_|\___/ \__|_| |_|_|\___||___/
EOF

while true; do
    menu
done