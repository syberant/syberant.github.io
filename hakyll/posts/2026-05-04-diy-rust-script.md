---
title: DIY rust-script
---

[rust-script](https://rust-script.org/) is a binary for executing standalone Rust scripts.
Descriptive name, right?

Let's try a quick example of how to use it before we make our own inferior DIY version:
```rust
#!/usr/bin/env rust-script

fn main() {
    println!("Hello world!");
}
```

Save it as `hello.rs`, mark it as executable with `chmod +x hello.rs` and then execute it with `./hello.rs`.
It will print `Hello world!`.

Let's move on to my DIY version before I start explaining all the things it's worse at.
```rust
#!/usr/bin/env -S bash -c "TEMP=\$(mktemp); rustc -O -o \$TEMP \"\$1\"; \$TEMP" bash


fn main() {
    println!("Hello world!");
}
```

Only the [shebang](https://en.wikipedia.org/Shebang_(Unix)) changed, but it looks a lot harder to understand now.

The first reason it's complicated is because we have to do 2 things in 1 command:
compile our script *and* execute it.
This forces us into calling a shell with appropriate arguments.
And to do that we first have to use the `env` command.

## env
From the `env` manpage:

> The -S option allows specifying multiple arguments in a script.  Running a script named 1.pl containing the following first line:
>
>     #!/usr/bin/env -S perl -w -T
>     ...
>
> Will execute perl -w -T 1.pl
>
> Without the '-S' parameter the script will likely fail with:
>
>     /usr/bin/env: 'perl -w -T': No such file or directory

So that explains the weird `env -S` part.

On to `bash -c "<your script here>" bash`!

## bash
From the `bash` manpage:

> If the -c option is present, then commands are read from the first non-option argument *command_string*.  If there are  arguments  after  the
> *command_string*, the first argument is assigned to `$0` and any remaining arguments are assigned to the positional parameters.  The assignment
> to `$0` sets the name of the shell, which is used in warning and error messages.

`#!/usr/bin/env -S bash -c "echo \$1" bash`
^[The `\` in `\$1` is to protect it from `env`, try removing it to see the resulting error message!]
will output `./hello.rs` when run.

The kernel gives `./hello.rs` as an argument to `env` which in turn gives it to `bash` which will make it available as `$1`.
Thus the last `bash` in our shebang is purely there to take up the spot of `$0`.

## rustc
`rustc` should be pretty familiar to Rust programmers (although you usually interact with it through `cargo`).

The `-O` flag is what `--release` mode uses to enable optimisations and the `-o` flag tells `rustc` where to put its resulting binary.

## mktemp
This is purely there to prevent race conditions but unfortunately seems to add about 0.08 seconds of delay for me.

Other ways of picking a name:

- hardcoding
- SHA sum, could even allow caching compilation results

## Why wouldn't you use the DIY version?

Well...

- It's more complex, meaning you probably have to copy-paste it in every time.
- It doesn't cache the compilation meaning a delay in startup time
  ^[Given the small size of most scripts this actually doesn't bother me that much despite Rust's well-deserved notoriety for long compile times. The above `hello.rs` file took 0.46 seconds to execute on my laptop.]
- The big one: You can't have dependencies, `rust-script` [totally can](https://rust-script.org/#scripts)!

## Why would you?
For me personally, the disadvantages are okay and the increased portability is worth it.

One less dependency! Woohoo!

It's also an extra motivating factor to not `cargo add` a dependency on a crate.
This does of course put real limits on what you can do given Rust's small-ish standard library.
^[e.g. no JSON parsing]

The [cargo-script RFC](https://github.com/rust-lang/cargo/issues/12207) is a plan for a builtin version of this idea.
Once that is fully implemented this DIY trick is probably no longer useful for Rust but you can still use it for other compiled languages like Zig or Haskell.
