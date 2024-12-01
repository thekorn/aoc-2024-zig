const std = @import("std");
const utils = @import("./utils.zig");

pub fn solve(content: []const u8, add_weight: bool) !i32 {
    var result: i32 = 0;
    var readIter = std.mem.tokenizeSequence(u8, content, "\n");

    var left = utils.List(i32).init(utils.gpa);
    var right = utils.List(i32).init(utils.gpa);

    var counter = utils.Map(i32, i32).init(utils.gpa);

    while (readIter.next()) |line| {
        var lineIter = std.mem.tokenizeSequence(u8, line, " ");
        try left.append(try utils.parseInt(i32, lineIter.next().?, 10));

        const r = try utils.parseInt(i32, lineIter.next().?, 10);
        if (counter.contains(r)) {
            const v = counter.get(r) orelse unreachable;
            try counter.put(r, v + 1);
        } else {
            try counter.put(r, 1);
        }
        try right.append(r);
    }
    const l = try left.toOwnedSlice();
    std.mem.sort(i32, l, {}, comptime std.sort.asc(i32));
    const r = try right.toOwnedSlice();
    std.mem.sort(i32, r, {}, comptime std.sort.asc(i32));

    var i: usize = 0;
    while (true) : (i += 1) {
        if (i >= l.len or i >= r.len) {
            break;
        }
        const x = l[i];
        const y = r[i];

        if (add_weight) {
            const factor: i32 = counter.get(x) orelse 0;
            result += @intCast(@abs(factor * x));
        } else {
            result += @intCast(@abs(y - x));
        }
    }

    return result;
}

pub fn main() !void {
    const content = @embedFile("./data/day01.txt");
    const result1 = try solve(content, false);
    utils.print("Result day 1 - part 1: {any}\n", .{result1});
    const result2 = try solve(content, true);
    utils.print("Result day 1 - part 2: {any}\n", .{result2});
}

test "part1 test" {
    const content =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    const result = try solve(content, false);
    try std.testing.expectEqual(@as(i32, 11), result);
}

test "part2 test" {
    const content =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    const result = try solve(content, true);
    try std.testing.expectEqual(@as(i32, 31), result);
}
