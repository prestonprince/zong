const rl = @import("raylib");
pub const WALL_HEIGHT = 200;
pub const WALL_WIDTH = 20;

const WallInitialValuesModel = struct {
    pos: rl.Vector2,
    size: rl.Vector2,
    speed: rl.Vector2,
};

const Wall_1_InitialValues = WallInitialValuesModel{ .pos = rl.Vector2.init(50, 10), .size = rl.Vector2.init(WALL_WIDTH, WALL_HEIGHT), .speed = rl.Vector2.init(0, 0) };
const Wall_2_InitialValues = WallInitialValuesModel{ .pos = rl.Vector2.init(730, 10), .size = rl.Vector2.init(WALL_WIDTH, WALL_HEIGHT), .speed = rl.Vector2.init(0, 0) };

pub const Wall = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    speed: rl.Vector2,

    pub fn init_wall_1() Wall {
        return Wall{
            .position = Wall_1_InitialValues.pos,
            .size = Wall_1_InitialValues.size,
            .speed = Wall_1_InitialValues.speed,
        };
    }
    pub fn init_wall_2() Wall {
        return Wall{
            .position = Wall_2_InitialValues.pos,
            .size = Wall_2_InitialValues.size,
            .speed = Wall_2_InitialValues.speed,
        };
    }
    pub fn reset_wall_1(self: *Wall) void {
        const w = Wall_1_InitialValues;
        self.position = w.pos;
        self.size = w.size;
        self.speed = w.speed;
    }
    pub fn reset_wall_2(self: *Wall) void {
        const w = Wall_2_InitialValues;
        self.position = w.pos;
        self.size = w.size;
        self.speed = w.speed;
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
