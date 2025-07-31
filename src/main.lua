require("utils/log")

-- Main entry point for the game
function _init()
    log("=== Game Started ===")

    -- Play music pattern from assets/music.p8
    music(0)
end

function _update()
    -- No update logic required
end

function _draw()
    -- Clear the screen
    cls()

    -- Draw the sprite from assets/sprites.p8
    sspr(8,0,15,11,57,60)

    print("hello, world!", 38, 76, 7)
end
