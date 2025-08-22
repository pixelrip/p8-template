-- Simple Logging System
-- Provides a basic logging function for debugging Pico-8 games

-- In a perfect world, I would actually structure these modules like 
-- "real Lua" with returns and better encapsulation--instead of basically
-- just including them as globals. But alas, no matter what I try picotool
-- ends up taking a big shit when I try to require sibling/sister files so
-- I will leave as globals.

log = {}

function log.print(txt)
	printh(tostr(txt), "log", false)
end

-- Prints and entire table into the console
function log.table(tbl, prefix)
    prefix = prefix or ""
    for key, value in pairs(tbl) do
        log.print(prefix .. tostr(key) .. " = " .. tostr(value))
    end
end

