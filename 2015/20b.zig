const std = @import("std");

pub fn main() !void {
    const result = try house(std.heap.page_allocator, 33100000);
    std.debug.print("{}\n", .{result});
}

fn house(allocator: *std.mem.Allocator, presents: usize) !usize {
    const n = presents / 10;
    var houses = try allocator.alloc(usize, n + 1);
    defer allocator.free(houses);

    std.mem.set(usize, houses, 0);

    var i: usize = 1;
    while (i <= n) : (i += 1) {
        var j: usize = i;
        var c: usize = 0;
        while (j <= n) : (j += i) {
            houses[j] += i * 11;
            c += 1;
            if (c == 50) break;
        }
    }

    for (houses) |h, k| {
        if (h >= presents) return k;
    } else unreachable;
}
