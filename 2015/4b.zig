const std = @import("std");
const Md5 = std.crypto.hash.Md5;

const input = "yzbqklnj";

pub fn main() !void {
    var buffer: [20]u8 = undefined;
    var digest: [16]u8 = undefined;

    var n: usize = 1;
    while (true) : (n += 1) {
        const source = try std.fmt.bufPrint(&buffer, "{s}{}", .{ input, n });
        Md5.hash(source, &digest, .{});

        if (digest[0] == 0 and digest[1] == 0 and digest[2] == 0) {
            std.debug.print("{}\n", .{n});
            return;
        }
    }
}
