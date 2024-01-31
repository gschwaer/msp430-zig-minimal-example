# Blink In Assembly

I simplified the blink example a little. It will not pause between blinks.

The LED will just look dimmed (hard to make out by eye). But if you run the code with `mspdebug`,
then break with `CTRL+C`, and `step` one instruction at a time, you can see the LED switches on and
off.

See also [`../Readme.md`](../Readme.md).


## Additional Relevant Documents

- [LD Linker Scripts](https://sourceware.org/binutils/docs/ld.html)
- [GCC Assembler Directives](https://sourceware.org/binutils/docs/as.html#Pseudo-Ops)


## Generated Assembly (For Reference)

```
blink.bin:     file format elf32-msp430
blink.bin
architecture: msp:14, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x0000c000

Program Header:
    LOAD off    0x00000000 vaddr 0x0000bf8c paddr 0x0000bf8c align 2**2
         filesz 0x00000088 memsz 0x00000088 flags r-x
    LOAD off    0x0000008a vaddr 0x0000fffe paddr 0x0000fffe align 2**2
         filesz 0x00000002 memsz 0x00000002 flags r--

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .reset        00000002  0000fffe  0000fffe  0000008a  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .text         00000014  0000c000  0000c000  00000074  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
SYMBOL TABLE:
0000fffe l    d  .reset 00000000 .reset
0000c000 l    d  .text  00000000 .text
00000000 l    df *ABS*  00000000 blink.o
0000c000 l       .text  00000000 start
0000c00e l       .text  00000000 loop



Disassembly of section .reset:

0000fffe <.reset>:
    fffe:       00 c0           interrupt service routine at 0xc000

Disassembly of section .text:

0000c000 <start>:
    c000:       31 40 00 04     mov     #1024,  r1      ;#0x0400
    c004:       b2 40 80 5a     mov     #23168, &0x0120 ;#0x5a80
    c008:       20 01
    c00a:       d2 d3 22 00     bis.b   #1,     &0x0022 ;r3 As==01

0000c00e <loop>:
    c00e:       d2 e3 21 00     xor.b   #1,     &0x0021 ;r3 As==01
    c012:       fd 3f           jmp     $-4             ;abs 0xc00e
```
