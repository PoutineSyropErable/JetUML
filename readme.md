git clone https://github.com/PoutineSyropErable/JetUML ~/.local/bin/JetUML

create the .desktop file so it can be found easily:

```
mv ./JetUML.desktop /home/francois/.local/share/applications/JetUML.desktop
```

You must install java and the javafx jar and put them in /usr/lib/jvm

javafx-sdk-23 is a softlink to the actual 23.x.y file. Here's a dir tree of depth 2

javafx-sdk-23
├── legal
│   ├── javafx.base
│   ├── javafx.controls
│   ├── javafx.fxml
│   ├── javafx.graphics
│   ├── javafx.media
│   ├── javafx.swing
│   └── javafx.web
└── lib

java-23-openjdk
├── bin
├── conf -> /etc/java-openjdk
├── demo
│   ├── jfc
│   └── nbproject
├── include
│   └── linux
├── jmods
├── legal -> /usr/share/licenses/java-openjdk
├── lib
│   ├── jfr
│   ├── security
│   └── server
└── man -> /usr/share/man

25 directories
