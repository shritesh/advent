const std = @import("std");

test "example" {
    const input = @embedFile("14_example.txt");
    const result1 = try run(input, 1);
    const result10 = try run(input, 10);
    const result1000 = try run(input, 1000);

    try std.testing.expectEqual(@as(u16, 16), result1);
    try std.testing.expectEqual(@as(u16, 160), result10);
    try std.testing.expectEqual(@as(u16, 1120), result1000);
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

    const State = union(enum) { flying: u8, resting: u8 };

    fn init(speed: u8, flight: u8, rest: u8) Reindeer {
        return Reindeer{
            .speed = speed,
            .flight = flight,
            .rest = rest,
            .distance = 0,
            .state = State{ .flying = flight },
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
};

fn run(input: []const u8, seconds: u16) !u16 {
    var max_distance: u16 = 0;

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

        var second: usize = 0;
        while (second < seconds) : (second += 1) {
            reindeer.next();
        }

        max_distance = @maximum(max_distance, reindeer.distance);
    }

    return max_distance;
}
