const std = @import("std");

pub fn build(b: *std.Build) !void {
    const cross_target = try std.Target.Query.parse(.{
        .arch_os_abi = "msp430-freestanding-none", // `freestanding` = No OS, `none` = No C ABI
    });
    const obj = b.addObject(.{
        .name = "blink",
        .root_source_file = .{ .path = "blink.zig" },
        .target = std.Build.resolveTargetQuery(b, cross_target),
        .optimize = std.builtin.Mode.ReleaseSmall, // for clear assembly
    });
    // By default the compiler will not emit the object, make it do that.
    const install = b.addInstallArtifact(
        obj,
        .{
            // By default the compiler does not know where to emit an object artifact to. We let it
            // write it in the same directory where binaries are emitted to.
            .dest_dir = std.Build.Step.InstallArtifact.Options.Dir{ .override = .bin },
        },
    );
    b.default_step.dependOn(&install.step);
}
