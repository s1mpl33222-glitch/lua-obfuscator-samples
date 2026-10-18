-- This file was generated at discord.gg/syncrypt

local v1
local v2
if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
    game:GetService("CoreGui").ToraScript:Destroy()
end
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v4 = lib:CreateWindow("Merge a Mini Army")
task.spawn(function()
    local now = tick()
    local t1 = { "%H", "%M", "%S" }

    while task.wait() do
        if tick() - now >= 1 then
            now = tick()
            os.date(table.concat(t1, ":"))
        end
    end
end)
local LocalPlayer = game:GetService("Players").LocalPlayer
local Parent
for _, descendant in pairs(workspace.Plots:GetDescendants()) do
    local v11 = descendant.Name == "Owner"

    if v11 then
        v11 = descendant:IsA("ObjectValue")

        if v11 then
            v11 = descendant.Value == LocalPlayer
        end
    end

    if v11 then
        Parent = descendant.Parent
    end
end
v4:AddToggle({
	["text"] = "Auto Merge",
	["flag"] = "toggle",
	["state"] = false,
	["callback"] = function(p1)
    _G.Merge = p1
    print("Merge: ", p1)

    if not p1 then
        return
    end

    Merge()
end
})
function Merge()
    local function v12()
        _G.Merge = true

        while _G.Merge do
            local function v13()
                local Units = Parent.Units
                local RemoteFunction = game:GetService("ReplicatedStorage").Framework.Features.BrainrotSystem.BrainrotUtil.RemoteFunction
                local v16, v17

                Units, v16, v17 = pairs(Units:GetChildren())

                local t2 = {}

                while true do
                    local v19

                    v17, v19 = Units(v16, v17)

                    if not v17 then
                        break
                    end

                    if v19:IsA("CFrameValue") then
                        local attribute = v19:GetAttribute("BrainrotId")

                        if attribute then
                            t2[attribute] = t2[attribute] or {}
                            attribute = t2[attribute]
                            table.insert(attribute, v19)
                        end
                    end
                end

                for _, v in pairs(t2) do
                    if #v >= 2 then
                        Units = v[1]
                        v16 = v[2]
                        RemoteFunction:InvokeServer("PickUpPlot", Units.Name)
                        task.wait(0.2)
                        RemoteFunction:InvokeServer("MergePlot", Units.Name, v16.Name)

                        break
                    end
                end

                wait(0.2)
            end

            wait()
            pcall(v13)
        end
    end

    spawn(v12)
end
v4:AddToggle({
	["text"] = "Auto Deploy",
	["flag"] = "toggle",
	["state"] = false,
	["callback"] = function(p2)
    _G.Deploy = p2
    print("Deploy: ", p2)

    if not p2 then
        return
    end

    Deploy()
end
})
function Deploy()
    spawn(function()
        _G.Deploy = true

        while _G.Deploy do
            wait()
            pcall(function()
                local match, v24 = game:GetService("Players").LocalPlayer.PlayerGui.HUD.TopButtons.Deploy.UnitsCurrentlyDeployed.Frame.AmountDeployed.Text:match("(%d+)%s*/%s*(%d+)")

                match = tonumber(match)
                v24 = tonumber(v24)

                if match then
                    if v24 then
                        v24 = match < v24
                    end
                else
                    v24 = match
                end

                if not v24 then
                    wait(0.2)

                    return
                end

                game:GetService("ReplicatedStorage").Framework.Features.CampSystem.CampUtil.RemoteEvent:FireServer("Deploy")
                wait(0.2)
            end)
        end
    end)
end
v4:AddToggle({
	["text"] = "Buy SpawnLevel",
	["flag"] = "toggle",
	["state"] = false,
	["callback"] = function(p3)
    _G.up1 = p3
    print("up1: ", p3)

    if not p3 then
        return
    end

    v1()
end
})
local function _()
    spawn(function()
        _G.up1 = true

        while _G.up1 do
            wait()
            pcall(function()
                if game:GetService("Players").LocalPlayer.PlayerGui.HUD.TopButtons.UpgradesWindow.Notification.Visible ~= true then
                    wait(0.2)

                    return
                end

                game:GetService("ReplicatedStorage").Framework.Features.BrainrotSystem.BrainrotUtil.RemoteEvent:FireServer("UpgradeSpawnLevel")
                wait(0.2)
            end)
        end
    end)
end
v4:AddToggle({
	["text"] = "Buy MaxOutside",
	["flag"] = "toggle",
	["state"] = false,
	["callback"] = function(p4)
    _G.up2 = p4
    print("up2: ", p4)

    if not p4 then
        return
    end

    v2()
end
})
local function _()
    spawn(function()
        _G.up2 = true

        while _G.up2 do
            wait()
            pcall(function()
                if game:GetService("Players").LocalPlayer.PlayerGui.HUD.TopButtons.UpgradesWindow.Notification.Visible ~= true then
                    wait(0.2)

                    return
                end

                game:GetService("ReplicatedStorage").Framework.Features.BrainrotSystem.BrainrotUtil.RemoteEvent:FireServer("UpgradeMaxOutside")
                wait(0.2)
            end)
        end
    end)
end
v4:AddToggle({
	["text"] = "Buy MaxSpawned",
	["flag"] = "toggle",
	["state"] = false,
	["callback"] = function(p5)
    _G.up3 = p5
    print("up3: ", p5)

    if not p5 then
        return
    end

    up3()
end
})
function up3()
    spawn(function()
        _G.up3 = true

        while _G.up3 do
            wait()
            pcall(function()
                if game:GetService("Players").LocalPlayer.PlayerGui.HUD.TopButtons.UpgradesWindow.Notification.Visible ~= true then
                    wait(0.2)

                    return
                end

                game:GetService("ReplicatedStorage").Framework.Features.BrainrotSystem.BrainrotUtil.RemoteEvent:FireServer("UpgradeMaxSpawned")
                wait(0.2)
            end)
        end
    end)
end
v4:AddLabel({
	["text"] = "YouTube: Tora IsMe"
})
lib:Init()
