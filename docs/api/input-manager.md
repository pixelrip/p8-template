# Input Manager API

Simple input handling for Pico-8 games. Essential functionality that works immediately with clear expansion points.

## Basic Functions

### im:init()
Initialize the input manager. Call once at startup.

### im:update()
Update button states. Call at the beginning of each frame.

### im:pressed(button)
Check if a button was just pressed this frame.

```lua
if im:pressed(4) then  -- 🅾️ button
    shoot()
end
```

### im:released(button)
Check if a button was just released this frame.

```lua
if im:released(4) then  -- 🅾️ released
    charge_shot()
end
```

### im:held(button)
Check if a button is currently held down.

```lua
if im:held(0) then  -- Left arrow
    player.x -= 2
end
```

### im:set_cooldown(button, frames)
Set a cooldown for a specific button to prevent rapid input.

```lua
if im:pressed(4) then
    shoot()
    im:set_cooldown(4, 10)  -- 10 frame cooldown
end
```

## Button IDs

```
0 = Left    4 = 🅾️ (O)
1 = Right   5 = ❎ (X)
2 = Up
3 = Down
```

## Basic Usage Pattern

```lua
function _init()
    im:init()
end

function _update()
    im:update()
    
    -- Movement
    if im:held(0) then player.x -= 2 end  -- Left
    if im:held(1) then player.x += 2 end  -- Right
    
    -- Actions
    if im:pressed(4) then shoot() end     -- 🅾️ pressed
    if im:released(5) then jump() end     -- ❎ released
end
```

## Extension Points

The input manager includes commented examples for common extensions. Uncomment and modify these as needed for your game:

- **Two Player Support** - Handle multiple players with separate input states
- **Hold Detection** - Detect how long buttons are held, repeat input functionality
- **Combo Detection** - Recognize input sequences (Street Fighter-style combos)
- **Gesture Recognition** - Detect directional patterns and swipes
- **Input Recording** - Record and playback input sequences for demos/replays
- **Button Remapping** - Allow custom button configurations for accessibility

## Performance Tips

- Keep input checking simple - avoid complex logic in update loops
- Use cooldowns sparingly to preserve responsiveness
- Consider caching frequently checked input states
- For advanced features, only enable what your game actually needs
