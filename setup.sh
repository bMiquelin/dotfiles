#!/bin/zsh
mkdir -p ~/g
mkdir -p ~/p
mkdir -p ~/dev
mkdir -p ~/src
mkdir -p ~/tmp
mkdir -p ~/assets

if [ -z "$DOTFILES" ]; then
    echo "Error: DOTFILES variable is not set."
    exit 1
fi

install_package() {
    if command -v yay &> /dev/null; then
        yay -S --needed $1
    else
        sudo pacman -S --needed $1
    fi
}

setup_yay() {
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git ~/tmp/yay
    cd ~/tmp/yay
    makepkg -si
    echo "✅ Yay installed"
}

setup_sddm_autologin() {

    current_user=$(whoami)
    sudo tee -a ~/tmp/sddm.conf > /dev/null <<EOL
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
    install_package git docker rust visual-studio-code-bin wapiti yarn npm python-pip

    # cfg vs-code
    code --install-extension catppuccin.catppuccin-vsc catppuccin.catppuccin-vsc-icons eamodio.gitlens ms-dotnettools.csdevkit
    
    # cfg dotnet
    wget https://dot.net/v1/dotnet-install.sh -O ~/tmp/dotnet-install.sh
    chmod +x ~/tmp/dotnet-install.sh
    ~/tmp/dotnet-install.sh --channel 9.0

    # cfg git
    git clone https://github.com/bMiquelin/dotfiles
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
    ln -sf $DOTFILES/bin/pass.sh ~/.local/bin/pass
    chmod +x $DOTFILES/bin/pass.sh.sh
    ln -sf $DOTFILES/bin/watch_cfg.sh ~/.local/bin/watch_cfg
    chmod +x $DOTFILES/bin/watch_cfg.sh    
    echo "✅ Script OK, get encrypted pass file"
}

setup_zsh() { 
    install_package zsh
    chsh -s $(which zsh)
    ln -sf $DOTFILES/zsh/.zshrc ~/.zshrc
    source ~/.zshrc
    echo "✅ Zsh installed"
}

setup_fonts() { 
    if ls ~/.local/share/fonts/Hack* 1> /dev/null 2>&1; then
        echo "Fonts are already installed"
    fi
    install_package noto-fonts-cjk
    font_dir=~/tmp/Hack.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -O $font_dir
    unzip $font_dir '*.ttf' ~/.local/share/fonts/
    rm $font_dir
    sudo cp $DOTFILES/fonts/local.conf /etc/fonts/local.conf
    fc-cache -f -v
    echo "✅ Hack fonts installed"
}

setup_lvim() { 
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
    ln -sf $DOTFILES/lvim/config.lua ~/.config/lvim/config.lua
}

setup_kde_theming() { 
    # OS Theme
    cd ~/tmp
    git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde
    cd catppuccin-kde
    ./install.sh

    # Konsole Theme
    cd ~/.local/share/konsole && wget https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme

    # Icon Theme
    cd ~/.local/share/icons
    git clone https://github.com/m4thewz/dracula-icons
    echo "Check ~/.config/kdeglobals for icon config"

    # Window Decorations
    echo "Window Decorations -> Pick Scratchy"
}

setup_i3() {
    ln -sf $DOTFILES/i3/config ~/.config/i3/config
    echo "✅ i3 installed"
}

setup_konsole() { 
    cd ~/.local/share/konsole && wget https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme
    ln -sf $DOTFILES/konsole/konsolerc ~/.config/konsolerc
    ln -sf $DOTFILES/konsole/zsh.profile ~/.local/share/konsole/zsh.profile
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
    echo "Check /usr/share/X11/xkb/symbols/us, Line 129, inside intl block, at ACC11"
    echo "key <AC11> { [dead_acute, quotedbl, apostrophe ] };"
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
