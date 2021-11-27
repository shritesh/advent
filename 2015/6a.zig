const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const stdin = std.io.getStdIn().reader();

const Action = enum { On, Off, Toggle };

const Instruction = struct {
    action: Action,
    from_x: u16,
    from_y: u16,
    to_x: u16,
    to_y: u16,
};

fn consumeString(slice: *[]u8, string: []const u8) bool {
    if (mem.eql(u8, string, slice.*[0..string.len])) {
        slice.* = slice.*[string.len..slice.len];
        return true;
    }
    return false;
}

fn consumeInteger(slice: *[]u8) ?u16 {
    var last = slice.len;
    for (slice.*) |c, i| {
        if (c < '0' or c > '9') {
            last = i;
            break;
        }
    }

    const int = fmt.parseInt(u16, slice.*[0..last], 10) catch return null;
    slice.* = slice.*[last..];

    return int;
}

fn readInstruction() ?Instruction {
    var buffer: [50]u8 = undefined;
    var line = (stdin.readUntilDelimiterOrEof(&buffer, '\n') catch return null) orelse return null;

    var instruction: Instruction = undefined;

    if (consumeString(&line, "turn on ")) {
        instruction.action = .On;
    } else if (consumeString(&line, "turn off ")) {
        instruction.action = .Off;
    } else if (consumeString(&line, "toggle ")) {
        instruction.action = .Toggle;
    } else return null;

    instruction.from_x = consumeInteger(&line) orelse return null;
    if (!consumeString(&line, ",")) return null;
    instruction.from_y = consumeInteger(&line) orelse return null;

    if (!consumeString(&line, " through ")) return null;

    instruction.to_x = consumeInteger(&line) orelse return null;
    if (!consumeString(&line, ",")) return null;
    instruction.to_y = consumeInteger(&line) orelse return null;

    return instruction;
}

pub fn main() !void {
    var lights = mem.zeroes([1000][1000]bool);

    while (readInstruction()) |instruction|
        for (lights[instruction.from_x .. instruction.to_x + 1]) |*row|
            for (row[instruction.from_y .. instruction.to_y + 1]) |*light| {
                light.* = switch (instruction.action) {
                    .On => true,
                    .Off => false,
                    .Toggle => !light.*,
                };
            };

    var count: usize = 0;
    for (lights) |row|
        for (row) |light|
            if (light) {
                count += 1;
            };

    std.debug.print("{}\n", .{count});
}
