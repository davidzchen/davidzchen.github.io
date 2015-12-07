---
layout: tiles
title: tiles attach
nav: projects
---

# tiles attach

```sh
tiles attach [<session-name>] [-h|--help] [-v|--verbose]
```

Attaches to the given tmux session. If no `<session-name>` is provided, then the
default tmux session will be attached.

Running this command is equivalent to running:

```sh
$ tmux -2 attach-session <session-name>
```

## Options

* `-v --verbose` - Prints each command before it is run.
* `-h --help` - Prints this help text.
