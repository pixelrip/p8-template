# Constants System

The constants system provides centralized configuration for all game parameters using a flat naming structure optimized for Pico-8's token limitations.

## Purpose

1. **Centralized Configuration**: All game parameters are defined in one place (`config/constants.lua`), making it easy to adjust game balance and behavior.
2. **Improved Readability**: Named constants make code more self-documenting than magic numbers.
3. **Token Optimization**: Using a flat naming structure optimizes for PICO-8's token limitations.
4. **Consistency**: Ensures consistent values are used throughout the codebase.

## Naming Convention

Constants follow a hierarchical naming pattern:
```
ENTITY_PROPERTY = value
ENTITY_CATEGORY_PROPERTY = value
SYSTEM_COMPONENT_PROPERTY = value
```

This approach avoids nested tables (which would use more tokens) while maintaining clear organization.

### Examples:
- `PLAYER_RADIUS = 4` - Basic property
- `PLAYER_BOOST_DRAIN_RATE = 2` - Categorized property
- `ARENA_BOUNDS_LEFT = 5` - Nested property flattened



## Usage Patterns

### Direct Access
```lua
-- Efficient direct access
player.radius = PLAYER_RADIUS
player.speed = PLAYER_SPEED
```

### Configuration Changes
Single location for all game tuning:
```lua
-- Adjust game feel by changing constants
PLAYER_SPEED = 2.0  -- Faster players
PUCK_FRICTION = 0.95  -- Slower puck
```

## Best Practices

### Adding New Constants
When adding new constants:
1. Add them to the appropriate section in `config/constants.lua`
2. Follow the established naming convention
3. Include a comment if the constant's purpose isn't immediately obvious
4. Consider token usage - avoid creating new nested structures

### Usage Guidelines
1. **Always use constants** for values that might need adjustment during game balancing
2. **Group related constants** with consistent prefixes
3. **Add comments** for non-obvious constants
4. **Consider token usage** when naming and structuring constants

### Import and Usage
```lua
-- Import constants at the beginning of your program
#include config/constants.lua

-- Use constants instead of hardcoded values
self.radius = PLAYER_RADIUS  -- Good
self.radius = 4              -- Avoid
```
