const std = @import("std");
pub const Allocator = std.mem.Allocator;
pub const List = std.ArrayList;
pub const Map = std.AutoHashMap;
pub const StrMap = std.StringHashMap;
pub const BitSet = std.DynamicBitSet;
pub const Str = []const u8;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = gpa_impl.allocator();

// Add utility functions here

// Useful stdlib functions
pub const tokenizeAny = std.mem.tokenizeAny;
pub const tokenizeSeq = std.mem.tokenizeSequence;
pub const tokenizeSca = std.mem.tokenizeScalar;
pub const splitAny = std.mem.splitAny;
pub const splitSeq = std.mem.splitSequence;
pub const splitSca = std.mem.splitScalar;
pub const indexOf = std.mem.indexOfScalar;
pub const indexOfAny = std.mem.indexOfAny;
pub const indexOfStr = std.mem.indexOfPosLinear;
pub const lastIndexOf = std.mem.lastIndexOfScalar;
pub const lastIndexOfAny = std.mem.lastIndexOfAny;
pub const lastIndexOfStr = std.mem.lastIndexOfLinear;
pub const trim = std.mem.trim;
pub const sliceMin = std.mem.min;
pub const sliceMax = std.mem.max;

pub const parseInt = std.fmt.parseInt;
pub const parseFloat = std.fmt.parseFloat;

pub const print = std.debug.print;
pub const assert = std.debug.assert;

pub const sort = std.sort.block;
pub const asc = std.sort.asc;
pub const desc = std.sort.desc;

pub fn charCode(c: u8) usize {
    if (c >= 97 and c <= 122) {
        return c - 'a';
    } else {
        return c - 'A' + 26;
    }
}

pub fn codeToChar(code: usize) u8 {
    if (code < 26) {
        return 'a' + @as(u8, @intCast(code));
    } else {
        return 'A' + @as(u8, @intCast(code)) - 26;
    }
}

pub fn Counter(comptime K: type) type {
    return struct {
        const Self = @This();
        items: Map(K, i32),

        pub fn init(alloc: Allocator) !Self {
            return .{
                .items = Map(K, i32).init(alloc),
            };
        }

        pub fn add(self: *Self, key: K) !void {
            const cnt = try self.items.getOrPut(key);
            if (cnt.found_existing) {
                cnt.value_ptr.* += 1;
            } else {
                cnt.value_ptr.* = 1;
            }
        }

        pub fn get(self: *Self, key: K) ?i32 {
            return self.items.get(key);
        }
    };
}

test "utils - Counter" {
    const CounterStr = Counter(i32);
    var counter = try CounterStr.init(gpa);
    try counter.add(1);
    try counter.add(1);
    try counter.add(2);
    try counter.add(3);
    try counter.add(5);
    try counter.add(6);

    try std.testing.expectEqual(2, counter.get(1));
    try std.testing.expectEqual(1, counter.get(2));
    try std.testing.expectEqual(null, counter.get(10));
}
