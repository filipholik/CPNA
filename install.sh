# !/bin/bash
# Script for the COCOON Programmable Node (CPN) installation
# University of Glasgow, 2025 

#!/bin/bash

# Configuration
CPN_REPO_URL="https://raw.githubusercontent.com/filipholik/CPNA/main/CPN_Compiled_250829.zip"
TARGET_DIR="$HOME/CPN"
FILE_NAME="CPN_Compiled_250829.zip"

spin() {
    local pid=$1
    local message=$2
    local -a marks=('/' '-' '\' '|')
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r%s %s" "$message" "${marks[i]}"
        sleep 0.2
    done
    printf "\r%s Done!    \n" "$message"
}

progress_bar() {
    local duration=$1
    local interval=0.1
    local ticks=0

    # Calculate total ticks using bc for float division
    local total_ticks=$(echo "$duration / $interval" | bc)

    while [ $ticks -le $total_ticks ]; do
        # Calculate percent using bc
        percent=$(echo "scale=0; $ticks * 100 / $total_ticks" | bc)
        filled=$(( percent / 2 ))
        empty=$(( 50 - filled ))

        bar=$(printf "%${filled}s" | tr ' ' '#')
        spaces=$(printf "%${empty}s")

        printf "\r[%s%s] %d%%" "$bar" "$spaces" "$percent"

        sleep $interval
        ticks=$((ticks + 1))
    done
    echo
    #echo -e "\nDone!"
}

# Installation of pre-requisites 
echo "Installing the pre-requisites..."
sudo apt install git

# Create destination directory if it doesn't exist
echo "Creating the target directory..."
mkdir -p "$TARGET_DIR"

# File download
echo "Downloading $CPN_REPO_URL to $TARGET_DIR..."
curl -L "$CPN_REPO_URL" -o "$TARGET_DIR/$FILE_NAME"

if [ $? -eq 0 ]; then
    echo "Download complete: $TARGET_DIR/$FILE_NAME"

    # Unzip the file
    echo "Unzipping the file..."
    unzip "$TARGET_DIR/$FILE_NAME" -d "$TARGET_DIR"

    if [ $? -eq 0 ]; then
        echo "✅ Unzip complete!"
    else
        echo "❌ Failed to unzip."
    fi
else
    echo "Download failed."
    exit 1
fi

# Opening the file
