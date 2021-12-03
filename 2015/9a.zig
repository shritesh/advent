const std = @import("std");

test "example" {
    const data = @embedFile("9_example.txt");
    const result = run(data);
    try std.testing.expectEqual(@as(u32, 605), result);
}

pub fn main() void {
    const data = @embedFile("9.txt");
    const result = run(data);
    std.debug.print("{}\n", .{result});
}

const Graph = struct {
    edges: [32]Edge = undefined,
    count: usize = 0,
    cities: CitySet = CitySet{},

    fn insert(self: *Graph, from: []const u8, to: []const u8, dist: u16) void {
        self.edges[self.count] = Edge{
            .from = self.cities.getOrInsert(from),
            .to = self.cities.getOrInsert(to),
            .distance = dist,
        };
        self.count += 1;
    }

    fn distance(self: Graph, a: u4, b: u4) u16 {
        for (self.edges[0..self.count]) |e| {
            if ((e.from == a and e.to == b) or (e.from == b and e.to == a)) {
                return e.distance;
            }
        } else unreachable;
    }

    fn route(self: Graph, order: []const u4) u16 {
        var total: u16 = 0;
        for (order[0 .. order.len - 1]) |from, i| {
            const to = order[i + 1];
            total += self.distance(from, to);
        }
        return total;
    }

    fn shortestRoute(self: Graph) u32 {
        var order: [16]u4 = undefined;
        for (order) |*e, i| {
            e.* = @intCast(u4, i);
        }

        var shortest = ~@as(u32, 0);
        self.permuteShortestRoute(&shortest, order[0..self.cities.count], 0);
        return shortest;
    }

    fn permuteShortestRoute(self: Graph, shortest: *u32, order: []u4, i: usize) void {
        if (i == order.len) {
            const total = self.route(order);
            shortest.* = @minimum(shortest.*, total);
        }

        for (order[i..]) |*j| {
            std.mem.swap(u4, &order[i], j);
            self.permuteShortestRoute(shortest, order, i + 1);
            std.mem.swap(u4, &order[i], j);
        }
    }

    const Edge = struct {
        from: u4,
        to: u4,
        distance: u16,
    };

    const CitySet = struct {
        count: u4 = 0,
        names: [16][]const u8 = undefined,

        fn getOrInsert(self: *CitySet, city: []const u8) u4 {
            for (self.names[0..self.count]) |c, i| {
                if (std.mem.eql(u8, city, c)) return @intCast(u4, i);
            }

            const i = self.count;
            self.names[i] = city;
            self.count += 1;
            return i;
        }
    };
};

fn run(input: []const u8) u32 {
    var graph = Graph{};

    var lines = std.mem.tokenize(u8, input, "\n");
    while (lines.next()) |line| {
        var tokens = std.mem.split(u8, line, " ");
        var from = tokens.next().?;
        _ = tokens.next();
        var to = tokens.next().?;
        _ = tokens.next();
        var distance = std.fmt.parseInt(u16, tokens.next().?, 10) catch unreachable;

        graph.insert(from, to, distance);
    }

    return graph.shortestRoute();
}
