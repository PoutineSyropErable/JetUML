#!/bin/bash

# Set installation directories
JAVA_DIR="$HOME/.local/java"
JDK_DIR="$JAVA_DIR/java23-openjdk"

# JetUML name and url, decomment if you want to redownload
# JETUML_JAR="$JAVA_DIR/JetUML-3.8.jar"
# JETUML_URL="https://github.com/prmr/JetUML/releases/download/v3.8/JetUML-3.8.jar"

function downloadJetUML() {
	# Download JetUML JAR
	echo "Downloading JetUML 3.8..."
	curl -L -o "$JETUML_JAR" "$JETUML_URL"

	if [[ $? -eq 0 ]]; then
		echo "JetUML 3.8 installed in $JETUML_JAR."
	else
		echo "Failed to download JetUML 3.8."
		exit 1
	fi
}

# decomment if you want to redownload it
# downloadJetUML()

mkdir -p "$JAVA_DIR"
mkdir -p "$JDK_DIR"

# Function to detect OS
detect_os() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		echo "Linux"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo "Mac"
	else
		echo "Unknown"
	fi
}

# Function to detect architecture
detect_arch() {
	ARCH=$(uname -m)
	case $ARCH in
	"x86_64") echo "x86_64" ;;
	"aarch64") echo "ARM64" ;;
	*) echo "Unknown" ;;
	esac
}

# Detect OS and architecture
OS=$(detect_os)
ARCH=$(detect_arch)

# If detection fails, prompt user
if [[ "$OS" == "Unknown" ]]; then
	echo "Failed to detect OS. Please select:"
	echo "1: Linux"
	echo "2: Mac"
	read -p "Enter choice (1 or 2): " OS_CHOICE
	case $OS_CHOICE in
	1) OS="Linux" ;;
	2) OS="Mac" ;;
	*)
		echo "Invalid choice. Exiting."
		exit 1
		;;
	esac
fi

if [[ "$ARCH" == "Unknown" ]]; then
	echo "Failed to detect CPU architecture. Please select:"
	echo "1: x86_64 (Intel/AMD)"
	echo "2: ARM64 (Apple Silicon, ARM CPUs)"
	read -p "Enter choice (1 or 2): " ARCH_CHOICE
	case $ARCH_CHOICE in
	1) ARCH="x86_64" ;;
	2) ARCH="ARM64" ;;
	*)
		echo "Invalid choice. Exiting."
		exit 1
		;;
	esac
fi

printf "\nUsing OS: $OS, Using CPU architecture: $ARCH\n\n"

# Define JavaFX URLs
declare -A JAVAFX_URLS=(
	["Linux_x86_64"]="https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_linux-x64_bin-sdk.zip"
	["Linux_ARM64"]="https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_linux-aarch64_bin-sdk.zip"
	["Mac_x86_64"]="https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_osx-x64_bin-sdk.zip"
	["Mac_ARM64"]="https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_osx-aarch64_bin-sdk.zip"
)

# Define OpenJDK URLs (from download.java.net)
declare -A JDK_URLS=(
	["Linux_x86_64"]="https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz"
	["Linux_ARM64"]="https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-aarch64_bin.tar.gz"
	["Mac_ARM64"]="https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-aarch64_bin.tar.gz"
	["Mac_x86_64"]="https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-x64_bin.tar.gz"
)

# Getting unzip so it can work:
unzip -v || {
	echo "unzip not found. Installing..."
	sudo apt install -y unzip || sudo pacman -S unzip || sudo dnf install -y unzip || sudo apk add unzip || brew install unzip
}

# Download JavaFX (goes in ~/.local/java)
JAVAFX_URL=${JAVAFX_URLS["${OS}_${ARCH}"]}
if [[ -n "$JAVAFX_URL" ]]; then
	FILE_NAME="${JAVAFX_URL##*/}"
	FILE_PATH="$JAVA_DIR/$FILE_NAME"

	echo "Downloading JavaFX 23.0.2 for $OS ($ARCH)..."
	curl -L -o "$FILE_PATH" "$JAVAFX_URL"

	if ! unzip -tq "$FILE_PATH"; then
		echo "Error: JavaFX archive is invalid. Exiting."
		rm "$FILE_PATH"
		exit 1
	fi

	echo "Extracting JavaFX..."
	unzip -q "$FILE_PATH" -d "$JAVA_DIR"
	rm "$FILE_PATH"
	echo "JavaFX installed in $JAVA_DIR."
else
	echo "No JavaFX download available for $OS ($ARCH)."
fi

# Download OpenJDK (goes in ~/.local/java/java23-openjdk)
JDK_URL=${JDK_URLS["${OS}_${ARCH}"]}
if [[ -n "$JDK_URL" ]]; then
	FILE_NAME="${JDK_URL##*/}"
	FILE_PATH="$JDK_DIR/$FILE_NAME"

	echo "Downloading OpenJDK 23 for $OS ($ARCH)..."
	curl -L -o "$FILE_PATH" "$JDK_URL"

	if [[ $FILE_NAME == *.tar.gz ]]; then
		echo "Extracting OpenJDK..."
		mkdir -p "$JDK_DIR"
		tar -xzf "$FILE_PATH" -C "$JDK_DIR" --strip-components=1
		rm "$FILE_PATH"
	else
		echo "Download failed or file format incorrect."
		exit 1
	fi

	echo "OpenJDK installed in $JDK_DIR."
else
	echo "No OpenJDK download available for $OS ($ARCH)."
fi

# Cleanup any leftover zip/tar files
echo "Cleaning up temporary files..."
rm -f "$JAVA_DIR"/*.zip
rm -f "$JDK_DIR"/*.tar.gz

echo "Installation complete!"
echo "JavaFX installed in: $JAVA_DIR"
echo "OpenJDK installed in: $JDK_DIR"
echo "JetUML installed in: $JETUML_JAR"
