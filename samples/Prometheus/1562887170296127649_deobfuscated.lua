-- This file was generated at discord.gg/syncrypt

local v136 = game:GetService("TextService")
local up27 = v136
local v110 = game:GetService("ReplicatedStorage")
v136 = v110:FindFirstChild("TipRemotes")
if (not v136) then
    v136 = (Instance.new("Folder"))
    v136.Name = "TipRemotes"
    v136.Parent = v110
end
local v111 = v136:FindFirstChild("UpdateSignText")
if (not v111) then
    v111 = (Instance.new("RemoteEvent"))
    v111.Name = "UpdateSignText"
    v111.Parent = v136
end
local v114 = function(arg9_1, arg9_2, arg9_3)
    local v99, v101
    local up2 = arg9_1
    local v96 = arg9_2
    local v97 = (not v96)
    local up1 = arg9_3
    local v98 = v97
    if not (v97) then
        v98 = (not (v96:FindFirstChild("JarText")))
    end
    if v98 then
        return
    else
        local up3 = ""
        v98, v101 = pcall(function()
            local v39 = up27
            local v40 = up1
            local v47 = up2.UserId
            v39 = v39:FilterStringAsync(v40, v47):GetNonChatStringForBroadcastAsync()
            up3 = v39
            return
        end)
        if v98 then
            v99 = (v96.JarText:FindFirstChild("Text"))
            if v99 then
                v98 = up3
                v99.Text = v98
            end
        end
        return
    end
end
v111.OnServerEvent :Connect(v114)

return
