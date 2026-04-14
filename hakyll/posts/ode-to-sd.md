---
title: "An ode to sd, a home for all my hacky shell scripts"
---

`sd` will not "revolutionize" anything you do,
it's just one of those things quietly in the background providing comfort
without you having to think about it.

Here's how [the project](https://github.com/ianthehenry/sd) describes itself:

> `sd` is a tool for running scripts in your script directory.

That sounds a bit vague, let me explain why I think this is so good.
You could also stop reading me and head on over to [an explanation by the author of `sd`](https://ianthehenry.com/posts/a-cozy-nest-for-your-scripts).
I especially liked this part:

> `sd` is for script hoarders, who want to rage against the chaos of their `~/bin`.
> And `sd` is for people who spend a lot of time combing through `ctrl-r`,
> looking for that oneliner that they never thought to make into a script,
> because it was too much of a hassle and who knows if they'll ever run it again.

Here's my elevator pitch for `sd`:

> `sd` allows you to organise and run all your (oneliner) shell scripts while keeping your `$PATH` clean.

## Usage
Let's take a look at `sd` in practice.

```bash
$ sd qr --which
/home/sybrand/sd/qr
```
My script directory is located at `~/sd`.
```bash
$ sd qr --cat
#!/usr/bin/env bash
# Show a QR code of the given args
# Useful for sharing URLs and text snippets to your phone.

set -euo pipefail

echo "$@" | qrencode -o - --type=ANSI256UTF8
```
If none of the known flags are used, then the script is executed with the given arguments.
```bash
$ sd qr 'https://github.com/ianthehenry/sd'
█████████████████████████████████████
█████████████████████████████████████
████ ▄▄▄▄▄ █▄▀▀▄▄██▄ ▄█▀▀█ ▄▄▄▄▄ ████
████ █   █ ███▄█ ██▄ ▀▄▀ █ █   █ ████
████ █▄▄▄█ ██▄▀▄▀█▄  ▀ ▄▀█ █▄▄▄█ ████
████▄▄▄▄▄▄▄█ █ ▀▄▀▄▀ █ ▀ █▄▄▄▄▄▄▄████
████▄▄█▄ █▄█▀ ▄▄▀ ██ ▄▀ █▀▄▀▀█▀▀▄████
████▀ ▄▀ █▄▀▄▀  ▀ █ ▀ ███▀▀ ▄▀▄█▀████
████▀  ▀ █▄▄▄▄█▄▄ ▀█▄▀▀█▄█  ▀▀▀▀ ████
█████ ▄██ ▄▄ ▄  ▄▄█▄▄█  ▄▄▄▀ █ █ ████
████  ▀█ █▄█▀ █▀▀▀  █▀▀ ▄▄██▀▄▀▀█████
████  ▄█ ▀▄ ▄ ▄▄▀█▀ █▄█ ██▀█▄ ▀█▄████
████▄▄▄█▄█▄▄▀█▄█▄▄  █ ▀█ ▄▄▄  ▄▄█████
████ ▄▄▄▄▄ ██ ██▄█  ▄▀▀  █▄█ ▄███████
████ █   █ █  ▄█▀▄▄▀▄██▄▄ ▄▄▄▄█▄ ████
████ █▄▄▄█ █▀▄▀█▀▀ ▄▀▄ █▄▄▀ ▄▀ ▄ ████
████▄▄▄▄▄▄▄█▄▄▄▄▄███▄██▄▄█▄█▄████████
█████████████████████████████████████
█████████████████████████████████████
```

Yes, this script could have been an [alias](https://en.wikipedia.org/wiki/Alias_(command)).
The extra namespacing still assures me.

## Filesystem
`sd` is a one-to-one mapping between the arguments it takes and the filesystem.

It first drills down into your script directory like subcommands,
then passes the rest of the arguments to your script.

TODO

## Kernel
One could theoretically obtain the core feature of `sd` by modifying your kernel's `exec` function to traverse directories and pop args as described above.
You'd then only need an `alias sd=~/sd`{lang=bash}.

I do not know of any operating system that has done this.
Neither do I know if it would be practical.

## Conclusion
Go! Try it out!

Or don't. You might already have a system for your scripts,
it could be interesting to compare and contrast.

--------------------------------------------------------------------------------

One more thing: `sd` is so conceptually simple and easy to hack on
that [I rewrote it](https://github.com/syberant/sdr) into a small
^[210 lines of code spread over 2 files, 1 transitive dependency (on `anyhow`)]
Rust project.

Just because I'm bad at bash and
didn't want to forever depend on a third-party script for something this simple and important.
