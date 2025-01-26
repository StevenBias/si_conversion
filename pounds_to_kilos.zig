const std = @import("std");

pub fn main() !void {
    // Add a writter to stdout
    const stdout = std.io.getStdOut().writer();

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    // We can be sure our args' memory is freed when main is returned from
    defer std.process.argsFree(std.heap.page_allocator, args);

    // Do not forget the first argument is the program name
    // Ask for exactly two other arguments
    if (args.len != 3) return error.ExpectedArgument;

    try stdout.print("{s}, {s}!\n", .{args[1], args[2]});
}
