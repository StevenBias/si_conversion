const std = @import("std");

fn pounds_to_kilos(pounds: f32) f32 {
    return pounds * 0.45359237;
}

pub fn main() !void {
    // Add a writter to stdout
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    const Units = enum(u8) {pounds = 1};

    try stdout.print("{s}\n", .{
        \\Select the unit you want to convert:
        \\
        \\[1] - pounds
        \\
    });

    var input_unit: [3]u8 = undefined;
    const in_unit = try stdin.readUntilDelimiter(&input_unit, '\n');
    const unit = try std.fmt.parseInt(u8, in_unit, 10);

    if(unit == @intFromEnum(Units.pounds)) {

        try stdout.print("\nPlease enter a value in {s}: ", .{@tagName(Units.pounds)});

        var input: [20]u8 = undefined;
        const in = try stdin.readUntilDelimiter(&input, '\n');
        const pounds = try std.fmt.parseFloat(f32, in);
        const kilos = pounds_to_kilos(pounds);

        try stdout.print("\n{d} lb = {d:.2} kg\n", .{pounds, kilos});
    } 

    try stdout.print("{s}\n", .{"ByeBye!"});
}
