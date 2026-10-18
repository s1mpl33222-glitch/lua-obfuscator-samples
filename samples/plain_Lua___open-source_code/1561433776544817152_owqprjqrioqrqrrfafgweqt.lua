local KEY = ...
local FILE = "feqwfbweulifw.lua"
for _, b in ipairs({ "https://pizdecware.pw/", "https://pware.lol/" }) do
    local ok, r = pcall(game.HttpGet, game, b .. FILE)
    if ok and #r > 1000
        and (r:sub(1, 2) == "--" or r:find("^%s*return"))
        and not r:find("Just a moment")
        and not r:lower():find("<!doctype") then
        return loadstring(r)(KEY)
    end
end
return