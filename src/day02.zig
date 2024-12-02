const std = @import("std");
const utils = @import("./utils.zig");

const Line = struct {
    items: []u32,

    fn has_valid_mutation(self: *Line, allow_skip: bool, current_idx: usize) utils.Allocator.Error!bool {
        if (allow_skip) {
            for (0..3) |i| {
                if (current_idx >= i) {
                    var ln = try self.copy_without_item(current_idx - i);
                    const valid = try ln.is_valid(false);
                    if (valid) return true;
                }
            }
        }
        return false;
    }

    fn is_valid(self: *Line, allow_skip: bool) !bool {
        var currentValue: ?u32 = null;
        var isIncreasing: ?bool = null;

        for (self.items, 0..) |value, idx| {
            if (currentValue == null) {
                currentValue = value;
                continue;
            } else {
                if (value == currentValue) {
                    return try self.has_valid_mutation(allow_skip, idx);
                }
                const currentIsIncreasing = value > currentValue.?;
                if (isIncreasing == null) {
                    isIncreasing = currentIsIncreasing;
                } else {
                    if (isIncreasing != currentIsIncreasing) {
                        return try self.has_valid_mutation(allow_skip, idx);
                    }
                }
                const diff: i64 = @as(i64, currentValue.?) - @as(i64, value);
                if (@abs(diff) > 3) {
                    return try self.has_valid_mutation(allow_skip, idx);
                }
                currentValue = value;
            }
        }
        return true;
    }

    fn copy_without_item(self: *Line, index: usize) utils.Allocator.Error!Line {
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

fn solve(content: []const u8, allow_skip: bool) !u32 {
    var safeCount: u32 = 0;
    var lineIter = std.mem.tokenizeSequence(u8, content, "\n");

    while (lineIter.next()) |line| {
        var items = utils.List(u32).init(utils.gpa);
        var cellIter = std.mem.tokenizeSequence(u8, line, " ");
        while (cellIter.next()) |cell| {
            try items.append(try utils.parseInt(u32, cell, 10));
        }
        var ln = Line{ .items = try items.toOwnedSlice() };
        if (try ln.is_valid(allow_skip)) safeCount += 1;
    }
    return safeCount;
}

pub fn main() !void {
    const content = @embedFile("./data/day02.txt");
    const result1 = try solve(content, false);
    utils.print("Result day 2 - part 2: {any}\n", .{result1});
    const result2 = try solve(content, true);
    utils.print("Result day 2 - part 2: {any}\n", .{result2});
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
    const result = try solve(content, false);
    try std.testing.expectEqual(@as(u32, 2), result);
}

test "day02 -> copy without item" {
    var items = [_]u32{ 1, 2, 3, 4, 5 };
    var ln = Line{ .items = &items };
    const ln1 = try ln.copy_without_item(1);

    try std.testing.expectEqualSlices(u32, ln1.items, &[_]u32{ 1, 3, 4, 5 });
}

test "day02 -> part2" {
    const content =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;
    const result = try solve(content, true);
    try std.testing.expectEqual(@as(u32, 4), result);
}

test "day02 -> part2.1" {
    const content =
        \\1 2 3 4 5
        \\1 20 19 18 17
        \\1 20 3 4 5
        \\1 20 19 20 17
    ;
    const result = try solve(content, true);
    try std.testing.expectEqual(@as(u32, 3), result);
}

test "day02 -> part2.2" {
    const content =
        \\1 2 3 4 5
        \\20 20 19 18 17
    ;
    const result = try solve(content, true);
    try std.testing.expectEqual(@as(u32, 2), result);
}

test "day02 -> part2.3" {
    const content =
        \\1 2 3 4 5
        \\1 5 6 7 8
    ;
    const result = try solve(content, true);
    try std.testing.expectEqual(@as(u32, 2), result);
}

test "day02 -> part2.4" {
    const content =
        \\24 25 24 23 21 19 18 17
    ;
    const result = try solve(content, true);
    try std.testing.expectEqual(@as(u32, 1), result);
}
