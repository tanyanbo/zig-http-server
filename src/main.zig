const std = @import("std");
const server = @import("./server.zig");
const net = std.net;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Logs from your program will appear here!\n", .{});

    try server.listen();
}
