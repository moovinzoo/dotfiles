#!/bin/bash

BUS_NUM=$(cat $HOME/.config/waybar/variables/dp_bus_num)
DEVICE_NUM=$(cat $HOME/.config/waybar/variables/dp_device_num)
ddcutil -b $BUS_NUM setvcp $DEVICE_NUM + 10
