const std = @import("std");

const requirements = [_][]const u8{
    "children: 3",
    "cats: 7",
    "samoyeds: 2",
    "pomeranians: 3",
    "akitas: 0",
    "vizslas: 0",
    "goldfish: 5",
    "trees: 3",
    "cars: 2",
    "perfumes: 1",
};

pub fn main() void {
    const input = @embedFile("16.txt");

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        const first_colon = std.mem.indexOfScalar(u8, line, ':').?;
        const number = line[4..first_colon]; // 'Sue n+:'

        if (matches(line[first_colon + 2 ..])) {
            std.debug.print("{s}\n", .{number});
            return;
        }
    }
}

fn matches(message: []const u8) bool {
    var items = std.mem.split(u8, message, ", ");
    while (items.next()) |item| {
        if (!matchesRequirement(item)) return false;
    } else return true;
}

fn matchesRequirement(item: []const u8) bool {
    for (requirements) |requirement| {
        if (std.mem.eql(u8, item, requirement)) return true;
    } else return false;
}
