#!/bin/bash

# Set paths
APP_NAME="JetUML"
APP_DIR="$HOME/Applications/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
WRAPPER_SCRIPT="$HOME/.local/java/JetUML"
ICON_SOURCE="$HOME/.local/java/jet.png"
ICON_DEST="$RESOURCES_DIR/jet.png"
PLIST_FILE="$CONTENTS_DIR/Info.plist"

# Ensure necessary directories exist
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy the JetUML wrapper script
if [[ -f "$WRAPPER_SCRIPT" ]]; then
    cp "$WRAPPER_SCRIPT" "$MACOS_DIR/JetUML"
    chmod +x "$MACOS_DIR/JetUML"
else
    echo "Error: JetUML wrapper script not found at $WRAPPER_SCRIPT"
    exit 1
fi

# Copy the icon if it exists
if [[ -f "$ICON_SOURCE" ]]; then
    cp "$ICON_SOURCE" "$ICON_DEST"
else
    echo "Warning: Icon not found at $ICON_SOURCE. The app will have no icon."
fi

# Create the Info.plist file
cat > "$PLIST_FILE" <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.jetuml.app</string>
    <key>CFBundleVersion</key>
    <string>3.8</string>
    <key>CFBundleExecutable</key>
    <string>JetUML</string>
    <key>CFBundleIconFile</key>
    <string>jet.png</string>
</dict>
</plist>
EOL

# Final message
echo "JetUML macOS launcher created at $APP_DIR"
echo "Run it using: open \"$APP_DIR\""

