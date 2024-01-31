#!/usr/bin/env bash
set -eu

msp430-elf-as -mmcu="$CHIP" blink.S -o blink.o
msp430-elf-ld -T link.ld blink.o -o blink.bin
