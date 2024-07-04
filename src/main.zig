const std = @import("std");
const rl = @import("raylib");
const rlm = rl.math;

const game_state = @import("models/game_state.zig");
const ball = @import("models/ball.zig");
const wall = @import("models/wall.zig");

fn get_x_y_text_start(text: [:0]const u8, font_size: i32) struct {
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

pub fn main() !void {
    rl.initWindow(game_state.SCREEN_WIDTH, game_state.SCREEN_HEIGHT, "zong");
    defer rl.closeWindow();

    var main_ball = ball.Ball.init(400, 200, 10, 5, rl.Color.white);
    var wall_1 = wall.Wall.init(50, 10, wall.WALL_WIDTH, wall.WALL_HEIGHT, 0);
    var wall_2 = wall.Wall.init(730, 10, wall.WALL_WIDTH, wall.WALL_HEIGHT, 0);

    var main_game_state = game_state.GameState{
        .main_ball = &main_ball,
        .wall_1 = &wall_1,
        .wall_2 = &wall_2,
        .game_winner = game_state.PlayerEnum.none,
        .is_game_over = false,
    };

    // Main game loop
    rl.setTargetFPS(60);
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        if (!main_game_state.is_game_over and main_game_state.game_winner == game_state.PlayerEnum.none) {
            // Update
            main_game_state.update();

            // Draw
            main_game_state.draw();
        } else {
            const game_over_text: [:0]const u8 = "GAME OVER";
            const game_winner_text: [:0]const u8 = if (main_game_state.game_winner == game_state.PlayerEnum.player_one) "PLAYER ONE WINS" else "PLAYER TWO WINS";

            const game_over_text_starts = get_x_y_text_start(game_over_text, 24);
            const game_winner_text_starts = get_x_y_text_start(game_winner_text, 24);

            rl.drawText(game_over_text, game_over_text_starts.x_start, game_over_text_starts.y_start - 25, 24, rl.Color.red);
            rl.drawText(game_winner_text, game_winner_text_starts.x_start, game_winner_text_starts.y_start + 10, 24, rl.Color.red);
        }
    }
}
