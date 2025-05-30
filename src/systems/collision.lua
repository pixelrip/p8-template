-- Collision Detection System
-- Basic collision detection for Pico-8 games
-- Designed to be simple and extensible

collision = {}

-- === BASIC SHAPES ===

-- Point in rectangle collision
-- Returns true if point (px, py) is inside rectangle
function collision.point_rect(px, py, rx, ry, rw, rh)
    return px >= rx and px < rx + rw and 
           py >= ry and py < ry + rh
end

-- Rectangle vs rectangle collision (AABB - Axis Aligned Bounding Box)
-- Returns true if rectangles overlap
function collision.rect_rect(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and
           y1 < y2 + h2 and y2 < y1 + h1
end

-- Circle vs circle collision
-- Returns true if circles overlap
function collision.circle_circle(x1, y1, r1, x2, y2, r2)
    local dx, dy = x2 - x1, y2 - y1
    local dist_sq = dx * dx + dy * dy
    local radii_sq = (r1 + r2) * (r1 + r2)
    return dist_sq <= radii_sq
end

-- === OBJECT HELPERS ===

-- Check if two objects collide
-- Assumes objects have x, y, w, h properties
function collision.objects(obj1, obj2)
    return collision.rect_rect(obj1.x, obj1.y, obj1.w, obj1.h,
                              obj2.x, obj2.y, obj2.w, obj2.h)
end

-- === EXTENSION POINTS ===
-- The following are examples of common extensions.
-- Uncomment and modify as needed for your game.

-- TILEMAP COLLISION
-- Add these functions for tile-based collision detection:
--
-- function collision.tile_solid(tx, ty)
--     -- Example implementations:
--     -- return mget(tx, ty) == 1  -- Tile 1 is solid
--     -- return fget(mget(tx, ty), 0)  -- Flag 0 = solid
--     -- return tilemap_data[ty] and tilemap_data[ty][tx] == 1
-- end
-- 
-- function collision.check_tilemap(x, y, w, h)
--     -- Check if rectangle overlaps any solid tiles
--     local left, top = flr(x / 8), flr(y / 8)
--     local right, bottom = flr((x + w - 1) / 8), flr((y + h - 1) / 8)
--     
--     for ty = top, bottom do
--         for tx = left, right do
--             if collision.tile_solid(tx, ty) then
--                 return true
--             end
--         end
--     end
--     return false
-- end

-- MOVEMENT WITH COLLISION
-- Add these functions for collision-aware movement:
--
-- function collision.move_x(obj, dx, solid_func)
--     -- Move object horizontally, stopping at collision
--     local target_x = obj.x + dx
--     
--     if dx > 0 then
--         -- Moving right
--         while obj.x < target_x do
--             obj.x += 1
--             if solid_func(obj.x + obj.w - 1, obj.y, obj.w, obj.h) then
--                 obj.x -= 1
--                 break
--             end
--         end
--     elseif dx < 0 then
--         -- Moving left
--         while obj.x > target_x do
--             obj.x -= 1
--             if solid_func(obj.x, obj.y, obj.w, obj.h) then
--                 obj.x += 1
--                 break
--             end
--         end
--     end
--     
--     return obj.x
-- end
-- 
-- function collision.move_y(obj, dy, solid_func)
--     -- Move object vertically, stopping at collision
--     local target_y = obj.y + dy
--     
--     if dy > 0 then
--         -- Moving down
--         while obj.y < target_y do
--             obj.y += 1
--             if solid_func(obj.x, obj.y + obj.h - 1, obj.w, obj.h) then
--                 obj.y -= 1
--                 break
--             end
--         end
--     elseif dy < 0 then
--         -- Moving up
--         while obj.y > target_y do
--             obj.y -= 1
--             if solid_func(obj.x, obj.y, obj.w, obj.h) then
--                 obj.y += 1
--                 break
--             end
--         end
--     end
--     
--     return obj.y
-- end

-- COLLISION GROUPS
-- Add these functions for group-based collision checking:
--
-- collision.groups = {}
-- 
-- function collision.add_to_group(obj, group_name)
--     if not collision.groups[group_name] then
--         collision.groups[group_name] = {}
--     end
--     add(collision.groups[group_name], obj)
-- end
-- 
-- function collision.remove_from_group(obj, group_name)
--     if collision.groups[group_name] then
--         del(collision.groups[group_name], obj)
--     end
-- end
-- 
-- function collision.check_group(obj, group_name)
--     if not collision.groups[group_name] then return nil end
--     
--     for other in all(collision.groups[group_name]) do
--         if other ~= obj and collision.objects(obj, other) then
--             return other
--         end
--     end
--     return nil
-- end
-- 
-- function collision.check_all_groups(obj, group_name)
--     local collisions = {}
--     if not collision.groups[group_name] then return collisions end
--     
--     for other in all(collision.groups[group_name]) do
--         if other ~= obj and collision.objects(obj, other) then
--             add(collisions, other)
--         end
--     end
--     return collisions
-- end

-- ADVANCED SHAPES
-- Add these functions for more complex collision shapes:
--
-- function collision.circle_rect(cx, cy, cr, rx, ry, rw, rh)
--     -- Circle vs rectangle collision
--     local closest_x = mid(cx, rx, rx + rw)
--     local closest_y = mid(cy, ry, ry + rh)
--     local dx, dy = cx - closest_x, cy - closest_y
--     return (dx * dx + dy * dy) <= (cr * cr)
-- end
-- 
-- function collision.line_rect(x1, y1, x2, y2, rx, ry, rw, rh)
--     -- Line vs rectangle collision (useful for raycasting)
--     -- Implementation would use line-rectangle intersection algorithm
-- end

-- SPATIAL OPTIMIZATION
-- Add these functions for performance with many objects:
--
-- collision.spatial_grid = {}
-- collision.grid_size = 64  -- Grid cell size in pixels
-- 
-- function collision.add_to_grid(obj)
--     local gx, gy = flr(obj.x / collision.grid_size), flr(obj.y / collision.grid_size)
--     local key = gx .. "," .. gy
--     
--     if not collision.spatial_grid[key] then
--         collision.spatial_grid[key] = {}
--     end
--     add(collision.spatial_grid[key], obj)
-- end
-- 
-- function collision.get_nearby(x, y, radius)
--     local nearby = {}
--     local grid_radius = ceil(radius / collision.grid_size)
--     local center_gx, center_gy = flr(x / collision.grid_size), flr(y / collision.grid_size)
--     
--     for gx = center_gx - grid_radius, center_gx + grid_radius do
--         for gy = center_gy - grid_radius, center_gy + grid_radius do
--             local key = gx .. "," .. gy
--             if collision.spatial_grid[key] then
--                 for obj in all(collision.spatial_grid[key]) do
--                     add(nearby, obj)
--                 end
--             end
--         end
--     end
--     
--     return nearby
-- end
