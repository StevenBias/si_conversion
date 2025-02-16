const std = @import("std");

const floatMax = std.math.floatMax(f32);

// Add a writter to stdout
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

// zig fmt: off
const Units = enum(u8) {
    pounds = 1,
    kilograms = 2,
    fahrenheit = 3,
    celsius = 4,
    feet = 5,
    centimeters = 6,
    yards = 7,
    meters = 8,
    miles = 9,
    kilometers = 10,
    max
};
// zig fmt: on

const Unit_t = struct {
    unit: Units,
    symbol: []const u8,
    conv_symbol: []const u8,
};

fn new_unit(unit: Units) Unit_t {
    switch (unit) {
        Units.pounds => {
            return Unit_t{
                .unit = unit,
                .symbol = "lb",
                .conv_symbol = "kg",
            };
        },
        Units.kilograms => {
            return Unit_t{
                .unit = unit,
                .symbol = "kg",
                .conv_symbol = "lb",
            };
        },
        Units.fahrenheit => {
            return Unit_t{
                .unit = unit,
                .symbol = "°F",
                .conv_symbol = "°C",
            };
        },
        Units.celsius => {
            return Unit_t{
                .unit = unit,
                .symbol = "°C",
                .conv_symbol = "°F",
            };
        },
        Units.feet => {
            return Unit_t{
                .unit = unit,
                .symbol = "ft",
                .conv_symbol = "cm",
            };
        },
        Units.centimeters => {
            return Unit_t{
                .unit = unit,
                .symbol = "cm",
                .conv_symbol = "ft",
            };
        },
        Units.yards => {
            return Unit_t{
                .unit = unit,
                .symbol = "yd",
                .conv_symbol = "m",
            };
        },
        Units.meters => {
            return Unit_t{
                .unit = unit,
                .symbol = "m",
                .conv_symbol = "yd",
            };
        },
        Units.miles => {
            return Unit_t{
                .unit = unit,
                .symbol = "mi",
                .conv_symbol = "km",
            };
        },
        Units.kilometers => {
            return Unit_t{
                .unit = unit,
                .symbol = "km",
                .conv_symbol = "mi",
            };
        },
        else => unreachable,
    }
}

const lb_kg_conversion = 0.45359237;
const ft_cm_conversion = 30.48;
const yt_m_conversion = 0.9144;
const mi_km_conversion = 1.609344;

fn kilometers_to_miles(km: f32) f32 {
    return (km / mi_km_conversion);
}

fn miles_to_kilometers(miles: f32) f32 {
    return (miles * mi_km_conversion);
}

fn meters_to_yards(meters: f32) f32 {
    return (meters / yt_m_conversion);
}

fn yards_to_meters(yards: f32) f32 {
    return (yards * yt_m_conversion);
}

fn centimeters_to_feet(centimeters: f32) f32 {
    return (centimeters / ft_cm_conversion);
}

fn feet_to_centimeters(feet: f32) f32 {
    return (feet * ft_cm_conversion);
}

fn celsius_to_fahrenheit(cels: f32) f32 {
    return (cels * (9.0 / 5.0) + 32);
}

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
    const in_val = std.fmt.parseFloat(f32, in) catch floatMax;

    if (in_val != floatMax) {
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
            Units.celsius => {
                out_val = celsius_to_fahrenheit(in_val);
            },
            Units.feet => {
                out_val = feet_to_centimeters(in_val);
            },
            Units.centimeters => {
                out_val = centimeters_to_feet(in_val);
            },
            Units.yards => {
                out_val = yards_to_meters(in_val);
            },
            Units.meters => {
                out_val = meters_to_yards(in_val);
            },
            Units.miles => {
                out_val = miles_to_kilometers(in_val);
            },
            Units.kilometers => {
                out_val = kilometers_to_miles(in_val);
            },
            else => unreachable,
        }
        // zig fmt: off
        try stdout.print("\n{d} {s} = {d:.3} {s}\n", .{
            in_val, unit.symbol, out_val, unit.conv_symbol
        });
        // zig fmt: on
    } else {
        try stdout.print("{s}\n", .{"Sorry, invalid input."});
    }
}

pub fn main() !void {
    try stdout.print("{s}\n", .{
        \\Select the unit you want to convert:
        \\
        \\[1]  - pounds to kilograms
        \\[2]  - kilograms to pounds
        \\[3]  - fahrenheit to celsius
        \\[4]  - celsius to fahrenheit
        \\[5]  - feet to centimeters
        \\[6]  - centimeters to feet
        \\[7]  - yards to meters
        \\[8]  - meters to yards
        \\[9]  - miles to kilometers
        \\[10] - kilometers to miles
        \\
    });

    var input_unit: [10]u8 = undefined;
    const in_unit = try stdin.readUntilDelimiter(&input_unit, '\n');
    const sel: u8 = std.fmt.parseInt(u8, in_unit, 10) catch @intFromEnum(Units.max);

    if (sel > 0 and sel < @intFromEnum(Units.max)) {
        try convert(sel);
    } else {
        try stdout.print("{s}\n", .{"Sorry, invalid input."});
    }

    try stdout.print("{s}\n", .{"ByeBye!"});
}
