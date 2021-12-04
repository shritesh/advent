const std = @import("std");

const format = std.fmt.format;
const swap = std.mem.swap;
const CharList = std.ArrayList(u8);

test "example" {
    const allocator = std.testing.allocator;

    var number = CharList.init(allocator);
    defer number.deinit();

    var result = CharList.init(allocator);
    defer result.deinit();

    try number.appendSlice("1");

    var i: usize = 0;
    while (i < 5) : (i += 1) {
        try explode(number.items, &result);
        swap(CharList, &number, &result);
    }

    try std.testing.expectEqualSlices(u8, "312211", number.items);
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var number = CharList.init(allocator);
    defer number.deinit();

    var result = CharList.init(allocator);
    defer result.deinit();

    try number.appendSlice("1113222113");

    var i: usize = 0;
    while (i < 50) : (i += 1) {
        try explode(number.items, &result);
        swap(CharList, &number, &result);
    }

    std.debug.print("{}\n", .{number.items.len});
}

fn explode(input: []const u8, result: *CharList) !void {
    result.clearRetainingCapacity();
    const writer = result.writer();

    var last = input[0];
    var running_length: usize = 1;

    if (input.len == 1) {
        try format(writer, "{}{c}", .{ running_length, last });
        return;
    }

    for (input[1..]) |c| {
        if (c == last) {
            running_length += 1;
            continue;
        }

        try format(writer, "{}{c}", .{ running_length, last });

        last = c;
        running_length = 1;
    } else try format(writer, "{}{c}", .{ running_length, last });
}
