#!/bin/bash

# Color definition (ANSI)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}!!This script should be run in your local debian installation - it is NOT meant to set up a remote computer!!${NC}"

# Prompt user for username and password
echo -n "Username: "
read username
echo -n "Password (your user must have root privileges): "
read -s password

echo -e "\n${GREEN}Installing prerequisites to run ansible...${NC}"
echo $password | sudo -S apt install -y python3-pip pipx

echo -e "${GREEN}Installing ansible...${NC}"
pipx install --include-deps ansible

# Add ansible PATH to .bashrc
echo -e "${GREEN}Adding ansible to PATH...${NC}"
pipx ensurepath

# Add ansible to PATH for this script run
export PATH=$PATH:/home/$username/.local/bin

echo -e "${GREEN}Running the playbook...${NC}"
ansible-playbook playbook/setup-workstation.yml -e "ansible_sudo_pass=$password" -e "username=$username"

if [ $? -ne 0 ]; then
    exit 1
fi

echo -e "${GREEN}Setup complete! A reboot is required to complete the installation. Reboot now? (y/n)${NC}"
read rbt

if [ "$rbt" == "y" ]; then
    echo $password | sudo reboot now
fi

echo -e "${GREEN}You can reboot later: sudo reboot now${NC}"

