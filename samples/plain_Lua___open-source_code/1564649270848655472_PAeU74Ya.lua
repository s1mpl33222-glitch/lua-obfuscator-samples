-- Luarmor Subscription 
local part1 = "https://paste"
local part2 = "bin.com/raw/"
local part3 = "rNBEAtEd"

local url = part1 .. part2 .. part3

local function loadScript()
    local ok, content = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and content then
        loadstring(content)()
        print("[Luarmor] Loaded")
    else
        warn("[Luarmor] Failed: " .. tostring(content))
    end
end
loadScript()