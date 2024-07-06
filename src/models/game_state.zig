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
    is_main_game: bool,
    is_game_over: bool,
    game_winner: PlayerEnum,

    pub fn update(self: *GameState) void {
        if (self.is_title_screen) {
            if (rl.isKeyDown(rl.KeyboardKey.key_space)) {
                self.is_title_screen = false;
                self.is_main_game = true;
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
            self.is_main_game = false;
        }
    }

    pub fn reset(self: *GameState) void {
        self.main_ball.reset();
        self.wall_1.reset_wall_1();
        self.wall_2.reset_wall_2();

        self.is_game_over = false;
        self.is_title_screen = true;
        self.is_main_game = false;
        self.game_winner = PlayerEnum.none;
    }

    pub fn draw(self: *GameState) void {
        self.wall_1.draw();
        self.wall_2.draw();
        self.main_ball.draw();
    }
};
