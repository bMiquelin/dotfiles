#!/bin/bash

# -- base pkgs --
pacman -S sudo grub efibootmgr \
    dosfstools os-prober mtools \
    networkmanager \
    xorg xorg-xinit nvidia nvidia-utils \
    nvim git htop firefox \
    bspwm sxhkd rofi feh picom alacritty polybar

sudo pacman -Syu

# -- advanced pkgs --
pacman -S \
    xclip ripgrep neofetch \
    cmatrix dust dmenu sxhkd \
    picom polybar fish thunar \
    curl dunst dotnet-sdk \
    exa ya remmina freerdp \
    base-devel lolcat flameshot \
    bat arandr qjackctl \
		discord

# -- audio --
# pavucontrol ncpamixer pipeware-media-session pipewire pipewire-jack pipewire-alsa pipewire-pulse pipewire-media-session wireplumber  alsa-plugins


# --- dotfiles & git ---
cd $HOME
mkdir repo
cd repo
sudo pacman -S git --needed
git clone https://github.com/bMiquelin/dotfiles
git config --global user.email "bruno.b.miquelin@gmail.com"
git config --global user.name (whoami)
git config --global credential.helper store
chmod +x ./pull_cfg.sh
sh ./pull_cfg.sh

# --- neovim --- ##
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# --- fish as default shell --- #
# chsh -s $(which fish)

# -- FIX NVidia Tearing --
# nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"




# --- vs-code ---
# tar -xf code-stable-x64-1663191492.tar.gz -o
# mv ./VSCode-linux-x64/ ~/Programs/
# sudo ln -sf ~/Programs/VSCode-linux-x64/code /usr/bin/Code
