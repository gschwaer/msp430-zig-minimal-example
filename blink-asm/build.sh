#!/usr/bin/env bash
set -eu

msp430-elf-as -mmcu="$CHIP" -g blink.S -o blink.o
msp430-elf-ld -T link.ld blink.o -o blink-linked.o
mv blink-linked.o blink.o
msp430-elf-strip -R .MSP430.attributes blink.o  # kondo the obj
