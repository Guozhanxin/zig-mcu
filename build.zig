const std = @import("std");

const stm32f4 = std.zig.CrossTarget{
    .cpu_arch = .thumb,
    .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
    .os_tag = .freestanding,
    .abi = .eabihf,
};

pub fn build(b: *std.Build) void {
    const optimize = .ReleaseSmall;
    const target_name = "stm32-zboot";

    const elf = b.addExecutable(.{
        .name = b.fmt("{s}{s}", .{ target_name, ".elf" }),
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(stm32f4),
        .optimize = optimize,
        .strip = false, // do not strip debug symbols
    });

    elf.setLinkerScript(b.path("src/chip/link.lds"));
    elf.addCSourceFile(.{ .file = b.path("src/chip/start.s"), .flags = &.{} });

    // Copy the elf to the output directory.
    const copy_elf = b.addInstallArtifact(elf, .{});
    b.default_step.dependOn(&copy_elf.step);

    // Convert the hex from the elf
    const hex = b.addObjCopy(elf.getEmittedBin(), .{ .format = .hex });
    hex.step.dependOn(&elf.step);
    // Copy the hex to the output directory
    const copy_hex = b.addInstallBinFile(
        hex.getOutput(),
        b.fmt("{s}{s}", .{ target_name, ".hex" }),
    );
    b.default_step.dependOn(&copy_hex.step);

    // Convert the bin form the elf
    const bin = b.addObjCopy(elf.getEmittedBin(), .{ .format = .bin });
    bin.step.dependOn(&elf.step);

    // Copy the bin to the output directory
    const copy_bin = b.addInstallBinFile(
        bin.getOutput(),
        b.fmt("{s}{s}", .{ target_name, ".bin" }),
    );
    b.default_step.dependOn(&copy_bin.step);
}
