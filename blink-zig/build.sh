#!/usr/bin/env bash
set -eu

zig build  # zig 0.11.0 has issues with volatile, use zig > 0.11.0
msp430-elf-ld -T link.ld zig-out/bin/blink.o -o blink.o
msp430-elf-strip -R .MSP430.attributes blink.o  # kondo the obj
