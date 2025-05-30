require("config/constants")

require("utils/log")

require("core/game-state")
require("core/input-manager")

require("systems/collision")

require("states/title")

-- Main entry point for the game
function _init()
    log("=== Game Started ===")
    
    -- Initialize input manager
    im:init()
    
    -- Register game states
    gs:add("title", TitleState)
    
    -- Start with title screen
    gs:switch("title")
end

function _update()
    -- Update input manager
    im:update()
    
    -- Update current game state
    gs:update()
end

function _draw()
    -- Draw current game state
    gs:draw()
end
