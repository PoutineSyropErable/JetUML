#!/bin/bash

# Detect the user's shell
detect_shell() {
	case "$SHELL" in
	*/bash) echo "bash" ;;
	*/zsh) echo "zsh" ;;
	*/fish) echo "fish" ;;
	*) echo "unknown" ;;
	esac
}

# Get the shell name
USER_SHELL=$(detect_shell)
CONFIG_FILE=""

# Set the correct config file
case "$USER_SHELL" in
"bash") CONFIG_FILE="$HOME/.bashrc" ;;
"zsh") CONFIG_FILE="$HOME/.zshrc" ;;
"fish") CONFIG_FILE="$HOME/.config/fish/config.fish" ;;
"unknown")
	echo "Unsupported shell: $SHELL"
	exit 1
	;;
esac

echo "Detected shell: $USER_SHELL"
echo "Modifying: $CONFIG_FILE"

# Define the environment variables to append
ENV_VARS="
# Java Environment Setup
export PATH=\"\$HOME/.local/java:\$PATH\"

# Set Java Home
export JAVA_HOME=\"\$HOME/.local/java/java-23-openjdk\"

# Add Java binaries to PATH
export PATH=\"\$JAVA_HOME/bin:\$PATH\"

# Set JavaFX module path
export PATH_TO_FX=\"\$HOME/.local/java/javafx-sdk-23/lib\"

# Add JavaFX binaries to PATH (optional, but helps some setups)
export PATH=\"\$PATH_TO_FX:\$PATH\"
"

# Append environment variables if not already present
if ! grep -q "export JAVA_HOME=" "$CONFIG_FILE"; then
	echo "$ENV_VARS" >>"$CONFIG_FILE"
	echo "Environment variables added to $CONFIG_FILE."
else
	echo "Java environment variables already exist in $CONFIG_FILE."
fi

# Source the file to apply changes immediately
if [[ "$USER_SHELL" == "fish" ]]; then
	source "$CONFIG_FILE" >/dev/null 2>&1
else
	source "$CONFIG_FILE"
fi

echo "Setup complete. Restart your terminal or run 'source $CONFIG_FILE' to apply changes."
