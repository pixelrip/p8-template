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
    
    -- Print "boilerplate" centered on screen
    -- PICO-8 screen is 128x128, text is about 4 pixels per character
    -- "boilerplate" is 11 characters, so 44 pixels wide
    -- Center horizontally: (128 - 44) / 2 = 42
    print("boilerplate", 42, 60, 7)
    
    -- Draw the sprite below the text
    -- Sprite 0, centered horizontally at x=60, below text at y=80
    sspr(8,0,15,11,57,80)
end

function TitleState:exit()
    log("Exiting Title State")
end
