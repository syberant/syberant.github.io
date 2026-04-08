---
title: USB sticks as capabilities
---

There is an interesting concept in computer security called
[capabilities](https://en.wikipedia.org/wiki/Capability-based_security).
In short, a program can do something (like read/write a file or open a TCP connection) only if it holds a *capability* to do such a thing,
which is very reminiscent of file descriptors.

Confusingly, POSIX also describes something it calls "capabilities" but these are very coarse-grained
^[Linux's `CAP_SYS_ADMIN` reminds me of a [god object](https://en.wikipedia.org/wiki/God_object), look it up with `man capabilities`]
and can't be transferred between processes.
They do thus not qualify as "true" capabilities.

[WASI](https://en.wikipedia.org/wiki/WebAssembly_System_Interface) is probably the best chance we currently have for bringing capabilities to the masses
but there exist plenty of other (niche) projects:

- [Capsicum](https://en.wikipedia.org/wiki/Capsicum_(Unix))
- [Genode](https://en.wikipedia.org/wiki/Genode)
- [seL4](https://en.wikipedia.org/wiki/SeL4)
- [RedoxOS](https://en.wikipedia.org/wiki/RedoxOS)
- [CHERI](https://en.wikipedia.org/wiki/Capability_Hardware_Enhanced_RISC_Instructions) (hardware)

I've been experimenting on my Linux system
^[NixOS to be precise, you can [view my exact config](https://github.com/syberant/nix-config)]
with bringing capabilities to the physical world.

By default my laptop has its WiFi-chip turned off and a blocklist of distracting websites.
I can restore my internet connection by either plugging in Ethernet
^[Itself a physical manifestation of a capability] 
or a special USB stick whose ID I've hardcoded.
Another USB stick also undoes my blocklist.
^[I'll write an explanation for how at some point, in short: udev, rfkill and iptables]
This has helped me cut down on (among other things) a [news addiction](https://xkcd.com/477/).

## Imagined ideal system
In some imaginary future world I foresee it being easy and useful to do stuff like this.
Let me just quickly jot down a list of possibilities.

Internet:

- Unrestricted
- Blocklist of distracting domains
- Limited speed (3G, or even 56k dialup)
- Allow-list of domains (and ports?)
- Offline

Display:

- Unrestricted
- Application-specific transparency
- Black & white

Audio:

- Unrestricted
- Blocklist/allowlist of outputs^[Builtin speakers, headphone jack, bluetooth and usb. Did I miss any?]
- Turned off

Besides these "outputs" we also have some "inputs" on which we'd like our outputs to depend:

- USB devices, the presence of specific devices could be used to allow/disallow any of the above "outputs".
  Arbitrary USB devices could thus function like physicial keys.
- Power, charging generally signifies I'm at a desk, we might permit more.
  Discharging could mean that I'm at a less formal place like a couch.
- Location (GPS?),
  maybe we'd like to prevent access to personal files while at work.
  Or only allow access to a specific game while at a friends house.
  <!-- I used iOS's shortcuts to automatically call my family if I was struggling to leave my room --> 
- Time, perhaps no more access to work emails after 17:30?
