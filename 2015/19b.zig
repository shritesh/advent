const std = @import("std");

pub fn main() !void {
    var input = @embedFile("19.txt").*;
    const result = try run(std.heap.page_allocator, &input);
    std.debug.print("{}\n", .{result});
}

fn run(allocator: *std.mem.Allocator, input: []u8) !usize {
    var molecule = std.ArrayList(u8).init(allocator);
    defer molecule.deinit();

    var replacements = std.ArrayList([2][]const u8).init(allocator);
    defer replacements.deinit();

    // Copy and reverse molecule
    const last_newline = std.mem.lastIndexOfScalar(u8, input, '\n').?;
    try molecule.appendSlice(input[last_newline + 1 ..]);
    std.mem.reverse(u8, molecule.items);

    // Reverse all replacements
    var start: usize = 0;
    for (input) |c, i| {
        if (c == '\n') {
            std.mem.reverse(u8, input[start..i]);
            start = i + 1;
        }
    }

    var lines = std.mem.split(u8, input[0 .. last_newline - 1], "\n");
    while (lines.next()) |replacement| {
        const first_space = std.mem.indexOfScalar(u8, replacement, ' ').?;
        const last_space = std.mem.lastIndexOfScalar(u8, replacement, ' ').?;
        var from = replacement[0..first_space];
        var to = replacement[last_space + 1 ..];

        try replacements.append([2][]const u8{ from, to });
    }

    var count: usize = 0;
    while (molecule.items[0] != 'e') : (count += 1)
        try replaceOne(&molecule, replacements);

    return count;
}

fn replaceOne(molecule: *std.ArrayList(u8), replacements: std.ArrayList([2][]const u8)) !void {
    var i: usize = 0;
    while (i < molecule.items.len) : (i += 1) {
        for (replacements.items) |replacement| {
            if (replacement[0].len > molecule.items.len - i) continue;
            if (std.mem.eql(u8, replacement[0], molecule.items[i .. i + replacement[0].len])) {
                try molecule.replaceRange(i, replacement[0].len, replacement[1]);
                return;
            }
        }
    } else unreachable;
}
