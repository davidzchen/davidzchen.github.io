---
layout: post
title: "Installing GNOME Terminal on Elementary OS 5.1 Hera"
date: 2020-07-20 13:00:00
categories:
  - tech
---

[Elementary OS][elementary-os] has become my favorite Linux distribution. The
Pantheon desktop environment is unmatched among Linux desktop environments in
terms of usability and aesthetics. While earlier versions were rather buggy, the
latest version, 5.1 Hera, has become stable enough for daily usage.

[elementary-os]: https://elementary.io

Elementary comes with its own terminal emulator, [Pantheon
Terminal][pantheon-terminal], which, like many other aspects of the
distribution, focuses on simplicity. However, I still prefer using [GNOME
Terminal][gnome-terminal] due to its richer feature set and customizability.

[pantheon-terminal]: https://github.com/elementary/terminal
[gnome-terminal]: https://help.gnome.org/users/gnome-terminal/stable/

Installing GNOME Terminal on Elementary OS is not as straightforward as
installing most other apps--which is mainly done via [AppCenter][appcenter]--and
takes a few extra steps.

[appcenter]: https://appcenter.elementary.io/

## Installing GNOME Terminal

First, install the `gnome-terminal` package:

```sh
sudo apt install gnome-terminal
```

Although GNOME Terminal is installed, getting it to show up in the Slingshot
app launcher takes an additional step. To do so, open the `gnome-terminal`
[desktop file][desktop-file]. This will require root privileges:

[desktop-file]: https://developer.gnome.org/integration-guide/stable/desktop-files.html.en

```sh
sudo vi /usr/share/applications/gnome-terminal.desktop
```

You can also do this via Files by opening a New Window As Administrator and
navigating to the `/usr/share/applications` directory.

Make the following two changes:

* Change the name to GNOME Terminal since both terminal emulators are named
  "Terminal" by default.
* Comment out or remove the line beginning with `OnlyShowIn`. This will add
  GNOME Terminal to Slingshot.

```cfg
[Desktop Entry]
Name=GNOME Terminal  # <-- Change to GNOME Terminal
Comment=Use the command line
Keywords=shell;prompt;command;commandline;cmd;
TryExec=gnome-terminal
Exec=gnome-terminal
Icon=utilities-terminal
Type=Application
X-GNOME-DocPath=gnome-terminal/index.html
X-GNOME-Bugzilla-Bugzilla=GNOME
X-GNOME-Bugzilla-Product=gnome-terminal
X-GNOME-Bugzilla-Component=BugBuddyBugs
X-GNOME-Bugzilla-Version=3.28.2
Categories=GNOME;GTK;System;TerminalEmulator;
StartupNotify=true
X-GNOME-SingleWindow=false
#OnlyShowIn=GNOME;Unity;  # <-- comment out or remove this line
Actions=new-window
--- snipped ---
```

## Hide menubar by default

To hide the GNOME Terminal menubar by default, first install `dconf-tools`:

```sh
sudo apt install dconf-tools
```

Open [dconf Editor][dconf-editor], navigate to `/org/gnome/terminal/legacy`, and
uncheck `default-show-menubar`:

[dconf-editor]: https://wiki.gnome.org/Apps/DconfEditor

![Uncheck default-show-menubar for GNOME Terminal in
dconf-settings](/assets/img/gnome-terminal-dconf.png)

The menubar can be toggled by right clicking in the terminal window and
selecting "Show Menubar" or via the F10 key.

## Add GNOME Terminal Here context menu option

A useful feature is to have an option in the Files right click context menu to
open a GNOME Terminal window in the current directory. To do this, create a
[Contractor][contractor] file for `gnome-terminal`:

[contractor]: https://github.com/elementary/contractor

```sh
sudo vi /usr/share/contractor/gnome-terminal.contract
```

Add the following:

```cfg
[Contractor Entry]
Name=Open GNOME Terminal Here
Icon=
Description=Open in GNOME Terminal
MimeType=inode/directory
Exec=gnome-terminal --working-directory=%u
X-GNOME-Gettext-Domain=contractor
```

This will add a "Open GNOME Terminal Here" option to the right click menu
in Files. Note that this option appears at the bottom of the menu and not
under the "Open in" menu, which includes (Pantheon) Terminal by default. It
would be nice if there was an easy way to add a GNOME Terminal option there
for consistency, but this works well enough for now.

