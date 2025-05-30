# Camera System

Simple camera control for Pico-8 games. Essential functionality that works immediately with clear expansion points for advanced camera behaviors.

## Basic Functions

### cam:set_position(x, y)
Set camera position directly.

```lua
cam:set_position(100, 50)  -- Position camera at world coordinates
```

### cam:follow(target_object)
Make camera follow a target object (must have x, y properties).

```lua
cam:follow(player)  -- Camera will center on player
```

### cam:update()
Update camera position. Call once per frame.

```lua
function _update()
    cam:update()  -- Update camera before game logic
end
```

### cam:apply() / cam:reset()
Apply and reset camera transform for drawing.

```lua
function _draw()
    -- Draw world objects with camera
    cam:apply()
    draw_world()
    cam:reset()
    
    -- Draw UI without camera
    draw_ui()
end
```

### cam:set_bounds(min_x, min_y, max_x, max_y)
Constrain camera to world boundaries.

```lua
cam:set_bounds(0, 0, 512, 512)  -- Keep camera in 512x512 world
```

## Basic Usage Pattern

```lua
function _init()
    player = {x = 100, y = 100}
    
    -- Set up camera
    cam:follow(player)
    cam:set_bounds(0, 0, 1024, 1024)  -- World size
end

function _update()
    -- Update camera first
    cam:update()
    
    -- Update game objects
    update_player()
end

function _draw()
    cls()
    
    -- Draw world with camera
    cam:apply()
    draw_world()
    draw_player()
    cam:reset()
    
    -- Draw UI without camera
    draw_hud()
end
```

## Common Examples

### Platformer Camera
```lua
-- Basic following
cam:follow(player)
cam:set_bounds(0, 0, level_width, level_height)
```

### Top-Down Game
```lua
-- Center on player
cam:follow(player)
cam:set_bounds(0, 0, world_width, world_height)
```

### Fixed Camera Positions
```lua
-- Move to specific location
cam:set_position(room_x, room_y)

-- Switch between rooms
if player.x > room_boundary then
    cam:set_position(next_room_x, next_room_y)
end
```

### Manual Camera Control
```lua
-- Debug camera movement
if im:held(0) then cam.x -= 2 end  -- Left
if im:held(1) then cam.x += 2 end  -- Right
if im:held(2) then cam.y -= 2 end  -- Up
if im:held(3) then cam.y += 2 end  -- Down
```

## Extension Points

The camera system includes commented examples for common extensions. Uncomment and modify these as needed for your game:

- **Camera Shake** - Screen shake effects for impacts and explosions
- **Smooth Following** - Lerped movement with deadzone for smoother camera
- **Look Ahead** - Camera leads player movement direction
- **Multiple Targets** - Focus on multiple objects, zoom to fit all
- **Zoom System** - Scale in/out with smooth transitions (complex)
- **Camera Zones** - Different camera behaviors in different areas
- **Cinematic Camera** - Scripted camera movements for cutscenes
- **Utility Functions** - World/screen coordinate conversion, bounds checking

## Integration with Other Systems

### With Timer System
```lua
-- Smooth camera transitions
timer:tween(cam, "x", target_x, 60, timer.ease_in_out)
timer:tween(cam, "y", target_y, 60, timer.ease_in_out)
```

### With Math Utilities
```lua
-- Keep camera in bounds
cam.x = math2d.clamp(cam.x, 0, world_width - 128)
cam.y = math2d.clamp(cam.y, 0, world_height - 128)

-- Smooth following
local dx, dy = math2d.normalize(target.x - cam.x, target.y - cam.y)
cam.x += dx * follow_speed
cam.y += dy * follow_speed
```

### With Game States
```lua
-- Different camera behavior per state
function GameState:init()
    cam:follow(player)
end

function MenuState:init()
    cam:set_position(menu_x, menu_y)
end
```

## Performance Tips

- Update camera before updating game objects to avoid one-frame lag
- Use `cam:set_bounds()` to prevent camera from showing empty areas
- Consider using smooth following extensions for better feel
- For large worlds, only update/draw objects visible on screen
- Use camera shake sparingly to preserve impact
