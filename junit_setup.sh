#!/bin/bash

# Base installation path
BASE_PATH="$HOME/.local/java"
JUNIT4_PATH="$BASE_PATH/junit4"
JUNIT5_PATH="$BASE_PATH/junit5"

# Create directories if they don't exist
mkdir -p "$JUNIT4_PATH" "$JUNIT5_PATH"

# Define URLs and target filenames using separate arrays for backward compatibility
JARS=(
	"$JUNIT4_PATH/junit-4.13.2.jar"
	"$JUNIT5_PATH/junit-jupiter-api-5.11.3.jar"
	"$JUNIT5_PATH/junit-jupiter-engine-5.11.3.jar"
	"$JUNIT5_PATH/junit-jupiter-params-5.11.3.jar"
)

URLS=(
	"https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar"
	"https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-api/5.11.3/junit-jupiter-api-5.11.3.jar"
	"https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.11.3/junit-jupiter-engine-5.11.3.jar"
	"https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-params/5.11.3/junit-jupiter-params-5.11.3.jar"
)

# Loop through the JAR files and download them if they don't exist
for i in "${!JARS[@]}"; do
	JAR_FILE="${JARS[$i]}"
	JAR_URL="${URLS[$i]}"

	if [[ -f "$JAR_FILE" ]]; then
		echo "✔ $JAR_FILE already exists, skipping download."
	else
		echo "⬇ Downloading $JAR_URL..."
		curl -L --fail --retry 3 -o "$JAR_FILE" "$JAR_URL"
		if [[ $? -ne 0 ]]; then
			echo "❌ Failed to download $JAR_URL"
			exit 1
		fi
	fi
done

echo "✅ JUnit setup complete."
