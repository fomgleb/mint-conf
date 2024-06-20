#!/bin/bash

# Install required packages
sudo apt install -y wget git

# Install zsh if not installed
if [ "$(echo $SHELL)" == "/bin/bash" ]; then
	sudo apt install -y zsh
	sudo chsh -s $(which zsh)
	echo "Logout and then login to set up zsh"
	exit 0
fi

# Install ohmyzsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set zsh theme to `philips`
sed -i 's/RSH_THEME="[^"]*"/RSH_THEME="philips"/' ~/.zshrc

