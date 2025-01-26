const std = @import("std");

pub fn main() !void {
    // Add a writter to stdout
    const stdout = std.io.getStdOut().writer();

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    // We can be sure our args' memory is freed when main is returned from
    defer std.process.argsFree(std.heap.page_allocator, args);

    // Do not forget the first argument is the program name
    // Ask for exactly one other arguments
    if (args.len != 2) return error.ExpectedArgument;

    const pounds = try std.fmt.parseFloat(f32, args[1]);
    try stdout.print("{} lb\n", .{pounds});
}
