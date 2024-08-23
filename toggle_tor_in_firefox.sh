#!/bin/bash

# Check if the user has provided an argument
if [ $# -eq 0 ]; then
    echo "No argument provided. Use 'on' or 'off'."
    exit 1
fi

# Set the replacement values based on the argument
if [ "$1" == "on" ]; then
    OLD_PROXY_TYPE="user_pref(\"network.proxy.type\", 4);"
    NEW_PROXY_TYPE="user_pref(\"network.proxy.type\", 1);"
    SOCKS_PROXY="user_pref(\"network.proxy.socks\", \"127.0.0.1\");"
    SOCKS_PORT="user_pref(\"network.proxy.socks_port\", 9150);"
elif [ "$1" == "off" ]; then
    OLD_PROXY_TYPE="user_pref(\"network.proxy.type\", 1);"
    NEW_PROXY_TYPE="user_pref(\"network.proxy.type\", 4);"
    SOCKS_PROXY=""
    SOCKS_PORT=""
else
    echo "Invalid argument. Use 'on' or 'off'."
    exit 1
fi

# Path to the prefs.js file (Update this path if necessary)
PREFS_FILE="$HOME/.mozilla/firefox/your_dir_name.default/prefs.js"

if [ "$1" == "on" ]; then
    if grep -q "$NEW_PROXY_TYPE" "$PREFS_FILE" && grep -q "$SOCKS_PROXY" "$PREFS_FILE" && grep -q "$SOCKS_PORT" "$PREFS_FILE"; then
        exit 0
    fi
elif [ "$1" == "off" ]; then
    if grep -q "$NEW_PROXY_TYPE" "$PREFS_FILE"; then
        exit 0
    fi
else
    exit 0
fi

# Backup the original prefs.js file
cp "$PREFS_FILE" "$PREFS_FILE.bak"

# Close Firefox instance
wmctrl -c "Mozilla Firefox"
while pgrep -fa "firefox" | grep -v "tor-browser" | grep "/usr/lib/firefox/firefox$" > /dev/null; do
    sleep 0.1
done

# Update network.proxy.type
if grep -q "user_pref(\"network.proxy.type\"," "$PREFS_FILE"; then
    sed -i "s/$OLD_PROXY_TYPE/$NEW_PROXY_TYPE/" "$PREFS_FILE"
else
    echo "$NEW_PROXY_TYPE" >> "$PREFS_FILE"
fi

# Add SOCKS settings if enabling Tor (on)
if [ "$1" == "on" ]; then
    if ! grep -q "user_pref(\"network.proxy.socks\"," "$PREFS_FILE"; then
        echo "$SOCKS_PROXY" >> "$PREFS_FILE"
    fi
    if ! grep -q "user_pref(\"network.proxy.socks_port\"," "$PREFS_FILE"; then
        echo "$SOCKS_PORT" >> "$PREFS_FILE"
    fi
fi

firefox &

