const std = @import("std");
const rl = @import("raylib");
const rlm = rl.math;

const game_state = @import("models/game_state.zig");
const ball = @import("models/ball.zig");
const wall = @import("models/wall.zig");

const util = @import("utils/util.zig");

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
        .is_title_screen = true,
    };

    // Main game loop
    rl.setTargetFPS(60);
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        if (main_game_state.is_title_screen) {
            const title_text = "Zong";
            const title_text_starts = util.get_x_y_text_start(title_text, 24);

            const instruction_text = "Press Enter To Start";
            const instruction_text_starts = util.get_x_y_text_start(instruction_text, 24);

            rl.drawText(title_text, title_text_starts.x_start, title_text_starts.y_start - 25, 24, rl.Color.white);
            rl.drawText(instruction_text, instruction_text_starts.x_start, instruction_text_starts.y_start + 10, 24, rl.Color.white);

            main_game_state.update();
        } else if (!main_game_state.is_game_over and main_game_state.game_winner == game_state.PlayerEnum.none) {
            // Update
            main_game_state.update();

            // Draw
            main_game_state.draw();
        } else {
            const game_over_text: [:0]const u8 = "GAME OVER";
            const game_winner_text: [:0]const u8 = if (main_game_state.game_winner == game_state.PlayerEnum.player_one) "PLAYER ONE WINS" else "PLAYER TWO WINS";
            const restart_text: [:0]const u8 = "Press Enter To Restart";

            const game_over_text_starts = util.get_x_y_text_start(game_over_text, 24);
            const game_winner_text_starts = util.get_x_y_text_start(game_winner_text, 24);
            const restart_text_starts = util.get_x_y_text_start(restart_text, 18);

            rl.drawText(game_over_text, game_over_text_starts.x_start, game_over_text_starts.y_start - 25, 24, rl.Color.red);
            rl.drawText(game_winner_text, game_winner_text_starts.x_start, game_winner_text_starts.y_start + 10, 24, rl.Color.red);
            rl.drawText(restart_text, restart_text_starts.x_start, restart_text_starts.y_start + 40, 18, rl.Color.white);

            if (rl.isKeyDown(rl.KeyboardKey.key_enter)) {
                main_game_state.game_winner = game_state.PlayerEnum.none;
                main_game_state.is_game_over = false;
                main_game_state.is_title_screen = true;
            }
        }
    }
}
