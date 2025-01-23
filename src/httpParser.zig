const std = @import("std");

pub const HttpMethod = enum {
    GET,
    POST,
};

pub const HttpRequest = struct {
    method: HttpMethod,
    target: []const u8 = "/",
    body: []const u8 = "",
    // headers: ?std.AutoHashMap = null,
};

pub fn parse(request: []u8) HttpRequest {
    var iter = std.mem.splitSequence(u8, request, "\r\n");
    const firstLine = iter.next() orelse "";
    var firstLineIter = std.mem.splitSequence(u8, firstLine, " ");
    const method = std.meta.stringToEnum(HttpMethod, firstLineIter.next() orelse "POST") orelse HttpMethod.POST;
    const target = firstLineIter.next() orelse "/test";

    // while (iter.next()) |headerLine| {
    //     std.debug.print("{s}\n", .{headerLine});
    // }

    return .{
        .method = method,
        .target = target,
    };
}
