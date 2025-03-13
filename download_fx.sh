#!/bin/bash

set -e # Exit if any command fails

# JavaFX Download URL
JAVAFX_URL="https://download2.gluonhq.com/openjfx/17.0.14/openjfx-17.0.14_linux-x64_bin-sdk.zip"

# Target Install Directory
INSTALL_DIR="$HOME/.local/java"
JAVAFX_ZIP="$INSTALL_DIR/javafx.zip"

# Create install directory
mkdir -p "$INSTALL_DIR"

echo "Downloading JavaFX 17.0.14..."
wget -q --show-progress "$JAVAFX_URL" -O "$JAVAFX_ZIP"

# Extract JavaFX
echo "Extracting JavaFX..."
unzip -q "$JAVAFX_ZIP" -d "$INSTALL_DIR"

# Cleanup
rm "$JAVAFX_ZIP"
