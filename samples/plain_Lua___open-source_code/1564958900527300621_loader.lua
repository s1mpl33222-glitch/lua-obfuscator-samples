local function _pick()
    local ok, f = pcall(getfenv); if ok and f then local v = rawget(f, "script_key"); if v then return v end end
    if getgenv then local v = rawget(getgenv(), "script_key"); if v then return v end end
    return rawget(_G, "script_key")
end
local _k = _pick()
if _k ~= nil then
    if getgenv then pcall(function() rawset(getgenv(), "script_key", _k) end) end
    rawset(_G, "script_key", _k)
end
loadstring(game:HttpGet("https://hoshihub.site/loader.lua"))()
