const std = @import("std");
const rpan = std.mem.readPackedIntNative;

const Parts = packed struct {
    first: u8,
    second: u8,
    third: u8,
    fourth: u8,
};

const adjectives: []const []const u8 = &.{
    "fast",
    "slow",
    "nice",
    "mean",
    "strong",
    "weak",
    "pretty",
    "ugly",
    "real",
    "fake",
    "beloved",
    "hated",
};

const nouns: []const []const u8 = &.{
    "richard",
    "jake",
    "mike",
    "oscar",
    "lima",
    "romeo",
    "juliet",
    "victor",

    "george",
    "john",
    "thomas",
    "james",
    "andrew",
    "martin",
    "william",
    "zachary",
    "millard",
    "franklin",
    "abraham",
    "ulysses",
    "rutherford",
    "chester",
    "grover",
    "benjamin",
    "theodore",
    "woodrow",
    "warren",
    "calvin",
    "herbert",
    "franklin",
    "harry",
    "dwight",
    "lyndon",
    "richard",
    "gerald",
    "jimmy",
    "ronald",
    "bill",
    "barack",
    "donald",
    "joe",

    "you",
    "me",
    "mom",
    "dad",
};

const verbs: []const []const u8 = &.{
    "helping",
    "hating",
    "loving",
    "killing",
    "eating",
    "tearing",
    "building",
    "ignoring",
};

const errs = error{
    TooManyArguments,
    TooFewArguments,
};

pub fn main() !void {
    std.debug.print("adj count: {any}, noun count: {any}, verb count: {any}\n", .{ adjectives.len, nouns.len, verbs.len });
    const al = std.heap.page_allocator;
    // first arg is the master key, second arg is the website name
    // const args = try std.process.argsAlloc(al);
    const args = try std.process.argsAlloc(al);
    defer std.process.argsFree(al, args);

    var i: u4 = 0;
    var sha = std.crypto.hash.sha2.Sha224.init(.{});
    for (args[1..]) |arg| {
        i += 1;
        if (i > 2) {
            return errs.TooManyArguments;
        }
        sha.update(arg);
    }
    if (i < 2) {
        return errs.TooFewArguments;
    }

    const first = rpan(u64, sha.peek()[0..16], 0);
    sha.update(&sha.peek());
    const second = rpan(u64, sha.peek()[0..16], 0);
    sha.update(&sha.peek());
    const third = rpan(u64, sha.peek()[0..16], 0);
    sha.update(&sha.peek());
    const fourth = rpan(u64, sha.peek()[0..16], 0);

    const adj = adjectives[first % adjectives.len];
    const noun1 = nouns[second % nouns.len];
    const noun2 = nouns[third % nouns.len];
    const verb = verbs[fourth % verbs.len];
    // std.debug.print("{any} {any} {s}-{s}\n", .{ parts, hash, adj, noun });
    const out = std.io.getStdOut();
    try out.writeAll(adj);
    try out.writeAll("-");
    try out.writeAll(noun1);
    try out.writeAll("-");
    try out.writeAll(verb);
    try out.writeAll("-");
    try out.writeAll(noun2);
    try out.writeAll("\n");
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
