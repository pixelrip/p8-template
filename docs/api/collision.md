# Collision System API

Basic collision detection for Pico-8 games. Simple, extensible, and token-efficient.

## Basic Functions

### collision.point_rect(px, py, rx, ry, rw, rh)
Check if a point is inside a rectangle.

```lua
if collision.point_rect(mouse_x, mouse_y, button.x, button.y, button.w, button.h) then
    -- Mouse is over button
end
```

### collision.rect_rect(x1, y1, w1, h1, x2, y2, w2, h2)
Check if two rectangles overlap (AABB collision).

```lua
if collision.rect_rect(player.x, player.y, player.w, player.h,
                      enemy.x, enemy.y, enemy.w, enemy.h) then
    -- Player hit enemy
end
```

### collision.circle_circle(x1, y1, r1, x2, y2, r2)
Check if two circles overlap.

```lua
if collision.circle_circle(bullet.x, bullet.y, 2, enemy.x, enemy.y, 8) then
    -- Bullet hit enemy
end
```

### collision.objects(obj1, obj2)
Check if two objects collide. Objects must have `x`, `y`, `w`, `h` properties.

```lua
if collision.objects(player, pickup) then
    -- Player collected pickup
end
```

## Extension Points

The collision system includes commented examples for common extensions. Uncomment and modify these as needed for your game:

- **Tilemap Collision** - Check against tile-based worlds
- **Movement Helpers** - Move objects with collision response
- **Collision Groups** - Check objects against groups of other objects
- **Advanced Shapes** - Circle vs rectangle, line vs rectangle
- **Spatial Optimization** - Performance improvements for many objects

## Integration

```lua
-- Optional loading in main.lua
require("systems/collision")

-- Basic usage in game states
function GameState:update()
    if collision.objects(player, enemy) then
        -- Handle collision
    end
end
```

## Performance Tips

- Use rectangles for speed, circles for smooth movement
- Check distance before detailed collision
- Use spatial partitioning for 20+ objects
- Separate X/Y movement for platformers
