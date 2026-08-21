---
title: Project "Remove memoffset"
---

I recently attempted to prune some dependencies for one of my projects which resulted in [this PR](https://github.com/Amanieu/intrusive-rs/pull/107)
replacing `memoffset::offset_of` with [`core::mem::offset_of`](https://doc.rust-lang.org/core/mem/macro.offset_of.html).

Two things made this possible:

1. That crate's MSRV ^[Minimum Supported Rust Version] was above 1.77 which was when `core::mem::offset_of` was stabilised.
2. The two macros should be completely compatible. `memoffset` states that

  > If you're using a rustc version greater or equal to 1.77,
  > this crate's offset_of!() macro simply forwards to core::mem::offset_of!().

The PR was merged :)

I then wondered *how many other crates still unnecessarily have such a dependency on `memoffset`?*

crates.io showed 237 [reverse dependencies](https://crates.io/crates/memoffset/reverse_dependencies), of which 1 has already accepted my PR to fix things.

I am NOT going to fix all of them
^[and some can't remove this dependency because they want to support a MSRV below 1.77]
but let's have a go and fire off a bunch of PRs, shall we?

----

Some observations from looking at a bunch of crates and sending out a lot of PRs.

**MSRV is often quite unclear.**
Upstream MSRV can differ substantially from the MSRV in the latest release version, particularly for crates with a low release frequency.
The `edition` (like e.g. Rust 2021) required is sometimes not available on the declared MSRV.
Platform-specific or dev-dependencies can have more relaxed standards than the "main" codebase.
Component or helper crates in larger codebases sometimes don't have any MSRV declared while the "main" crates do.

**People are really friendly.**
I've had nothing but good interactions with complete strangers during this project which actually brightened up my day.
It feels good, worth trying if you need a dose of positivity.
Many issues and PRs were swiftly handled and so far none were refused.

**There's low-hanging fruit in removing old dependencies.**
I stumbled on this by accident but the list of other crates (partially) moved into `std` is substantial.
Admittedly, many uses are only as a dev-dependency.

----

In a year or so we can start doing the same trick by replacing uses of the `cfg-if` crate with `cfg_select` [introduced recently in 1.95](https://blog.rust-lang.org/2026/04/16/Rust-1.95.0/#cfg-select).

I started thinking about what other old dependencies can be removed but
[this list](https://rust-lang.github.io/std-replacement-data/all.json)
from [rust-lang/std-replacement-data](https://github.com/rust-lang/std-replacement-data)
contains exactly that information!

---

<!--
Hi, I may or may not have used your crate but I'd like to say a quick thank you for it anyway!
I'm going down the list of reverse dependencies on `memoffset`.

This PR aims to remove the `memoffset` crate from your dependencies.
[`core::mem::offset_of`](https://doc.rust-lang.org/core/mem/macro.offset_of.html) was stabilised in rustc 1.77 which I believe is at or below your MSRV.

The `memoffset` crate 0.9.1 says that

> If you're using a rustc version greater or equal to 1.77,
> this crate's offset_of!() macro simply forwards to core::mem::offset_of!().

I consider it very unlikely (see [here](https://github.com/rust-lang/rust/issues/111839)) for any usage of the `offset_of!` macro to break but please check anyway.
I hope we can all enjoy the benefits of one less dependency :)
-->

<!-- As commit message I use the following: -->

<!--
`memoffset::offset_of!` was stabilised as `core::mem::offset_of!` in rust 1.77
-->

Here's a list of reverse dependencies sorted by total downloads, I stopped when total downloads dipped below 50k.

| Crate | MSRV | PR sent | Fixed/PR accepted |
| :--- | ---: | ---: | ---: |
| [rustix](https://crates.io/crates/rustix) | 1.65 | No, also uses `span_of!` |  |
| [nix](https://crates.io/crates/nix) | 1.69 | No, [aware](https://github.com/nix-rust/nix/issues/2389) |  |
| [zlib-rs](https://crates.io/crates/zlib-rs) | 1.75 | No, [aware](https://github.com/trifectatechfoundation/zlib-rs/blob/4a9d306de9b748e8e3631a97d60910420675b785/zlib-rs/src/deflate.rs#L4300) |  |
| [objc2](https://crates.io/crates/objc2) | 1.71 | [Issue](https://github.com/madsmtm/objc2/issues/851) | Yes |
| [wayland-sys](https://crates.io/crates/wayland-sys) | 1.86 | [Yes](https://github.com/Smithay/wayland-rs/pull/939) | Yes |
| [uds_windows](https://crates.io/crates/uds_windows) | 1.85 | [Yes](https://github.com/haraldh/rust_uds_windows/pull/25) |  |
| [field-offset](https://crates.io/crates/field-offset) |  | No |  |
| [solana-program](https://crates.io/crates/solana-program) | 1.81 | [Yes](https://github.com/anza-xyz/solana-sdk/pull/816) | Yes |
| [egui_glow](https://crates.io/crates/egui_glow) | 1.92 | [Yes](https://github.com/emilk/egui/pull/8304) | Yes |
| [intrusive-collections](https://crates.io/crates/intrusive-collections) | 1.82 | [Yes](https://github.com/Amanieu/intrusive-rs/pull/107) | Yes |
| [wasmtime-runtime](https://crates.io/crates/wasmtime-runtime) |  | dead crate |  |
| [foyer-intrusive-collections](https://crates.io/crates/foyer-intrusive-collections) |  |  |  |
| [wasmer-types](https://crates.io/crates/wasmer-types) | 1.93 | [Yes](https://github.com/wasmerio/wasmer/pull/6782) | Yes |
| [wasmer-vm](https://crates.io/crates/wasmer-vm) | 1.93 | [Yes](https://github.com/wasmerio/wasmer/pull/6782) | Yes |
| [solana-stable-layout](https://crates.io/crates/solana-stable-layout) | 1.89 | [Yes](https://github.com/anza-xyz/solana-sdk/pull/816) | Yes |
| [solana-loader-v4-interface](https://crates.io/crates/solana-loader-v4-interface) | 1.89 |  |  |
| [solana-runtime](https://crates.io/crates/solana-runtime) | 2024 edition |  |  |
| [blazesym-c](https://crates.io/crates/blazesym-c) | 1.88 | [Yes](https://github.com/libbpf/blazesym/pull/1608) | Yes |
| [starlark](https://crates.io/crates/starlark) | 2024 edition | [Issue](https://github.com/facebook/starlark-rust/issues/214) | Yes |
| [glium](https://crates.io/crates/glium) |  |  |  |
| [virtio-queue](https://crates.io/crates/virtio-queue) |  |  |  |
| [authenticator](https://crates.io/crates/authenticator) |  | [Yes](https://github.com/mozilla/authenticator-rs/pull/361) | Yes |
| [solana-accounts-db](https://crates.io/crates/solana-accounts-db) |  |  |  |
| [const-field-offset-macro](https://crates.io/crates/const-field-offset-macro) | 1.88 |  |  |
| [imgui](https://crates.io/crates/imgui) | 1.82 | [Yes](https://github.com/imgui-rs/imgui-rs/pull/845) |  |
| [speedy](https://crates.io/crates/speedy) |  |  |  |
| [type-layout](https://crates.io/crates/type-layout) |  |  |  |
| [ggez](https://crates.io/crates/ggez) | 1.56 |  |  |
| [implib](https://crates.io/crates/implib) |  |  |  |
| [near-vm-runner](https://crates.io/crates/near-vm-runner) |  |  |  |
| [wasmer-vm-near](https://crates.io/crates/wasmer-vm-near) |  |  |  |
| [wasmer-compiler-singlepass-near](https://crates.io/crates/wasmer-compiler-singlepass-near) |  |  |  |
| [ntfs](https://crates.io/crates/ntfs) | 1.83 | [Yes](https://github.com/ColinFinck/ntfs/pull/39) |  |
| [gpgme](https://crates.io/crates/gpgme) |  |  |  |
| [az-cvm-vtpm](https://crates.io/crates/az-cvm-vtpm) |  |  |  |
| [linera-wasmer-vm](https://crates.io/crates/linera-wasmer-vm) |  |  |  |
| [cargo-modules](https://crates.io/crates/cargo-modules) | 1.91 | Waiting on `intrusive-collections` |  |
| [pgx-pg-sys](https://crates.io/crates/pgx-pg-sys) |  |  |  |
| [savefile](https://crates.io/crates/savefile) |  |  |  |
| [mpi](https://crates.io/crates/mpi) | 1.78 | [Yes](https://github.com/rsmpi/rsmpi/pull/225) | Yes |
| [perf-event-open-sys2](https://crates.io/crates/perf-event-open-sys2) |  |  |  |
| [intuicio-core](https://crates.io/crates/intuicio-core) |  |  |  |
| [imgui-glow-renderer](https://crates.io/crates/imgui-glow-renderer) |  |  |  |
| [c-scape](https://crates.io/crates/c-scape) |  |  |  |
| [dep-obj](https://crates.io/crates/dep-obj) |  |  |  |
| [samply](https://crates.io/crates/samply) |  |  |  |
| [authenticator-ctap2-2021](https://crates.io/crates/authenticator-ctap2-2021) |  |  |  |
| [fdt-rs](https://crates.io/crates/fdt-rs) |  |  |  |
| [lean-sys](https://crates.io/crates/lean-sys) | No |  |  |
| [ktls](https://crates.io/crates/ktls) | 1.75 | [Issue](https://github.com/rustls/ktls/issues/71) |  |
| [nbdkit](https://crates.io/crates/nbdkit) |  |  |  |
| [substrate-wasmtime-runtime](https://crates.io/crates/substrate-wasmtime-runtime) |  |  |  |
| [pc-ints](https://crates.io/crates/pc-ints) | 1.91 | [Yes](https://github.com/A1-Triard/pc-ints/pull/2) |  |
| [libertyos_kernel](https://crates.io/crates/libertyos_kernel) |  | dead crate |  |
| [fyrox-core](https://crates.io/crates/fyrox-core) | 1.87 | [Yes](https://github.com/FyroxEngine/Fyrox/pull/925) | Yes |
| [lightbeam](https://crates.io/crates/lightbeam) |  |  |  |
| [light-bounded-vec](https://crates.io/crates/light-bounded-vec) |  |  |  |
| [pete](https://crates.io/crates/pete) | 1.64 |  |  |
| [ferrisetw](https://crates.io/crates/ferrisetw) |  |  |  |
| [miraland-program](https://crates.io/crates/miraland-program) |  |  |  |
| [super_speedy_syslog_searcher](https://crates.io/crates/super_speedy_syslog_searcher) |  |  |  |
| [redbpf-probes](https://crates.io/crates/redbpf-probes) |  |  |  |
| [redbpf-macros](https://crates.io/crates/redbpf-macros) |  |  |  |
| [near-vm-vm](https://crates.io/crates/near-vm-vm) |  |  |  |
| [eastl-rs](https://crates.io/crates/eastl-rs) |  |  |  |
| [rg3d-core](https://crates.io/crates/rg3d-core) |  | dead crate |  |
| [near-vm-compiler-singlepass](https://crates.io/crates/near-vm-compiler-singlepass) |  |  |  |
| [rafx-framework](https://crates.io/crates/rafx-framework) |  |  |  |
| [mmtk](https://crates.io/crates/mmtk) | 1.84 | [Yes](https://github.com/mmtk/mmtk-core/pull/1520) | Yes |

Not sure how I feel about helping (even this tiniest bit) facebook and blockchain companies...
