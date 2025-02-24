# Initial download and setup

On a good system, like arch-based where everything is up to date and not dinosaur old:

```
git clone https://github.com/PoutineSyropErable/JetUML ~/.local/java
cd ~/.local/java
./JavaSetup.sh # Won't work with older bash, like default on mac.
```

On Mac:

```
# Start by getting a newer version of bash:
brew install bash
# Then find bash location:
brew --prefix bash
# So the command should be $<Brew bash path> ./JavaSetup.sh
# ie: (probably one of the two)
/opt/homebrew/bin/bash ./JavaSetup.sh # Apple Silicon
/usr/local/bin/bash ./JavaSetup.sh    # Intel Macs
```

Just install a new version of bash with whatever package manager you have, and use it.
And if your package manager is dinosaur old and it can't give you a new enough version of bash,
then figure out how to install a newer version of bash on your machine, compile from source if you need to.

Or, just modify my script by commenting out the "declare -A" line, and then just hardcode the variable for the url of jetuml and javafx

---

# Making a GUI App Launcer

the .desktop file is to launch it with a normal launche ( For linux only)

```
mv ./JetUML.desktop $HOME/.local/share/applications/JetUML.desktop
```

on mac, do (Experimental, not tested)

```
./create_mac_launcher.sh
```

---

# Permanently adding the directory path of this project to your shell PATH Variable (To be able to execute a command)

then to be able to just use the JetUML terminal command, you need to add ~/.local/java to the path permanently.
To do so, you must modify the rc file of your shell. (It's executed every startup)

**Automatic way:**

```
./setupEnvVar.sh
```

**Manual Way:**
Depending on your shell (bash, zsh, fish), find it's (run config/RC) file
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
export JAVA_HOME="$HOME/.local/java/java-23-openjdk"

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

---

# Lazy typer aliases

you can also add

```
alias jetuml="JetUML"
```

to your shell rc file so you can just type jetuml if you are too lazy to capitalize JetUML.
