#!/bin/bash
cd $HOME/repo/dotfiles/.config

cp -rv ./* ~/.config
notify-send 'Pull config'