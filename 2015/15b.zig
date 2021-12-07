const std = @import("std");

test "example" {
    const ingredients = .{
        Ingredient.new("Butterscotch", .{ -1, -2, 6, 3 }, 8),
        Ingredient.new("Cinnamon", .{ 2, 3, -2, -1 }, 3),
        Ingredient.new("", .{ 0, 0, 0, 0 }, 0),
        Ingredient.new("", .{ 0, 0, 0, 0 }, 0),
    };

    const result = run(ingredients);
    try std.testing.expectEqual(@as(usize, 57600000), result);
}

pub fn main() void {
    const ingredients = .{
        Ingredient.new("Sprinkles", .{ 5, -1, 0, 0 }, 5),
        Ingredient.new("PeanutButter", .{ -1, 3, 0, 0 }, 1),
        Ingredient.new("Frosting", .{ 0, -1, 4, 0 }, 6),
        Ingredient.new("Sugar", .{ -1, 0, 0, 2 }, 8),
    };

    const result = run(ingredients);
    std.debug.print("{}\n", .{result});
}

const Ingredient = struct {
    name: []const u8,
    properties: [4]i8,
    calorie: u8,

    fn new(name: []const u8, properties: [4]i8, calorie: u8) Ingredient {
        return Ingredient{
            .name = name,
            .properties = properties,
            .calorie = calorie,
        };
    }
};

fn calories(ingredients: [4]Ingredient, proportions: [4]u8) u32 {
    var total: u32 = 0;
    for (proportions) |p, i| {
        total += @as(u32, ingredients[i].calorie) * p;
    }

    return total;
}

fn score(ingredients: [4]Ingredient, proportions: [4]u8) usize {
    var s: usize = 1;

    var property: usize = 0;
    while (property < 4) : (property += 1) {
        var property_score: i32 = 0;
        for (proportions) |proportion, i| {
            property_score += @as(i32, proportion) * @as(i32, ingredients[i].properties[property]);
        }
        if (property_score <= 0) return 0;
        s *= @intCast(usize, property_score);
    }

    return s;
}

fn run(ingredients: [4]Ingredient) usize {
    var max_score: usize = 0;

    var i: u8 = 0;
    while (i <= 100) : (i += 1) {
        var j: u8 = 0;
        while (j <= 100 - i) : (j += 1) {
            var k: u8 = 0;
            while (k <= 100 - i - j) : (k += 1) {
                const l = 100 - i - j - k;
                const proportions: [4]u8 = .{ i, j, k, l };

                if (calories(ingredients, proportions) != 500) continue;

                const s = score(ingredients, proportions);
                max_score = @maximum(max_score, s);
            }
        }
    }

    return max_score;
}
