-- Game State System
-- A simple State management system for Pico-8 games
-- Base State object that all game States should inherit from
State = {}
State.__index = State

-- Creates a new State object
function State:new()
    local o = setmetatable({}, self)
    return o
end

-- State lifecycle methods (to be overridden by specific States)
function State:init() end  -- Called when entering the State
function State:update() end  -- Called every frame to update State
function State:draw() end  -- Called every frame to draw State
function State:exit() end  -- Called when leaving the State

-- Game State manager
gs = {
    current = nil,  -- Current active State
    States = {}     -- Table of registered States
}

-- Register a new State with the given name
function gs:add(name, State_obj)
    self.States[name] = State_obj
end

-- Switch to a different State
-- Additional arguments are passed to the init function of the new State
function gs:switch(name, ...)
    -- Exit the current State if it exists
    if self.current then
        self.current:exit()
    end

    -- Set the new State
    self.current = self.States[name]
    
    -- Initialize the new State if it exists
    if self.current then
        self.current:init(...)
    end
end

-- Update the current State
function gs:update()
    if self.current then
        self.current:update()
    end
end

-- Draw the current State
function gs:draw()
    if self.current then
        self.current:draw()
    end
end
