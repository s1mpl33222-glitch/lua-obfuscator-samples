repeat task.wait() until game:IsLoaded()

local url = "https://api.getpolsec.com/scripts/hosted/ddcacb25c21642090c5c6ea0b0435643bac2c7091e64bf07064744b863d43c9a.lua"

local ok, src = pcall(game.HttpGet, game, url)
if not ok then return warn("HttpGet failed:", src) end

local fn, err = loadstring(src)
if not fn then return warn("loadstring failed:", err) end

fn()
