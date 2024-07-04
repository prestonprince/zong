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
    pub fn update(self: *Ball) void {
        self.position = rlm.vector2Add(self.position, self.speed);

        // check for y collisions
        if (self.position.y <= 0 or self.position.y + self.size >= SCREEN_HEIGHT) {
            self.speed.y *= -1;
        }

        // check for x collisions
        if (self.position.x <= 0 or self.position.x + self.size >= SCREEN_WIDTH) {
            self.speed.x *= -1;
        }
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
    pub fn update(self: *Wall, ball: *Ball, is_wall_1: bool) void {
        self.position = rlm.vector2Add(self.position, self.speed);

        if ((is_wall_1 and ball.position.x <= self.position.x + WALL_WIDTH) or (!is_wall_1 and ball.position.x + ball.size >= self.position.x)) {
            ball.speed.x *= -1;
        }
    }
    pub fn draw(self: *Wall) void {
        rl.drawRectangleV(self.position, self.size, rl.Color.white);
    }
};

pub fn main() !void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "tut pong");
    defer rl.closeWindow();

    var ball = Ball.init(400, 200, 10, 6);
    var wall = Wall.init(10, 10, WALL_WIDTH, WALL_HEIGHT, 0);
    var wall_2 = Wall.init(770, 10, WALL_WIDTH, WALL_HEIGHT, 0);

    // main game loop
    rl.setTargetFPS(60);
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        // Update
        ball.update();
        wall.update(&ball, true);
        wall_2.update(&ball, false);

        // Draw
        wall.draw();
        wall_2.draw();
        ball.draw();
    }
}
