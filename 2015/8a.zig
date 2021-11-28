const std = @import("std");
const print = std.debug.print;

const stdin = std.io.getStdIn().reader();

fn countChars(string: []const u8) usize {
    if (string[0] != '"' or string[string.len - 1] != '"') unreachable;
    var count: usize = 0;
    var idx: usize = 1;

    while (idx < string.len - 1) : (idx += 1) {
        count += 1;

        if (string[idx] == '\\') {
            if (idx + 1 >= string.len - 1) unreachable;

            if (string[idx + 1] == '\\' or string[idx + 1] == '\"') {
                idx += 1;
            } else if (string[idx + 1] == 'x') {
                if (idx + 1 + 2 >= string.len - 1) unreachable;
                idx += 3;
            }
        }
    }

    return count;
}

pub fn main() !void {
    var buffer: [50]u8 = undefined;

    var total: usize = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        total += line.len - countChars(line);
    }

    print("{}\n", .{total});
}
