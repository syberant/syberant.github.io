---
title: "Readable RISC-V Assembly Dialect"
---

I've been thinking a bit about making a dialect of RISC-V assembly.
There should be a surjective translation from my dialect into regular RISC-V assembly, this could be proven using Lean.
Given that everybody is used to it, I also think it should look a little bit like C:
Assignment statements, if-statements, maybe even loops.
If I could squeeze a few functional programming concepts in I would be supremely happy.

Let's try an example to clear things up; original assembly code taken from [here](https://projectf.io/posts/riscv-compiler-explorer/img/ce-interface.png).

### Example: Change Endianness
```riscvasm
srli a1, a0, 8
lui a2, 16
addi a2, a2, -256
and a1, a1, a2

srli a3, a0, 24
or a1, a1, a3

and a2, a2, a0
slli a2, a2, 8

slli a0, a0, 24
or a0, a0, a2
or a0, a0, a1

ret
```
would become
```
a1 = a0 >> 8
a2 = 0xff00
a1 &= a2

a3 = a0 >> 24
a1 |= a3

a2 &= a0
a2 <<= 8

a0 <<= 24
a0 |= a2
a0 |= a1

ret
```
or
```
a1 = a0 >> 8
a2 = 0xff00
a1 &= a2

a3 = a0 >> 24
a1 |= a3

a2 = (a2 & a0) << 8
a0 = (a0 << 24) | a2 | a1

ret
```
or
```
alias word = a0

a1 = (word >> 8) & (a2 = 0xff00)

a1 |= (a3 = word >> 24)

a2 = (a2 & word) << 8

a0 = (word << 24) | a2 | a1

ret
```
or maybe even
```
alias word = a0

// NOTE: a2 and a3 are set "just-in-time" style to retain the same ordering
a1 = (word >> 8) & (a2 = 0xff00) | (a3 = word >> 24)

a2 = (a2 & word) << 8

a0 = (word << 24) | a2 | a1

ret
```

### Explanation
Backwards-compatibility kunnen we geven door b.v. ook "normale" assembly syntax te accepteren als `ADD r1, r2, r3`.
Ook zit ik te denken aan de vorm `r1 = ADD r2, r3` waarbij het eerste register het *destination* register is.

`ADDI r1, r1, 8` zouden we kunnen weergeven als `r1 += 8`.
`ADDI r1, r2, 8` als `r1 = r2 + 8`.
`ADD r1, r2, r3` als `r1 = r2 + r3`.
`NOP` stel ik me voor als keyword.
`MV r1, r2` als `r1 = r2`.

Instead of manually using a register we could also use an *alias* to give it a name, a practice reminiscent of local variables.
Aliases are scoped, can be redefined/shadowed and will be resolved fully during compile time.
Maybe give warning/error if aliases ever overlap to the same register?
Maybe also if the register an alias points to is used?
Error for a write, warning for a read?

We don't necessarily need to handle pseudoinstructions but they are prime candidates for syntactic sugar.
`LUI` and `ADDI` together are used to implement `LI`, this might lead to confusion as to exactly which instructions are used to implement `r1 = <NUMBER>`.
Is `LUI` or `ADDI` used first? In case they're not both necessary, is the other one used with a 0 immediate?

Expressions are easy for immediates, we just handle them at compile-time.
Can we do them for registers too? We need to be very careful and explicit about ordering.
`r1 = r2 + r3` is simple.
`r1 = r2 + r3 * r4 - 3` is more complicated, maybe we can use RPN?
`r1 = r2 r3 r4 * + 3 -` doesn't seem very readable though.
In practice these calculations might be interleaved using additional registers for enhanced instruction-level parallelism.

What to do when the destination register appears in the expression?
We'd probably need an additional temporary register, unless it's only used in the first operation.
We can just forbid this.


Using this new assembly dialect might also shield one from the AT&T vs. Intel syntax debate :)

Another (unrelated) improvement that could be made to the experience of reading assembly is color-coding the registers,
I think this would be a very useful addition to "normal" syntax highlighting.

### Example: Binary Search
A binary search example from <https://maz.utk.edu/my-courses/cosc230/book/example-risc-v-assembly-programs/>:
```riscvasm
  addi t1, zero, 0
  addi t2, a2, (-1)
1:
  bgt t1, t2, 1f
  add t0, t1, t2
  srai t0, t0, 1
  slli t4, t0, 2
  add t4, t4, a0
  lw t4, t4, 0
  ble a1, t4, 2f
  addi t1, t0, 1
  j 1b
2:
  bge a1, t4, 2f
  addi t2, t0, (-1)
  j 1b
2:
  mv a0, t0
1:
  ret
```
could become
```
  t1 = 0
  t2 = a2 - 1
1:
  bgt t1, t2, 1f
  t0 = t1 + t2
  srai t0, t0, 1
  t4 = t0 << 2
  t4 += a0
  lw t4, t4, 0
  ble a1, t4, 2f
  t1 = t0 + 1
  j 1b
2:
  bge a1, t4, 2f
  t2 = t0 - 1
  j 1b
2:
  a0 = t0
1:
  ret
```
or
```
  t1 = 0
  t2 = a2 - 1
1:
  if t1 <= t2 {
    t0 = t1 + t2
    srai t0, t0, 1

    t4 = t0 << 2
    t4 += a0
    lw t4, t4, 0

    if a1 > t4 {
      t1 = t0 + 1
      j 1b
    }
2:
    if a1 < t4 {
      t2 = t0 - 1
      j 1b
    }
2:
    a0 = t0
  }
1:
  ret
```

We might be able to make assembly look like basic C code with a lot of `goto` :)

## Other unusual assembly things
[Typed assembly](https://en.wikipedia.org/wiki/Typed_assembly_language) seems really cool.
Might be worth investigating it and stealing a subset of functionality.

We could add types and e.g. overload operators (like `+`, `+=`, etc.) to emit different instructions depending on the type of the alias or the type of register (integer, floating point or vector).

[High Level Assembly](https://en.wikipedia.org/wiki/High_Level_Assembly) could also provide/spark useful ideas.

### Properties
We might sometimes want to know (or prove) certain properties about our assembly.

Some ideas:

- Memory:
  - read and/or/neither write?
  - stack/heap?
- Register usage: Input (whose contents we use/rely on) and output (whose contents we change).
  - Large overlap between input and output sets is common.
  - Maybe useful to assert compliance to calling conventions?
  - Should stack spilling (and restoring) count?
- Control flow?
