#!/bin/bash

BUS_NUM=$(cat $HOME/.config/waybar/variables/dp_bus_num)
DEVICE_NUM=$(cat $HOME/.config/waybar/variables/dp_device_num)
BRIGHTNESS=$()

while true; do
  echo {\"percentage\": $(ddcutil getvcp -b $BUS_NUM $DEVICE_NUM --brief | awk '{print $4}')} \
    | jq --unbuffered --compact-output
  sleep 1
done
