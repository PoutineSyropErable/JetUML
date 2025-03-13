#!/bin/bash

set -e # Exit on error

# Define OS and Architecture for Arch Linux x86_64
OS="linux"
ARCH="x64"
BASE_URL="https://api.adoptium.net/v3/assets/latest/17/hotspot"

# Fetch latest OpenJDK 17 URL
echo "Fetching latest OpenJDK 17 URL for Arch Linux x86_64..."
JDK_URL=$(curl -s "$BASE_URL?os=$OS&architecture=$ARCH&heap_size=normal&image_type=jdk" | jq -r '.[0].binary.package.link')

if [[ -z "$JDK_URL" ]]; then
	echo "\u274c Failed to get JDK download URL. Exiting."
	exit 1
fi

# Define download location
DOWNLOAD_DIR="$HOME/jdk_downloads"
INSTALL_DIR="$HOME/.local/java/java-17-openjdk/"
FILE_NAME="openjdk-17.tar.gz"
mkdir -p "$DOWNLOAD_DIR"

# Download OpenJDK
echo "Downloading OpenJDK 17 from: $JDK_URL"
wget -q --show-progress "$JDK_URL" -O "$DOWNLOAD_DIR/$FILE_NAME"

# Extract and Install
echo "Extracting OpenJDK 17..."
mkdir -p "$INSTALL_DIR"
tar -xzf "$DOWNLOAD_DIR/$FILE_NAME" -C "$INSTALL_DIR" --strip-components=1
