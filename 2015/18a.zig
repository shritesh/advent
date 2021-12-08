const std = @import("std");

test "example" {
    const input = @embedFile("18_example.txt");
    const result = run(input, 6, 4);
    try std.testing.expectEqual(@as(usize, 4), result);
}

pub fn main() void {
    const input = @embedFile("18.txt");
    const result = run(input, 100, 100);
    std.debug.print("{}\n", .{result});
}

fn run(input: []const u8, comptime size: usize, steps: usize) usize {
    var grid: [size][size]bool = undefined;

    var col: usize = 0;
    var row: usize = 0;
    for (input) |c| switch (c) {
        '\n' => {
            row += 1;
            col = 0;
        },
        '#' => {
            grid[row][col] = true;
            col += 1;
        },
        '.' => {
            grid[row][col] = false;
            col += 1;
        },
        else => unreachable,
    };

    var step: usize = 0;
    while (step < steps) : (step += 1) {
        next(size, &grid);
    }

    var count: usize = 0;
    for (grid) |r| {
        for (r) |c| {
            if (c) count += 1;
        }
    }

    return count;
}

fn next(comptime size: usize, grid: *[size][size]bool) void {
    var new: [size][size]bool = undefined;
    for (grid) |r, row| {
        for (r) |c, col| {
            if (c) {
                new[row][col] = switch (countNeighbors(size, grid.*, row, col)) {
                    2, 3 => true,
                    else => false,
                };
            } else {
                new[row][col] = countNeighbors(size, grid.*, row, col) == 3;
            }
        }
    }

    for (new) |r, row| {
        for (r) |c, col| {
            grid[row][col] = c;
        }
    }
}

inline fn countNeighbors(comptime size: usize, grid: [size][size]bool, row: usize, col: usize) usize {
    var count: usize = 0;
    if (col > 0 and grid[row][col - 1]) count += 1; // left
    if (col + 1 < size and grid[row][col + 1]) count += 1; // right
    if (row > 0 and grid[row - 1][col]) count += 1; // up
    if (row + 1 < size and grid[row + 1][col]) count += 1; // down
    if (col > 0 and row > 0 and grid[row - 1][col - 1]) count += 1; // top left
    if (row > 0 and col + 1 < size and grid[row - 1][col + 1]) count += 1; // top right
    if (row + 1 < size and col > 0 and grid[row + 1][col - 1]) count += 1; // bottom left
    if (row + 1 < size and col + 1 < size and grid[row + 1][col + 1]) count += 1; // bottom right
    return count;
}
