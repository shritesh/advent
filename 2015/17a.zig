const std = @import("std");

test "example" {
    const containers = [_]u8{ 20, 15, 10, 5, 5 };
    const result = run(&containers, 25);
    try std.testing.expectEqual(@as(usize, 4), result);
}

pub fn main() void {
    const containers = [_]u8{ 50, 44, 11, 49, 42, 46, 18, 32, 26, 40, 21, 7, 18, 43, 10, 47, 36, 24, 22, 40 };
    const result = run(&containers, 150);
    std.debug.print("{}\n", .{result});
}

fn run(comptime containers: []const u8, total: u16) usize {
    var order: [containers.len]u8 = undefined;

    var count = @as(usize, 0);

    var capacity: usize = 1;
    while (capacity <= containers.len) : (capacity += 1) {
        combination(containers, total, order[0..capacity], &count, 0, 0);
    }

    return count;
}

fn combination(containers: []const u8, total: u16, order: []u8, count: *usize, i: usize, j: usize) void {
    if (i == order.len) {
        var sum: usize = 0;
        for (order) |o| sum += o;
        if (sum == total) count.* += 1;
        return;
    }

    if (j == containers.len) return;

    order[i] = containers[j];
    combination(containers, total, order, count, i + 1, j + 1);
    combination(containers, total, order, count, i, j + 1);
}
