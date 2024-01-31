# Blink In C

I found the blink example code in the [TI forum](https://e2e.ti.com/support/microcontrollers/msp-low-power-microcontrollers-group/msp430/f/msp-low-power-microcontroller-forum/521585/msp-430-code-for-blinking-led).
The documentation of the toolchain stated that there should be an example folder with a blink
example. I couldn't find it.

The LED will will blink every half a second or so.

See also [`../Readme.md`](../Readme.md).


## Learnings

- `msp430-elf-gcc` does a `clr r12` before calling `main`. By the MSP430 EABI this sets the first
  argument of `main` to zero. The reason is presumably to prevent code in `main` from trying to
  evaluate `argv` in case `main` is defined as `main(int argc, char *argv[])`.
- `volatile` was added to `unsigned int i` to keep the compiler from optimizing out the delay loop
  (algorithmically the loop has no effect). `volatile` tells the compiler that operations on this
  variable have side effects, so they may not be eliminated. However, since `i` is a stack/automatic
  variable the compiler has to put this variable on the stack. Consequently every operation needs to
  be performed on the stack variable. Curiously: When removing `volatile` and even when optimizing
  with `-O3`, the delay loop is not optimized out. That may be due to some other compiler smarts.


## Generated Assembly (For Reference)

```
blink.bin:     file format elf32-msp430
blink.bin
architecture: msp:14, flags 0x00000102:
EXEC_P, D_PAGED
start address 0x0000c000

Program Header:
    LOAD off    0x00000000 vaddr 0x0000bf6c paddr 0x0000bf6c align 2**2
         filesz 0x000000c0 memsz 0x000000c0 flags r-x
    LOAD off    0x000000c0 vaddr 0x00000200 paddr 0x0000c02c align 2**2
         filesz 0x00000000 memsz 0x00000004 flags rw-
    LOAD off    0x000000c2 vaddr 0x0000fffe paddr 0x0000fffe align 2**2
         filesz 0x00000002 memsz 0x00000002 flags r--

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 __reset_vector 00000002  0000fffe  0000fffe  000000c2  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .rodata       00000000  0000c000  0000c000  000000c4  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  2 .rodata2      00000000  0000c000  0000c000  000000c4  2**0
                  CONTENTS
  3 .text         0000002c  0000c000  0000c000  00000094  2**1
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  4 .data         00000000  00000200  0000c02c  000000c0  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  5 .bss          00000000  00000200  0000c02c  000000c0  2**0
                  ALLOC
  6 .noinit       00000000  00000200  00000200  000000c4  2**0
                  CONTENTS
  7 .heap         00000004  00000200  0000c02c  000000c0  2**0
                  ALLOC
SYMBOL TABLE:
no symbols



Disassembly of section __reset_vector:

0000fffe <__reset_vector>:
    fffe:       00 c0           interrupt service routine at 0xc000

Disassembly of section .text:

0000c000 <.text>:
    c000:       31 40 00 04     mov     #1024,  r1      ;#0x0400
    c004:       0c 43           clr     r12             ;
    c006:       b0 12 0a c0     call    #-16374 ;#0xc00a
    c00a:       21 83           decd    r1              ;
    c00c:       b2 40 80 5a     mov     #23168, &0x0120 ;#0x5a80
    c010:       20 01
    c012:       d2 d3 22 00     bis.b   #1,     &0x0022 ;r3 As==01
    c016:       d2 e3 21 00     xor.b   #1,     &0x0021 ;r3 As==01
    c01a:       b1 40 50 c3     mov     #-15536,0(r1)   ;#0xc350
    c01e:       00 00
    c020:       b1 53 00 00     add     #-1,    0(r1)   ;r3 As==11
    c024:       2c 41           mov     @r1,    r12     ;
    c026:       0c 93           cmp     #0,     r12     ;r3 As==00
    c028:       fb 23           jnz     $-8             ;abs 0xc020
    c02a:       f5 3f           jmp     $-20            ;abs 0xc016

Disassembly of section .heap:

00000200 <.heap>:
 200:   00 00           beq
        ...
```
