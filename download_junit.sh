#!/bin/bash

mkdir -p ~/.local/java/junit4
wget -q --show-progress -O ~/.local/java/junit4/junit-4.13.2.jar \
	"https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar"

mkdir -p ~/.local/java/junit5
wget -q --show-progress -O ~/.local/java/junit5/junit-jupiter-api-5.11.3.jar \
	"https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-api/5.11.3/junit-jupiter-api-5.11.3.jar"

wget -q --show-progress -O ~/.local/java/junit5/junit-jupiter-engine-5.11.3.jar \
	"https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-engine/5.11.3/junit-jupiter-engine-5.11.3.jar"

wget -q --show-progress -O ~/.local/java/junit5/junit-jupiter-params-5.11.3.jar \
	"https://repo1.maven.org/maven2/org/junit/jupiter/junit-jupiter-params/5.11.3/junit-jupiter-params-5.11.3.jar"
