#!/bin/bash

set -euo pipefail

# Set installation directories
JAVA_DIR="$HOME/.local/java"
JDK_DIR="$JAVA_DIR/java-23-openjdk"
mkdir -p "$JAVA_DIR"
mkdir -p "$JDK_DIR"

# Hardcoded URLs for Mac ARM64
JAVAFX_URL="https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_osx-aarch64_bin-sdk.zip"
JDK_URL="https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-aarch64_bin.tar.gz"

echo "✅ JavaFX URL: $JAVAFX_URL"
echo "✅ JDK URL: $JDK_URL"

# Download and install JavaFX
FILE_NAME="${JAVAFX_URL##*/}"
FILE_PATH="$JAVA_DIR/$FILE_NAME"
echo "Downloading JavaFX..."
curl -L -o "$FILE_PATH" "$JAVAFX_URL"

echo "Extracting JavaFX..."
unzip -q "$FILE_PATH" -d "$JAVA_DIR"
rm "$FILE_PATH"

# Download and install OpenJDK
FILE_NAME="${JDK_URL##*/}"
FILE_PATH="$JDK_DIR/$FILE_NAME"
echo "Downloading OpenJDK..."
curl -L -o "$FILE_PATH" "$JDK_URL"

echo "Extracting OpenJDK..."
tar -xzf "$FILE_PATH" -C "$JDK_DIR" --strip-components=1
rm "$FILE_PATH"

echo "✅ Installation complete for Mac Apple Silicon!"

echo ""
ls
echo ""
"

