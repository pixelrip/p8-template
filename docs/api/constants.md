# Constants System

Centralized configuration using flat naming for token efficiency.

## Quick Reference

```lua
-- Define in config/constants.lua
PLAYER_SPEED = 2
ENEMY_COUNT = 5
SCREEN_WIDTH = 128

-- Use anywhere
player.speed = PLAYER_SPEED
```

## Current Constants

```lua
DEBUG_MODE = false  -- Enable debug features
FPS = 30           -- Target framerate
```

## Adding Constants

Use flat naming to save tokens:

```lua
-- Good (flat)
PLAYER_SPEED = 2
PLAYER_HEALTH = 100
ENEMY_SPEED = 1
BULLET_DAMAGE = 25

-- Avoid (nested - uses more tokens)
PLAYER = {speed = 2, health = 100}
ENEMY = {speed = 1}
```

## Naming Convention

```
ENTITY_PROPERTY = value
ENTITY_CATEGORY_PROPERTY = value
SYSTEM_COMPONENT_PROPERTY = value
```

## Examples

```lua
-- Player constants
PLAYER_SPEED = 2
PLAYER_JUMP_HEIGHT = 8
PLAYER_MAX_HEALTH = 100

-- Game constants
GRAVITY = 0.5
SCREEN_SHAKE_DURATION = 10
INVINCIBILITY_FRAMES = 60

-- Audio constants
SFX_JUMP = 0
SFX_SHOOT = 1
MUSIC_TITLE = 0
```

## Usage

```lua
-- In entities
function Player:update()
    self.y += GRAVITY
    if self.speed > PLAYER_SPEED then
        self.speed = PLAYER_SPEED
    end
end

-- In game logic
if player.health <= 0 then
    sfx(SFX_DEATH)
    gs:switch("gameover")
end
