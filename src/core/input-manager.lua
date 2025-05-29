-- Input Manager (im.lua)
-- Tracks button states and provides utilities for input handling

im = {
    -- Current button states for each player (true = pressed, false = not pressed)
    current = {{false, false, false, false, false, false}, {false, false, false, false, false, false}},
    
    -- Previous button states from last frame for each player
    previous = {{false, false, false, false, false, false}, {false, false, false, false, false, false}},
    
    -- Cooldown timers for each button for each player (0 = no cooldown)
    cooldowns = {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}},
    
    -- Hold timers for each button for each player (counts frames button has been held)
    hold_timers = {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}},
    
    -- Global cooldown that affects all buttons
    global_cooldown = 0,
    
    -- Default cooldown duration in frames
    default_cooldown = 10,
    
    -- Default hold duration in frames (how long button must be held to trigger hold)
    default_hold_duration = 30,  -- 1 second at 30fps
    
    -- Default repeat interval for held buttons (how often to trigger while holding)
    default_repeat_interval = 6  -- 5 times per second at 30fps
}

-- Initialize the input manager
function im:init()
    -- Reset all states for both players
    for p=0,1 do
        for i=0,5 do
            self.current[p+1][i+1] = false
            self.previous[p+1][i+1] = false
            self.cooldowns[p+1][i+1] = 0
            self.hold_timers[p+1][i+1] = 0
        end
    end
    self.global_cooldown = 0
end

-- Update button states (call this at the beginning of each frame)
function im:update()
    -- Update global cooldown
    if self.global_cooldown > 0 then
        self.global_cooldown -= 1
    end
    
    -- Update button states, cooldowns, and hold timers for both players
    for p=0,1 do
        for i=0,5 do
            -- Store previous state
            self.previous[p+1][i+1] = self.current[p+1][i+1]
            
            -- Update current state
            self.current[p+1][i+1] = btn(i, p)
            
            -- Update cooldown
            if self.cooldowns[p+1][i+1] > 0 then
                self.cooldowns[p+1][i+1] -= 1
            end
            
            -- Update hold timer
            if self.current[p+1][i+1] then
                -- Button is pressed, increment hold timer
                self.hold_timers[p+1][i+1] += 1
            else
                -- Button is not pressed, reset hold timer
                self.hold_timers[p+1][i+1] = 0
            end
        end
    end
end

-- Check if a button was just pressed this frame
function im:pressed(button, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Check if button is pressed now but wasn't pressed last frame
    -- Also check cooldowns
    return self.current[p_idx][idx] and 
           not self.previous[p_idx][idx] and 
           self.cooldowns[p_idx][idx] == 0 and
           self.global_cooldown == 0
end

-- Check if a button was just released this frame
function im:released(button, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Check if button is not pressed now but was pressed last frame
    return not self.current[p_idx][idx] and self.previous[p_idx][idx]
end

-- Check if a button is currently down
function im:down(button, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Check if button is currently pressed
    return self.current[p_idx][idx]
end

-- Check if a button has been held for the specified duration
function im:held(button, duration, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Use default duration if not specified
    duration = duration or self.default_hold_duration
    
    -- Check if button has been held for at least the specified duration
    return self.hold_timers[p_idx][idx] >= duration
end

-- Check if a button has just reached the held threshold this frame
function im:just_held(button, duration, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Use default duration if not specified
    duration = duration or self.default_hold_duration
    
    -- Check if button has exactly reached the hold duration this frame
    return self.hold_timers[p_idx][idx] == duration
end

-- Check for repeating input while a button is held
-- Returns true on initial press and then at regular intervals while held
function im:repeat_input(button, initial_delay, repeat_interval, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Use default values if not specified
    initial_delay = initial_delay or self.default_hold_duration
    repeat_interval = repeat_interval or self.default_repeat_interval
    
    -- Check for initial press
    if self.current[p_idx][idx] and not self.previous[p_idx][idx] and 
       self.cooldowns[p_idx][idx] == 0 and self.global_cooldown == 0 then
        return true
    end
    
    -- Check for repeat interval
    if self.hold_timers[p_idx][idx] >= initial_delay then
        -- Calculate how many frames past the initial delay
        local frames_past_delay = self.hold_timers[p_idx][idx] - initial_delay
        
        -- Check if we're on a repeat interval frame
        return frames_past_delay % repeat_interval == 0
    end
    
    return false
end

-- Set a cooldown for a specific button
function im:set_cooldown(button, frames, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Set cooldown
    self.cooldowns[p_idx][idx] = frames or self.default_cooldown
end

-- Set a global cooldown for all buttons
function im:set_global_cooldown(frames)
    self.global_cooldown = frames or self.default_cooldown
end

-- Wait for a button to be released before it can be pressed again
function im:wait_for_release(button, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    -- Set cooldown that will be cleared when button is released
    if self.current[p_idx][idx] then
        self.cooldowns[p_idx][idx] = 32767  -- Very high number (effectively infinite)
    elseif self.cooldowns[p_idx][idx] > 0 and not self.current[p_idx][idx] then
        -- Button was released, clear cooldown
        self.cooldowns[p_idx][idx] = 0
    end
end

-- Clear all cooldowns
function im:clear_cooldowns()
    for p=0,1 do
        for i=1,6 do
            self.cooldowns[p+1][i] = 0
        end
    end
    self.global_cooldown = 0
end

-- Get how long a button has been held (in frames)
function im:hold_duration(button, player_id)
    -- Default to player 0 if not specified
    player_id = player_id or 0
    
    -- Convert button to 1-indexed for our arrays
    local idx = button + 1
    local p_idx = player_id + 1
    
    return self.hold_timers[p_idx][idx]
end
