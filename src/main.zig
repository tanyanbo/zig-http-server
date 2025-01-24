const std = @import("std");
const server = @import("./server.zig");

pub fn main() !void {
    server.listen("127.0.0.1", 4221) catch {
        std.debug.print("error\n", .{});
    };
}
