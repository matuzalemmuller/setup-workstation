#!/bin/bash

# Color definition (ANSI)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}!!This script should be run in the local debian installation - it is NOT meant to set up a remote computer!!${NC}"

# Prompt user for username and password
username=$(whoami)
read -s -p "Sudo password (user must have root privileges): " password
echo

# Function to execute commands with sudo

sudo_exec() {
    echo "$password" | sudo -S "$@"
}

# Checking if password is valid
echo -e "\n${GREEN}Testing root password...${NC}"
if ! sudo_exec ls /root &>/dev/null; then
    echo -e "${YELLOW}Invalid root password!${NC}"
    exit 1
fi

# Check if this is the first time setting up the computer
if [[ ! -f /etc/first_time_setup ]]; then
    # cdrom entry breaks apt update
    echo -e "\n${GREEN}Removing cdrom entry from /etc/apt/sources.list${NC}"
    sudo_exec sed -i.bak '/cdrom/d' /etc/apt/sources.list
fi

# Install ansible if not already installed
if ! command -v ansible-playbook &>/dev/null; then
    echo -e "${GREEN}Updating package repository...${NC}"
    sudo_exec apt update

    # Install ansible
    echo -e "${GREEN}Installing prerequisites to run ansible...${NC}"
    sudo_exec apt install -y python3-pip pipx

    echo -e "${GREEN}Installing ansible...${NC}"
    pipx install --include-deps ansible
    pipx ensurepath --force
    export PATH=$PATH:/home/${username}/.local/bin
fi

# Run ansible playbook
echo -e "${GREEN}Running the playbook...${NC}"
if ! ansible-playbook playbook/setup-workstation.yml -e "ansible_sudo_pass=${password}" -e "username=${username}"; then
    exit 1
fi

# Complete/reboot
echo -ne "${GREEN}Setup complete! A reboot is required to the first time setup. Reboot now? (yes/[no])${NC}: "
read rbt

if [ "${rbt}" == "yes" ]; then
    echo ${password} | sudo -S reboot now
fi

echo -e "${YELLOW}If performing your first time setup: you can reboot later (sudo reboot now), but do NOT start XFCE!${NC}"
