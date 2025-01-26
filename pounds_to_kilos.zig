const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    try stdout.print("{s}, {s}!\n", .{args[1], "World"});
}
