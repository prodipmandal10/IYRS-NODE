#!/bin/bash

# Colors
RESET="\e[0m"
PINK="\e[95m"
CYAN="\e[36m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"

# Global variables
PRIVATE_KEY=""
RPC_URL=""
WALLET_ADDRESS=""
UPLOAD_FILE="my.jpg"

# Function to auto-generate random jpg (~8 KB)
generate_random_jpg() {
    RAND_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8).jpg
    convert -size 100x100 xc:gray -depth 8 $RAND_NAME
    echo $RAND_NAME
}

menu() {
  clear
  echo -e "${CYAN}=========================================================${RESET}"
  echo -e "${YELLOW}   🌟 IYRS NODERUN MADE BY BENGAL AIRDROP (@prodipgo, tg) 🌟${RESET}"
  echo -e "${CYAN}=========================================================${RESET}"
  echo ""
  echo -e "${PINK}1️⃣  Install Dependencies & Irys CLI${RESET}"
  echo -e "${PINK}2️⃣  Fund Wallet (Devnet)${RESET}"
  echo -e "${GREEN}3️⃣  Check Wallet Balance${RESET}"
  echo -e "${GREEN}4️⃣  Upload File (Manual)${RESET}"
  echo -e "${CYAN}5️⃣  Auto-generate & Upload Random JPG${RESET}"
  echo -e "${RED}0️⃣  Exit${RESET}"   # Exit button at the end
  echo ""
  read -p "Select an option: " choice

  case $choice in
    1)
      echo -e "${CYAN}>>> Updating system & installing dependencies...${RESET}"
      sudo apt-get update && sudo apt-get upgrade -y
      sudo apt install -y curl iptables build-essential git wget lz4 jq make \
        protobuf-compiler cmake gcc nano automake autoconf tmux htop nvme-cli \
        libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils \
        ncdu unzip screen ufw imagemagick
      echo -e "${CYAN}>>> Installing Node.js 20...${RESET}"
      curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
      sudo apt install -y nodejs
      echo -e "${CYAN}>>> Node version:${RESET}"
      node -v
      echo -e "${CYAN}>>> NPM version:${RESET}"
      npm -v
      echo -e "${CYAN}>>> Installing Irys CLI...${RESET}"
      sudo npm i -g @irys/cli
      echo -e "${GREEN}>>> Irys installed! Test with: irys${RESET}"
      read -p "Press Enter to return to menu..."
      ;;
    2)
      # Fund Wallet
      echo -e "${YELLOW}⚠️  Enter your PRIVATE KEY WITHOUT 0x ⚠️${RESET}"
      read -p "Private Key: " PK_INPUT
      PRIVATE_KEY="$PK_INPUT"
      read -p "Enter RPC URL: " RPC_URL
      echo -e "${CYAN}>>> Funding wallet...${RESET}"
      irys fund 1000000 -n devnet -t ethereum -w $PRIVATE_KEY --provider-url $RPC_URL
      read -p "Press Enter to return to menu..."
      ;;
    3)
      # Check balance
      read -p "Enter Wallet Address: " WALLET_ADDRESS
      if [ -z "$RPC_URL" ]; then
          read -p "Enter RPC URL (was not set yet): " RPC_URL
      fi
      echo -e "${CYAN}>>> Checking wallet balance...${RESET}"
      if ! irys balance $WALLET_ADDRESS -t ethereum -n devnet --provider-url $RPC_URL; then
          echo -e "${RED}⚠️  Balance check failed! Please check RPC or Wallet Address.${RESET}"
      fi
      read -p "Press Enter to return to menu..."
      ;;
    4)
      # Manual upload
      read -p "Enter filename to upload: " UPLOAD_FILE
      echo -e "${CYAN}>>> Uploading file: $UPLOAD_FILE ${RESET}"
      irys upload $UPLOAD_FILE -n devnet -t ethereum -w $PRIVATE_KEY --tags name=$UPLOAD_FILE format=image/jpeg --provider-url $RPC_URL
      read -p "Press Enter to return to menu..."
      ;;
    5)
      # Auto-generate random jpg
      echo -e "${CYAN}>>> Generating random JPG (~8 KB) and uploading...${RESET}"
      RANDOM_FILE=$(generate_random_jpg)
      echo -e "${GREEN}Generated file: $RANDOM_FILE${RESET}"
      irys upload $RANDOM_FILE -n devnet -t ethereum -w $PRIVATE_KEY --tags name=$RANDOM_FILE format=image/jpeg --provider-url $RPC_URL
      read -p "Press Enter to return to menu..."
      ;;
    0)
      echo -e "${RED}Exiting... Goodbye! 👋${RESET}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option!${RESET}"
      read -p "Press Enter to return to menu..."
      ;;
  esac
}

while true; do
  menu
done
