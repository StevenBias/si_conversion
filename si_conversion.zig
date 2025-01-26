const std = @import("std");

// Add a writter to stdout
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

const Units = enum(u8) {
    pounds = 1,
    kilograms = 2,
    fahrenheit = 3,
    max
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
                .unit = unit,
                .symbol = "lb",
                .conv_symbol = "kg",
            };
        },
        Units.kilograms => {
            return Unit_t {
                .unit = unit,
                .symbol = "kg",
                .conv_symbol = "lb",
            };
        },
        Units.fahrenheit => {
            return Unit_t {
                .unit = unit,
                .symbol = "°F",
                .conv_symbol = "°C",
            };
        },
        else => unreachable,
    }
}

const lb_kg_conversion = 0.45359237;

fn fahrenheit_to_celsius(fahr: f32) f32 {
    return (fahr - 32) * (5.0 / 9.0);
}

fn kilos_to_pounds(kilos: f32) f32 {
    return (kilos / lb_kg_conversion);
}

fn pounds_to_kilos(pounds: f32) f32 {
    return pounds * lb_kg_conversion;
}

// @brief Function to initial the correct structure accordind 'sel' choosed by
//        the user, get the value to be converted, do the conversion and print
//        the result
fn convert(sel: u8) !void {

    const unit = new_unit(@enumFromInt(sel));
    try stdout.print("\nPlease enter a value in {s}: ", .{@tagName(unit.unit)});

    var input: [20]u8 = undefined;
    const in = try stdin.readUntilDelimiter(&input, '\n');
    const in_val = std.fmt.parseFloat(f32, in) catch -1;

    if (in_val != -1) {
        var out_val: f32 = undefined;

        switch (unit.unit) {
            Units.pounds => {
                out_val = pounds_to_kilos(in_val);
            },
            Units.kilograms => {
                out_val = kilos_to_pounds(in_val);
            },
            Units.fahrenheit => {
                out_val = fahrenheit_to_celsius(in_val);
            },
            else => unreachable,
        }

        try stdout.print("\n{d} {s} = {d:.3} {s}\n", .{in_val, unit.symbol, out_val, unit.conv_symbol});
    } 
    else {
        try stdout.print("{s}\n", .{"Sorry, invalid input."});
    }

}

pub fn main() !void {
    try stdout.print("{s}\n", .{
        \\Select the unit you want to convert:
        \\
        \\[1] - pounds to kilograms
        \\[2] - kilograms to pounds
        \\[3] - fahrenheit to celsius
        \\
    });

    var input_unit: [10]u8 = undefined;
    const in_unit = try stdin.readUntilDelimiter(&input_unit, '\n');
    const sel: u8 = std.fmt.parseInt(u8, in_unit, 10) catch @intFromEnum(Units.max);

    if (sel > 0 and sel < @intFromEnum(Units.max)) {
        try convert (sel);
    } 
    else {
        try stdout.print("{s}\n", .{"Sorry, invalid input."});
    }

    try stdout.print("{s}\n", .{"ByeBye!"});
}
