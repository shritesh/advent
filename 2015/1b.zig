const std = @import("std");

pub fn main() void {
    const stdin = std.io.getStdIn().reader();

    var floor: i32 = 0;
    var idx: usize = 0;

    while (stdin.readByte()) |c| {
        idx += 1;

        if (c == '(') {
            floor += 1;
        } else if (c == ')') {
            floor -= 1;
        }

        if (floor == -1) {
            std.debug.print("{d}\n", .{idx});
            return;
        }
    } else |_| {}
    std.debug.print("Not found\n", .{});
}
