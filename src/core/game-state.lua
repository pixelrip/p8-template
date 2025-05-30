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

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- TRANSITION EFFECTS
-- Add smooth transitions between states:
--
-- gs.transition_time = 0
-- gs.transition_duration = 30  -- frames
-- gs.transition_type = "fade"
-- gs.next_state = nil
-- gs.next_args = nil
--
-- function gs:start_transition(to_state, ...)
--     self.next_state = to_state
--     self.next_args = {...}
--     self.transition_time = self.transition_duration
-- end
--
-- function gs:update_transition()
--     if self.transition_time > 0 then
--         self.transition_time -= 1
--         if self.transition_time == 0 then
--             self:switch(self.next_state, unpack(self.next_args))
--         end
--         return true  -- Skip normal update
--     end
--     return false
-- end
--
-- function gs:draw_transition()
--     if self.transition_time > 0 then
--         local alpha = self.transition_time / self.transition_duration
--         -- Add fade, slide, or other transition effects
--         fillp(0b0101010110101010)  -- Dither pattern for fade
--         rectfill(0, 0, 127, 127, 0)
--         fillp()
--     end
-- end

-- STATE STACK
-- Add push/pop functionality for pause screens, menus, etc:
--
-- gs.state_stack = {}
--
-- function gs:push(name, ...)
--     add(self.state_stack, {self.current, name})
--     self:switch(name, ...)
-- end
--
-- function gs:pop()
--     if #self.state_stack > 0 then
--         local prev = self.state_stack[#self.state_stack]
--         del(self.state_stack, prev)
--         self.current = prev[1]
--         if self.current then
--             self.current:init()
--         end
--     end
-- end

-- STATE DATA PERSISTENCE
-- Share data between states:
--
-- gs.shared_data = {}
--
-- function gs:set_data(key, value)
--     self.shared_data[key] = value
-- end
--
-- function gs:get_data(key)
--     return self.shared_data[key]
-- end
--
-- function gs:clear_data()
--     self.shared_data = {}
-- end

-- PAUSE SYSTEM
-- Pause current state and overlay pause screen:
--
-- gs.paused_state = nil
-- gs.pause_overlay = nil
--
-- function gs:pause(pause_state_name)
--     if not self.paused_state then
--         self.paused_state = self.current
--         self.pause_overlay = self.States[pause_state_name]
--         if self.pause_overlay then
--             self.pause_overlay:init()
--         end
--     end
-- end
--
-- function gs:resume()
--     if self.paused_state then
--         if self.pause_overlay then
--             self.pause_overlay:exit()
--         end
--         self.current = self.paused_state
--         self.paused_state = nil
--         self.pause_overlay = nil
--     end
-- end
--
-- function gs:is_paused()
--     return self.paused_state ~= nil
-- end

-- ADVANCED STATE MANAGEMENT
-- Add state history, conditional transitions, etc:
--
-- gs.state_history = {}
-- gs.max_history = 10
--
-- function gs:add_to_history(state_name)
--     add(self.state_history, state_name)
--     if #self.state_history > self.max_history then
--         del(self.state_history, self.state_history[1])
--     end
-- end
--
-- function gs:get_previous_state()
--     return self.state_history[#self.state_history]
-- end
--
-- function gs:can_switch_to(state_name)
--     -- Add custom logic for conditional state transitions
--     return self.States[state_name] ~= nil
-- end
