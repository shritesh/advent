const std = @import("std");

const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var buffer: [16]u8 = undefined;

    var count: usize = 0;

    while (stdin.readUntilDelimiterOrEof(&buffer, '\n')) |input| {
        const word = input orelse break;
        if (pairAtLeastTwice(word) and letterRepeatBetween(word))
            count += 1;
    } else |_| {}

    std.debug.print("{}\n", .{count});
}

fn pairAtLeastTwice(word: []const u8) bool {
    var i: usize = 0;
    while (i < word.len - 2) : (i += 1) {
        var j = i + 2;
        while (j < word.len - 1) : (j += 1) {
            if (word[i] == word[j] and word[i + 1] == word[j + 1]) return true;
        }
    }
    return false;
}

fn letterRepeatBetween(word: []const u8) bool {
    for (word[2..]) |c, i| if (c == word[i]) return true;
    return false;
}
