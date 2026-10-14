local Players = game:GetService("Players")
local player = Players.LocalPlayer
local deliveryUrl = "https://voidedx.vercel.app/api/raw?id=vx_vo51qtro&format=raw"
if player then deliveryUrl = deliveryUrl .. "&userId=" .. tostring(player.UserId) end

local requestOk, source = pcall(function()
    return game:HttpGet(deliveryUrl)
end)
if not requestOk then
    error("[VoidedX] Could not download the script: " .. tostring(source), 0)
end
if type(source) ~= "string" then
    error("[VoidedX] The server returned an invalid script.", 0)
end
local scriptChunk, compileError = loadstring(source)
if not scriptChunk then
    error("[VoidedX] " .. tostring(compileError), 0)
end
return scriptChunk()