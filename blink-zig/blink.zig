// Emitting a function pointer to `_start` into the `.reset` section.
export const __reset: *const fn () callconv(.C) void linksection(".reset") = &_start;

// `_start` should be `callconv(.Naked)`, because we don't want function prologue/epilogue (stack is
// still invalid). Currently that is not possible (see https://github.com/ziglang/zig/issues/18183).
// It works ok because we don't use any registers in `_start`, so the function prologue is empty.
// The epilogue is also empty because `_start` (and `main`) are `noreturn`.
export fn _start() callconv(.C) noreturn {
    // The symbol `__ram_end` is defined in the linker script.
    const stack_start = @intFromPtr(@extern(*u8, .{ .name = "__ram_end" }));

    // Setup stack pointer.
    asm volatile (
        \\MOV %[arg1], SP
        :
        : [arg1] "i" (stack_start), // input operand contraint "i" = immediate integer operand
    );

    main();
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
