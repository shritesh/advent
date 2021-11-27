const std = @import("std");

const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var visited = std.AutoHashMap([2]i32, void).init(std.heap.page_allocator);
    defer visited.deinit();

    var coordinate = [_]i32{ 0, 0 };
    try visited.put(coordinate, {});

    while (stdin.readByte()) |c| {
        switch (c) {
            '>' => coordinate[0] += 1,
            '<' => coordinate[0] -= 1,
            '^' => coordinate[1] -= 1,
            'v' => coordinate[1] += 1,
            else => continue,
        }
        try visited.put(coordinate, {});
    } else |_| {}

    std.debug.print("{d}\n", .{visited.count()});
}
