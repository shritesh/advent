const std = @import("std");

const Requirement = struct {
    item: []const u8,
    num: u16,

    fn parse(input: []const u8) Requirement {
        const first_colon = std.mem.indexOfScalar(u8, input, ':').?;

        const item = input[0..first_colon];
        const num = std.fmt.parseInt(u16, input[first_colon + 2 ..], 10) catch unreachable;

        return Requirement{ .item = item, .num = num };
    }
};

const requirements = [_]Requirement{
    Requirement.parse("children: 3"),
    Requirement.parse("cats: 7"),
    Requirement.parse("samoyeds: 2"),
    Requirement.parse("pomeranians: 3"),
    Requirement.parse("akitas: 0"),
    Requirement.parse("vizslas: 0"),
    Requirement.parse("goldfish: 5"),
    Requirement.parse("trees: 3"),
    Requirement.parse("cars: 2"),
    Requirement.parse("perfumes: 1"),
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
    const req = Requirement.parse(item);
    for (requirements) |requirement| {
        if (std.mem.eql(u8, req.item, requirement.item)) {
            if (std.mem.eql(u8, req.item, "cats") or std.mem.eql(u8, req.item, "trees")) {
                return req.num > requirement.num;
            } else if (std.mem.eql(u8, req.item, "pomeranians") or std.mem.eql(u8, req.item, "goldfish")) {
                return req.num < requirement.num;
            } else return req.num == requirement.num;
        }
    } else return false;
}
