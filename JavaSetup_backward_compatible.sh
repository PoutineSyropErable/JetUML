#!/bin/bash

set -euo pipefail # Enable strict error handling
# This will cause exit if any command fails, like with regular programming language

# Set installation directories
JAVA_DIR="$HOME/.local/java"
JDK_DIR="$JAVA_DIR/java-23-openjdk"
mkdir -p "$JAVA_DIR"
mkdir -p "$JDK_DIR"

# JetUML file name and url
JETUML_JAR="$JAVA_DIR/JetUML-3.8.jar"
JETUML_URL="https://github.com/prmr/JetUML/releases/download/v3.8/JetUML-3.8.jar"

OS_ARCHS=("Linux_x86_64" "Linux_ARM64" "Mac_x86_64" "Mac_ARM64")
JDK_URLS=(
	"https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz"
	"https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-aarch64_bin.tar.gz"
	"https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-x64_bin.tar.gz"
	"https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_macos-aarch64_bin.tar.gz"
)
JAVAFX_URLS=(
	"https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_linux-x64_bin-sdk.zip"
	"https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_linux-aarch64_bin-sdk.zip"
	"https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_osx-x64_bin-sdk.zip"
	"https://download2.gluonhq.com/openjfx/23.0.2/openjfx-23.0.2_osx-aarch64_bin-sdk.zip"
)

#--------------------------------- Ensure programs are installed ----------------------
# Ensure curl is installed
curl --version &>/dev/null || {
	echo "curl not found. Installing..."
	sudo apt install -y curl 2>/dev/null ||
		sudo pacman -S curl 2>/dev/null ||
		sudo dnf install -y curl 2>/dev/null ||
		sudo apk add curl 2>/dev/null ||
		brew install curl 2>/dev/null || {
		echo "can't get curl"
		exit 1
	}
}

echo ""
echo "Curl is installed."
echo ""

# Ensure unzip is installed
unzip -v &>/dev/null || {
	echo "unzip not found. Installing..."
	sudo apt install -y unzip 2>/dev/null ||
		sudo pacman -S unzip 2>/dev/null ||
		sudo dnf install -y unzip 2>/dev/null ||
		sudo apk add unzip 2>/dev/null ||
		brew install unzip 2>/dev/null || {
		echo "can't get unzip"
		exit 1
	}
}

echo ""
echo "Unzip is installed."
echo ""

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

#-------- -------------------------- detecting os and cpu architecture -----------------------------
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
	"aarch64" | "arm64") echo "ARM64" ;;
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

#-------------------------------------------------------- GETTING THE URL FOR EACH ARCHITECTURE ----------------------
# Detect OS and architecture
OS_ARCH="${OS}_${ARCH}"

# Function to print available keys in an associative array
print_available_keys() {
	local -n array=$1 # Use nameref to pass an associative array by reference
	echo "Available keys in $2:"
	for key in "${!array[@]}"; do
		echo "  - $key → ${array[$key]}"
	done
	echo ""
}

# Function to look up a URL based on OS_ARCH and a given URL array name
get_url() {
	local target_os_arch="$1"
	local array_name="$2" # Name of the URL array, e.g., "JDK_URLS" or "JAVAFX_URLS"
	local index=-1
	local i

	# Loop over OS_ARCHS to find the index that matches target_os_arch
	for i in "${!OS_ARCHS[@]}"; do
		if [ "${OS_ARCHS[$i]}" = "$target_os_arch" ]; then
			index=$i
			break
		fi
	done

	if [ $index -eq -1 ]; then
		echo "Error: OS_ARCH '$target_os_arch' not found." >&2
		return 1
	fi

	# Indirectly access the URL from the array specified by array_name
	local url
	eval "url=\${${array_name}[$index]}"
	echo "$url"
}

# Debugging: Check for JavaFX URL
echo -e "\n🔍 Debugging: Looking for key '${OS_ARCH}' in JAVAFX_URLS\n"
print_available_keys JAVAFX_URLS "JAVAFX_URLS"

if [[ -v JAVAFX_URLS[$OS_ARCH] ]]; then
	JAVAFX_URL=$(get_url "$OS_ARCH" "JAVAFX_URLS")
else
	echo "❌ Error: No JavaFX URL found for '${OS_ARCH}'."
	exit 1
fi

# Debugging: Check for JDK URL
echo -e "\n🔍 Debugging: Looking for key '${OS_ARCH}' in JDK_URLS\n"
print_available_keys JDK_URLS "JDK_URLS"

if [[ -v JDK_URLS[$OS_ARCH] ]]; then
	JDK_URL=$(get_url "$OS_ARCH" "JDK_URLS")
else
	echo "❌ Error: No JDK URL found for '${OS_ARCH}'."
	exit 1
fi

# Print final results
echo -e "\n✅ JavaFX URL: $JAVAFX_URL"
echo "✅ JDK URL: $JDK_URL"
echo -e "\n🎉 All URLs successfully retrieved!\n"

#------------------------------------------- DOWNLOAD JAVA JDKS and JAVAFX -------------------

if [[ -n "$JAVAFX_URL" ]]; then
	FILE_NAME="${JAVAFX_URL##*/}"
	FILE_PATH="$JAVA_DIR/$FILE_NAME"

	echo ""
	echo "Downloading JavaFX 23.0.2 for $OS ($ARCH)..."
	curl -L -o "$FILE_PATH" "$JAVAFX_URL"

	if ! unzip -tq "$FILE_PATH"; then
		echo "Error: JavaFX archive is invalid. Exiting."
		rm "$FILE_PATH"
		exit 1
	fi

	echo ""
	echo "Extracting JavaFX..."
	echo ""
	unzip -q "$FILE_PATH" -d "$JAVA_DIR"
	rm "$FILE_PATH"
	echo "JavaFX installed in $JAVA_DIR."
else
	echo "No JavaFX download available for $OS ($ARCH)."
fi

if [[ -n "$JDK_URL" ]]; then
	FILE_NAME="${JDK_URL##*/}"
	FILE_PATH="$JDK_DIR/$FILE_NAME"

	echo ""
	echo "Downloading OpenJDK 23 for $OS ($ARCH)..."
	curl -L -o "$FILE_PATH" "$JDK_URL"

	if [[ $FILE_NAME == *.tar.gz ]]; then
		echo ""
		echo "Extracting OpenJDK..."
		echo ""
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

#------------------------------------------------- CLEANUP AND END STUFF

# Cleanup any leftover zip/tar files
echo "Cleaning up temporary files..."
rm -f "$JAVA_DIR"/*.zip
rm -f "$JDK_DIR"/*.tar.gz

echo "Installation complete!"
echo "JavaFX installed in: $JAVA_DIR"
echo "OpenJDK installed in: $JDK_DIR"
echo "JetUML installed in: $JETUML_JAR"

echo ""
ls
echo ""
