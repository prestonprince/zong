const std = @import("std");
const rl = @import("raylib");
const rlm = rl.math;

const game_state = @import("models/game_state.zig");
const ball = @import("models/ball.zig");
const wall = @import("models/wall.zig");

pub fn main() !void {
    rl.initWindow(game_state.SCREEN_WIDTH, game_state.SCREEN_HEIGHT, "zong");
    defer rl.closeWindow();

    var main_ball = ball.Ball.init(400, 200, 10, 4);
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

            const screenCenterX: i32 = @divTrunc(game_state.SCREEN_WIDTH, 2);
            const screenCenterY: i32 = @divTrunc(game_state.SCREEN_HEIGHT, 2);

            const font_size: i32 = 24;
            const game_over_text_width: i32 = rl.measureText(game_over_text, font_size);
            const game_winner_text_width: i32 = rl.measureText(game_winner_text, font_size);

            const game_over_text_start_x = screenCenterX - (@divTrunc(game_over_text_width, 2));
            const game_winner_text_start_x = screenCenterX - (@divTrunc(game_winner_text_width, 2));

            const game_over_text_start_y = screenCenterY - font_size;
            const game_winner_text_start_y = (screenCenterY - font_size);

            rl.drawText(game_over_text, game_over_text_start_x, game_over_text_start_y - 25, font_size, rl.Color.red);
            rl.drawText(game_winner_text, game_winner_text_start_x, game_winner_text_start_y + 10, font_size, rl.Color.red);
        }
    }
}
