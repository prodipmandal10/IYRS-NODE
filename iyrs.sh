#!/bin/bash

# --- Colors ---
RESET="\e[0m"
PINK="\e[95m"
CYAN="\e[36m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BOLD='\033[1m'

# --- Global variables ---
CONFIG_FILE="$HOME/.iyrs_config"
UPLOADED_FILE_LIST="$HOME/.iyrs_uploaded_files"
PRIVATE_KEY=""
RPC_URL=""
WALLET_ADDRESS=""

# --- Load saved config ---
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
}

# --- Save config ---
save_config() {
    echo "PRIVATE_KEY=$PRIVATE_KEY" > "$CONFIG_FILE"
    echo "RPC_URL=$RPC_URL" >> "$CONFIG_FILE"
    echo "WALLET_ADDRESS=$WALLET_ADDRESS" >> "$CONFIG_FILE"
}

# --- Header ---
print_header() {
    clear
    echo -e "${YELLOW}${BOLD}=====================================================${RESET}"
    echo -e "${YELLOW}${BOLD} # # # # # 🌟 IYRS NODERUN 🌟 # # # # #${RESET}"
    echo -e "${YELLOW}${BOLD} # # # # # # MADE BY PRODIP # # # # # #${RESET}"
    echo -e "${YELLOW}${BOLD}=====================================================${RESET}"
    echo -e "${CYAN}🌐 Twitter: https://x.com/prodipmandal10${RESET}"
    echo -e "${CYAN}📩 Telegram: @prodipgo${RESET}"
    echo ""
}

# --- Generate random JPG (~8 KB) ---
generate_random_jpg() {
    RAND_NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8).jpg
    if convert -size 100x100 xc:gray -depth 8 "$RAND_NAME" &> /dev/null; then
        echo "$RAND_NAME"
        return 0
    else
        echo ""
        return 1
    fi
}

# --- Load existing config ---
load_config

# --- Main menu loop ---
while true; do
    print_header
    echo -e "${YELLOW}${BOLD}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}${BOLD}║      🔵 BENGAL AIRDROP IYRS MENU 🔵     ║${RESET}"
    echo -e "${YELLOW}${BOLD}╠══════════════════════════════════════════════╣${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}1${RESET}${BOLD}] ${PINK}📦 Install Dependencies & Irys CLI         ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}2${RESET}${BOLD}] ${PINK}⚙️ Setup Config (Private Key / RPC / Wallet)${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}3${RESET}${BOLD}] ${PINK}🔄 Change Config (RPC / Key / Wallet)      ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}4${RESET}${BOLD}] ${PINK}💰 Fund Wallet (Devnet)                    ${YELLOW}${BOLD} ║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}5${RESET}${BOLD}] ${PINK}🔍 Check Wallet Balance                    ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}6${RESET}${BOLD}] ${PINK}⬆️ Upload File (Manual)                    ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}7${RESET}${BOLD}] ${PINK}🔄 Auto-generate & Upload Random JPG      ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}8${RESET}${BOLD}] ${PINK}📜 View Uploaded Files                     ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}║ [${YELLOW}0${RESET}${BOLD}] ${PINK}👋 Exit Script                             ${YELLOW}${BOLD}║${RESET}"
    echo -e "${YELLOW}${BOLD}╚══════════════════════════════════════════════╝${RESET}"
    echo ""
    
    read -p "${PINK}👉 Select an option: ${RESET}" choice
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
            echo -e "${CYAN}>>> Node version: $(node -v)${RESET}"
            echo -e "${CYAN}>>> NPM version: $(npm -v)${RESET}"
            echo -e "${CYAN}>>> Installing Irys CLI...${RESET}"
            if sudo npm i -g @irys/cli; then
                echo -e "${GREEN}>>> Irys installed! Test with: irys${RESET}"
            else
                echo -e "${RED}❌ Irys CLI installation failed!${RESET}"
            fi
            read -p "Press Enter to return to menu..."
            ;;
        2)
            echo -e "${YELLOW}⚠️  Enter your PRIVATE KEY WITHOUT 0x ⚠️${RESET}"
            read -p "Private Key: " PRIVATE_KEY
            read -p "Enter RPC URL: " RPC_URL
            read -p "Enter Wallet Address: " WALLET_ADDRESS
            save_config
            echo -e "${GREEN}✅ Config saved successfully!${RESET}"
            read -p "Press Enter to return to menu..."
            ;;
        3)
            echo -e "${CYAN}>>> Current saved config:${RESET}"
            echo "PRIVATE_KEY: ${PRIVATE_KEY:0:4}************ (hidden)"
            echo "RPC_URL: $RPC_URL"
            echo "WALLET_ADDRESS: $WALLET_ADDRESS"
            echo ""
            read -p "Change Private Key? (y/n): " CH_PK
            if [[ "$CH_PK" == "y" ]]; then
                read -p "Enter new PRIVATE KEY (without 0x): " PRIVATE_KEY
            fi
            read -p "Change RPC URL? (y/n): " CH_RPC
            if [[ "$CH_RPC" == "y" ]]; then
                read -p "Enter new RPC URL: " RPC_URL
            fi
            read -p "Change Wallet Address? (y/n): " CH_WALLET
            if [[ "$CH_WALLET" == "y" ]]; then
                read -p "Enter new Wallet Address: " WALLET_ADDRESS
            fi
            save_config
            echo -e "${GREEN}✅ Config updated successfully!${RESET}"
            read -p "Press Enter to return to menu..."
            ;;
        4)
            echo -e "${CYAN}>>> Funding wallet...${RESET}"
            if ! irys fund 1000000 -n devnet -t ethereum -w "$PRIVATE_KEY" --provider-url "$RPC_URL"; then
                echo -e "${RED}❌ Funding failed! Check your Private Key or RPC URL.${RESET}"
            fi
            read -p "Press Enter to return to menu..."
            ;;
        5)
            echo -e "${CYAN}>>> Checking wallet balance...${RESET}"
            if ! irys balance "$WALLET_ADDRESS" -t ethereum -n devnet --provider-url "$RPC_URL"; then
                echo -e "${RED}⚠️ Balance check failed!${RESET}"
            fi
            read -p "Press Enter to return to menu..."
            ;;
        6)
            read -p "Enter filename to upload: " UPLOAD_FILE
            if [ ! -f "$UPLOAD_FILE" ]; then
                echo -e "${RED}❌ File not found: $UPLOAD_FILE${RESET}"
            else
                echo -e "${CYAN}>>> Uploading file: $UPLOAD_FILE ${RESET}"
                UPLOAD_URL=$(irys upload "$UPLOAD_FILE" -n devnet -t ethereum -w "$PRIVATE_KEY" \
                             --tags name="$UPLOAD_FILE" format=image/jpeg --provider-url "$RPC_URL" 2>/dev/null | grep -o 'https://gateway.irys.xyz/[^ ]*')
                if [ -n "$UPLOAD_URL" ]; then
                    echo -e "${GREEN}✅ Upload successful! URL: $UPLOAD_URL${RESET}"
                    echo "$UPLOAD_URL" >> "$UPLOADED_FILE_LIST"
                else
                    echo -e "${RED}❌ Upload failed!${RESET}"
                fi
            fi
            read -p "Press Enter to return to menu..."
            ;;
        7)
            echo -e "${CYAN}>>> Generating random JPG (~8 KB) and uploading...${RESET}"
            RANDOM_FILE=$(generate_random_jpg)
            if [ -z "$RANDOM_FILE" ]; then
                echo -e "${RED}❌ File generation failed.${RESET}"
            else
                UPLOAD_URL=$(irys upload "$RANDOM_FILE" -n devnet -t ethereum -w "$PRIVATE_KEY" \
                             --tags name="$RANDOM_FILE" format=image/jpeg --provider-url "$RPC_URL" 2>/dev/null | grep -o 'https://gateway.irys.xyz/[^ ]*')
                if [ -n "$UPLOAD_URL" ]; then
                    echo -e "${GREEN}✅ Upload successful! URL: $UPLOAD_URL${RESET}"
                    echo "$UPLOAD_URL" >> "$UPLOADED_FILE_LIST"
                else
                    echo -e "${RED}❌ Upload failed!${RESET}"
                fi
                rm -f "$RANDOM_FILE"
            fi
            read -p "Press Enter to return to menu..."
            ;;
        8)
            echo -e "${CYAN}>>> Uploaded Files List:${RESET}"
            if [ -f "$UPLOADED_FILE_LIST" ]; then
                nl -w2 -s'. ' "$UPLOADED_FILE_LIST"
            else
                echo "No files uploaded yet."
            fi
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
done
