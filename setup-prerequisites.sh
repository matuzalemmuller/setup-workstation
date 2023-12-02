#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Installing prerequisites to run ansible...${NC}"
sudo apt install -y python3-pip pipx

echo -e "${GREEN}Installing ansible...${NC}"
pipx install --include-deps ansible

echo -e "${GREEN}Adding ansible to PATH${NC}"
pipx ensurepath
