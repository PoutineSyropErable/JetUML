```
git clone https://github.com/PoutineSyropErable/JetUML ~/.local/java
cd ~/.local/java
./JavaSetup.sh
```

the .desktop file is to launch it with a normal launche ( For linux only)

```
mv ./JetUML.desktop /home/francois/.local/share/applications/JetUML.desktop
```

on mac, do (Experimental, not tested)

```
./create_mac_launcher.sh
```

then to be able to just use the JetUML terminal command, you need to add ~/.local/java to the path.
To do so, you must modify the rc file of your shell.

Automatic way:

```
./setupEnvVar.sh
```

```
~/.config/fish/config.fish
~/.zshrc
~/.bashrc
```

and add:

```
export PATH="$HOME/.local/java:$PATH"
```

Optional, but should be done:
You should also add these environment variable to your shell permanently by adding:

```
# Set Java Home
export JAVA_HOME="$HOME/.local/java/java23-openjdk"

# Add Java binaries to PATH
export PATH="$JAVA_HOME/bin:$PATH"

# Set JavaFX module path
export PATH_TO_FX="$HOME/.local/java/javafx-sdk-23/lib"

# Add JavaFX binaries to PATH (optional, but helps some setups)
export PATH="$PATH_TO_FX:$PATH"
```
