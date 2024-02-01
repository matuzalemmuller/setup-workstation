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
echo -ne "\nPerform first time setup? (yes/NO): "
read first_time_setup

if [ "$first_time_setup" != "yes" ]; then
    first_time_setup="no"
fi

# Checking if password is valid, need to be improved (but it won't be)
echo -e "\n${GREEN}Testing root password...${NC}"
echo $password | sudo -S ls /root
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo -e "${YELLOW}Invalid root password!${NC}"
    exit 1
fi

# cdrom entry breaks apt update
echo -e "\n${GREEN}Removing cdrom entry from /etc/apt/sources.list${NC}"
echo $passwd | sudo -S sed -i.bak '/cdrom/d' /etc/apt/sources.list

# Only install ansible if ansible-playbook command does not exist
if ! command -v ansible-playbook &> /dev/null
then
    echo -e "${GREEN}Updating package repository...${NC}"
    echo $password | sudo -S apt update

    # Install ansible
    echo -e "${GREEN}Installing prerequisites to run ansible...${NC}"
    echo $password | sudo -S apt install -y python3-pip pipx

    echo -e "${GREEN}Installing ansible...${NC}"
    pipx install --include-deps ansible

    # Add ansible PATH to .bashrc
    echo -e "${GREEN}Adding ansible to PATH...${NC}"
    pipx ensurepath

    # Add ansible to PATH for this script run
    export PATH=$PATH:/home/$username/.local/bin
fi

# Run ansible playbook
echo -e "${GREEN}Running the playbook...${NC}"
ansible-playbook playbook/setup-workstation.yml -e "ansible_sudo_pass=$password" -e "username=$username" -e "first_time_setup=$first_time_setup"

if [ $? -ne 0 ]; then
    exit 1
fi

# Complete/reboot
echo -e "${GREEN}Setup complete! A reboot is required to the first time setup. Reboot now? (y/N)${NC}"
read rbt

if [ "$rbt" == "y" ]; then
    echo $password | sudo -S reboot now
fi

echo -e "${YELLOW}If performing your first time setup: you can reboot later (sudo reboot now), but do NOT start XFCE!${NC}"

