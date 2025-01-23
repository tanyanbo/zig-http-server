const std = @import("std");

pub const HttpMethod = enum {
    GET,
    POST,
};

pub const HttpRequest = struct {
    method: HttpMethod,
    target: []const u8 = "/",
    body: []const u8 = "",
    headers: ?std.StringHashMap([]const u8) = null,
};

pub fn parse(request: []u8) !HttpRequest {
    var iter = std.mem.splitSequence(u8, request, "\r\n");
    const firstLine = iter.next() orelse "";
    var firstLineIter = std.mem.splitSequence(u8, firstLine, " ");
    const method = std.meta.stringToEnum(HttpMethod, firstLineIter.next() orelse "POST") orelse HttpMethod.POST;
    const target = firstLineIter.next() orelse "/test";

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var headers = std.StringHashMap([]const u8).init(allocator);
    defer headers.deinit();
    while (iter.next()) |headerLine| {
        var headerIter = std.mem.splitSequence(u8, headerLine, ": ");
        const header = headerIter.next();
        const value = headerIter.next();
        if (header != null and value != null) {
            try headers.put(header.?, value.?);
        }
    }

    return .{
        .method = method,
        .target = target,
        .headers = headers,
    };
}
