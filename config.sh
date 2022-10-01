pacman -S \
    xclip ripgrep neofetch \
    cmatrix dust dmenu sxhkd \
    picom polybar fish thunar \
    


# --- dotfiles & git ---
cd $HOME
mkdir repo
cd repo
sudo pacman -S git --needed
git clone https://github.com/bMiquelin/dotfiles
git config --global user.email "bruno.b.miquelin@gmail.com"
git config --global user.name "bMiq"
git config --global credential.helper store
chmod +x ./pull_cfg.sh
sh ./pull_cfg.sh




# --- vs-code ---
# tar -xf code-stable-x64-1663191492.tar.gz -o
# mv ./VSCode-linux-x64/ ~/Programs/
# sudo ln -sf ~/Programs/VSCode-linux-x64/code /usr/bin/Code