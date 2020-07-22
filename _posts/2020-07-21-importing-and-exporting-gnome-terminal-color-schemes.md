---
layout: post
title: "Importing and Exporting GNOME Terminal Color Schemes"
date: 2020-07-21 12:30:00
categories:
  - tech
---

Unlike terminal emulators such as [iTerm2][iterm2] and
[Terminal.app][terminal-app], GNOME Terminal does not have an easy way to import
and export color schemes as files. The closest analogue is via Profiles, which
are managed in dconf.

[iterm2]: https://www.iterm2.com/
[terminal-app]: https://support.apple.com/guide/terminal/welcome/mac

Note that the following is not the most ideal approach. Tools such as
[Gogh][gogh] do exist and provide an easy and automated way to apply color
schemes to GNOME Terminal, as well as to a number of other terminal emulators.
However, for the sake of learning, I think it is still helpful to document some
details of how GNOME Terminal profiles are managed, and in the future, I plan
to write my own tool to automate this.

[gogh]: https://github.com/Mayccoll/Gogh

As a sidenote, Gogh's [recommended usage][gogh-install] is to fetch its shell
script and then execute it on your local shell. [**This is a serious security
risk**][dont-pipe-to-shell] and should always be avoided.

[gogh-install]: https://github.com/Mayccoll/Gogh#install
[dont-pipe-to-shell]: https://www.seancassidy.me/dont-pipe-to-your-shell.html

In addition to terminal emulator color schemes, I also have corresponding color
schemes for [tmux][tmux] and my go-to text editor [vim][vim]. Eventually, I
plan to write tooling to manage color schemes across all of these.

[tmux]: https://github.com/tmux/tmux/wiki
[vim]: https://www.vim.org/

## Importing a GNOME Terminal Profile

This part assumes that you already have a profile exported from GNOME Terminal
that contains the color scheme you want to apply. See below for more information
on how to do this.

After [installing GNOME Terminal on Elementary OS][install-gnome-terminal],
there is no default profile created, and the only one that exists is an
Unnamed profile:

[install-gnome-terminal]: {% post_url 2020-07-20-install-gnome-terminal-on-elementaryos %}

<img src="/assets/img/gnome-terminal-unnamed-profile.png" class="img-responsive"
    alt="GNOME Terminal Unnamed profile">

Similarly, running `dconf dump /org/gnome/terminal/legacy/profiles:/` returns
no output.

The first step is to create a new default profile. Profiles are identified
using a [UUID][uuid], and the UUID of the default profile is needed in order
to import a profile containing your color scheme.

[uuid]: https://tools.ietf.org/html/rfc4122

Create a new profile, name it "default", and set it as the default profile.
This step is required before the unnamed profile can be removed. Note that the
name of the new profile doesn't really matter, since once the new profile is
imported, it will overwrite the name in addition to other settings, including
the colors. Now, delete the unnamed profile.

The `dconf dump` command will now output the new profile:

```
$ dconf dump /org/gnome/terminal/legacy/profiles:/
[/]
list=['e27d087d-18c4-4b72-83be-c84103543515']
default='e27d087d-18c4-4b72-83be-c84103543515'

[:e27d087d-18c4-4b72-83be-c84103543515]
visible-name='default'
```

As shown above, UUID of the new default profile is
`e27d087d-18c4-4b72-83be-c84103543515`. Now, import your profile file as
follows:

```sh
dconf load /org/gnome/terminal/legacy/profiles:/:e27d087d-18c4-4b72-83be-c84103543515/ < citylights-profile.dconf
```

This command will import the profile's settings and will also immediately apply
its settings and color scheme to any open terminal windows.

<img src="/assets/img/gnome-terminal-profile-installed.png" class="img-responsive"
    alt="GNOME Terminal profile installed">

## Exporting a GNOME Terminal Profile

To export a GNOME Terminal profile, first dump the list of profiles using
`dconf dump`:

```
$ dconf dump /org/gnome/terminal/legacy/profiles:/
[/]
list=['e27d087d-18c4-4b72-83be-c84103543515']
default='e27d087d-18c4-4b72-83be-c84103543515'

[:e27d087d-18c4-4b72-83be-c84103543515]
foreground-color='rgb(183,197,211)'
highlight-background-color='rgb(40,70,102)'
visible-name='City Lights'
palette=['rgb(51,63,74)', 'rgb(217,84,104)', 'rgb(139,212,156)', 'rgb(235,191,131)', 'rgb(83,154,252)', 'rgb(182,45,101)', 'rgb(112,225,232)', 'rgb(113,140,161)', 'rgb(65,80,94)', 'rgb(217,84,104)', 'rgb(139,212,156)', 'rgb(247,218,179)', 'rgb(94,196,255)', 'rgb(182,45,101)', 'rgb(112,225,232)', 'rgb(183,197,211)']
cursor-background-color='rgb(73,98,124)'
use-system-font=false
cursor-colors-set=true
highlight-colors-set=true
use-theme-colors=false
use-transparent-background=false
cursor-foreground-color='rgb(73,98,124)'
font='PragmataPro Mono 10'
allow-bold=true
use-theme-transparency=false
bold-color-same-as-fg=true
bold-color='#97979C9CACAC'
background-color='rgb(28,31,39)'
background-transparency-percent=7
cursor-blink-mode='off'
highlight-foreground-color='#'
```

Note that unlike the output of the same `dconf dump` command in the previous
section, this command's output is much more verbose, since the profile now
overrides many of the default settings.

Using the UUID of the profile you want to export (which in this case is
`e27d087d-18c4-4b72-83be-c84103543515`) dump its settings into a file:

```sh
dconf dump /org/gnome/terminal/legacy/profiles:/:e27d087d-18c4-4b72-83be-c84103543515/ > citylights-profile.dconf
```

This file can in turn be imported using the steps described above.
