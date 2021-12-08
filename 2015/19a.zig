const std = @import("std");

test "example 1" {
    const input = @embedFile("19a_example_1.txt");
    const result = try run(std.testing.allocator, input);
    try std.testing.expectEqual(@as(usize, 4), result);
}

test "example 2" {
    const input = @embedFile("19a_example_2.txt");
    const result = try run(std.testing.allocator, input);
    try std.testing.expectEqual(@as(usize, 7), result);
}

pub fn main() !void {
    const input = @embedFile("19.txt");
    const result = try run(std.heap.page_allocator, input);
    std.debug.print("{}\n", .{result});
}

fn run(allocator: *std.mem.Allocator, input: []const u8) !usize {
    const last_newline = std.mem.lastIndexOfScalar(u8, input, '\n').?;
    const molecule = input[last_newline + 1 ..];

    var new_molecule = std.ArrayList(u8).init(allocator);
    defer new_molecule.deinit();

    var molecules = std.BufSet.init(allocator);
    defer molecules.deinit();

    var lines = std.mem.split(u8, input[0 .. last_newline - 1], "\n");
    while (lines.next()) |replacement| {
        const first_space = std.mem.indexOfScalar(u8, replacement, ' ').?;
        const last_space = std.mem.lastIndexOfScalar(u8, replacement, ' ').?;
        const from = replacement[0..first_space];
        const to = replacement[last_space + 1 ..];

        var i: usize = 0;
        while (i <= molecule.len - from.len) : (i += 1) {
            if (std.mem.eql(u8, molecule[i .. i + from.len], from)) {
                new_molecule.clearRetainingCapacity();
                try new_molecule.appendSlice(molecule[0..i]);
                try new_molecule.appendSlice(to);
                try new_molecule.appendSlice(molecule[i + from.len ..]);
                try molecules.insert(new_molecule.items);
            }
        }
    }

    return molecules.count();
}
