#!/bin/bash

# Issue: https://www.linux.org.ru/forum/linux-hardware/17326993

# Define the input devices file and the output udev rule file
input_devices_file="/proc/bus/input/devices"
udev_rule_file="/etc/udev/rules.d/15-test.rules"

# Initialize variables to hold the extracted values
bus_type=""
vendor=""
product=""
version=""
properties="0"  # Default to "0" if not found

# Variable to track if the correct section is found
found_unknown=false

# Read the input devices file and save the relevant block
device_block=()
while IFS= read -r line; do
    if echo "$line" | grep -q "^I:"; then
        device_block=("$line")  # Start new device block
    elif [ -n "$line" ]; then
        device_block+=("$line")  # Continue the current device block
    fi

    if echo "$line" | grep -q "UNKNOWN"; then
        found_unknown=true
        break
    fi
done < "$input_devices_file"

if ! $found_unknown; then
    echo "Error: 'UNKNOWN' entry not found in $input_devices_file"
    exit 1
fi

# Process the saved block to extract values
for next_line in "${device_block[@]}"; do
    echo "Processing line: $next_line"
    case "$next_line" in
        I:*) # Extract values from the I: line
            bus_type=$(echo "$next_line" | grep -oP 'Bus=\K[0-9a-f]+')
            vendor=$(echo "$next_line" | grep -oP 'Vendor=\K[0-9a-f]+')
            product=$(echo "$next_line" | grep -oP 'Product=\K[0-9a-f]+')
            version=$(echo "$next_line" | grep -oP 'Version=\K[0-9a-f]+')
            ;;
        B:*) # Extract properties from the B: line
            if echo "$next_line" | grep -q "PROP="; then
                properties=$(echo "$next_line" | grep -oP 'PROP=\K[0-9]+')
            fi
            ;;
    esac
done

# Debug output of extracted values
echo "Extracted values:"
echo "  Bus Type: $bus_type"
echo "  Vendor: $vendor"
echo "  Product: $product"
echo "  Version: $version"
echo "  Properties: $properties"

# Check if any values are missing
if [ -z "$bus_type" ] || [ -z "$vendor" ] || [ -z "$product" ] || [ -z "$version" ]; then
    echo "Error: Failed to extract required values from $input_devices_file"
    exit 1
fi

# Create the udev rule file with the extracted values
udev_rule_content="ACTION==\"add\", ATTRS{id/bustype}==\"$bus_type\", ATTRS{id/product}==\"$product\", ATTRS{id/vendor}==\"$vendor\", ATTRS{id/version}==\"$version\", ATTRS{properties}==\"$properties\", ATTR{../inhibited}=\"1\""

# Use sudo to write the udev rule file
echo "$udev_rule_content" | sudo tee "$udev_rule_file" > /dev/null

echo "Udev rule created at $udev_rule_file"

