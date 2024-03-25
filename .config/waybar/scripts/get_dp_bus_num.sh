#!/bin/bash

ddcutil detect --brief | grep -B 1 "card1-DP-1" | head -1 | awk -F '/dev/i2c-' '{print $2}'
