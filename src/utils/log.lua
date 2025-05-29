-- Simple Logging System
-- Provides a basic logging function for debugging Pico-8 games

-- Log a message to the log file
-- @param txt - The message to log (will be converted to string)
function log(txt)
	printh(tostr(txt), "log", false)
end
