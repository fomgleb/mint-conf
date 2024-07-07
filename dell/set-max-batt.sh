#!/bin/bash

# Check if one parameter is passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <max>"
    exit 1
fi

max_value_param=$1

if [ $max_value_param -lt 55 ]; then
    end=55
elif [ $max_value_param -gt 100 ]; then
    end=100
else
    end=$max_value_param
fi

start=$((end-5))

# Use variables in the commands
sudo smbios-battery-ctl --set-charging-mode=custom
sudo smbios-battery-ctl --set-custom-charge-interval=$start $end

