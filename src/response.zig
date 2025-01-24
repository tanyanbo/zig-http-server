const std = @import("std");
const expect = std.testing.expect;
const HttpResponseCode = @import("statusCodes.zig").HttpResponseCode;

pub const HttpResponse = struct {
    body: ?[]const u8,
    status: HttpResponseCode,
};

pub fn getResponse(allocator: std.mem.Allocator, httpResponse: HttpResponse) ![]const u8 {
    const response = try std.fmt.allocPrint(allocator,
        \\HTTP/1.1 {d} {s}
        \\Content-Type: text/html
        \\
        \\{s}
    , .{
        @intFromEnum(httpResponse.status),
        std.enums.tagName(HttpResponseCode, httpResponse.status).?,
        httpResponse.body.?,
    });
    return response;
}

test "resp" {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const httpResponse = HttpResponse{
        .status = HttpResponseCode.Ok,
        .body = "Hello World!",
    };
    const r = try getResponse(allocator, httpResponse);
    defer allocator.free(r);
    try stdout.print("{s}\n", .{r});
}
