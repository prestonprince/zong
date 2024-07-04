const rl = @import("raylib");
const wall = @import("wall.zig");
const ball = @import("ball.zig");

const util = @import("../utils/util.zig");

pub const SCREEN_WIDTH = 800;
pub const SCREEN_HEIGHT = 400;

pub const PlayerEnum = enum(i32) {
    none = -1,
    player_one = 1,
    player_two = 2,
};

pub const GameState = struct {
    // Entities
    wall_1: *wall.Wall,
    wall_2: *wall.Wall,
    main_ball: *ball.Ball,

    // States
    is_title_screen: bool,
    is_game_over: bool,
    game_winner: PlayerEnum,

    pub fn update(self: *GameState) void {
        if (self.is_title_screen) {
            if (rl.isKeyDown(rl.KeyboardKey.key_enter)) {
                self.is_title_screen = false;
            }

            return;
        }
        self.wall_1.update(true);
        self.wall_2.update(false);
        const game_update = self.main_ball.update(self.wall_1, self.wall_2);

        if (@abs(self.main_ball.speed.x) >= 12) {
            self.main_ball.color = rl.Color.pink;
        }

        if (game_update.is_game_over) {
            self.is_game_over = game_update.is_game_over;
            self.game_winner = game_update.game_winner;
        }
    }

    pub fn draw(self: *GameState) void {
        self.wall_1.draw();
        self.wall_2.draw();
        self.main_ball.draw();
    }
};
