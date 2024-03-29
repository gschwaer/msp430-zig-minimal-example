# Blink In Zig

See also [`../Readme.md`](../Readme.md).


## Additional Software Requirements

- [get Zig](https://ziglang.org/download/) (I initially used `zig-linux-x86_64-0.11.0.tar.xz` but
  that has quirks - see below - use something greater than `0.11.0`)


## Additional Relevant Documents

- see [`../blink-asm/Readme.md`](../blink-asm/Readme.md).
- [GCC Inline Assembly Operand Constraints](https://gcc.gnu.org/onlinedocs/gcc/Simple-Constraints.html)


## Learnings

- We can put code & data in specific sections with `export` and `linksection(".section")`. The
  sections can then be relocated using a linker script.
- In Zig `0.11.0`, `volatile` seems to be broken (for MSP430 at least). The generated assembly looks
  as follows:
  ```
  c00a:       5c 42 21 00     mov.b   &0x0021,r12
  c00e:       5c e3           xor.b   #1,     r12
  c010:       c2 4c 21 00     mov.b   r12,    &0x0021
  c014:       fc 3f           jmp     $-6             ;abs 0xc00e
  ```
  The value of `p1out` is read into `r12`, then we `xor 1`, then we write `r12` back to `p1out`, and
  loop to (!) the `xor`. So `p1out` is not read between loop iterations. This is a failed
  optimization anyway, because MSP430 assembly allows to directly `xor` to a memory address without
  load & store into register first.
  I tested the same code in Zig `0.12.0-dev` (current `master` branch) and it worked fine. The
  generated assembly was:
  ```
  c00a:       d2 e3 21 00     xor.b   #1,     &0x0021
  c00e:       fd 3f           jmp     $-4             ;abs 0xc00a
  ```
  Much better. I found [an issue on this](https://github.com/ziglang/zig/issues/12928) but for Zig
  `0.10.0-dev`. It should have been resolved by `0.10.0` already. Strangely it's still present.
- Other people seem to be working on better support for microcontrollers in Zig
  ([link](https://microzig.tech/)). Support for MSP430 is not implemented but might be in the future
  ([link](https://github.com/ZigEmbeddedGroup/regz/#what-about-msp430)). Generally it seems like a
  good idea to follow the [ZigEmbeddedGroup](https://github.com/ZigEmbeddedGroup).


## Generated Assembly (For Reference)

(with Zig `0.12.0-dev`)

```
blink.bin:     file format elf32-msp430
blink.bin
architecture: MSP430, flags 0x00000102:
EXEC_P, D_PAGED
start address 0x0000c000

Program Header:
    LOAD off    0x00000ffe vaddr 0x0000fffe paddr 0x0000fffe align 2**12
         filesz 0x00000002 memsz 0x00000002 flags r--
    LOAD off    0x00001000 vaddr 0x0000c000 paddr 0x0000c000 align 2**12
         filesz 0x00000016 memsz 0x00000016 flags r-x
   STACK off    0x00000000 vaddr 0x00000000 paddr 0x00000000 align 2**0
         filesz 0x00000000 memsz 0x01000000 flags rw-

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .reset        00000002  0000fffe  0000fffe  00000ffe  2**1
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .text         00000016  0000c000  0000c000  00001000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
SYMBOL TABLE:
no symbols



Disassembly of section .reset:

0000fffe <.reset>:
    fffe:       00 c0           interrupt service routine at 0xc000

Disassembly of section .text:

0000c000 <.text>:
    c000:       31 40 00 04     mov     #1024,  r1      ;#0x0400
    c004:       00 3c           jmp     $+2             ;abs 0xc006
    c006:       b2 40 80 5a     mov     #23168, &0x0120 ;#0x5a80
    c00a:       20 01
    c00c:       d2 d3 22 00     bis.b   #1,     &0x0022 ;r3 As==01
    c010:       d2 e3 21 00     xor.b   #1,     &0x0021 ;r3 As==01
    c014:       fd 3f           jmp     $-4             ;abs 0xc010
```
