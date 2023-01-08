#!/bin/bash
IS_VERBOSE=false
if [ "$1" ];
then
    IS_VERBOSE=true
fi

verbose() {
    if [ $IS_VERBOSE == false ];
    then
        $@ > /dev/null 2>&1
    else
        $@ > /dev/stdout
    fi
}

echo "[1/4] Checking wget..."
{
    verbose sudo pacman -S --noconfirm wget --needed
}

echo "[2/4] Hack Fonts"
{
    sudo mkdir -p "/usr/local/share/fonts/ttf/Hack"
    mkdir -p $HOME/temp
    verbose wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip" -O $HOME/temp/hack.zip
    verbose sudo unzip -f $HOME/temp/hack.zip -d "/usr/local/share/fonts/ttf/Hack"
    rm $HOME/temp/hack.zip
}

echo "[3/4] Noto Fonts CJK Fallback"
{
    verbose sudo pacman -S --noconfirm noto-fonts-cjk noto-fonts-emoji noto-fonts-extra --needed
}

echo "[4/4] Clearing Cache"
{
    fc-cache -f
}

echo "Done"