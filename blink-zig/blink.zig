export const reset_vector: u16 linksection(".reset") = 0xC000;

export fn main() void {
    // This is by no means elegant, but a minimal working example.
    // We don't use the stack here, so we don't initialize it.
    const wdtctl: *volatile u16 = @ptrFromInt(0x0120);
    wdtctl.* = 0x5a80; // disable watchdog

    const p1dir: *volatile u8 = @ptrFromInt(0x0022);
    p1dir.* |= 1; // set P1.0 to output

    const p1out: *volatile u8 = @ptrFromInt(0x0021);
    while (true) {
        p1out.* ^= 1; // toggle P1.0
    }
}
