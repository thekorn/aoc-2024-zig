const std = @import("std");
const utils = @import("./utils.zig");

const Line = struct {
    items: []u32,

    fn is_valid(self: *Line) bool {
        var currentValue: ?u32 = null;
        var isIncreasing: ?bool = null;

        for (self.items) |value| {
            if (currentValue == null) {
                currentValue = value;
                continue;
            } else {
                if (value == currentValue) return false;
                const currentIsIncreasing = value > currentValue.?;
                if (isIncreasing == null) {
                    isIncreasing = currentIsIncreasing;
                } else {
                    if (isIncreasing != currentIsIncreasing) return false;
                }
                const diff: i64 = @as(i64, currentValue.?) - @as(i64, value);
                if (@abs(diff) > 3) return false;
                currentValue = value;
            }
        }
        return true;
    }

    fn copy_without_item(self: *Line, index: usize) !Line {
        var items = utils.List(u32).init(utils.gpa);

        for (self.items, 0..) |value, idx| {
            if (index == idx) {
                continue;
            }
            try items.append(value);
        }
        return Line{ .items = try items.toOwnedSlice() };
    }
};

fn part1(content: []const u8) !u32 {
    var safeCount: u32 = 0;
    var lineIter = std.mem.tokenizeSequence(u8, content, "\n");

    while (lineIter.next()) |line| {
        var items = utils.List(u32).init(utils.gpa);
        var cellIter = std.mem.tokenizeSequence(u8, line, " ");
        while (cellIter.next()) |cell| {
            try items.append(try utils.parseInt(u32, cell, 10));
        }
        var ln = Line{ .items = try items.toOwnedSlice() };
        if (ln.is_valid()) safeCount += 1;
    }
    return safeCount;
}

pub fn main() !void {
    const content = @embedFile("./data/day02.txt");
    const result1 = try part1(content);
    utils.print("Result day 2 - part 2: {any}\n", .{result1});
    //const result2 = try part2(content);
    //utils.print("Result day 1 - part 2: {any}\n", .{result2});
}

test "day02 -> part1" {
    const content =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;
    const result = try part1(content);
    try std.testing.expectEqual(@as(u32, 2), result);
}

test "day02 -> copy without item" {
    var items = [_]u32{ 1, 2, 3, 4, 5 };
    var ln = Line{ .items = &items };
    const ln1 = try ln.copy_without_item(1);

    try std.testing.expectEqualSlices(u32, ln1.items, &[_]u32{ 1, 3, 4, 5 });
}
