#!/bin/bash

# If the issue https://github.com/linuxmint/cinnamon/issues/11198 is resolved then this script isn't needed

# Instal reqired package
sudo apt install -y inputplug

# Create needed bash script
mkdir -p /home/fomgleb/.local/bin
cat << 'EOF' > ~/.local/bin/input-plug.sh
#!/bin/bash

if [[ "$1" == "XIDeviceEnabled" && "$3" == "XISlaveKeyboard" ]]; then
	output=$(xset q | grep "repeat rate")
	delay=$(echo $output | awk '{print $4}')
	rate=$(echo $output | awk '{print $7}')

	xset r rate $delay $rate
fi

EOF
chmod +x ~/.local/bin/input-plug.sh

# Run the command
inputplug --command ~/.local/bin/input-plug.sh

# Run the command on startup
LINE="inputplug --command /home/$USER/.local/bin/input-plug.sh &"
if [ ! -f ~/.xprofile ]; then
    touch ~/.xprofile
fi
if ! grep -Fxq "$LINE" ~/.xprofile; then
    echo "$LINE" >> ~/.xprofile
fi

echo "Disable and enable the \"Key repeat\" setting (System Settings -> Keyboard -> Typing)"

