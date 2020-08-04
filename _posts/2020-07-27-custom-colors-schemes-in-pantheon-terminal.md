---
layout: post
title: "Custom Color Schemes in Pantheon Terminal"
date: 2020-07-27 14:30:00
categories:
  - tech
---

[Pantheon Terminal][pantheon-terminal] on Elementary OS 5.1 Hera is a fairly
simple terminal emulator that focuses on being simple and lightweight. It
features three built-in color schemes: a high-contrast light theme,
[Solarized][solarized] Light, and a dark theme. Aside from this, it features
few other configuration options available in the UI.

[pantheon-terminal]: https://github.com/elementary/terminal
[solarized]: https://ethanschoonover.com/solarized/

However, for those of us power users, being able to customize the terminal
color scheme is a must, and ideally, Pantheon Terminal should provide a UI for
configuring custom color schemes. There is currently a GitHub Issue on the
Pantheon Terminal repository ([elementary/terminal#418][terminal-418]) for this
feature, but in the meantime, there is a workaround for applying a custom color
scheme through dconf settings.

[terminal-418]: https://github.com/elementary/terminal/issues/418

There are four main dconf settings under `/io/elementary/terminal/settings` for
configuring the color scheme:

```bash
gsettings set io.elementary.terminal.settings background "$BACKGROUND"
gsettings set io.elementary.terminal.settings foreground "$FOREGROUND"
gsettings set io.elementary.terminal.settings cursor-color "$CURSOR"
gsettings set io.elementary.terminal.settings palette "$PALETTE"
```

Color values can be expressed in either hex or rgba color values as described
in the Colors section in the [GNOME GTK+ Style Sheets documentation][gnome-css]
(GTK+ adopts a number of web technologies for UI layout and styling after all).

[gnome-css]: https://developer.gnome.org/gtk3/stable/chap-css-overview.html

The `background`, `foreground`, and `cursor-color` settings are fairly
straightforward and take one color value each. The `palette` setting takes
a string consisting of color values to override the 0-15 [xterm color
ranges][xterm-colors], separated by `':'` characters. The details of xterm
colors is a topic far beyond the scope of this post, but this [StackOverflow
post][stackoverflow-color-codes] provides a good overview. In a nutshell, the
colors in this range correspond to the following:

<table class="table">
  <thead>
    <tr>
      <th colspan="2">Normal colors</th>
      <th colspan="2">Bright colors</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>0</td><td>Black</td>  <td>8</td> <td>Bright Black</td></tr>
    <tr><td>1</td><td>Red</td>    <td>9</td> <td>Bright Red</td></tr>
    <tr><td>2</td><td>Yellow</td> <td>10</td><td>Bright Yellow</td></tr>
    <tr><td>3</td><td>Green</td>  <td>11</td><td>Bright Green</td></tr>
    <tr><td>4</td><td>Blue</td>   <td>12</td><td>Bright Blue</td></tr>
    <tr><td>5</td><td>Magenta</td><td>13</td><td>Bright Magenta</td></tr>
    <tr><td>6</td><td>Cyan</td>   <td>14</td><td>Bright Cyan</td></tr>
    <tr><td>7</td><td>White</td>  <td>15</td><td>Bright White</td></tr>
  </tbody>
</table>

[xterm-colors]: https://invisible-island.net/xterm/manpage/xterm.html#h3-VT100-Widget-Resources
[stackoverflow-color-codes]: https://stackoverflow.com/questions/29447692/whats-the-meaning-of-color0-15-in-urxvt-settings

Thus, the `palette` setting takes a string of the following format:

```bash
"$BLACK:$RED:$GREEN:$ORANGE:$BLUE:$MAGENTA:$CYAN:$WHITE:$BR_BLACK:$BR_RED:$BR_GREEN:$BR_ORANGE:$BR_BLUE:$BR_MAGENTA:$BR_CYAN:$BR_WHITE"
```

**Sidenote 1:** One interesting point to note is that hex color values in GTK+
are expressed using [Xlib color strings][xlib-colors], which are similar in
syntax to [CSS hex color values][css-colors]. The main difference is that since
Xlib uses 16 bits to represent each color component, whereas [CSS uses 8
bits][web-colors]. From the [Xlib RGB Device String Specification][xlib-colors]:

> The syntax is an initial sharp sign character followed by a numeric
> specification, in one of the following formats:
>
> ```
> #RGB	(4 bits each)
> #RRGGBB	(8 bits each)
> #RRRGGGBBB	(12 bits each)
> #RRRRGGGGBBBB	(16 bits each)
> ```
>
> The R, G, and B represent single hexadecimal digits. When fewer than 16 bits
> each are specified, they represent the most significant bits of the value
> (unlike the "rgb:" syntax, in which values are scaled). For example, the
> string "#3a7" is the same as "#3000a0007000".

[xlib-colors]: https://www.x.org/releases/X11R7.7/doc/libX11/libX11/libX11.html#RGB_Device_String_Specification
[css-colors]: https://developer.mozilla.org/en-US/docs/Web/CSS/color
[web-colors]: https://en.wikipedia.org/wiki/Web_colors

**Sidenote 2:** There is also an additional `prefer-dark-style` setting, which
is used to enable the dark mode UI for Pantheon Terminal. This is a setting that
isn't exposed to users currently but can be enabled through the "Prefer dark
variant" setting in [elementary-tweaks][elementary-tweaks]. There is
[ongoing work][eos-darkmode] to implement a system-wide dark mode in Elementary
OS and [formalize a standard][darkmode-standard] for dark mode preference across
FreeDesktop.org projects.  The dashboard for the Dark Mode project for
Elementary OS can be found [here][eos-darkmode-dash].

[elementary-tweaks]: https://github.com/elementary-tweaks/elementary-tweaks
[eos-darkmode]: https://blog.elementary.io/the-need-for-a-freedesktop-dark-style-preference/
[darkmode-standard]: https://github.com/elementary/os/wiki/Dark-Style-Preference
[eos-darkmode-dash]: https://github.com/orgs/elementary/projects/43

To make life easier, I wrote a bash script that makes it easier to specify,
understand, and apply custom color schemes for Pantheon Terminal. As a dark mode
aficionado, I also have `prefer-dark-style` enabled:

```bash
#!/bin/bash

set -euf -o pipefail

readonly BLACK="#1B232A"      # black    terminal_color_0
readonly RED="#D95468"        # red      terminal_color_1
readonly GREEN="#8BD49C"      # green    terminal_color_2
readonly ORANGE="#D98E48"     # orange   terminal_color_3
readonly BLUE="#539AFC"       # blue     terminal_color_4
readonly MAGENTA="#B62D65"    # magenta  terminal_color_5
readonly CYAN="#008B94"       # cyan     terminal_color_6
readonly WHITE="#718CA1"      # white    terminal_color_7

readonly BR_BLACK="#333F4A"   # bright black    terminal_color_8
readonly BR_RED="#D95468"     # bright red      terminal_color_9
readonly BR_GREEN="#8BD49C"   # bright green    terminal_color_10
readonly BR_ORANGE="#EBBF83"  # bright orange   terminal_color_11
readonly BR_BLUE="#5EC4FF"    # bright blue     terminal_color_12
readonly BR_MAGENTA="#B62D65" # bright magenta  terminal_color_13
readonly BR_CYAN="#70E1E8"    # bright cyan     terminal_color_14
readonly BR_WHITE="#B7C5D3"   # bright white    terminal_color_15

readonly BACKGROUND="$BLACK"
readonly FOREGROUND="$BR_WHITE"
readonly CURSOR="$BLUE"
readonly DARKSTYLE='true'
readonly PALETTE="$BLACK:$RED:$GREEN:$ORANGE:$BLUE:$MAGENTA:$CYAN:$WHITE:$BR_BLACK:$BR_RED:$BR_GREEN:$BR_ORANGE:$BR_BLUE:$BR_MAGENTA:$BR_CYAN:$BR_WHITE"

gsettings set io.elementary.terminal.settings background "$BACKGROUND"
gsettings set io.elementary.terminal.settings foreground "$FOREGROUND"
gsettings set io.elementary.terminal.settings cursor-color "$CURSOR"
gsettings set io.elementary.terminal.settings prefer-dark-style "$DARKSTYLE"
gsettings set io.elementary.terminal.settings palette "$PALETTE"
```

As a final note, applying these settings will override the current color scheme
selected in the Pantheon Terminal settings menu. However, this is not
completely persistent, and selecting one of the other color schemes from the
menu will override your custom color scheme, and you would need to run the
script in order to re-apply your custom color scheme again.

<img src="/assets/img/pantheon-terminal-custom-colors.png" class="img-responsive"
    alt="Pantheon Terminal with Citylights color scheme">
