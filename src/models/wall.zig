const rl = @import("raylib");
pub const WALL_HEIGHT = 200;
pub const WALL_WIDTH = 20;

pub const Wall = struct {
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
            if (rl.isKeyDown(rl.KeyboardKey.key_w)) self.position.y -= 9;
            if (rl.isKeyDown(rl.KeyboardKey.key_s)) self.position.y += 9;
        } else {
            if (rl.isKeyDown(rl.KeyboardKey.key_up)) self.position.y -= 9;
            if (rl.isKeyDown(rl.KeyboardKey.key_down)) self.position.y += 9;
        }
    }
    pub fn draw(self: *Wall) void {
        rl.drawRectangleV(self.position, self.size, rl.Color.white);
    }
};
