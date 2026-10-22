-- This file was generated at discord.gg/syncrypt

local v140 = game:GetService("ReplicatedStorage")
local v108 = v140:WaitForChild("TipRemotes")
local v112 = v108:FindFirstChild("GetPlayerAssets")
local v113 = v112 and (not (v112:IsA("RemoteFunction")))
if v113 then
    warn("\226\154\160\239\184\143 GetPlayerAssets was a RemoteEvent! Deleting and replacing with RemoteFunction...")
    v112:Destroy()
    v112 = nil
end
if (not v112) then
    v112 = (Instance.new("RemoteFunction"))
    v112.Name = "GetPlayerAssets"
    v112.Parent = v108
end
local v117 = require(v140:WaitForChild("PlayerAssets"))
local up25 = v117
v112.OnServerInvoke = function(arg6_1, arg6_2)
    local v77, v79, v80, v81
    local v75 = (arg6_2 or arg6_1)
    local up1 = v75
    v75, v79, v80, v81 = pcall(function()
        local v67 = up25
        local v68 = up1
        local v74 = up1.UserId
        return v67:GetContent(v68, v74)
    end)
    if v75 then
        return v79, v80, v81
    else
        warn(("\226\154\160\239\184\143 Failed fetch for " .. up1.Name))
        v77 = nil
        return v77, nil, nil
    end
end
return
