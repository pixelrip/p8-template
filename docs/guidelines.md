# Project Coding Guidelines

This document provides guidance for how this boilerplate expects game code to be created. 

## Architecture Patterns

### Entity-System Hybrid
- **Entities**: Encapsulate state and basic behaviors
- **Systems**: Handle cross-entity concerns and complex mechanics
- **Delegation**: Entities call systems for complex operations

### Entity Pattern
```lua
Entity = {}
Entity.__index = Entity

function Entity.new(x, y)
    local self = setmetatable({}, Entity)
    
    -- Properties
    self.x, self.y = x, y
    self.velocity = {x=0, y=0}
    
    -- Methods defined in constructor (token efficiency)
    function self:update()
        self:handle_input()
        self:apply_physics()
    end
    
    function self:draw()
        circfill(self.x, self.y, self.radius, self.color)
    end
    
    return self
end
```

### System Pattern
```lua
SystemName = {}

function SystemName.method_name(entity1, entity2)
    -- Centralized logic
    return result
end

function SystemName.another_method(params)
    -- Cross-entity functionality
end
```

### State Pattern
```lua
StateName = {}

function StateName:init()
    -- Initialize state
end

function StateName:update()
    -- Handle logic, check transitions
end

function StateName:draw()
    -- Render everything
end
```


## Pico-8 Optimization

### Token Limits (8192 maximum)
- **Flat constants**: `PLAYER_RADIUS = 4` not `PLAYER.RADIUS = 4`
- **Combined declarations**: `local x,y,z = 0,0,0` not separate lines
- **Methods in constructors**: Avoid prototype pollution
- **Short aliases**: `local cf = circfill` for repeated calls

### Character Limits (65535 maximum)
- **Remove comments** in production builds
- **Minimize whitespace** (handled by build process)
- **Concise variable names** in hot code paths

### Performance
- **Reverse iteration** for safe removal: `for i=#list,1,-1 do`
- **Frame-based timing**: Use counters, not time()
- **Efficient collision detection**: Check bounds before expensive calculations

## Error Prevention

- **Validate asset files exist** before building
- **Check token limits** during development
- **Test both dev and prod builds** before release
- **Use meaningful error messages** in build scripts
- **Document system interactions** to prevent circular dependencies

## Performance Guidelines

- **Minimize object creation** in update loops
- **Use local variables** for frequently accessed data
- **Cache expensive calculations** when possible
- **Prefer integer math** over floating point when appropriate
- **Batch similar operations** (drawing, collision checks)