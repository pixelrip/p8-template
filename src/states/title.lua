-- Title State
-- The main menu/title screen of the game

TitleState = State:new()

function TitleState:init()
    log("Entering Title State")
    -- Start playing the music pattern
    music(0)
end

function TitleState:update()
    -- Title screen update logic
end

function TitleState:draw()
    -- Title screen drawing logic
    cls()
    
    print("boilerplate", 42, 60, 7)
    sspr(8,0,15,11,57,80)
end

function TitleState:exit()
    log("Exiting Title State")
end
