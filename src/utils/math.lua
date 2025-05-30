-- Math Utilities
-- Essential 2D game math for Pico-8
-- Designed to be minimal and extensible

math2d = {}

-- === VECTOR OPERATIONS ===

-- Calculate distance between two points
function math2d.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return sqrt(dx * dx + dy * dy)
end

-- Normalize a vector (returns unit vector)
function math2d.normalize(x, y)
    local len = sqrt(x * x + y * y)
    if len == 0 then return 0, 0 end
    return x / len, y / len
end

-- Dot product of two vectors
function math2d.dot(x1, y1, x2, y2)
    return x1 * x2 + y1 * y2
end

-- === ANGLE UTILITIES ===

-- Get angle from point1 to point2 (in radians)
function math2d.angle_to(x1, y1, x2, y2)
    return atan2(y2 - y1, x2 - x1)
end

-- Convert degrees to radians
function math2d.deg_to_rad(degrees)
    return degrees * 0.017453  -- pi/180
end

-- Convert radians to degrees  
function math2d.rad_to_deg(radians)
    return radians * 57.2958   -- 180/pi
end

-- === RANGE AND CLAMPING ===

-- Clamp value between min and max
function math2d.clamp(value, min_val, max_val)
    return max(min_val, min(max_val, value))
end

-- Map value from one range to another
function math2d.map(value, in_min, in_max, out_min, out_max)
    return out_min + (out_max - out_min) * ((value - in_min) / (in_max - in_min))
end

-- === RANDOM UTILITIES ===

-- Random float between min and max
function math2d.random_range(min_val, max_val)
    return min_val + rnd(max_val - min_val)
end

-- Pick random element from table
function math2d.random_choice(tbl)
    return tbl[flr(rnd(#tbl)) + 1]
end

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- ADVANCED VECTOR OPERATIONS
-- More sophisticated vector math:
--
-- function math2d.cross(x1, y1, x2, y2)
--     return x1 * y2 - y1 * x2
-- end
--
-- function math2d.reflect(vx, vy, nx, ny)
--     -- Reflect vector v off normal n
--     local dot = 2 * math2d.dot(vx, vy, nx, ny)
--     return vx - dot * nx, vy - dot * ny
-- end
--
-- function math2d.project(vx, vy, onto_x, onto_y)
--     -- Project vector v onto another vector
--     local dot = math2d.dot(vx, vy, onto_x, onto_y)
--     local len_sq = onto_x * onto_x + onto_y * onto_y
--     if len_sq == 0 then return 0, 0 end
--     local scalar = dot / len_sq
--     return scalar * onto_x, scalar * onto_y
-- end
--
-- function math2d.perpendicular(x, y)
--     return -y, x  -- 90 degree rotation
-- end

-- BEZIER CURVES
-- Smooth curve calculations:
--
-- function math2d.bezier_quadratic(t, p0x, p0y, p1x, p1y, p2x, p2y)
--     local mt = 1 - t
--     local mt2 = mt * mt
--     local t2 = t * t
--     return mt2 * p0x + 2 * mt * t * p1x + t2 * p2x,
--            mt2 * p0y + 2 * mt * t * p1y + t2 * p2y
-- end
--
-- function math2d.bezier_cubic(t, p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y)
--     local mt = 1 - t
--     local mt2 = mt * mt
--     local mt3 = mt2 * mt
--     local t2 = t * t
--     local t3 = t2 * t
--     return mt3 * p0x + 3 * mt2 * t * p1x + 3 * mt * t2 * p2x + t3 * p3x,
--            mt3 * p0y + 3 * mt2 * t * p1y + 3 * mt * t2 * p2y + t3 * p3y
-- end

-- NOISE FUNCTIONS
-- Simple noise generation:
--
-- math2d.noise_seed = 12345
--
-- function math2d.hash(x, y)
--     local h = (x * 374761393 + y * 668265263) % 4294967296
--     h = (h ~ (h >> 13)) * 1274126177 % 4294967296
--     return (h ~ (h >> 16)) / 4294967296
-- end
--
-- function math2d.noise(x, y)
--     local ix, iy = flr(x), flr(y)
--     local fx, fy = x - ix, y - iy
--     
--     local a = math2d.hash(ix, iy)
--     local b = math2d.hash(ix + 1, iy)
--     local c = math2d.hash(ix, iy + 1)
--     local d = math2d.hash(ix + 1, iy + 1)
--     
--     local ux = fx * fx * (3 - 2 * fx)  -- Smooth interpolation
--     local uy = fy * fy * (3 - 2 * fy)
--     
--     return math2d.lerp(math2d.lerp(a, b, ux), math2d.lerp(c, d, ux), uy)
-- end

-- GEOMETRIC SHAPES
-- Shape intersection and containment:
--
-- function math2d.point_in_circle(px, py, cx, cy, radius)
--     return math2d.distance(px, py, cx, cy) <= radius
-- end
--
-- function math2d.point_in_rect(px, py, rx, ry, rw, rh)
--     return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
-- end
--
-- function math2d.circle_intersect(x1, y1, r1, x2, y2, r2)
--     return math2d.distance(x1, y1, x2, y2) <= r1 + r2
-- end
--
-- function math2d.line_intersect(x1, y1, x2, y2, x3, y3, x4, y4)
--     local denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
--     if denom == 0 then return false end  -- Parallel lines
--     
--     local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
--     local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom
--     
--     if t >= 0 and t <= 1 and u >= 0 and u <= 1 then
--         return true, x1 + t * (x2 - x1), y1 + t * (y2 - y1)
--     end
--     return false
-- end

-- PHYSICS HELPERS
-- Common physics calculations:
--
-- function math2d.apply_velocity(obj, dt)
--     dt = dt or 1
--     obj.x += obj.vx * dt
--     obj.y += obj.vy * dt
-- end
--
-- function math2d.apply_acceleration(obj, dt)
--     dt = dt or 1
--     obj.vx += obj.ax * dt
--     obj.vy += obj.ay * dt
-- end
--
-- function math2d.apply_friction(obj, friction)
--     friction = friction or 0.9
--     obj.vx *= friction
--     obj.vy *= friction
-- end
--
-- function math2d.spring_force(current, target, strength, damping)
--     strength = strength or 0.1
--     damping = damping or 0.8
--     local force = (target - current) * strength
--     return force * damping
-- end
--
-- function math2d.orbit(center_x, center_y, radius, angle, speed)
--     angle += speed
--     local x = center_x + cos(angle) * radius
--     local y = center_y + sin(angle) * radius
--     return x, y, angle
-- end

-- INTERPOLATION
-- Advanced interpolation methods:
--
-- function math2d.lerp(a, b, t)
--     return a + (b - a) * t
-- end
--
-- function math2d.smoothstep(edge0, edge1, x)
--     local t = math2d.clamp((x - edge0) / (edge1 - edge0), 0, 1)
--     return t * t * (3 - 2 * t)
-- end
--
-- function math2d.smootherstep(edge0, edge1, x)
--     local t = math2d.clamp((x - edge0) / (edge1 - edge0), 0, 1)
--     return t * t * t * (t * (t * 6 - 15) + 10)
-- end

-- MATRIX OPERATIONS
-- 2D transformations:
--
-- function math2d.rotate_point(x, y, angle, origin_x, origin_y)
--     origin_x = origin_x or 0
--     origin_y = origin_y or 0
--     
--     local cos_a = cos(angle)
--     local sin_a = sin(angle)
--     
--     local dx = x - origin_x
--     local dy = y - origin_y
--     
--     return origin_x + dx * cos_a - dy * sin_a,
--            origin_y + dx * sin_a + dy * cos_a
-- end
--
-- function math2d.scale_point(x, y, scale_x, scale_y, origin_x, origin_y)
--     origin_x = origin_x or 0
--     origin_y = origin_y or 0
--     scale_y = scale_y or scale_x
--     
--     return origin_x + (x - origin_x) * scale_x,
--            origin_y + (y - origin_y) * scale_y
-- end

-- FAST APPROXIMATIONS
-- Performance-optimized versions:
--
-- function math2d.fast_distance(x1, y1, x2, y2)
--     -- Faster approximation using Manhattan + diagonal
--     local dx = abs(x2 - x1)
--     local dy = abs(y2 - y1)
--     return 0.414 * min(dx, dy) + max(dx, dy)
-- end
--
-- function math2d.fast_normalize(x, y)
--     -- Fast inverse square root approximation
--     local len_sq = x * x + y * y
--     if len_sq == 0 then return 0, 0 end
--     local inv_len = 1 / sqrt(len_sq)  -- Could use fast inverse sqrt here
--     return x * inv_len, y * inv_len
-- end
