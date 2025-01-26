const std = @import("std");

const Units = enum(u8) {
    pounds = 1,
    kilograms = 2,
};

const Unit_t = struct {
    unit: Units,
    symbol: []const u8,
    conv_symbol: []const u8,
};

fn new_unit(unit: Units) Unit_t {
    switch(unit) {
        Units.pounds => {
            return Unit_t {
                .unit = Units.pounds,
                .symbol = "lb",
                .conv_symbol = "kg",
            };
        },
        else => unreachable,
    }
}

const lb_kg_conversion = 0.45359237;

fn pounds_to_kilos(pounds: f32) f32 {
    return pounds * lb_kg_conversion;
}

pub fn main() !void {
    // Add a writter to stdout
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("{s}\n", .{
        \\Select the unit you want to convert:
        \\
        \\[1] - pounds to kilograms
        \\
    });

    var ttt: Unit_t = undefined;
    var input_unit: [3]u8 = undefined;
    const in_unit = try stdin.readUntilDelimiter(&input_unit, '\n');
    const unit = try std.fmt.parseInt(u8, in_unit, 10);

    switch (unit) {
        @intFromEnum(Units.pounds) => {
            ttt = new_unit(Units.pounds);
            try stdout.print("\nPlease enter a value in {s}: ", .{@tagName(ttt.unit)});

            var input: [20]u8 = undefined;
            const in = try stdin.readUntilDelimiter(&input, '\n');
            const pounds = try std.fmt.parseFloat(f32, in);

            const kilos = pounds_to_kilos(pounds);

            try stdout.print("\n{s}\n", .{ttt.symbol});
            try stdout.print("\n{d} {s} = {d:.3} {s}\n", .{pounds, ttt.symbol, kilos, ttt.conv_symbol});
        },
        else => {},
    } 

    try stdout.print("{s}\n", .{"ByeBye!"});
}
