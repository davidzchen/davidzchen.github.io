---
layout: tiles
title: tiles attach
nav: projects
---

# tiles start

```sh
tiles start <session-name> [-h|--help] [-v|--verbose]
```

Creates tmux sessions defined in the `~/.tiles` configuration file.

## Options

* `-v --verbose` - Prints each command before it is run.
* `-h --help` - Prints this help text.

## Usage

The `.tiles` file must be in the user's home directory. The syntax of the
`.tiles` file is as follows:

```python
tmux_session(
    name = "session-name",
    windows = [],
)
```

The `name` parameter is used to reference the session when invoking this script.
The `windows` parameter is a list of tuples of `[window_name,
working_directory]`.  For example, the following configuration:

```python
tmux_session(
    name = "work",
    windows = [
        ["blog", "~/Projects/blog"],
        ["tensorflow", "~/Projects/tensorflow"]
    ]
)
```

defines a tmux session named `"work"` with two windows. The session can be
started by invoking:

```sh
$ tiles start work
```

If a session in `.tiles` is named `"default"`, invoking `tiles start` with
arguments starts the default session.
