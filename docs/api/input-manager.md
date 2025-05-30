# Input Manager

Handles button states, cooldowns, and input patterns.

## Quick Reference

```lua
im:init()                      -- Initialize (call once)
im:update()                    -- Update states (call each frame)
im:pressed(btn, player)        -- Just pressed this frame
im:released(btn, player)       -- Just released this frame
im:down(btn, player)           -- Currently held down
im:held(btn, duration, player) -- Held for duration frames
```

## Basic Usage

```lua
function _init()
    im:init()
end

function _update()
    im:update()
    
    -- Movement
    if im:down(0) then player.x -= 2 end  -- Left held
    if im:down(1) then player.x += 2 end  -- Right held
    
    -- Actions
    if im:pressed(4) then shoot() end     -- 🅾️ pressed
    if im:released(5) then charge_shot() end  -- ❎ released
end
```

## Advanced Features

### Hold Detection
```lua
-- Charge attack after holding for 1 second
if im:just_held(4, 30) then  -- 30 frames = 1 sec
    start_charge_effect()
end

if im:held(4, 30) and im:released(4) then
    fire_charge_shot()
end
```

### Repeat Input
```lua
-- Menu navigation with repeat
if im:repeat_input(2, 15, 8) then  -- Down, 0.5s delay, repeat every 8 frames
    menu_cursor += 1
end
```

### Cooldowns
```lua
-- Prevent rapid fire
if im:pressed(4) then
    shoot()
    im:set_cooldown(4, 10)  -- 10 frame cooldown
end

-- Global cooldown (affects all buttons)
im:set_global_cooldown(30)
```

## Button IDs

```
0 = Left    4 = 🅾️ (O)
1 = Right   5 = ❎ (X)
2 = Up
3 = Down
```

## Two Players

```lua
-- Player 0 (default)
if im:pressed(4, 0) then player1_action() end

-- Player 1
if im:pressed(4, 1) then player2_action() end
