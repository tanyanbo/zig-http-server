const std = @import("std");
const httpParser = @import("httpParser.zig");
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

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        const input = try allocator.alloc(u8, 1024);
        defer allocator.free(input);

        _ = try connection.stream.read(input);

        const request = httpParser.parse(input);

        try stdout.print("method: {any}, target: {s}", .{ request.method, request.target });

        try connection.stream.writeAll("HTTP/1.1 200 OK\r\n\r\nhello world");
        connection.stream.close();
    }
}
