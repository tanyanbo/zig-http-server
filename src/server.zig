const std = @import("std");
const request = @import("request.zig");
const response = @import("response.zig");
const HttpResponseCode = @import("statusCodes.zig").HttpResponseCode;
const net = std.net;

pub fn listen(ip: []const u8, port: u16) !void {
    const stdout = std.io.getStdOut().writer();
    const address = try net.Address.resolveIp(ip, port);

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

        const req = try request.parseRequest(input);

        if (std.mem.eql(u8, req.target, "/")) {
            const httpResponse = response.HttpResponse{
                .status = HttpResponseCode.Ok,
                .body = "Hello World",
            };
            const resp = try response.getResponse(allocator, httpResponse);
            defer allocator.free(resp);
            try connection.stream.writeAll(resp);
        } else {
            try connection.stream.writeAll("HTTP/1.1 404 Not Found\r\n\r\n");
        }

        connection.stream.close();
    }
}
