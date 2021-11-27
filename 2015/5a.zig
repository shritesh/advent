const std = @import("std");

const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var buffer: [16]u8 = undefined;

    var count: usize = 0;

    while (stdin.readUntilDelimiterOrEof(&buffer, '\n')) |input| {
        const word = input orelse break;
        if (atLeastThreeVowels(word) and twiceInARow(word) and doesNotContain(word))
            count += 1;
    } else |_| {}

    std.debug.print("{}\n", .{count});
}

fn atLeastThreeVowels(word: []const u8) bool {
    var count: usize = 0;
    for (word) |char| switch (char) {
        'a', 'e', 'i', 'o', 'u' => {
            count += 1;
            if (count >= 3) {
                return true;
            }
        },
        else => {},
    };
    return false;
}

fn twiceInARow(word: []const u8) bool {
    var last = word[0];
    for (word[1..]) |c| {
        if (c == last) {
            return true;
        }
        last = c;
    }
    return false;
}

fn doesNotContain(word: []const u8) bool {
    for (word[1..]) |c, i| switch (word[i]) {
        'a', 'c', 'p', 'x' => if (c == word[i] + 1) return false,
        else => {},
    };

    return true;
}
