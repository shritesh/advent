const std = @import("std");

test "example" {
    const expectEqual = std.testing.expectEqual;
    var allocator = std.testing.allocator;

    const e0 =
        \\[1,{"c":"red","b":2},3]
    ;

    const e1 =
        \\{"d":"red","e":[1,2,3,4],"f":5}
    ;

    const e2 =
        \\[1,"red",5]
    ;

    try expectEqual(@as(i64, 6), try run(allocator, "[1,2,3]"));
    try expectEqual(@as(i64, 4), try run(allocator, e0));
    try expectEqual(@as(i64, 0), try run(allocator, e1));
    try expectEqual(@as(i64, 6), try run(allocator, e2));
}

pub fn main() !void {
    const input = @embedFile("12.txt");
    const result = try run(std.heap.page_allocator, input);
    std.debug.print("{}\n", .{result});
}

fn run(allocator: *std.mem.Allocator, input: []const u8) !i64 {
    var parser = std.json.Parser.init(allocator, false);
    defer parser.deinit();

    var tree = try parser.parse(input);
    defer tree.deinit();

    return calculate(tree.root);
}

fn calculate(value: std.json.Value) i64 {
    return switch (value) {
        .Integer => |i| i,
        .Float => |f| @floatToInt(i64, f),
        .Array => |a| blk: {
            var sum: i64 = 0;
            for (a.items) |v| sum += calculate(v);
            break :blk sum;
        },
        .Object => |o| blk: {
            var sum: i64 = 0;
            for (o.values()) |v| switch (v) {
                .String => |s| if (std.mem.eql(u8, s, "red")) break :blk 0,
                else => sum += calculate(v),
            };
            break :blk sum;
        },
        else => 0,
    };
}
