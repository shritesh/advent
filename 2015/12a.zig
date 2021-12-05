const std = @import("std");
const expectEqual = std.testing.expectEqual;

test "example" {
    const e0 =
        \\{"a":2,"b":4}
    ;

    const e1 =
        \\{"a":{"b":4},"c":-1}
    ;

    const e2 =
        \\"a":[-1,1]}
    ;

    const e3 =
        \\[-1,{"a":1}]
    ;

    try expectEqual(@as(i64, 6), try run("[1,2,3]"));
    try expectEqual(@as(i64, 6), try run(e0));
    try expectEqual(@as(i64, 3), try run("[[[3]]]"));
    try expectEqual(@as(i64, 3), try run(e1));
    try expectEqual(@as(i64, 0), try run(e2));
    try expectEqual(@as(i64, 0), try run(e3));
    try expectEqual(@as(i64, 0), try run("[]"));
    try expectEqual(@as(i64, 0), try run("{}"));
}

pub fn main() !void {
    const input = @embedFile("12.txt");
    const result = try run(input);
    std.debug.print("{}\n", .{result});
}

fn run(input: []const u8) !i64 {
    var sum: i64 = 0;
    var start: ?usize = null;

    for (input) |c, i| {
        if (start) |s| {
            if (!isDigit(c)) {
                sum += try std.fmt.parseInt(i64, input[s..i], 10);
                start = null;
            }
        } else if (isDigit(c) or c == '-') start = i;
    }

    return sum;
}

inline fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}
