const std = @import("std");

const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var total: u64 = 0;

    while (readInt('x')) |l| {
        const w = try readInt('x');
        const h = try readInt('\n');

        const first = l * w;
        const second = w * h;
        const third = h * l;

        total += 2 * first + 2 * second + 2 * third;
        total += std.math.min3(first, second, third);
    } else |_| {}

    std.debug.print("{}\n", .{total});
}

fn readInt(delimiter: u8) !u32 {
    var buffer: [4]u8 = undefined;
    const input = (try stdin.readUntilDelimiterOrEof(&buffer, delimiter)) orelse return error.EndOfStream;
    return std.fmt.parseInt(u32, input, 10);
}
