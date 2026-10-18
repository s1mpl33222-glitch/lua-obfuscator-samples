if _G.IsExecuting then return end
_G.IsExecuting = true

task.delay(3, function()
    _G.IsExecuting = false
end)

local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled

local isSuccess = loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/Collect1MillionItems/refs/heads/main/Loader.lua"))()

if isSuccess == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/UIConstructor/refs/heads/main/Telemetry.lua"))()
    if not isMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/UIConstructor/refs/heads/main/PC.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/Collect1MillionItems/refs/heads/main/PC%20Script.lua", true))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/UIConstructor/refs/heads/main/Mobile.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/Collect1MillionItems/refs/heads/main/Mobile%20Script.lua", true))()
    end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/Collect1MillionItems/refs/heads/main/Key.lua", true))()
end
