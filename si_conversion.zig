const std = @import("std");

fn pounds_to_kilos(pounds: f32) f32 {
    return pounds * 0.45359237;
}

pub fn main() !void {
    // Add a writter to stdout
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    // const args = try std.process.argsAlloc(std.heap.page_allocator);
    // We can be sure our args' memory is freed when main is returned from
    // defer std.process.argsFree(std.heap.page_allocator, args);

    // Do not forget the first argument is the program name
    // Ask for exactly one other arguments
    // if (args.len != 2) return error.ExpectedArgument;

    try stdout.print("{s}\n", .{"Please enter a value pounds:"});

    var input: [20]u8 = undefined;
    const in = try stdin.readUntilDelimiter(&input, '\n');
    const pounds = try std.fmt.parseFloat(f32, in);
    const kilos = pounds_to_kilos(pounds);

    try stdout.print("{d} lb = {d:.2} kg\n", .{pounds, kilos});
}
