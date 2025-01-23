const std = @import("std");
const net = std.net;

pub fn listen() !void {
    const stdout = std.io.getStdOut().writer();

    const address = try net.Address.resolveIp("127.0.0.1", 4221);
    var listener = try address.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();

    while (true) {
        const connection = try listener.accept();
        try stdout.print("client connected!\n", .{});
        try connection.stream.writeAll("HTTP/1.1 200 OK\r\n\r\n");
    }
}
