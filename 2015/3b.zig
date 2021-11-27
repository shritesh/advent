const std = @import("std");

const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var visited = std.AutoHashMap([2]i32, void).init(std.heap.page_allocator);
    defer visited.deinit();

    var santa = [_]i32{ 0, 0 };
    var robot = [_]i32{ 0, 0 };

    try visited.put(santa, {});
    var real = true;

    while (stdin.readByte()) |c| {
        var current = &santa;

        if (!real) {
            current = &robot;
        }

        switch (c) {
            '>' => current[0] += 1,
            '<' => current[0] -= 1,
            '^' => current[1] -= 1,
            'v' => current[1] += 1,
            else => continue,
        }
        try visited.put(current.*, {});
        real = !real;
    } else |_| {}

    std.debug.print("{d}\n", .{visited.count()});
}
