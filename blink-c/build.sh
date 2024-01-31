#!/usr/bin/env bash
set -eu

msp430-elf-gcc -I "$BSP_INC" -L "$BSP_INC" -T "$CHIP".ld -mmcu="$CHIP" -Os -g blink.c -o blink.o
msp430-elf-strip -s -R .MSP430.attributes -R .comment blink.o -o blink.bin  # kondo the obj
