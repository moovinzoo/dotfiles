#!/bin/bash

# Localization -Korean
fcitx5 &
/usr/lib/polkit-kde-authentication-agent-1 &

# Update mirrorlist to latest on every boot
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist &

# Retrieve display bus, device numbers
$HOME/.config/hypr/scripts/get_dp_bus_num.sh > $HOME/.config/hypr/variables/dp_bus_num
$HOME/.config/hypr/scripts/get_dp_device_num.sh > $HOME/.config/hypr/variables/dp_device_num

# Setup Waybar w. external monitor setup
waybar -c $HOME/.config/waybar/externalonly_config &

# Setup wallpaper
swaybg -m center -i $HOME/.config/hypr/wallpapers/output_28.jpg -c "#000000" &
