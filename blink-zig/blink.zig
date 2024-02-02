// Emitting a function pointer to `_start` into the `.reset` section.
export const __reset: *const fn () callconv(.Naked) void linksection(".reset") = &_start;

// `_start` needs to be `callconv(.Naked)` (i.e., a function without prologue/epilogue), because the
// stack is not initialized yet.
export fn _start() callconv(.Naked) noreturn {
    // In assembly we have to:
    // 1. Setup stack pointer.
    // 2. Jump to main.
    //
    // Notes:
    // - This inline assembly needs to be `volatile` so it cannot be optimized out.
    // - We may not do anything else in this function, because the stack is not set up. If the
    //   compiler reorders instructions and moves a potential `mov x, y(SP)` before the assembly
    //   section, we crash.
    // - We cannot call regular functions from .Naked functions, so we jump to main in assembly.
    // - Unfortunately we cannot inline `main`, because that would pass all restrictions of naked
    //   functions over to `main`. So the jump may become a no-op like `jmp $+2`.
    asm volatile (
        \\MOV #__ram_end, SP
        \\JMP main
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
