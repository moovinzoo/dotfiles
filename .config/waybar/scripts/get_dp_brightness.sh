#!/bin/bash

BUS_NUM=$(cat $HOME/.config/waybar/variables/dp_bus_num)
DEVICE_NUM=$(cat $HOME/.config/waybar/variables/dp_device_num)
ddcutil getvcp -b $BUS_NUM $DEVICE_NUM --brief | awk '{print $4}'
