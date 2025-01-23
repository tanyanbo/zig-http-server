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

        const request = try httpParser.parse(input);

        if (std.mem.eql(u8, request.target, "/")) {
            try connection.stream.writeAll("HTTP/1.1 200 OK\r\n\r\n");
        } else {
            try connection.stream.writeAll("HTTP/1.1 404 Not Found\r\n\r\n");
        }

        connection.stream.close();
    }
}
