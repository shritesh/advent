const std = @import("std");

test "example" {
    const input = @embedFile("14_example.txt");
    const result1 = try run(input, 1);
    const result140 = try run(input, 140);
    const result1000 = try run(input, 1000);

    try std.testing.expectEqual(@as(u16, 1), result1);
    try std.testing.expectEqual(@as(u16, 139), result140);
    try std.testing.expectEqual(@as(u16, 689), result1000);
}

pub fn main() !void {
    const input = @embedFile("14.txt");
    const result = try run(input, 2503);
    std.debug.print("{}\n", .{result});
}

const Reindeer = struct {
    speed: u8,
    flight: u8,
    rest: u8,
    distance: u16,
    state: State,
    points: u16,

    const State = union(enum) { flying: u8, resting: u8 };

    fn init(speed: u8, flight: u8, rest: u8) Reindeer {
        return Reindeer{
            .speed = speed,
            .flight = flight,
            .rest = rest,
            .distance = 0,
            .state = State{ .flying = flight },
            .points = 0,
        };
    }

    fn next(self: *Reindeer) void {
        switch (self.state) {
            .flying => |*remaining| {
                self.distance += self.speed;
                remaining.* -= 1;
                if (remaining.* == 0) self.state = State{ .resting = self.rest };
            },
            .resting => |*remaining| {
                remaining.* -= 1;
                if (remaining.* == 0) self.state = State{ .flying = self.flight };
            },
        }
    }

    fn award(self: *Reindeer, max_distance: u16) void {
        if (self.distance == max_distance) self.points += 1;
    }
};

fn run(input: []const u8, seconds: u16) !u16 {
    var reindeers: [16]Reindeer = undefined;
    var count: usize = 0;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        var tokens = std.mem.tokenize(u8, line, " ");

        var skip: usize = 0;
        while (skip < 3) : (skip += 1) _ = tokens.next() orelse return error.ParseError; // Reindeer can fly
        var speed = tokens.next() orelse return error.ParseError;
        _ = tokens.next() orelse return error.ParseError; // km/s
        _ = tokens.next() orelse return error.ParseError; // for
        var duration = tokens.next() orelse return error.ParseError;
        skip = 0;
        while (skip < 6) : (skip += 1) _ = tokens.next() orelse return error.ParseError; // seconds, but then must rest for
        var rest = tokens.next() orelse return error.ParseError;
        _ = tokens.next() orelse return error.ParseError; // seconds.

        var reindeer = Reindeer.init(
            try std.fmt.parseInt(u8, speed, 10),
            try std.fmt.parseInt(u8, duration, 10),
            try std.fmt.parseInt(u8, rest, 10),
        );

        reindeers[count] = reindeer;
        count += 1;
    }

    var max_distance: u16 = 0;
    var second: usize = 0;
    while (second < seconds) : (second += 1) {
        for (reindeers[0..count]) |*r| {
            r.next();
            max_distance = @maximum(max_distance, r.distance);
        }
        for (reindeers[0..count]) |*r| {
            r.award(max_distance);
        }
    }

    var max_points: u16 = 0;
    for (reindeers[0..count]) |r| {
        max_points = @maximum(max_points, r.points);
    }

    return max_points;
}
