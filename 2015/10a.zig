const std = @import("std");

const bufsize = 1024 * 1024;

test "example" {
    var buffer: [bufsize]u8 = undefined;
    buffer[0] = '1';
    var len: usize = 1;

    var i: usize = 0;
    while (i < 5) : (i += 1) {
        try run(&buffer, &len);
    }
    try std.testing.expectEqualSlices(u8, "312211", buffer[0..len]);
}

pub fn main() !void {
    const input = "1113222113";

    var buffer: [bufsize]u8 = undefined;
    std.mem.copy(u8, &buffer, input);
    var len = input.len;

    var i: usize = 0;
    while (i < 40) : (i += 1) {
        try run(&buffer, &len);
    }
    std.debug.print("{}\n", .{len});
}

fn run(input: []u8, len: *usize) !void {
    var buffer: [bufsize]u8 = undefined;
    var pos: usize = 0;

    var last = input[0];
    var running_length: usize = 1;

    if (len.* == 1) {
        pos += try write(buffer[0..], running_length, last);
    } else for (input[1..len.*]) |c| {
        if (c == last) {
            running_length += 1;
            continue;
        }
        pos += try write(buffer[pos..], running_length, last);
        last = c;
        running_length = 1;
    } else {
        pos += try write(buffer[pos..], running_length, last);
    }

    std.mem.copy(u8, input, buffer[0..pos]);
    len.* = pos;
}

fn write(buffer: []u8, running_length: usize, char: u8) !usize {
    var encoding = try std.fmt.bufPrint(buffer, "{}{c}", .{ running_length, char });
    return encoding.len;
}
