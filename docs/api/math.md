# Math Utilities

Essential 2D game math for Pico-8. Provides common mathematical operations with clear expansion points for advanced game math.

## Vector Operations

### math2d.distance(x1, y1, x2, y2)
Calculate distance between two points.

```lua
local dist = math2d.distance(player.x, player.y, enemy.x, enemy.y)
if dist < 16 then
    -- Enemy is close to player
end
```

### math2d.normalize(x, y)
Convert vector to unit length (magnitude of 1).

```lua
local dx, dy = math2d.normalize(target.x - player.x, target.y - player.y)
player.x += dx * player.speed
player.y += dy * player.speed
```

### math2d.dot(x1, y1, x2, y2)
Calculate dot product of two vectors.

```lua
local dot = math2d.dot(player.vx, player.vy, wall.nx, wall.ny)
-- Use for collision response, angle calculations
```

## Angle Utilities

### math2d.angle_to(x1, y1, x2, y2)
Get angle from first point to second point (in radians).

```lua
local angle = math2d.angle_to(turret.x, turret.y, player.x, player.y)
turret.rotation = angle
```

### math2d.deg_to_rad(degrees) / math2d.rad_to_deg(radians)
Convert between degrees and radians.

```lua
local rad_angle = math2d.deg_to_rad(45)  -- 45 degrees to radians
local deg_angle = math2d.rad_to_deg(0.785)  -- ~45 degrees
```

## Range and Clamping

### math2d.clamp(value, min_val, max_val)
Constrain value between minimum and maximum.

```lua
player.x = math2d.clamp(player.x, 0, 127)  -- Keep on screen
health = math2d.clamp(health + healing, 0, max_health)
```

### math2d.map(value, in_min, in_max, out_min, out_max)
Map value from one range to another.

```lua
-- Convert health (0-100) to color (8-11)
local color = math2d.map(health, 0, 100, 8, 11)

-- Create bullet spread
for i = 1, 5 do
    local angle = math2d.map(i, 1, 5, -0.2, 0.2)
    spawn_bullet(player.x, player.y, base_angle + angle)
end
```

## Random Utilities

### math2d.random_range(min_val, max_val)
Random float between min and max values.

```lua
local spawn_x = math2d.random_range(10, 117)
local damage = math2d.random_range(8, 12)
```

### math2d.random_choice(table)
Pick random element from table.

```lua
local colors = {7, 10, 11, 12}
local random_color = math2d.random_choice(colors)

local enemy_types = {"grunt", "scout", "heavy"}
local enemy_type = math2d.random_choice(enemy_types)
```

## Common Usage Patterns

### Enemy AI Movement
```lua
-- Move toward player
local dx, dy = math2d.normalize(player.x - enemy.x, player.y - enemy.y)
enemy.x += dx * enemy.speed
enemy.y += dy * enemy.speed

-- Keep enemy on screen
enemy.x = math2d.clamp(enemy.x, 0, 127)
enemy.y = math2d.clamp(enemy.y, 0, 127)
```

### Bullet Patterns
```lua
-- Spread shot
for i = 1, 5 do
    local angle = math2d.map(i, 1, 5, -0.3, 0.3)
    local bullet_angle = player.angle + angle
    spawn_bullet(player.x, player.y, bullet_angle)
end

-- Aimed shot
local angle = math2d.angle_to(enemy.x, enemy.y, player.x, player.y)
spawn_bullet(enemy.x, enemy.y, angle)
```

### Screen Effects
```lua
-- Health-based screen shake
local shake_intensity = math2d.map(player.health, 0, 100, 5, 0)
camera_x += math2d.random_range(-shake_intensity, shake_intensity)

-- Distance-based volume
local dist = math2d.distance(player.x, player.y, sound_source.x, sound_source.y)
local volume = math2d.clamp(math2d.map(dist, 0, 64, 1, 0), 0, 1)
```

## Extension Points

The math utilities include commented examples for common extensions. Uncomment and modify these as needed for your game:

- **Advanced Vector Operations** - Cross product, reflection, projection, perpendicular
- **Bezier Curves** - Quadratic and cubic bezier calculations for smooth paths
- **Noise Functions** - Simple noise generation for procedural content
- **Geometric Shapes** - Point-in-shape tests, line/circle intersection
- **Physics Helpers** - Velocity, acceleration, friction, spring forces, orbiting
- **Interpolation** - Smoothstep, smootherstep, and other interpolation methods
- **Matrix Operations** - 2D transformations (rotate, scale points)
- **Fast Approximations** - Performance-optimized versions of expensive operations

## Performance Tips

- Use `math2d.fast_distance()` extension for approximate distance when exact values aren't needed
- Cache frequently calculated values (like normalized vectors)
- Consider using integer math when possible to save tokens
- Use `math2d.clamp()` instead of multiple `min()`/`max()` calls
