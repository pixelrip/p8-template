# Architecture Guide

## Core Patterns

### State Pattern
```lua
MyState = State:new()

function MyState:init()    -- Called when entering
function MyState:update()  -- Called every frame
function MyState:draw()    -- Called every frame
function MyState:exit()    -- Called when leaving
```

### Entity Pattern
```lua
Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    self.x, self.y = x, y
    
    function self:update()
        -- Handle input, physics, etc.
    end
    
    function self:draw()
        circfill(self.x, self.y, 4, 7)
    end
    
    return self
end
```

## PICO-8 Optimization

### Token Efficiency
- **Flat constants**: `PLAYER_SPEED = 2` not `PLAYER.SPEED = 2`
- **Combined declarations**: `local x,y = 0,0`
- **Methods in constructors**: Avoid prototype pollution
- **Short aliases**: `local cf = circfill`

### Performance
- **Reverse iteration**: `for i=#list,1,-1 do` (safe removal)
- **Frame counters**: Use `frame += 1` not `time()`
- **Local variables**: Cache frequently accessed data
- **Integer math**: Prefer over floating point

### Memory
- **Minimize object creation** in update loops
- **Reuse tables** when possible
- **Clear unused references**: `obj = nil`
