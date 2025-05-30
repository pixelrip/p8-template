# Timer and Tween System

Simple timing and animation for Pico-8 games. Essential functionality that works immediately with clear expansion points.

## Basic Functions

### timer:add(duration, callback)
Add a countdown timer that calls a function when it expires.

```lua
timer:add(60, function() 
    explode() 
end)  -- Explode after 2 seconds (60 frames)
```

### timer:update()
Update all timers and tweens. Call once per frame.

```lua
function _update()
    timer:update()
end
```

### timer:clear()
Clear all active timers and tweens.

```lua
timer:clear()  -- Stop all animations
```

## Tween Functions

### timer:tween(object, property, target, duration, easing, callback)
Smoothly animate an object's property to a target value.

```lua
-- Move player to x=100 over 2 seconds
timer:tween(player, "x", 100, 120)

-- With easing and callback
timer:tween(player, "y", 50, 60, timer.ease_in_out, function()
    sfx(0)  -- Play sound when done
end)
```

### timer:lerp(start, target, t)
Linear interpolation between two values.

```lua
local value = timer:lerp(0, 100, 0.5)  -- Returns 50
```

### timer:ease_in_out(t)
Simple easing function for smooth animations.

```lua
timer:tween(menu, "y", 64, 30, timer.ease_in_out)
```

## Basic Usage Pattern

```lua
function _init()
    player = {x=10, y=10}
    
    -- Delayed action
    timer:add(180, function()
        spawn_enemy()
    end)
    
    -- Smooth movement
    timer:tween(player, "x", 100, 120, timer.ease_in_out)
end

function _update()
    timer:update()  -- Always call this first
end
```

## Common Examples

### Menu Animations
```lua
-- Slide menu in from top
timer:tween(menu, "y", 64, 30, timer.ease_in_out)

-- Fade effect (using color)
timer:tween(text, "color", 7, 60)
```

### Game Events
```lua
-- Delayed spawn
timer:add(120, function() spawn_powerup() end)

-- Temporary invincibility
timer:add(180, function() player.invincible = false end)
```

### Smooth Movement
```lua
-- Move to clicked position
timer:tween(player, "x", mouse_x, 60)
timer:tween(player, "y", mouse_y, 60)
```

## Extension Points

The timer system includes commented examples for common extensions. Uncomment and modify these as needed for your game:

- **Advanced Easing** - Bounce, elastic, quadratic, and other easing functions
- **Multi-Property Tweens** - Animate multiple properties simultaneously
- **Tween Chains** - Sequence multiple animations with waits and callbacks
- **Tween Groups** - Manage related animations together (pause/resume/clear)
- **Custom Interpolation** - Color lerping, angle interpolation, custom curves
- **Performance Optimization** - Object pooling for frequently created timers
- **Animation Events** - Callbacks during animation progress (50%, 80%, etc.)

## Performance Tips

- Use `timer:clear()` when switching game states to prevent memory leaks
- For frequently created timers, consider the pooling extension
- Keep easing functions simple to preserve tokens
- Batch similar animations using multi-property tweens
