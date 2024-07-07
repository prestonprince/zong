const rl = @import("raylib");
const rlm = rl.math;

const wall_model = @import("wall.zig");
const Wall = wall_model.Wall;

const GameState = @import("game_state.zig");

const InitialBallValuesModel = struct {
    pos: rl.Vector2,
    speed: rl.Vector2,
    size: f32,
    color: rl.Color,
};

pub const InitialBallValues = InitialBallValuesModel{
    .size = 10,
    .pos = rl.Vector2.init(400, 200),
    .speed = rl.Vector2.init(5, 5),
    .color = rl.Color.white,
};

pub const Ball = struct {
    position: rl.Vector2,
    size: f32,
    speed: rl.Vector2,
    color: rl.Color,

    pub fn init() Ball {
        return Ball{
            .position = InitialBallValues.pos,
            .size = InitialBallValues.size,
            .speed = InitialBallValues.speed,
            .color = InitialBallValues.color,
        };
    }
    pub fn reset(self: *Ball) void {
        self.position = InitialBallValues.pos;
        self.size = InitialBallValues.size;
        self.speed = InitialBallValues.speed;
        self.color = InitialBallValues.color;
    }
    pub fn update(self: *Ball, wall_1: *Wall, wall_2: *Wall) struct {
        is_game_over: bool,
        game_winner: GameState.PlayerEnum,
    } {
        self.position = rlm.vector2Add(self.position, self.speed);

        // check for y collisions
        if (self.position.y <= 0 or self.position.y + self.size >= GameState.SCREEN_HEIGHT) {
            self.speed.y *= -1;

            return .{ .is_game_over = false, .game_winner = GameState.PlayerEnum.none };
        }

        const wall_1_y_cond = self.position.y >= wall_1.position.y and self.position.y <= wall_1.position.y + wall_model.WALL_HEIGHT;
        const wall_2_y_cond = self.position.y >= wall_2.position.y and self.position.y <= wall_2.position.y + wall_model.WALL_HEIGHT;
        const wall_1_x_conditional = self.position.x - self.size <= wall_1.position.x + wall_model.WALL_WIDTH;
        const wall_2_x_conditional = self.position.x + self.size >= wall_2.position.x;

        if ((wall_1_y_cond and wall_1_x_conditional) or (wall_2_y_cond and wall_2_x_conditional)) {
            if (@abs(self.speed.x) < 16) {
                self.speed.x *= -1.1;
            } else {
                self.speed.x *= -1;
            }

            return .{ .is_game_over = false, .game_winner = GameState.PlayerEnum.none };
        }

        if (self.position.x < wall_1.position.x + wall_model.WALL_WIDTH) {
            return .{ .is_game_over = true, .game_winner = GameState.PlayerEnum.player_two };
        }

        if (self.position.x + self.size > wall_2.position.x) {
            return .{ .is_game_over = true, .game_winner = GameState.PlayerEnum.player_one };
        }

        return .{ .is_game_over = false, .game_winner = GameState.PlayerEnum.none };
    }
    pub fn draw(self: *Ball) void {
        rl.drawCircleV(self.position, self.size, self.color);
    }
};
