const std = @import("std");
const server = @import("./server.zig");
const net = std.net;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Logs from your program will appear here!\n", .{});
    const address = try net.Address.resolveIp("127.0.0.1", 4221);

    server.listen(address) catch {
        std.debug.print("error\n", .{});
    };
}
