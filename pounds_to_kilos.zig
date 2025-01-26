const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const args = try std.process.argsAlloc(std.heap.page_allocator);

    // Do not forget the first argument is the program name
    // Ask for exactly two other arguments
    if (args.len != 3) return error.ExpectedArgument;

    try stdout.print("{s}, {s}!\n", .{args[1], args[2]});
}
