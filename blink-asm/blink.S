.section ".reset", #alloc  /* the .reset needs to be alloc, otherwise the flashing tool does not know that this needs to be flashed -- took me quite a while to figure that out */
    .word 0xc000           /* start at beginning of ROM */

.text
start:
    mov #0x400, r1         /* set up stack to end of RAM (0x0200 + 512) */
    mov #0x5a80, &0x0120   /* disable watchdog (WDTCTL = &0x0120, WDTPWD = 0x5a) */
    bis.b #0x01, &0x022    /* set P1.0 to output (P1DIR = &0x022) */
loop:
    xor.b #0x01, &0x021    /* toggle P1.0 high/low (P1OUT = &0x021) */
    jmp loop               /* infinite loop */
