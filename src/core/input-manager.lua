-- Input Manager
-- Simple input handling for Pico-8 games
-- Designed to be minimal and extensible

im = {
    -- Current and previous button states (single player by default)
    current = {false, false, false, false, false, false},
    previous = {false, false, false, false, false, false},
    
    -- Basic cooldown timers for each button
    cooldowns = {0, 0, 0, 0, 0, 0},
    
    -- Default cooldown duration in frames
    default_cooldown = 10
}

-- Initialize the input manager
function im:init()
    for i = 1, 6 do
        self.current[i] = false
        self.previous[i] = false
        self.cooldowns[i] = 0
    end
end

-- Update button states (call this at the beginning of each frame)
function im:update()
    for i = 0, 5 do
        -- Store previous state
        self.previous[i + 1] = self.current[i + 1]
        
        -- Update current state
        self.current[i + 1] = btn(i)
        
        -- Update cooldown
        if self.cooldowns[i + 1] > 0 then
            self.cooldowns[i + 1] -= 1
        end
    end
end

-- === BASIC INPUT FUNCTIONS ===

-- Check if a button was just pressed this frame
function im:pressed(button)
    local idx = button + 1
    return self.current[idx] and 
           not self.previous[idx] and 
           self.cooldowns[idx] == 0
end

-- Check if a button was just released this frame
function im:released(button)
    local idx = button + 1
    return not self.current[idx] and self.previous[idx]
end

-- Check if a button is currently held down
function im:held(button)
    local idx = button + 1
    return self.current[idx]
end

-- Set a cooldown for a specific button
function im:set_cooldown(button, frames)
    local idx = button + 1
    self.cooldowns[idx] = frames or self.default_cooldown
end

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- TWO PLAYER SUPPORT
-- Add support for multiple players:
--
-- im.players = {
--     {current = {false, false, false, false, false, false},
--      previous = {false, false, false, false, false, false},
--      cooldowns = {0, 0, 0, 0, 0, 0}},
--     {current = {false, false, false, false, false, false},
--      previous = {false, false, false, false, false, false},
--      cooldowns = {0, 0, 0, 0, 0, 0}}
-- }
--
-- function im:pressed_p(button, player_id)
--     player_id = player_id or 0
--     local p = self.players[player_id + 1]
--     local idx = button + 1
--     return p.current[idx] and not p.previous[idx] and p.cooldowns[idx] == 0
-- end
--
-- function im:update_multiplayer()
--     for p = 0, 1 do
--         local player = self.players[p + 1]
--         for i = 0, 5 do
--             player.previous[i + 1] = player.current[i + 1]
--             player.current[i + 1] = btn(i, p)
--             if player.cooldowns[i + 1] > 0 then
--                 player.cooldowns[i + 1] -= 1
--             end
--         end
--     end
-- end

-- HOLD DETECTION
-- Add hold timing and repeat functionality:
--
-- im.hold_timers = {0, 0, 0, 0, 0, 0}
-- im.hold_threshold = 30  -- frames to trigger hold
-- im.repeat_interval = 6  -- frames between repeats
--
-- function im:update_with_holds()
--     for i = 0, 5 do
--         self.previous[i + 1] = self.current[i + 1]
--         self.current[i + 1] = btn(i)
--         
--         if self.cooldowns[i + 1] > 0 then
--             self.cooldowns[i + 1] -= 1
--         end
--         
--         -- Update hold timers
--         if self.current[i + 1] then
--             self.hold_timers[i + 1] += 1
--         else
--             self.hold_timers[i + 1] = 0
--         end
--     end
-- end
--
-- function im:held_for(button, duration)
--     duration = duration or self.hold_threshold
--     return self.hold_timers[button + 1] >= duration
-- end
--
-- function im:just_held(button, duration)
--     duration = duration or self.hold_threshold
--     return self.hold_timers[button + 1] == duration
-- end
--
-- function im:repeat_input(button, initial_delay, repeat_rate)
--     initial_delay = initial_delay or self.hold_threshold
--     repeat_rate = repeat_rate or self.repeat_interval
--     
--     if self:pressed(button) then return true end
--     
--     if self.hold_timers[button + 1] >= initial_delay then
--         local frames_past = self.hold_timers[button + 1] - initial_delay
--         return frames_past % repeat_rate == 0
--     end
--     
--     return false
-- end

-- COMBO DETECTION
-- Add input sequence detection:
--
-- im.combo_buffer = {}
-- im.combo_window = 60  -- frames to complete combo
-- im.max_combo_length = 8
--
-- function im:add_to_combo(button)
--     add(self.combo_buffer, {button = button, time = 0})
--     if #self.combo_buffer > self.max_combo_length then
--         del(self.combo_buffer, self.combo_buffer[1])
--     end
-- end
--
-- function im:update_combos()
--     -- Age combo inputs
--     for i = #self.combo_buffer, 1, -1 do
--         self.combo_buffer[i].time += 1
--         if self.combo_buffer[i].time > self.combo_window then
--             del(self.combo_buffer, self.combo_buffer[i])
--         end
--     end
--     
--     -- Add new inputs to combo buffer
--     for i = 0, 5 do
--         if self:pressed(i) then
--             self:add_to_combo(i)
--         end
--     end
-- end
--
-- function im:check_combo(sequence)
--     if #self.combo_buffer < #sequence then return false end
--     
--     local start_idx = #self.combo_buffer - #sequence + 1
--     for i = 1, #sequence do
--         if self.combo_buffer[start_idx + i - 1].button ~= sequence[i] then
--             return false
--         end
--     end
--     return true
-- end

-- GESTURE RECOGNITION
-- Add directional input patterns:
--
-- im.gesture_buffer = {}
-- im.gesture_threshold = 8  -- frames between direction changes
-- im.gesture_timeout = 90   -- frames to complete gesture
--
-- function im:get_direction()
--     if self:held(0) then return "left" end
--     if self:held(1) then return "right" end
--     if self:held(2) then return "up" end
--     if self:held(3) then return "down" end
--     return nil
-- end
--
-- function im:update_gestures()
--     local current_dir = self:get_direction()
--     local last_entry = self.gesture_buffer[#self.gesture_buffer]
--     
--     if current_dir and (not last_entry or last_entry.direction ~= current_dir) then
--         add(self.gesture_buffer, {direction = current_dir, time = 0})
--     end
--     
--     -- Age gesture inputs
--     for i = #self.gesture_buffer, 1, -1 do
--         self.gesture_buffer[i].time += 1
--         if self.gesture_buffer[i].time > self.gesture_timeout then
--             del(self.gesture_buffer, self.gesture_buffer[i])
--         end
--     end
-- end
--
-- function im:check_gesture(pattern)
--     if #self.gesture_buffer < #pattern then return false end
--     
--     local start_idx = #self.gesture_buffer - #pattern + 1
--     for i = 1, #pattern do
--         if self.gesture_buffer[start_idx + i - 1].direction ~= pattern[i] then
--             return false
--         end
--     end
--     return true
-- end

-- INPUT RECORDING
-- Record and playback input sequences:
--
-- im.recording = false
-- im.recorded_inputs = {}
-- im.playback_inputs = {}
-- im.playback_frame = 0
--
-- function im:start_recording()
--     self.recording = true
--     self.recorded_inputs = {}
-- end
--
-- function im:stop_recording()
--     self.recording = false
--     return self.recorded_inputs
-- end
--
-- function im:record_frame()
--     if self.recording then
--         local frame_input = {}
--         for i = 0, 5 do
--             frame_input[i + 1] = self.current[i + 1]
--         end
--         add(self.recorded_inputs, frame_input)
--     end
-- end
--
-- function im:start_playback(recorded_sequence)
--     self.playback_inputs = recorded_sequence
--     self.playback_frame = 1
-- end
--
-- function im:update_playback()
--     if self.playback_inputs and self.playback_frame <= #self.playback_inputs then
--         local frame_input = self.playback_inputs[self.playback_frame]
--         for i = 1, 6 do
--             self.current[i] = frame_input[i]
--         end
--         self.playback_frame += 1
--     end
-- end

-- BUTTON REMAPPING
-- Allow custom button configurations:
--
-- im.button_map = {0, 1, 2, 3, 4, 5}  -- Default mapping
--
-- function im:remap_button(from_button, to_button)
--     self.button_map[from_button + 1] = to_button
-- end
--
-- function im:get_mapped_button(button)
--     return self.button_map[button + 1] or button
-- end
--
-- function im:pressed_mapped(button)
--     local mapped = self:get_mapped_button(button)
--     return self:pressed(mapped)
-- end
