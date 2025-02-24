# Initial download and setup

First start by cloning and cd-ing into the dir, then run the setup file.

```bash
git clone https://github.com/PoutineSyropErable/JetUML ~/.local/java
cd ~/.local/java
./JavaSetup.sh
```

---

# Permanently adding the directory path of this project to your shell PATH Variable (To be able to execute a command)

then to be able to just use the JetUML terminal command, you need to add ~/.local/java to the path permanently.
To do so, you must modify the rc file of your shell. (It's executed every startup)

**Automatic way:**

```bash
./setupEnvVar.sh
```

**Manual Way:**
Depending on your shell (bash, zsh, fish), find it's (run config/RC) file

If you are using a different shell, you are using something niche, and you definitely installed it and configured it yourself,
So, you should know where the file is and how to do it yourself, or at least know how to ask ChatGPT how to do it.

Here's the path to the shell rc files

```bash
~/.config/fish/config.fish
~/.zshrc
~/.bashrc
```

Add to it:

```bash
export PATH="$HOME/.local/java:$PATH"
```

(^^ This is a shell command that will be executed at every shell startup)

Optional, but should be done:
You should also add these environment variable to your shell permanently by adding:

```bash
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

```bash
JetUML
```

in the terminal
If you are on linux, or (on mac and my mac launcher script worked), then you can just start it like any regular application,
using your prefered gui app launcher. (Probably the one integrated into your os)

---

# Lazy typer aliases

You can also add:

```bash
alias jetuml="JetUML"
```

to your shell rc file so you can just type jetuml if you are too lazy to capitalize JetUML.

---

# Making a GUI App Launcer

The .desktop file is to launch it with a normal launche ( For linux only)

```bash
mv ./JetUML.desktop $HOME/.local/share/applications/JetUML.desktop
```

On mac, do (Experimental, not tested)

```bash
./create_mac_launcher.sh
```

---

# Old versions - Not Important, don't need to read. Just moved previous readme to bottom and changed it a bit.

## This is going to be semi consistent, because I changed the main script to be backward compatible. And again, this is an artefact.

### It had the previous fix for it.

On a good system, like arch-based where everything is up to date and not dinosaur old,
you can use the general script that will detect your os and cpu architecture and download the correct files.

```bash
./JavaSetup_NewBash.sh
# Won't work with older bash, like default on mac.
# This was previously named ./JavaSetup.sh
# and ./JavaSetup.sh was called ./JavaSetup_BackwardCompatible.sh
# Well, before that, the backward compatible version didn't even exist
```

**New option**:
On mac, you can just use the hardcoded script:

```bash
./JavaSetup_Mac_Intel.sh
# or
./JavaSetup_Mac_Silicon.sh
```

**Old option**:
If my general script doesn't work on your machine, such as
"error, line 17: linux_86_64 unbound variable" or something similar, then it's because your version of
bash is too old, declarative arrays don't work there, and I can't be fucked to change it to using an if else/switch statement
rather then a dictionary to chose the url.

The solution is to install a new version of bash, and run the script with it
On Mac:

```bash
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
Or, do what I can't be fucked to do, and replace the nice dictionary (from a associative arrays) with something that works with old versions.
Example:
`if OS_ARCH = X then URL = Y`, or have two arrays, and do `for: if OS_ARCH = OS_ARCHS[i], then URL = URL[i] else next.`
