#!/bin/bash

BUS_NUM=$(cat $HOME/.config/waybar/variables/dp_bus_num)
ddcutil getvcp -b $BUS_NUM known --brief | grep 100 | awk '{print $2}'
