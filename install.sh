# !/bin/bash
# Script for the COCOON Programmable Node (CPN) installation
# University of Glasgow, 2025 

#!/bin/bash

# Configuration
CPN_REPO_URL="https://raw.githubusercontent.com/filipholik/CPNA/main/CPN.zip"
FILE_NAME="CPN.zip"
TARGET_DIR="$HOME/CPN"

# Installation of pre-requisites 
echo "Installing the pre-requisites..."
sudo apt install git build-essential gcc-multilib protobuf-compiler protobuf-c-compiler libprotobuf-c-dev libprotobuf-dev clang-14 git python3-protobuf python3-twisted clang
#sudo apt install pkg-config meson ninja-build python3-pyelftools libnuma-dev libpcap-dev libbpf-dev 
# Missing: libclang

echo "✅ Installation of the pre-requisites completed..."

# Create destination directory if it doesn't exist
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Target directory exists. Deleting: $TARGET_DIR"
    rm -rf "$TARGET_DIR"
fi
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
        # Delete the zip file
        rm "$TARGET_DIR/$FILE_NAME"
        echo "🗑️  Cleaning up... "
        echo "✅ Installation complete!"
    else
        echo "❌ Failed to unzip."
    fi
else
    echo "Download failed."
    exit 1
fi