pub const pin = @import("pin.zig");
pub const uart = @import("uart.zig");
pub const spi = @import("spi.zig");

pub const clock = @import("clock.zig");
pub const flash = @import("flash.zig");

const mem = @import("std").mem;

pub const ChipSeriseType = enum {
    STM32F4,
};

pub var chip_series: ChipSeriseType = ChipSeriseType.STM32F4;

pub fn init(series: []const u8) void {
    if (mem.eql(u8, series[0..], "F4")) {
        chip_series = ChipSeriseType.STM32F4;
    }
    clock.init();
    flash.init();
}
