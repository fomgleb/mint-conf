sudo apt -y update
sudo apt upgrade -y

# Install Vim
sudo apt install vim

# Install Mission Center (windows-like task manager)
sudo flatpak install -y io.missioncenter.MissionCenter

# Install VSCode
wget --output-document=vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install -y ./vscode.deb
rm -f ./vscode.deb

# Install Obsidian (notes editor)
wget --output-document=obsidian.deb "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb"
sudo apt install -y ./obsidian.deb
rm -f ./obsidian.deb

# Install Telegram (messenger)
wget --output-document=telegram.tar.xz "https://telegram.org/dl/desktop/linux"
sudo tar -xf telegram.tar.xz -C /usr/local
rm -f ./telegram.tar.xz
/usr/local/Telegram/Telegram

# Install Microsoft Edge (browser)
wget --output-document=microsoft-edge.deb "https://go.microsoft.com/fwlink?linkid=2149051&brand=M102"
sudo apt install -y ./microsoft-edge.deb
rm -f ./microsoft-edge.deb

# Install Diodon (clipboard manager)
sudo apt install diodon
diodon &

# Install Slimbook Battery (power manager)
sudo add-apt-repository ppa:slimbook/slimbook
sudo apt install slimbookbattery

# Install GitHub CLI
sudo apt install gh

#Install GitLab CLI
curl -s https://raw.githubusercontent.com/profclems/glab/trunk/scripts/install.sh | sudo bash

