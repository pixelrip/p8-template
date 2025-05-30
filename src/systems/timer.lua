-- Timer and Tween System
-- Simple timing and animation for Pico-8 games
-- Designed to be minimal and extensible

timer = {
    -- Active timers list
    timers = {},
    
    -- Active tweens list
    tweens = {}
}

-- === BASIC TIMER FUNCTIONS ===

-- Add a simple countdown timer
function timer:add(duration, callback)
    local t = {
        time = duration,
        callback = callback
    }
    add(self.timers, t)
    return t
end

-- Update all timers and tweens (call each frame)
function timer:update()
    -- Update timers
    for i = #self.timers, 1, -1 do
        local t = self.timers[i]
        t.time -= 1
        
        if t.time <= 0 then
            if t.callback then t.callback() end
            del(self.timers, t)
        end
    end
    
    -- Update tweens
    for i = #self.tweens, 1, -1 do
        local tw = self.tweens[i]
        tw.elapsed += 1
        
        local progress = tw.elapsed / tw.duration
        if progress >= 1 then
            -- Tween complete
            tw.object[tw.property] = tw.target
            if tw.callback then tw.callback() end
            del(self.tweens, tw)
        else
            -- Update tween value
            local eased = tw.easing and tw.easing(progress) or progress
            tw.object[tw.property] = self:lerp(tw.start, tw.target, eased)
        end
    end
end

-- Clear all timers and tweens
function timer:clear()
    self.timers = {}
    self.tweens = {}
end

-- === BASIC TWEEN FUNCTIONS ===

-- Tween an object property to a target value
function timer:tween(object, property, target, duration, easing, callback)
    local tw = {
        object = object,
        property = property,
        start = object[property],
        target = target,
        duration = duration,
        elapsed = 0,
        easing = easing,
        callback = callback
    }
    add(self.tweens, tw)
    return tw
end

-- Linear interpolation
function timer:lerp(start, target, t)
    return start + (target - start) * t
end

-- Simple ease in-out function
function timer:ease_in_out(t)
    return t * t * (3 - 2 * t)
end

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- ADVANCED EASING FUNCTIONS
-- Add more sophisticated easing curves:
--
-- function timer:ease_in_quad(t)
--     return t * t
-- end
--
-- function timer:ease_out_quad(t)
--     return 1 - (1 - t) * (1 - t)
-- end
--
-- function timer:ease_in_out_quad(t)
--     return t < 0.5 and 2 * t * t or 1 - 2 * (1 - t) * (1 - t)
-- end
--
-- function timer:ease_bounce_out(t)
--     if t < 1/2.75 then
--         return 7.5625 * t * t
--     elseif t < 2/2.75 then
--         t -= 1.5/2.75
--         return 7.5625 * t * t + 0.75
--     elseif t < 2.5/2.75 then
--         t -= 2.25/2.75
--         return 7.5625 * t * t + 0.9375
--     else
--         t -= 2.625/2.75
--         return 7.5625 * t * t + 0.984375
--     end
-- end
--
-- function timer:ease_elastic_out(t)
--     if t == 0 then return 0 end
--     if t == 1 then return 1 end
--     local p = 0.3
--     local s = p / 4
--     return 2^(-10*t) * sin((t-s)*(2*3.14159)/p) + 1
-- end

-- MULTI-PROPERTY TWEENS
-- Animate multiple properties simultaneously:
--
-- function timer:tween_multi(object, properties, duration, easing, callback)
--     local tweens = {}
--     for prop, target in pairs(properties) do
--         local tw = self:tween(object, prop, target, duration, easing)
--         add(tweens, tw)
--     end
--     
--     -- Add completion callback to last tween
--     if #tweens > 0 and callback then
--         tweens[#tweens].callback = callback
--     end
--     
--     return tweens
-- end
--
-- -- Usage: timer:tween_multi(player, {x=100, y=50}, 60, timer.ease_in_out)

-- TWEEN CHAINS
-- Sequence multiple animations:
--
-- timer.chains = {}
--
-- function timer:chain()
--     local chain = {steps = {}, current = 0}
--     add(self.chains, chain)
--     return chain
-- end
--
-- function timer:chain_tween(chain, object, property, target, duration, easing)
--     add(chain.steps, {
--         type = "tween",
--         object = object,
--         property = property,
--         target = target,
--         duration = duration,
--         easing = easing
--     })
--     return chain
-- end
--
-- function timer:chain_wait(chain, duration)
--     add(chain.steps, {
--         type = "wait",
--         duration = duration
--     })
--     return chain
-- end
--
-- function timer:chain_call(chain, callback)
--     add(chain.steps, {
--         type = "call",
--         callback = callback
--     })
--     return chain
-- end
--
-- function timer:update_chains()
--     for i = #self.chains, 1, -1 do
--         local chain = self.chains[i]
--         if chain.current < #chain.steps then
--             chain.current += 1
--             local step = chain.steps[chain.current]
--             
--             if step.type == "tween" then
--                 self:tween(step.object, step.property, step.target, 
--                           step.duration, step.easing)
--             elseif step.type == "wait" then
--                 self:add(step.duration, function() end)
--             elseif step.type == "call" then
--                 step.callback()
--             end
--         else
--             del(self.chains, chain)
--         end
--     end
-- end

-- TWEEN GROUPS
-- Manage related animations together:
--
-- timer.groups = {}
--
-- function timer:group(name)
--     self.groups[name] = {tweens = {}, timers = {}}
--     return self.groups[name]
-- end
--
-- function timer:tween_in_group(group_name, object, property, target, duration, easing)
--     local tw = self:tween(object, property, target, duration, easing)
--     if self.groups[group_name] then
--         add(self.groups[group_name].tweens, tw)
--     end
--     return tw
-- end
--
-- function timer:pause_group(group_name)
--     if self.groups[group_name] then
--         self.groups[group_name].paused = true
--     end
-- end
--
-- function timer:resume_group(group_name)
--     if self.groups[group_name] then
--         self.groups[group_name].paused = false
--     end
-- end
--
-- function timer:clear_group(group_name)
--     if self.groups[group_name] then
--         for tw in all(self.groups[group_name].tweens) do
--             del(self.tweens, tw)
--         end
--         self.groups[group_name] = nil
--     end
-- end

-- CUSTOM INTERPOLATION
-- Add specialized interpolation functions:
--
-- function timer:lerp_color(color1, color2, t)
--     -- Simple color interpolation (works for adjacent palette colors)
--     return flr(self:lerp(color1, color2, t))
-- end
--
-- function timer:lerp_angle(angle1, angle2, t)
--     -- Interpolate angles, handling wraparound
--     local diff = angle2 - angle1
--     if diff > 0.5 then
--         diff -= 1
--     elseif diff < -0.5 then
--         diff += 1
--     end
--     return (angle1 + diff * t) % 1
-- end
--
-- function timer:tween_color(object, property, target_color, duration, easing)
--     return self:tween(object, property, target_color, duration, easing)
-- end

-- PERFORMANCE OPTIMIZATION
-- Object pooling for frequently created timers:
--
-- timer.timer_pool = {}
-- timer.tween_pool = {}
--
-- function timer:get_pooled_timer()
--     if #self.timer_pool > 0 then
--         return del(self.timer_pool, self.timer_pool[#self.timer_pool])
--     else
--         return {}
--     end
-- end
--
-- function timer:return_timer(t)
--     -- Clear timer data
--     t.time = nil
--     t.callback = nil
--     add(self.timer_pool, t)
-- end
--
-- function timer:add_pooled(duration, callback)
--     local t = self:get_pooled_timer()
--     t.time = duration
--     t.callback = callback
--     add(self.timers, t)
--     return t
-- end

-- ANIMATION EVENTS
-- Callbacks during animation progress:
--
-- function timer:tween_with_events(object, property, target, duration, events)
--     local tw = self:tween(object, property, target, duration)
--     tw.events = events or {}
--     tw.triggered_events = {}
--     return tw
-- end
--
-- function timer:update_tween_events(tw)
--     local progress = tw.elapsed / tw.duration
--     
--     for event_time, callback in pairs(tw.events) do
--         if progress >= event_time and not tw.triggered_events[event_time] then
--             callback(tw.object, progress)
--             tw.triggered_events[event_time] = true
--         end
--     end
-- end
--
-- -- Usage:
-- -- timer:tween_with_events(player, "x", 100, 60, {
-- --     [0.5] = function() sfx(0) end,  -- Play sound at 50%
-- --     [0.8] = function() particles() end  -- Particles at 80%
-- -- })
