const std = @import("std");
const rl = @import("raylib");

const rlm = rl.math;

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 400;

const WALL_HEIGHT = 200;
const WALL_WIDTH = 20;

const Ball = struct {
    position: rl.Vector2,
    size: f32,
    speed: rl.Vector2,

    pub fn init(x: f32, y: f32, size: f32, speed: f32) Ball {
        return Ball{
            .position = rl.Vector2.init(x, y),
            .size = size,
            .speed = rl.Vector2.init(speed, speed),
        };
    }
    pub fn update(self: *Ball, wall_1: *Wall, wall_2: *Wall) struct {
        is_game_over: bool,
        player_winner: i32,
    } {
        self.position = rlm.vector2Add(self.position, self.speed);

        // check for y collisions
        if (self.position.y <= 0 or self.position.y + self.size >= SCREEN_HEIGHT) {
            self.speed.y *= -1;
            return .{ .is_game_over = false, .player_winner = -1 };
        }

        const wall_1_y_cond = self.position.y >= wall_1.position.y and self.position.y <= wall_1.position.y + WALL_HEIGHT;
        const wall_2_y_cond = self.position.y >= wall_2.position.y and self.position.y <= wall_2.position.y + WALL_HEIGHT;
        const wall_1_x_conditional = self.position.x - self.size <= wall_1.position.x + WALL_WIDTH;
        const wall_2_x_conditional = self.position.x + self.size >= wall_2.position.x;

        if ((wall_1_y_cond and wall_1_x_conditional) or (wall_2_y_cond and wall_2_x_conditional)) {
            self.speed.x *= -1;
            return .{ .is_game_over = false, .player_winner = -1 };
        }

        if (self.position.x < wall_1.position.x + WALL_WIDTH) {
            return .{ .is_game_over = true, .player_winner = 2 };
        }

        if (self.position.x + self.size > wall_2.position.x) {
            return .{ .is_game_over = true, .player_winner = 1 };
        }

        return .{ .is_game_over = false, .player_winner = -1 };
    }
    pub fn draw(self: *Ball) void {
        rl.drawCircleV(self.position, self.size, rl.Color.white);
    }
};

const Wall = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    speed: rl.Vector2,

    pub fn init(x: f32, y: f32, width: f32, length: f32, speed: f32) Wall {
        return Wall{
            .position = rl.Vector2.init(x, y),
            .size = rl.Vector2.init(width, length),
            .speed = rl.Vector2.init(speed, speed),
        };
    }
    pub fn update(self: *Wall, is_wall_1: bool) void {
        if (is_wall_1) {
            if (rl.isKeyDown(rl.KeyboardKey.key_w)) self.position.y -= 7;
            if (rl.isKeyDown(rl.KeyboardKey.key_s)) self.position.y += 7;
        } else {
            if (rl.isKeyDown(rl.KeyboardKey.key_up)) self.position.y -= 7;
            if (rl.isKeyDown(rl.KeyboardKey.key_down)) self.position.y += 7;
        }
    }
    pub fn draw(self: *Wall) void {
        rl.drawRectangleV(self.position, self.size, rl.Color.white);
    }
};

pub fn main() !void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "tut pong");
    defer rl.closeWindow();

    var ball = Ball.init(400, 200, 10, 4);
    var wall = Wall.init(50, 10, WALL_WIDTH, WALL_HEIGHT, 0);
    var wall_2 = Wall.init(730, 10, WALL_WIDTH, WALL_HEIGHT, 0);

    var end_game: bool = false;

    // main game loop
    rl.setTargetFPS(60);
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        if (!end_game) {
            // Update
            const state = ball.update(&wall, &wall_2);
            wall.update(true);
            wall_2.update(false);

            // Draw
            wall.draw();
            wall_2.draw();
            ball.draw();
            if (state.is_game_over) {
                end_game = true;
            }
        } else {
            rl.drawText("GAME OVER", 350, 200, 24, rl.Color.red);
        }
    }
}
