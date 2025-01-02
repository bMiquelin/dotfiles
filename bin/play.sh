#!/bin/bash
declare -A games

games=(
    [dos2]="MANGOHUD=1 wine /home/miq/.wine/drive_c/g/DOS2/DefEd/bin/EoCApp.exe"
    [er]="wine /home/miq/.wine/drive_c/g/eldenring/Game/eldenring.exe"
    [poe2]="steam steam://rungameid/2694490"
    [d2]="wine '/home/miq/.wine/drive_c/g/D2/Diablo II Resurrected Launcher.exe'"
    [awakened]="~/Downloads/Awakened-PoE-Trade-3.25.102.AppImage --no-overlay"
)

if [ -z "$1" ]; then
    echo "Usage: $0 <game_name>"
    exit 1
fi

if [[ -n "${games[$1]}" ]]; then
    eval "${games[$1]} & disown"
else
    echo "Game not recognized: $1"
    echo "Available games: ${!games[@]}"
    exit 1
fi
