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

then to be able to just use the JetUML terminal command, you need to add ~/.local/java to the path permanently.
To do so, you must modify the rc file of your shell. (It's executed every startup)

Automatic way:

```
./setupEnvVar.sh
```

Manual Way: Depending on your shell (bash, zsh, fish), find it's run config file
(And you know which shell it is and where's it's config file is if it's a different one)

here's the path to the shell rc files

```
~/.config/fish/config.fish
~/.zshrc
~/.bashrc
```

and add:

```
export PATH="$HOME/.local/java:$PATH"
```

(^^ This is a shell command that will be executed at every shell startup)

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

Then you need to source your shell. Here's different way ranked from best and hardest to braindead but it works.

0. Actually source it: `source <shell-rc-path>`
1. execute the shell again `bash || zsh || fish`
2. Just close and reopen the terminal if you don't know how.

---

It should work now, just do

```
JetUML
```

in the terminal
If you are on linux, or (on mac and my mac launcher script worked), then you can just start it like any regular application,
using your prefered gui app launcher. (Probably the one integrated into your os)
