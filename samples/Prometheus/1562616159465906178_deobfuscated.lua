-- This file was generated at discord.gg/syncrypt

local unpackValues = unpack or table.unpack
local v151 = game:GetService("CoreGui"):FindFirstChild("ToraScript")
if v151 then
    game:GetService("CoreGui").ToraScript:Destroy()
end
v151 = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v181 = v151:CreateWindow("Battle Cat Training")
local v155 = v181.AddButton
local v180 = function()
    local v101 = {[1] = "train_start", [2] = true, [3] = {["1"] = 48}}
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(v101))

    return
end
v155(v181, {["text"] = "Best Train", ["flag"] = "button", ["callback"] = v180})
local v164 = function(arg9_1)
    _G.Spins = arg9_1
    print("Spins: ", arg9_1)
    if arg9_1 then
        Spins()
    end
    return
end
v181:AddToggle({["text"] = "Inf Spins", ["flag"] = "toggle", ["state"] = false, ["callback"] = v164})
Spins = function()
    local v116 = function()
        local v46, v48
        _G.Spins = true
        while true do
            v46 = _G
            if not v46.Spins then
                break
            end
            v48 = function()
                local v36 = {[1] = "client_daily_gacha_reward", [2] = {["1"] = -50}}
                game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(v36))
                wait(1)
                local v33 = {[1] = "client_daily_gacha_reward", [2] = {["1"] = 50}}
                local v40 = game:GetService("ReplicatedStorage").RemoteFunction
                local v35 = {unpack(v33)}
                v40:InvokeServer(unpackValues(v35))
                wait(1)

                return
            end
            wait()
            pcall(v48)
        end
        return
    end
    spawn(v116)

    return
end
v155 = v181.AddToggle
v164 = function(arg11_1)
    _G.Rebirth = arg11_1
    print("Rebirth: ", arg11_1)
    if arg11_1 then
        Rebirth()
    end
    return
end
v155(v181, {["text"] = "Auto Rebirth", ["flag"] = "toggle", ["state"] = false, ["callback"] = v164})
Rebirth = function()
    local v124 = function()
        local v27, v29
        _G.Rebirth = true
        while true do
            v27 = _G
            if not v27.Rebirth then
                break
            end
            v29 = function()
                local v127, v135, v136, v139
                local v132 = {[1] = "reborn_as_max", [2] = true, [3] = {}}
                local v133 = game:GetService("ReplicatedStorage").RemoteEvent
                local v129 = {unpack(v132)}
                v133:FireServer(unpackValues(v129))
                local v128 = game:GetService("Players").LocalPlayer.PlayerGui.RebornGui.main.list_back.list
                v129 = 0
                local v138 = v128.GetChildren
                v133 = ipairs
                for v127, v139 in v133(v138(v128)) do
                    v136 = (v139.Name == "Item")
                    v135 = v136
                    if not (v136) then
                        v135 = (v139.Name == "item")
                    end
                    if v135 then
                        v133 = 1
                        v129 += v133
                    end
                end
                local v131 = {[1] = "reborn_as_lv", [2] = true, [3] = {["1"] = v129}}
                v127 = game:GetService("ReplicatedStorage").RemoteEvent
                v139 = {unpack(v131)}
                v127:FireServer(unpackValues(v139))
                wait(1)

                return
            end
            wait()
            pcall(v29)
        end
        return
    end
    spawn(v124)

    return
end
v181:AddLabel({["text"] = "YouTube: Tora IsMe"})
v151:Init()
return
