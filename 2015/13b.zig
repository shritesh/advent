const std = @import("std");

pub fn main() !void {
    const input = @embedFile("13.txt");
    const result = try run(input);
    std.debug.print("{}\n", .{result});
}

fn run(input: []const u8) !i32 {
    var arrangement = Arrangement{};

    var lines = std.mem.tokenize(u8, input, ".\n");
    while (lines.next()) |line| {
        var tokens = std.mem.tokenize(u8, line, " ");

        var person1 = tokens.next() orelse return error.ParseError;
        _ = tokens.next() orelse return error.ParseError; // would
        var change = tokens.next() orelse return error.ParseError;
        var amount = tokens.next() orelse return error.ParseError;

        var skip: usize = 0;
        while (skip < 6) : (skip += 1) { // happiness units by sitting next to
            _ = tokens.next() orelse return error.ParseError;
        }

        var person2 = tokens.next() orelse return error.ParseError;

        var happiness: i16 = undefined;
        if (std.mem.eql(u8, change, "gain")) {
            happiness = try std.fmt.parseInt(i16, amount, 10);
        } else if (std.mem.eql(u8, change, "lose")) {
            happiness = -try std.fmt.parseInt(i16, amount, 10);
        } else return error.ParseError;

        arrangement.addRule(person1, person2, happiness);
        arrangement.addRule("SHRITESH", person1, 0);
        arrangement.addRule("SHRITESH", person2, 0);
    }

    return arrangement.maximumHappiness();
}

const Arrangement = struct {
    count: usize = 0,
    rules: [64]Rule = undefined,

    const Rule = struct {
        people: [2][]const u8,
        happiness: i16,
    };

    fn findRule(self: *Arrangement, person1: []const u8, person2: []const u8) ?*Rule {
        for (self.rules[0..self.count]) |*rule| {
            if ((std.mem.eql(u8, rule.people[0], person1) and std.mem.eql(u8, rule.people[1], person2)) or (std.mem.eql(u8, rule.people[1], person1) and std.mem.eql(u8, rule.people[0], person2)))
                return rule;
        } else return null;
    }

    fn addRule(self: *Arrangement, person1: []const u8, person2: []const u8, happiness: i16) void {
        if (self.findRule(person1, person2)) |rule| {
            rule.happiness += happiness;
        } else {
            self.rules[self.count] = Rule{
                .people = .{ person1, person2 },
                .happiness = happiness,
            };
            self.count += 1;
        }
    }

    fn countHappiness(self: *Arrangement, order: [][]const u8) i32 {
        var total: i32 = self.findRule(order[0], order[order.len - 1]).?.happiness;
        for (order[0 .. order.len - 1]) |person1, i| {
            const person2 = order[i + 1];
            total += self.findRule(person1, person2).?.happiness;
        }
        return total;
    }

    fn maximumHappiness(self: *Arrangement) i32 {
        var order: [32][]const u8 = undefined;
        var count: usize = 0;
        for (self.rules[0..self.count]) |rule| {
            for (rule.people) |person| {
                for (order[0..count]) |o| {
                    if (std.mem.eql(u8, o, person)) break;
                } else {
                    order[count] = person;
                    count += 1;
                }
            }
        }
        var maximum = ~@as(i32, 0);
        self.permuteMaximumHappiness(&maximum, order[0..count], 0);
        return maximum;
    }

    fn permuteMaximumHappiness(self: *Arrangement, maximum: *i32, order: [][]const u8, i: usize) void {
        if (i == order.len) {
            const total = self.countHappiness(order);
            maximum.* = @maximum(maximum.*, total);
        }

        for (order[i..]) |*j| {
            std.mem.swap([]const u8, &order[i], j);
            self.permuteMaximumHappiness(maximum, order, i + 1);
            std.mem.swap([]const u8, &order[i], j);
        }
    }
};
