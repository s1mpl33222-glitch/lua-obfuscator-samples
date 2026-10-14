local route = getgenv().__BANANA_SCRIPT_ROUTE
if not route then
    local p = game:GetService("Players").LocalPlayer
    if p then p:Kick("No script route specified.") end
    return
end
return loadstring(game:HttpGet("https://banana-hub.xyz/scripts/" .. route .. ".lua"))()