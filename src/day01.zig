const std = @import("std");
const utils = @import("./utils.zig");

const Values = struct {
    left: []u32,
    right: []u32,
    counter: utils.Counter(u32),

    fn init(alloc: utils.Allocator, content: []const u8) !Values {
        var readIter = std.mem.tokenizeSequence(u8, content, "\n");

        var left = utils.List(u32).init(alloc);
        var right = utils.List(u32).init(alloc);

        var counter = try utils.Counter(u32).init(alloc);

        while (readIter.next()) |line| {
            var lineIter = std.mem.tokenizeSequence(u8, line, " ");
            try left.append(try utils.parseInt(u32, lineIter.next().?, 10));

            const r = try utils.parseInt(u32, lineIter.next().?, 10);
            try counter.add(r);
            try right.append(r);
        }
        const l = try left.toOwnedSlice();
        std.mem.sort(u32, l, {}, comptime std.sort.asc(u32));
        const r = try right.toOwnedSlice();
        std.mem.sort(u32, r, {}, comptime std.sort.asc(u32));

        return .{
            .left = l,
            .right = r,
            .counter = counter,
        };
    }
};

fn part1(content: []const u8) !u32 {
    var result: u32 = 0;
    const values = try Values.init(utils.gpa, content);

    var i: usize = 0;
    while (true) : (i += 1) {
        if (i >= values.left.len or i >= values.right.len) {
            break;
        }
        const x = values.left[i];
        const y = values.right[i];

        const diff: i64 = @as(i64, y) - @as(i64, x);
        result += @intCast(@abs(diff));
    }

    return result;
}

fn part2(content: []const u8) !u32 {
    var result: u32 = 0;
    var values = try Values.init(utils.gpa, content);

    var i: usize = 0;
    while (true) : (i += 1) {
        if (i >= values.left.len or i >= values.right.len) {
            break;
        }
        const x = values.left[i];

        const factor: u32 = @intCast(values.counter.get(x) orelse 0);
        result += factor * x;
    }

    return result;
}

pub fn main() !void {
    const content = @embedFile("./data/day01.txt");
    const result1 = try part1(content);
    utils.print("Result day 1 - part 1: {any}\n", .{result1});
    const result2 = try part2(content);
    utils.print("Result day 1 - part 2: {any}\n", .{result2});
}

test "day01 -> part1" {
    const content =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    const result = try part1(content);
    try std.testing.expectEqual(@as(u32, 11), result);
}

test "day01 -> part2" {
    const content =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    const result = try part2(content);
    try std.testing.expectEqual(@as(u32, 31), result);
}
