#!/bin/bash
sudo pacman -S wget --needed

mkdir -p $HOME/tmp
wget "https://download.visualstudio.microsoft.com/download/pr/253e5af8-41aa-48c6-86f1-39a51b44afdc/5bb2cb9380c5b1a7f0153e0a2775727b/dotnet-sdk-7.0.100-linux-x64.tar.gz" -O $HOME/tmp/dotnet.tar.gz
mkdir -p $HOME/programs/dotnet
tar -xf $HOME/tmp/dotnet.tar.gz -C $HOME/programs/dotnet
sudo ln -sf ~/programs/dotnet/dotnet /usr/local/bin/dotnet
