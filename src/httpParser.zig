const std = @import("std");

pub const HttpMethod = enum {
    GET,
    POST,
};

pub const HttpRequest = struct {
    method: HttpMethod,
    target: []const u8 = "/",
    body: []const u8 = "",
    headers: ?std.AutoHashMap = null,
};

pub fn parse(request: []const u8) HttpRequest {
    var iter = std.mem.splitSequence(u8, request, "\r\n");
    while (iter.next()) |line| {
        std.debug.print("{}\n", .{line});
    }

    return .{
        .method = .GET,
    };
}
