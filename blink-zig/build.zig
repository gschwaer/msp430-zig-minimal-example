const std = @import("std");

pub fn build(b: *std.Build) !void {
    const cross_target = try std.Target.Query.parse(.{
        .arch_os_abi = "msp430-freestanding-none", // `freestanding` = No OS, `none` = No C ABI
    });
    const exe = b.addExecutable(.{
        .name = "blink.bin",
        .root_source_file = .{ .path = "blink.zig" },
        .target = std.Build.resolveTargetQuery(b, cross_target),
        .optimize = std.builtin.Mode.ReleaseSmall, // for clear assembly
    });
    exe.setLinkerScript(.{ .path = "link.ld" });
    const install = b.addInstallArtifact(exe, .{
        .dest_dir = .{
            .override = .{
                .custom = "../", // this is the parent directory of ./zig-out, which really is ./
            },
        },
    });
    b.getInstallStep().dependOn(&install.step);
}
