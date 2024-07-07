#!/bin/bash

# For honor magicbook 16

if [ -z "$1" ]; then
    echo "Usage $0 <max>"
    echo "sudo apt install tlp"
    echo "sudo tlp-stat -b"
    exit 1
fi

max_value_param=$1

if [ $max_value_param -lt 50 ]; then
    end=50
elif [ $max_value_param -gt 100 ]; then
    end=100
else
    end=$max_value_param
fi

start=$((end-5))

file_path="/etc/tlp.conf"

sudo sed -i -E "
  s/^# ?START_CHARGE_THRESH_BAT0=[0-9]+$/START_CHARGE_THRESH_BAT0=${start}/;
  s/^START_CHARGE_THRESH_BAT0=[0-9]+$/START_CHARGE_THRESH_BAT0=${start}/
" "$file_path"
sudo sed -i -E "
  s/^# ?STOP_CHARGE_THRESH_BAT0=[0-9]+$/STOP_CHARGE_THRESH_BAT0=${end}/;
  s/^STOP_CHARGE_THRESH_BAT0=[0-9]+$/STOP_CHARGE_THRESH_BAT0=${end}/
" "$file_path"

sudo systemctl restart tlp

