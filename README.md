# AOC 2024 in zig

![ci workflow](https://github.com/thekorn/aoc-2024-zig/actions/workflows/ci.yaml/badge.svg)

solution of the [Advent of Code 2024](https://adventofcode.com/2024) in zig

## setup

```sh
nix develop -c zsh
```

## run

```sh
zig build run_day01     # run day 1
zig build test_day01    # test day 1

zig build test          # run all tests
zig build run           # run all days
```

## benchmarking

```sh
zig build install_all -Doptimize=ReleaseSafe  # or
zig build install_all -Doptimize=ReleaseFast  # or
zig build install_all -Doptimize=ReleaseSmall # or

hyperfine -r 50 './zig-out/bin/day01'
```

## debugging

```sh
LLDB_DEBUGSERVER_PATH=/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver lldb zig-out/bin/day01                                               ✔  9.107s   󱄅  20.11.1   16:24:49 
(lldb) target create "zig-out/bin/day01"
Current executable set to '/Users/d438477/devel/github.com/thekorn/aoc-2024-zig/zig-out/bin/day01' (arm64).
(lldb) breakpoint set -f day01.zig -l 76
Breakpoint 1: where = day01`day01.main + 40 at day01.zig:76:5, address = 0x0000000100003ad4
(lldb) r
Process 53435 launched: '/Users/d438477/devel/github.com/thekorn/aoc-2024-zig/zig-out/bin/day01' (arm64)
Process 53435 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100003ad4 day01`day01.main at day01.zig:76:5
   73   }
   74
   75   pub fn main() !void {
-> 76       const content = @embedFile("./data/day01.txt");
   77       const result1 = try part1(content);
   78       utils.print("Result day 1 - part 1: {any}\n", .{result1});
   79       const result2 = try part2(content);
(lldb) ^D
```
