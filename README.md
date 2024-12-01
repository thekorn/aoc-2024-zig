# AOC 2024 in zig


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
