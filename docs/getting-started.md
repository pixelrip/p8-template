# Getting Started

## Quick Setup

1. **Install Prerequisites**
   - [PICO-8](https://www.lexaloffle.com/pico-8.php)
   - [Python 3.4+](https://www.python.org/)
   - [picotool](https://github.com/dansanderson/picotool)

2. **Build and Run**
   ```bash
   ./scripts/build.sh
   pico-8 boilerplate.p8
   ```

## Project Structure

```
src/
├── main.lua              # Entry point (_init, _update, _draw)
├── config/constants.lua  # Game configuration
├── core/                 # Core systems
│   ├── game-state.lua    # State management
│   └── input-manager.lua # Input handling
├── states/title.lua      # Game states
└── utils/log.lua         # Logging utility
```

## Your First State

```lua
-- src/states/game.lua
GameState = State:new()

function GameState:init()
    log("Starting game")
    self.player_x = 64
end

function GameState:update()
    if im:pressed(0) then  -- Left button
        self.player_x -= 2
    end
    if im:pressed(1) then  -- Right button
        self.player_x += 2
    end
end

function GameState:draw()
    cls()
    circfill(self.player_x, 64, 4, 7)
end
```

Register it in `main.lua`:
```lua
require("states/game")

function _init()
    im:init()
    gs:add("title", TitleState)
    gs:add("game", GameState)  -- Add this line
    gs:switch("title")
end
```

Switch states with input:
```lua
-- In TitleState:update()
if im:pressed(4) then  -- 🅾️ button
    gs:switch("game")
end
