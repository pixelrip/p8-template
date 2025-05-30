-- Camera System
-- Simple camera control for Pico-8 games
-- Designed to be minimal and extensible

cam = {
    -- Camera position
    x = 0,
    y = 0,
    
    -- Target to follow
    target = nil,
    
    -- World boundaries (optional)
    bounds = nil
}

-- === BASIC CAMERA FUNCTIONS ===

-- Set camera position directly
function cam:set_position(x, y)
    self.x = x or 0
    self.y = y or 0
    self:_apply_bounds()
end

-- Follow a target object (should have x, y properties)
function cam:follow(target_obj)
    self.target = target_obj
end

-- Update camera position (call each frame)
function cam:update()
    if self.target then
        -- Center camera on target
        self.x = self.target.x - 64  -- Half screen width
        self.y = self.target.y - 64  -- Half screen height
        self:_apply_bounds()
    end
end

-- Apply camera transform (call before drawing world objects)
function cam:apply()
    camera(self.x, self.y)
end

-- Reset camera transform (call after drawing world objects)
function cam:reset()
    camera()
end

-- Set world boundaries to constrain camera
function cam:set_bounds(min_x, min_y, max_x, max_y)
    self.bounds = {
        min_x = min_x,
        min_y = min_y,
        max_x = max_x - 128,  -- Account for screen width
        max_y = max_y - 128   -- Account for screen height
    }
end

-- Internal function to apply boundary constraints
function cam:_apply_bounds()
    if self.bounds then
        self.x = math2d.clamp(self.x, self.bounds.min_x, self.bounds.max_x)
        self.y = math2d.clamp(self.y, self.bounds.min_y, self.bounds.max_y)
    end
end

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- CAMERA SHAKE
-- Add screen shake effects:
--
-- cam.shake_x = 0
-- cam.shake_y = 0
-- cam.shake_timer = 0
-- cam.shake_intensity = 0
--
-- function cam:shake(intensity, duration)
--     self.shake_intensity = intensity
--     self.shake_timer = duration
-- end
--
-- function cam:update_shake()
--     if self.shake_timer > 0 then
--         self.shake_timer -= 1
--         local decay = self.shake_timer / 30  -- Adjust decay rate
--         local current_intensity = self.shake_intensity * decay
--         
--         self.shake_x = math2d.random_range(-current_intensity, current_intensity)
--         self.shake_y = math2d.random_range(-current_intensity, current_intensity)
--     else
--         self.shake_x = 0
--         self.shake_y = 0
--     end
-- end
--
-- function cam:apply_with_shake()
--     camera(self.x + self.shake_x, self.y + self.shake_y)
-- end

-- SMOOTH FOLLOWING
-- Add smooth camera movement with deadzone:
--
-- cam.smooth_factor = 0.1
-- cam.deadzone = 16
--
-- function cam:follow_smooth(target_obj, smooth_factor, deadzone)
--     self.target = target_obj
--     self.smooth_factor = smooth_factor or 0.1
--     self.deadzone = deadzone or 16
-- end
--
-- function cam:update_smooth()
--     if self.target then
--         local target_x = self.target.x - 64
--         local target_y = self.target.y - 64
--         
--         -- Check if target is outside deadzone
--         local dx = target_x - self.x
--         local dy = target_y - self.y
--         local dist = math2d.distance(0, 0, dx, dy)
--         
--         if dist > self.deadzone then
--             -- Smooth movement toward target
--             self.x += dx * self.smooth_factor
--             self.y += dy * self.smooth_factor
--         end
--         
--         self:_apply_bounds()
--     end
-- end

-- LOOK AHEAD
-- Camera leads player movement:
--
-- cam.look_ahead_distance = 32
-- cam.look_ahead_smooth = 0.05
--
-- function cam:follow_with_lookahead(target_obj, distance, smooth_factor)
--     self.target = target_obj
--     self.look_ahead_distance = distance or 32
--     self.look_ahead_smooth = smooth_factor or 0.05
-- end
--
-- function cam:update_lookahead()
--     if self.target then
--         local look_x = 0
--         local look_y = 0
--         
--         -- Calculate look ahead based on target velocity
--         if self.target.vx then
--             look_x = self.target.vx * self.look_ahead_distance
--         end
--         if self.target.vy then
--             look_y = self.target.vy * self.look_ahead_distance
--         end
--         
--         local target_x = self.target.x - 64 + look_x
--         local target_y = self.target.y - 64 + look_y
--         
--         -- Smooth movement toward look ahead position
--         self.x += (target_x - self.x) * self.look_ahead_smooth
--         self.y += (target_y - self.y) * self.look_ahead_smooth
--         
--         self:_apply_bounds()
--     end
-- end

-- MULTIPLE TARGETS
-- Focus camera on multiple objects:
--
-- function cam:focus_on_targets(targets, padding)
--     if #targets == 0 then return end
--     
--     padding = padding or 16
--     
--     -- Find bounding box of all targets
--     local min_x, min_y = targets[1].x, targets[1].y
--     local max_x, max_y = targets[1].x, targets[1].y
--     
--     for target in all(targets) do
--         min_x = min(min_x, target.x)
--         min_y = min(min_y, target.y)
--         max_x = max(max_x, target.x)
--         max_y = max(max_y, target.y)
--     end
--     
--     -- Center camera on bounding box
--     local center_x = (min_x + max_x) / 2
--     local center_y = (min_y + max_y) / 2
--     
--     self:set_position(center_x - 64, center_y - 64)
-- end

-- ZOOM SYSTEM
-- Simple zoom in/out (note: affects all drawing):
--
-- cam.zoom = 1
-- cam.target_zoom = 1
-- cam.zoom_smooth = 0.1
--
-- function cam:set_zoom(zoom_level, smooth)
--     if smooth then
--         self.target_zoom = zoom_level
--     else
--         self.zoom = zoom_level
--         self.target_zoom = zoom_level
--     end
-- end
--
-- function cam:update_zoom()
--     if self.zoom ~= self.target_zoom then
--         self.zoom += (self.target_zoom - self.zoom) * self.zoom_smooth
--     end
-- end
--
-- function cam:apply_with_zoom()
--     camera(self.x, self.y)
--     -- Note: Pico-8 doesn't have built-in zoom, would need custom implementation
--     -- This is more complex and token-heavy, consider carefully
-- end

-- CAMERA ZONES
-- Different camera behaviors in different areas:
--
-- cam.zones = {}
-- cam.current_zone = nil
--
-- function cam:add_zone(name, x, y, w, h, behavior)
--     self.zones[name] = {
--         x = x, y = y, w = w, h = h,
--         behavior = behavior
--     }
-- end
--
-- function cam:update_zones()
--     if not self.target then return end
--     
--     -- Check which zone target is in
--     for name, zone in pairs(self.zones) do
--         if self.target.x >= zone.x and self.target.x <= zone.x + zone.w and
--            self.target.y >= zone.y and self.target.y <= zone.y + zone.h then
--             
--             if self.current_zone ~= name then
--                 self.current_zone = name
--                 if zone.behavior.on_enter then
--                     zone.behavior.on_enter(self)
--                 end
--             end
--             
--             if zone.behavior.update then
--                 zone.behavior.update(self)
--             end
--             return
--         end
--     end
--     
--     self.current_zone = nil
-- end

-- CINEMATIC CAMERA
-- Scripted camera movements:
--
-- cam.cinematic_mode = false
-- cam.cinematic_target_x = 0
-- cam.cinematic_target_y = 0
-- cam.cinematic_speed = 0.05
-- cam.cinematic_callback = nil
--
-- function cam:move_to(x, y, speed, callback)
--     self.cinematic_mode = true
--     self.cinematic_target_x = x - 64
--     self.cinematic_target_y = y - 64
--     self.cinematic_speed = speed or 0.05
--     self.cinematic_callback = callback
-- end
--
-- function cam:update_cinematic()
--     if self.cinematic_mode then
--         local dx = self.cinematic_target_x - self.x
--         local dy = self.cinematic_target_y - self.y
--         local dist = math2d.distance(0, 0, dx, dy)
--         
--         if dist < 1 then
--             -- Arrived at target
--             self.x = self.cinematic_target_x
--             self.y = self.cinematic_target_y
--             self.cinematic_mode = false
--             
--             if self.cinematic_callback then
--                 self.cinematic_callback()
--                 self.cinematic_callback = nil
--             end
--         else
--             -- Move toward target
--             self.x += dx * self.cinematic_speed
--             self.y += dy * self.cinematic_speed
--         end
--         
--         self:_apply_bounds()
--     end
-- end

-- UTILITY FUNCTIONS
-- Helper functions for camera calculations:
--
-- function cam:world_to_screen(world_x, world_y)
--     return world_x - self.x, world_y - self.y
-- end
--
-- function cam:screen_to_world(screen_x, screen_y)
--     return screen_x + self.x, screen_y + self.y
-- end
--
-- function cam:is_on_screen(x, y, margin)
--     margin = margin or 0
--     return x >= self.x - margin and x <= self.x + 128 + margin and
--            y >= self.y - margin and y <= self.y + 128 + margin
-- end
--
-- function cam:get_screen_bounds()
--     return self.x, self.y, self.x + 128, self.y + 128
-- end
