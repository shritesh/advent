const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

const stdin = std.io.getStdIn().reader();

const Identifier = [2]u8;

const Shift = struct {
    Identifier: Identifier,
    By: u4,
};

const Wire = union(enum) {
    Value: u16,
    Identifier: Identifier,
    And: [2]Identifier,
    OneAnd: Identifier,
    Or: [2]Identifier,
    Not: Identifier,
    Lshift: Shift,
    Rshift: Shift,
};

const CachedWire = struct {
    Wire: Wire,
    Cache: ?u16,
};

const Wires = [256 * 256]?CachedWire;

fn calculate(wires: *Wires, identifier: Identifier) error{UnsetWire}!u16 {
    const idx = mem.bytesToValue(u16, &identifier);
    if (wires[idx] == null) return error.UnsetWire;

    const wire = &wires[idx].?;

    if (wire.Cache) |c| return c;

    const result = switch (wire.Wire) {
        .Value => |v| v,
        .Identifier => |i| try calculate(wires, i),
        .And => |is| (try calculate(wires, is[0])) & (try calculate(wires, is[1])),
        .OneAnd => |i| 1 & (try calculate(wires, i)),
        .Or => |is| (try calculate(wires, is[0])) | (try calculate(wires, is[1])),
        .Not => |i| ~(try calculate(wires, i)),
        .Lshift => |s| (try calculate(wires, s.Identifier)) << s.By,
        .Rshift => |s| (try calculate(wires, s.Identifier)) >> s.By,
    };

    wire.Cache = result;
    return result;
}

fn consumeString(slice: *[]u8, string: []const u8) bool {
    if (string.len > slice.len) return false;
    if (mem.eql(u8, string, slice.*[0..string.len])) {
        slice.* = slice.*[string.len..slice.len];
        return true;
    }
    return false;
}

fn readInt(comptime T: type, slice: *[]u8) !T {
    var last = slice.len;
    for (slice.*) |c, i| {
        if (c < '0' or c > '9') {
            last = i;
            break;
        }
    }

    const int = try fmt.parseInt(T, slice.*[0..last], 10);
    slice.* = slice.*[last..];

    return int;
}

fn readIdentifier(slice: *[]u8) !Identifier {
    if (slice.len == 0) return error.InvalidIdentifier;
    if (slice.len == 1 or slice.*[1] == ' ') {
        if (slice.*[0] < 'a' or slice.*[0] > 'z') return error.InvalidIdentifier;

        const identifier = [_]u8{ ' ', slice.*[0] };
        slice.* = slice.*[1..];
        return identifier;
    }

    if (slice.*[0] < 'a' or slice.*[0] > 'z' or slice.*[1] < 'a' or slice.*[1] > 'z') return error.InvalidIdentifier;
    const identifier = [_]u8{ slice.*[0], slice.*[1] };
    slice.* = slice.*[2..];
    return identifier;
}

fn readWire(slice: *[]u8) !Wire {
    if (readInt(u16, slice) catch null) |int| {
        if (int == 1 and consumeString(slice, " AND ")) {
            const identifier = try readIdentifier(slice);
            return Wire{ .OneAnd = identifier };
        }
        return Wire{ .Value = int };
    }

    if (consumeString(slice, "NOT ")) {
        const identifier = try readIdentifier(slice);
        return Wire{ .Not = identifier };
    }

    const identifier = try readIdentifier(slice);
    if (consumeString(slice, " AND ")) {
        const another = try readIdentifier(slice);
        return Wire{ .And = [2]Identifier{ identifier, another } };
    } else if (consumeString(slice, " OR ")) {
        const another = try readIdentifier(slice);
        return Wire{ .Or = [2]Identifier{ identifier, another } };
    } else if (consumeString(slice, " LSHIFT ")) {
        const by = try readInt(u4, slice);
        const shift = Shift{ .Identifier = identifier, .By = by };
        return Wire{ .Lshift = shift };
    } else if (consumeString(slice, " RSHIFT ")) {
        const by = try readInt(u4, slice);
        const shift = Shift{ .Identifier = identifier, .By = by };
        return Wire{ .Rshift = shift };
    } else return Wire{ .Identifier = identifier };
}

fn parseLine(slice: *[]u8, wires: *Wires) !void {
    const wire = try readWire(slice);
    if (!consumeString(slice, " -> ")) return error.NoArrowError;
    const identifier = try readIdentifier(slice);

    wires[mem.bytesToValue(u16, &identifier)] = CachedWire{ .Wire = wire, .Cache = null };
}

pub fn main() !void {
    var wires = mem.zeroes(Wires);

    var buffer: [32]u8 = undefined;
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |*line| {
        try parseLine(line, &wires);
    }

    const a = [_]u8{ ' ', 'a' };
    const b = [_]u8{ ' ', 'b' };

    const val_a = try calculate(&wires, a);

    const b_idx = mem.bytesToValue(u16, &b);
    wires[b_idx].?.Wire = Wire{ .Value = val_a };

    // Reset
    for (wires) |_, i| {
        if (wires[i]) |*wire| {
            wire.Cache = null;
        }
    }

    std.debug.print("{}\n", .{calculate(&wires, a)});
}
