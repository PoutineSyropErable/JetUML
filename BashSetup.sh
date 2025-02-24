#!/bin/bash

# Check if Bash version is at least 4.0
if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
	echo "❌ Error: This script requires Bash 4.0 or later."
	echo "➡️  Upgrade Bash: On macOS, run: brew install bash"
	exit 1
fi

echo "✅ Bash version supports associative arrays!"
