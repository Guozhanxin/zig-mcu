const std = @import("std");
const hal = @import("hal/hal.zig");
const sys = @import("platform/sys.zig");

// const pin = @import("chip/stm32f4/pin.zig");
// const clock = @import("chip/stm32f4/clock.zig");

export fn main() noreturn {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    const led = hal.pin.Pin("PC13") catch unreachable;
    hal.clock.clock_init();

    led.mode(hal.pin.Pin_Mode.Output);
    sys.init_debug("PA9") catch {};
    while (true) {
        led.write(hal.pin.Pin_Level.Low);
        hal.clock.delay_ms(1000);

        led.write(hal.pin.Pin_Level.High);
        hal.clock.delay_ms(1000);

        sys.debug.print("Hello Zboot App v1!\r\n", .{}) catch {};
    }
}

export fn subcpu_entry() noreturn {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    while (true) {}
}
