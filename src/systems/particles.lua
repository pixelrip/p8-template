-- Particle System
-- Simple particle effects for Pico-8 games
-- Designed to be minimal and extensible

particles = {
    -- Particle pool for efficiency
    pool = {},
    active = {},
    
    -- Pool settings
    max_particles = 100,
    pool_index = 1
}

-- === PARTICLE STRUCTURE ===
-- Each particle: {x, y, vx, vy, life, max_life, color}

-- Initialize particle pool
function particles:init()
    -- Pre-allocate particle objects to avoid garbage collection
    for i = 1, self.max_particles do
        self.pool[i] = {0, 0, 0, 0, 0, 0, 7}
    end
    self.active = {}
end

-- === BASIC PARTICLE FUNCTIONS ===

-- Emit particles at position with configuration
function particles:emit(x, y, count, config)
    config = config or {}
    
    for i = 1, count do
        local p = self:_get_particle()
        if p then
            -- Position
            p[1] = x + (config.spread_x or 0) * (rnd(2) - 1)
            p[2] = y + (config.spread_y or 0) * (rnd(2) - 1)
            
            -- Velocity
            local speed = config.speed or 1
            local angle = config.angle or rnd(1)
            if config.speed_min and config.speed_max then
                speed = math2d.random_range(config.speed_min, config.speed_max)
            end
            if config.angle_min and config.angle_max then
                angle = math2d.random_range(config.angle_min, config.angle_max)
            end
            
            p[3] = cos(angle) * speed  -- vx
            p[4] = sin(angle) * speed  -- vy
            
            -- Lifetime
            p[5] = config.life or 30
            p[6] = p[5]  -- max_life for effects
            
            -- Color
            if config.colors then
                p[7] = math2d.random_choice(config.colors)
            else
                p[7] = config.color or 7
            end
            
            add(self.active, p)
        end
    end
end

-- Update all particles
function particles:update()
    for i = #self.active, 1, -1 do
        local p = self.active[i]
        
        -- Update position
        p[1] += p[3]  -- x += vx
        p[2] += p[4]  -- y += vy
        
        -- Update lifetime
        p[5] -= 1
        
        -- Remove dead particles
        if p[5] <= 0 then
            self:_return_particle(p, i)
        end
    end
end

-- Draw all particles
function particles:draw()
    for p in all(self.active) do
        pset(p[1], p[2], p[7])
    end
end

-- Clear all particles
function particles:clear()
    for i = #self.active, 1, -1 do
        self:_return_particle(self.active[i], i)
    end
end

-- === SIMPLE PRESETS ===

-- Explosion effect
function particles:explosion(x, y, intensity)
    intensity = intensity or 1
    self:emit(x, y, 8 * intensity, {
        speed_min = 0.5,
        speed_max = 3,
        angle_min = 0,
        angle_max = 1,
        life = 20,
        colors = {8, 9, 10}
    })
end

-- Trail effect
function particles:trail(x, y, color)
    self:emit(x, y, 2, {
        speed_min = 0.1,
        speed_max = 0.5,
        spread_x = 2,
        spread_y = 2,
        life = 15,
        color = color or 7
    })
end

-- Sparkle effect
function particles:sparkle(x, y)
    self:emit(x, y, 3, {
        speed_min = 0.2,
        speed_max = 1,
        life = 25,
        colors = {7, 10, 9}
    })
end

-- === INTERNAL FUNCTIONS ===

-- Get particle from pool
function particles:_get_particle()
    if self.pool_index <= #self.pool then
        local p = self.pool[self.pool_index]
        self.pool_index += 1
        return p
    end
    return nil  -- Pool exhausted
end

-- Return particle to pool
function particles:_return_particle(particle, index)
    del(self.active, particle)
    self.pool_index -= 1
    self.pool[self.pool_index] = particle
end

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- ADVANCED EMITTERS
-- Continuous emission and shaped emitters:
--
-- particles.emitters = {}
--
-- function particles:add_emitter(name, x, y, config)
--     self.emitters[name] = {
--         x = x, y = y,
--         rate = config.rate or 1,
--         timer = 0,
--         config = config,
--         active = true
--     }
-- end
--
-- function particles:update_emitters()
--     for name, emitter in pairs(self.emitters) do
--         if emitter.active then
--             emitter.timer += 1
--             if emitter.timer >= emitter.rate then
--                 emitter.timer = 0
--                 self:emit(emitter.x, emitter.y, 1, emitter.config)
--             end
--         end
--     end
-- end
--
-- function particles:remove_emitter(name)
--     self.emitters[name] = nil
-- end

-- PHYSICS INTEGRATION
-- Add gravity, wind, and collision:
--
-- particles.gravity = 0.1
-- particles.wind_x = 0
-- particles.wind_y = 0
--
-- function particles:update_physics()
--     for p in all(self.active) do
--         -- Apply gravity
--         p[4] += self.gravity
--         
--         -- Apply wind
--         p[3] += self.wind_x
--         p[4] += self.wind_y
--         
--         -- Simple collision with screen bounds
--         if p[1] < 0 or p[1] > 127 then
--             p[3] *= -0.5  -- Bounce with damping
--         end
--         if p[2] > 127 then
--             p[4] *= -0.5
--             p[2] = 127
--         end
--     end
-- end

-- SPRITE PARTICLES
-- Use sprites instead of pixels:
--
-- function particles:emit_sprites(x, y, count, sprite_id, config)
--     config = config or {}
--     config.sprite = sprite_id
--     self:emit(x, y, count, config)
-- end
--
-- function particles:draw_sprites()
--     for p in all(self.active) do
--         if p.sprite then
--             spr(p.sprite, p[1], p[2])
--         else
--             pset(p[1], p[2], p[7])
--         end
--     end
-- end

-- PARTICLE TYPES
-- Different particle behaviors:
--
-- function particles:smoke(x, y)
--     self:emit(x, y, 5, {
--         speed_min = 0.2,
--         speed_max = 0.8,
--         angle_min = 0.2,  -- Upward bias
--         angle_max = 0.3,
--         life = 40,
--         colors = {5, 6, 13},
--         type = "smoke"
--     })
-- end
--
-- function particles:fire(x, y)
--     self:emit(x, y, 3, {
--         speed_min = 0.5,
--         speed_max = 1.5,
--         angle_min = 0.2,
--         angle_max = 0.3,
--         life = 20,
--         colors = {8, 9, 10},
--         type = "fire"
--     })
-- end
--
-- function particles:update_types()
--     for p in all(self.active) do
--         if p.type == "smoke" then
--             -- Smoke rises and fades
--             p[4] -= 0.05  -- Rise slowly
--             p[3] *= 0.98  -- Horizontal damping
--         elseif p.type == "fire" then
--             -- Fire flickers and rises
--             p[4] -= 0.1
--             p[3] += (rnd(0.4) - 0.2)  -- Random flicker
--         end
--     end
-- end

-- VISUAL EFFECTS
-- Fading, scaling, and color transitions:
--
-- function particles:update_visual_effects()
--     for p in all(self.active) do
--         local life_ratio = p[5] / p[6]
--         
--         -- Fade out over time
--         if life_ratio < 0.3 then
--             -- Could implement color fading here
--             -- Note: Pico-8 has limited color manipulation
--         end
--         
--         -- Size changes (for sprite particles)
--         if p.scale then
--             p.scale = life_ratio
--         end
--     end
-- end

-- EMITTER PATTERNS
-- Special emission patterns:
--
-- function particles:firework(x, y)
--     -- Initial burst upward
--     self:emit(x, y, 1, {
--         speed = 3,
--         angle = 0.25,  -- Straight up
--         life = 30,
--         color = 10,
--         type = "firework_rocket"
--     })
-- end
--
-- function particles:fountain(x, y)
--     self:emit(x, y, 3, {
--         speed_min = 1,
--         speed_max = 2.5,
--         angle_min = 0.1,
--         angle_max = 0.4,
--         life = 35,
--         colors = {11, 12, 7}
--     })
-- end
--
-- function particles:spiral(x, y, time)
--     local angle = time * 0.1
--     for i = 1, 3 do
--         local a = angle + i * 0.2
--         self:emit(x + cos(a) * 8, y + sin(a) * 8, 1, {
--             speed = 0.5,
--             angle = a,
--             life = 20,
--             color = 11
--         })
--     end
-- end

-- PERFORMANCE OPTIMIZATION
-- Spatial partitioning and LOD:
--
-- function particles:cull_offscreen()
--     for i = #self.active, 1, -1 do
--         local p = self.active[i]
--         -- Remove particles far off screen
--         if p[1] < -16 or p[1] > 144 or p[2] < -16 or p[2] > 144 then
--             self:_return_particle(p, i)
--         end
--     end
-- end
--
-- function particles:update_lod()
--     -- Reduce update frequency for distant particles
--     local cam_x, cam_y = cam.x or 0, cam.y or 0
--     
--     for p in all(self.active) do
--         local dist = math2d.distance(p[1], p[2], cam_x + 64, cam_y + 64)
--         if dist > 64 then
--             -- Skip every other frame for distant particles
--             if time() % 2 == 0 then
--                 -- Skip this particle this frame
--             end
--         end
--     end
-- end

-- Initialize particle system
particles:init()
