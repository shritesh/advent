const std = @import("std");
const print = std.debug.print;

const stdin = std.io.getStdIn().reader();

fn encodeChars(string: []const u8) usize {
    var count: usize = 2; // Enclosing quotes

    for (string) |c| {
        count += 1;
        if (c == '"') count += 1; // \"
        if (c == '\\') count += 1; // \\
    }
    return count;
}

pub fn main() !void {
    var buffer: [50]u8 = undefined;

    var total: usize = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        total += encodeChars(line) - line.len;
    }

    print("{}\n", .{total});
}
