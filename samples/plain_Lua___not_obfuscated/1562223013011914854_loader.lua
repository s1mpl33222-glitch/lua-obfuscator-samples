-- PhantomHub Loader v2
if not script_key or script_key == "" then
    warn("[PhantomHub] No key set.")
    return
end
local ok, src = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/765632/PhantomHub/master/data/phantomhub_script.lua")
end)
if not ok or not src then
    warn("[PhantomHub] Connection failed")
    return
end
local fn, err = loadstring(src)
if fn then fn() else warn("[PhantomHub] " .. tostring(err)) end
