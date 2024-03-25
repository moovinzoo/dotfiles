#!/bin/bash

# Localization -Korean
fcitx5 &
/usr/lib/polkit-kde-authentication-agent-1 &

# Update mirrorlist to latest on every boot
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist &

# Setup Waybar w. external monitor setup
waybar -c $HOME/.config/waybar/internalonly_config &

# Setup wallpaper
swaybg -m center -i $HOME/.config/hypr/wallpapers/output_29.jpg -c "#000000" &

