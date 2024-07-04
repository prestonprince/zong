const rl = @import("raylib");
const game_state = @import("../models/game_state.zig");

pub fn get_x_y_text_start(text: [:0]const u8, font_size: i32) struct {
    x_start: i32,
    y_start: i32,
} {
    const screenCenterX: i32 = @divTrunc(game_state.SCREEN_WIDTH, 2);
    const screenCenterY: i32 = @divTrunc(game_state.SCREEN_HEIGHT, 2);

    const text_width: i32 = rl.measureText(text, font_size);

    const text_x_start = screenCenterX - (@divTrunc(text_width, 2));
    const text_y_start = screenCenterY - font_size;

    return .{ .x_start = text_x_start, .y_start = text_y_start };
}
