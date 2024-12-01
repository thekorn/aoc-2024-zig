const std = @import("std");
const utils = @import("./utils.zig");

const Values = struct {
    left: []i32,
    right: []i32,
    counter: utils.Counter(i32),

    fn init(alloc: utils.Allocator, content: []const u8) !Values {
        var readIter = std.mem.tokenizeSequence(u8, content, "\n");

        var left = utils.List(i32).init(alloc);
        var right = utils.List(i32).init(alloc);

        var counter = try utils.Counter(i32).init(alloc);

        while (readIter.next()) |line| {
            var lineIter = std.mem.tokenizeSequence(u8, line, " ");
            try left.append(try utils.parseInt(i32, lineIter.next().?, 10));

            const r = try utils.parseInt(i32, lineIter.next().?, 10);
            try counter.add(r);
            try right.append(r);
        }
        const l = try left.toOwnedSlice();
        std.mem.sort(i32, l, {}, comptime std.sort.asc(i32));
        const r = try right.toOwnedSlice();
        std.mem.sort(i32, r, {}, comptime std.sort.asc(i32));

        return .{
            .left = l,
            .right = r,
            .counter = counter,
        };
    }
};

fn part1(content: []const u8) !i32 {
    var result: i32 = 0;
    const values = try Values.init(utils.gpa, content);

    var i: usize = 0;
    while (true) : (i += 1) {
        if (i >= values.left.len or i >= values.right.len) {
            break;
        }
        const x = values.left[i];
        const y = values.right[i];

        result += @intCast(@abs(y - x));
    }

    return result;
}

fn part2(content: []const u8) !i32 {
    var result: i32 = 0;
    var values = try Values.init(utils.gpa, content);

    var i: usize = 0;
    while (true) : (i += 1) {
        if (i >= values.left.len or i >= values.right.len) {
            break;
        }
        const x = values.left[i];

        const factor: i32 = values.counter.get(x) orelse 0;
        result += @intCast(@abs(factor * x));
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
    try std.testing.expectEqual(@as(i32, 11), result);
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
    try std.testing.expectEqual(@as(i32, 31), result);
}
