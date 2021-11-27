const std = @import("std");

pub fn main() void {
    const stdin = std.io.getStdIn().reader();

    var floor: i32 = 0;

    while (stdin.readByte()) |c| {
        if (c == '(') {
            floor += 1;
        } else if (c == ')') {
            floor -= 1;
        }
    } else |_| {}

    std.debug.print("{d}\n", .{floor});
}
