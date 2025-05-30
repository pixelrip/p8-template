# Game State Manager

Simple state management for PICO-8 games.

## Quick Reference

```lua
gs:add("name", StateObject)    -- Register state
gs:switch("name", ...)         -- Switch to state (passes args to init)
gs:update()                    -- Update current state
gs:draw()                      -- Draw current state
```

## Creating States

```lua
MenuState = State:new()

function MenuState:init(from_state)
    log("Entered menu from: " .. (from_state or "start"))
    self.selected = 1
end

function MenuState:update()
    if im:pressed(2) then self.selected += 1 end  -- Down
    if im:pressed(3) then self.selected -= 1 end  -- Up
    if im:pressed(4) then gs:switch("game") end   -- Z to start
end

function MenuState:draw()
    cls()
    print("menu", 60, 50, 7)
    print("> start", 50, 70, self.selected == 1 and 7 or 6)
end

function MenuState:exit()
    music(-1)  -- Stop music when leaving
end
```

## Registration

```lua
-- In main.lua
gs:add("menu", MenuState)
gs:add("game", GameState)
gs:switch("menu")
```

## State Switching

```lua
-- Simple switch
gs:switch("game")

-- Pass data to new state
gs:switch("game", "level1", 100)  -- level, score

-- In GameState:init(level, score)
function GameState:init(level, score)
    self.level = level or "level1"
    self.score = score or 0
end
