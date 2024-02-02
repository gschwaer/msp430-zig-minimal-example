// Emitting a function pointer to `_start` into the `.reset` section.
export const __reset: *const fn () callconv(.Naked) void linksection(".reset") = &_start;

// `_start` needs to be `callconv(.Naked)` (i.e., a function without prologue/epilogue), because the
// stack is not initialized yet.
export fn _start() callconv(.Naked) noreturn {
    // The symbol `__ram_end` is defined in the linker script.
    const stack_start = @intFromPtr(@extern(*u8, .{ .name = "__ram_end" }));

    // 1. Setup stack pointer.
    // 2. We cannot call regular functions from .Naked functions, so we have to jump to main in
    //    assembly.
    asm volatile (
        \\MOV %[arg1], SP
        \\JMP main
        :
        : [arg1] "i" (stack_start), // input operand contraint "i" = immediate integer operand
    );
}

export fn main() noreturn {
    // This is by no means elegant, but a minimal working example.
    const wdtctl: *volatile u16 = @ptrFromInt(0x0120);
    wdtctl.* = 0x5a80; // disable watchdog

    const p1dir: *volatile u8 = @ptrFromInt(0x0022);
    p1dir.* |= 1; // set P1.0 to output

    const p1out: *volatile u8 = @ptrFromInt(0x0021);
    while (true) {
        p1out.* ^= 1; // toggle P1.0
    }
}
