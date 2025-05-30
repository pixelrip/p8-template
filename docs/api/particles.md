# Particle System

Simple particle effects for Pico-8 games. Essential visual effects that work immediately with clear expansion points for advanced particle behaviors.

## Basic Functions

### particles:emit(x, y, count, config)
Emit particles at a position with configuration options.

```lua
-- Basic emission
particles:emit(player.x, player.y, 5, {
    speed = 2,
    life = 30,
    color = 10
})

-- Advanced configuration
particles:emit(explosion_x, explosion_y, 10, {
    speed_min = 1,
    speed_max = 3,
    angle_min = 0,
    angle_max = 1,
    life = 25,
    colors = {8, 9, 10},
    spread_x = 4,
    spread_y = 4
})
```

### particles:update()
Update all active particles. Call once per frame.

```lua
function _update()
    particles:update()  -- Update particles each frame
end
```

### particles:draw()
Draw all active particles.

```lua
function _draw()
    -- Draw particles with camera
    cam:apply()
    particles:draw()
    cam:reset()
end
```

### particles:clear()
Remove all active particles.

```lua
particles:clear()  -- Clear all particles (state transitions, etc.)
```

## Configuration Options

### Basic Properties
- **speed** - Single speed value for all particles
- **speed_min/speed_max** - Random speed range
- **angle** - Single angle (0-1, where 0.25 = up, 0.75 = down)
- **angle_min/angle_max** - Random angle range
- **life** - Particle lifetime in frames
- **color** - Single color for all particles
- **colors** - Array of colors to randomly choose from
- **spread_x/spread_y** - Random position offset

## Simple Presets

### particles:explosion(x, y, intensity)
Create an explosion effect.

```lua
particles:explosion(enemy.x, enemy.y)  -- Basic explosion
particles:explosion(bomb.x, bomb.y, 2)  -- Bigger explosion
```

### particles:trail(x, y, color)
Create a trailing effect.

```lua
particles:trail(player.x, player.y, 12)  -- Blue trail
particles:trail(bullet.x, bullet.y)     -- White trail
```

### particles:sparkle(x, y)
Create a sparkle effect.

```lua
particles:sparkle(coin.x, coin.y)  -- Collectible sparkle
particles:sparkle(star.x, star.y)  -- Decorative sparkle
```

## Basic Usage Pattern

```lua
function _init()
    player = {x = 64, y = 64}
    -- Particle system auto-initializes
end

function _update()
    -- Update particles first
    particles:update()
    
    -- Create effects based on game events
    if player_jumped then
        particles:trail(player.x, player.y + 8, 13)
    end
    
    if enemy_died then
        particles:explosion(enemy.x, enemy.y)
    end
end

function _draw()
    cls()
    
    -- Draw world with camera
    cam:apply()
    draw_world()
    particles:draw()  -- Draw particles in world space
    cam:reset()
    
    -- Draw UI
    draw_hud()
end
```

## Common Examples

### Action Game Effects
```lua
-- Muzzle flash
particles:emit(gun.x, gun.y, 3, {
    speed_min = 0.5,
    speed_max = 1.5,
    angle = gun.angle,
    life = 8,
    colors = {9, 10}
})

-- Impact sparks
particles:emit(hit.x, hit.y, 5, {
    speed_min = 1,
    speed_max = 2,
    life = 15,
    colors = {7, 10}
})
```

### Platformer Effects
```lua
-- Jump dust
particles:emit(player.x, player.y + 8, 3, {
    speed_min = 0.2,
    speed_max = 0.8,
    angle_min = 0.1,
    angle_max = 0.4,
    life = 20,
    color = 6
})

-- Collectible pickup
particles:sparkle(coin.x, coin.y)
```

### Environmental Effects
```lua
-- Falling leaves
particles:emit(tree.x, tree.y, 1, {
    speed_min = 0.1,
    speed_max = 0.3,
    angle_min = 0.6,
    angle_max = 0.9,
    life = 120,
    colors = {3, 11}
})

-- Water splash
particles:emit(water.x, water.y, 8, {
    speed_min = 1,
    speed_max = 2.5,
    angle_min = 0.1,
    angle_max = 0.4,
    life = 30,
    color = 12
})
```

## Extension Points

The particle system includes commented examples for common extensions. Uncomment and modify these as needed for your game:

- **Advanced Emitters** - Continuous emission, shaped emitters (circle, line)
- **Physics Integration** - Gravity, wind, collision with world
- **Sprite Particles** - Use sprites instead of pixels for larger effects
- **Particle Types** - Different behaviors (smoke, fire, water, magic)
- **Emitter Patterns** - Fireworks, fountains, spirals, bursts
- **Visual Effects** - Fading, scaling, rotation, color transitions
- **Performance Optimization** - Spatial partitioning, LOD systems

## Integration with Other Systems

### With Timer System
```lua
-- Delayed explosion
timer:add(60, function()
    particles:explosion(bomb.x, bomb.y)
end)

-- Particle burst sequence
for i = 1, 5 do
    timer:add(i * 10, function()
        particles:sparkle(target.x, target.y)
    end)
end
```

### With Math Utilities
```lua
-- Circular emission pattern
for i = 1, 8 do
    local angle = math2d.map(i, 1, 8, 0, 1)
    particles:emit(center.x, center.y, 1, {
        speed = 2,
        angle = angle,
        life = 30,
        color = 11
    })
end
```

### With Camera System
```lua
-- Only emit particles visible on screen
if cam:is_on_screen(effect.x, effect.y, 16) then
    particles:explosion(effect.x, effect.y)
end
```

### With Collision System
```lua
-- Particles on collision
if collision.check(bullet, enemy) then
    particles:emit(bullet.x, bullet.y, 5, {
        speed_min = 0.5,
        speed_max = 2,
        life = 20,
        colors = {8, 9}
    })
end
```

## Performance Tips

- The system uses object pooling to prevent garbage collection issues
- Maximum of 100 particles by default (configurable)
- Use `particles:clear()` when switching game states
- Consider using camera culling extensions for large worlds
- Limit particle count for complex effects to maintain 60fps
- Use simple presets for common effects rather than custom configurations

## Object Pool System

The particle system automatically manages memory using object pooling:
- Pre-allocates 100 particle objects at startup
- Reuses particles when they expire
- No memory allocation during gameplay
- Pool exhaustion gracefully handled (new particles ignored)
