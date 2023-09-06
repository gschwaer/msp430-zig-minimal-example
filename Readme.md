# Blink In Zig For MSP430 Microcontrollers

I wanted to experiment a little with [Zig lang](https://ziglang.org/).
And I saw that it has a MSP430 backend.
So I set out to try and run some Zig on an MSP430.
This is the journey to a minimal blink example to get started.

The experiment:

1. Starting with a known good blink example in C ([`./blink-c`](./blink-c)).
   - Well, what can I say, it blinks.
2. Create minimal blink example in assembly ([`./blink-asm`](./blink-asm)).
   - Understand what is really required
     by reading a) the manual
     and b) the generated assembly from `blink-c`.
   - To get `C` out of the loop completely.
3. Try to replicate it with Zig ([`./blink-zig`](./blink-zig)).
   - See [Learnings](./blink-zig/Readme.md#Learnings).


## Relevant Documents

- [MSP430G2xxx User's Guide](https://www.ti.com/lit/ug/slau144k/slau144k.pdf) (really good!)
  - includes msp430 register and assembly reference (nice!)
  - includes what is required to boot (thanks!)
- [MSP430G2x53 Datasheet](https://www.ti.com/lit/ds/symlink/msp430g2553.pdf)


## Hardware Requirements

- To follow along:
  - [TI MSP430 LaunchPad Development Tool (`MSP-EXP430G2`)](https://www.ti.com/tool/MSP-EXP430G2ET)
  - `MSP430G2553` (included in LaunchPad Kit)
- Basically usable for every MSP430, just adapt the build and run procedure.


## Software Requirements

- `mspdebug` (Debian/Ubuntu: `sudo apt install mspdebug`) - to flash and debug the code on the chip
- `msp430-elf-*` MSP430-GCC-OPENSOURCE toolchain from TI ([link](https://www.ti.com/tool/MSP430-GCC-OPENSOURCE#downloads))
  - "Mitto Systems GCC 64-bit Linux - toolchain only" -> extract into `repo-dir/msp430-gcc-9.3.1.11_linux64` (or change path in `.env`)
  - "Header and Support Files" -> extract into `repo-dir/msp430-gcc-support-files` (or change path in `.env`)


## How-To

First set up your terminal environment:
```bash
source .env
```
(Must be executed in the repo directory, in subfolders use `cd .. && source .env && cd -`.)

Enter the subdirectory of choice, then:
1. Build: `./build.sh`
2. Inspect: `./inspect.sh` (the generated assembly)
3. Run: `./run.sh` (then enter `prog blink.o` and `run`)
