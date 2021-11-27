const std = @import("std");
const min = std.math.min;
const min3 = std.math.min3;

const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var total: u64 = 0;

    while (readInt('x')) |l| {
        const w = try readInt('x');
        const h = try readInt('\n');

        var a: u32 = undefined;
        var b: u32 = undefined;

        if (min3(l, w, h) == l) {
            a = l;
            b = min(w, h);
        } else if (min3(l, w, h) == w) {
            a = w;
            b = min(l, h);
        } else {
            a = h;
            b = min(l, w);
        }

        total += a + a + b + b;
        total += l * w * h;
    } else |_| {}

    std.debug.print("{}\n", .{total});
}

fn readInt(delimiter: u8) !u32 {
    var buffer: [4]u8 = undefined;
    const input = (try stdin.readUntilDelimiterOrEof(&buffer, delimiter)) orelse return error.EndOfStream;
    return std.fmt.parseInt(u32, input, 10);
}
