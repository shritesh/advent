const std = @import("std");
const expect = std.testing.expect;
const expectEqualSlices = std.testing.expectEqualSlices;

test "example" {
    try expect(increasingThreeLetters("hijklmmn"));
    try expect(!noIOL("hijklmmn"));

    try expect(twoNonOverlappingPairs("abbceffg"));
    try expect(!increasingThreeLetters("abbceffg"));

    try expect(!twoNonOverlappingPairs("abbcegjk"));

    var password1: [8]u8 = "abcdefgh".*;
    nextPassword(&password1);
    try expectEqualSlices(u8, &password1, "abcdffaa");

    var password2: [8]u8 = "ghijklmn".*;
    nextPassword(&password2);
    try expectEqualSlices(u8, &password2, "ghjaabcc");
}

pub fn main() void {
    var password: [8]u8 = "hepxcrrq".*;
    nextPassword(&password);
    std.debug.print("{s}\n", .{&password});
    nextPassword(&password);
    std.debug.print("{s}\n", .{&password});
}

fn increasingThreeLetters(password: []const u8) bool {
    for (password[0 .. password.len - 2]) |c, i| {
        if (password[i + 1] == c + 1 and password[i + 2] == c + 2) return true;
    } else return false;
}

fn noIOL(password: []const u8) bool {
    for (password) |c| {
        if (c == 'i' or c == 'o' or c == 'l') return false;
    } else return true;
}

fn twoNonOverlappingPairs(password: []const u8) bool {
    var previous_letter: ?u8 = null;
    var i: usize = 0;
    while (i < password.len - 1) : (i += 1) {
        if (password[i] == password[i + 1]) {
            if (previous_letter) |l| if (l != password[i]) return true else continue;
            previous_letter = password[i];
        }
    } else return false;
}

fn nextPassword(password: []u8) void {
    while (true) {
        var idx = password.len - 1;
        while (true) {
            password[idx] += 1;
            if (password[idx] <= 'z') break;
            password[idx] = 'a';
            idx -= 1;
        }
        if (increasingThreeLetters(password) and noIOL(password) and twoNonOverlappingPairs(password)) return;
    }
}
