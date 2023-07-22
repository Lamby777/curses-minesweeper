const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable(.{
        .name = "cursesminesweeper",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = "src/main.zig" },
        .optimize = .ReleaseSafe,
    });

    exe.linkLibC();
    exe.linkSystemLibrary("ncursesw");
    exe.addIncludePath(".");

    const clap_module = b.createModule(.{
        .source_file = .{ .path = "./zig-clap/clap.zig" },
    });
    exe.addModule("zig-clap", clap_module);

    const run_cmd = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);
}
