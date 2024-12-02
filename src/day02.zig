const std = @import("std");
const utils = @import("./utils.zig");

fn part1(content: []const u8) !u32 {
    var safeCount: u32 = 0;
    var lineIter = std.mem.tokenizeSequence(u8, content, "\n");

    lines: while (lineIter.next()) |line| {
        var currentValue: ?u32 = null;
        var isIncreasing: ?bool = null;
        var cellIter = std.mem.tokenizeSequence(u8, line, " ");
        while (cellIter.next()) |cell| {
            const value = try utils.parseInt(u32, cell, 10);
            if (currentValue == null) {
                currentValue = value;
                continue;
            } else {
                if (value == currentValue) continue :lines;
                const currentIsIncreasing = value > currentValue.?;
                if (isIncreasing == null) {
                    isIncreasing = currentIsIncreasing;
                } else {
                    if (isIncreasing != currentIsIncreasing) continue :lines;
                }
                const diff: i64 = @as(i64, currentValue.?) - @as(i64, value);
                if (@abs(diff) > 3) continue :lines;
                currentValue = value;
            }
        }
        safeCount += 1;
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
