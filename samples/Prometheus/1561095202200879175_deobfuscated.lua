-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local lib = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local lib2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local lib3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local value41 = "KGuestCheatsJ Hub " .. identifyexecutor()
local uDim2 = UDim2.fromOffset(435, 340)
value41 = lib:CreateWindow({
	["Title"] = value41,
	["SubTitle"] = " In Area 51 Alpha V2.77",
	["TabWidth"] = 150,
	["Size"] = uDim2,
	["Acrylic"] = false,
	["Theme"] = "amethyst",
	["MinimizeKey"] = Enum.KeyCode.LeftControl
})
uDim2 = value41.AddTab
local RunService = value41:AddTab({
	["Title"] = "Get Guns",
	["Icon"] = "database"
})
local Main = value41:AddTab({
	["Title"] = "Teleports",
	["Icon"] = "star"
})
local v10 = value41:AddTab({
	["Title"] = "Visuals",
	["Icon"] = "moon"
})
local v11 = value41:AddTab({
	["Title"] = "Misc",
	["Icon"] = "folders"
})
uDim2 = {
	["Main"] = uDim2(value41, {
		["Title"] = "Main",
		["Icon"] = "octagon"
	}),
	["Main3"] = value41:AddTab({
		["Title"] = "Gun Mods",
		["Icon"] = "syringe"
	}),
	["Main2"] = RunService,
	["TP"] = Main,
	["Main6"] = v10,
	["Player"] = value41:AddTab({
		["Title"] = "Player Settings",
		["Icon"] = "users"
	}),
	["Main4"] = v11,
	["Settings"] = value41:AddTab({
		["Title"] = "GUI Settings",
		["Icon"] = "settings"
	})
}
RunService = game:GetService("RunService")
local t1 = {
	value1 = game:GetService("Players")
}
t1.value2 = t1.value1.LocalPlayer
_G.HitboxSize = 2
_G.HitboxEnabled = false
_G.HitboxVisible = false
Main = uDim2.Main
t1.value3 = Main:AddSlider("HitboxSize", {
	["Title"] = "Hitbox Size",
	["Default"] = 2,
	["Min"] = 2,
	["Max"] = 20,
	["Rounding"] = 1
})
Main = t1.value3
Main:OnChanged(function()
    _G.HitboxSize = t1.value3.Value
end)
RunService.Heartbeat:Connect(function()
    if not _G.HitboxEnabled then
        return
    end
end)
RunService = uDim2.Main
t1.value4 = RunService:AddToggle("HitboxEnable", {
	["Title"] = "Expand Hitboxes",
	["Default"] = false
})
t1.value4:OnChanged(function()
    _G.HitboxEnabled = t1.value4.Value
end)
RunService = uDim2.Main:AddToggle("HitboxShow", {
	["Title"] = "Show Hitbox",
	["Default"] = false
})
t1.value5 = nil
t1.value5 = RunService
t1.value5:OnChanged(function()
    _G.HitboxVisible = t1.value5.Value
end)
t1.value6 = lib.Options
RunService = uDim2.Main
RunService = RunService:AddToggle("Auto", {
	["Title"] = "Auto Rebirth",
	["Default"] = false
})
RunService:OnChanged(function()
    print("Toggle changed:", t1.value6.Auto.Value)

    while t1.value6.Auto.Value do
        game:GetService("ReplicatedStorage"):WaitForChild("RebirthRequest"):FireServer()
        task.wait(2)
    end
end)
RunService = uDim2.Main4
RunService:AddButton({
	["Title"] = "Fling All",
	["Description"] = "Risky",
	["Callback"] = function()
    local t2 = { "All" }
    local game_ = game
    game_ = game_:GetService("Players")
    local LocalPlayer = game_.LocalPlayer
    local u15 = false
    local function v16(p1)
        local v17 = p1:lower()

        if v17 == "all" and true or v17 == "others" then
            u15 = true

            return
        end

        if v17 == "random" then
            v17 = game_:GetPlayers()

            if not table.find(v17, LocalPlayer) then
                return v17[math.random(#v17)]
            end

            table.remove(v17, table.find(v17, LocalPlayer))

            return v17[math.random(#v17)]
        else
            local v18 = v17 ~= "random"
            local players, v20, v21

            if not v18 then
                if v18 then
                    v18 = next
                    players, v20 = game_:GetPlayers()

                    while true do
                        v20, v21 = v18(players, v20)

                        if not v20 then
                            break
                        end

                        if v21 ~= LocalPlayer then
                            if v21.Name:lower():match("^" .. v17) then
                                return v21
                            end

                            if v21.DisplayName:lower():match("^" .. v17) then
                                return v21
                            end
                        end
                    end

                    return
                else
                    return
                end

                return
            end

            if v17 == "all" then
                v18 = false
            else
                v18 = v17 ~= "others"
            end

            if v18 then
                v18 = next
                players, v20 = game_:GetPlayers()

                while true do
                    v20, v21 = v18(players, v20)

                    if not v20 then
                        break
                    end

                    if v21 ~= LocalPlayer then
                        if v21.Name:lower():match("^" .. v17) then
                            return v21
                        end

                        if v21.DisplayName:lower():match("^" .. v17) then
                            return v21
                        end
                    end
                end

                return
            else
                return
            end

            return
        end
    end
    local function v22(p2, p3, p4)
        game:GetService("StarterGui"):SetCore("SendNotification", {
				["Title"] = p2,
				["Text"] = p3,
				["Duration"] = p4
			})
    end
    local function v23(p5)
        local Character = LocalPlayer.Character
        local Humanoid
        if Character then
            Humanoid = Character:FindFirstChildOfClass("Humanoid")
        else
            Humanoid = Character
        end
        local RootPart
        if Humanoid then
            RootPart = Humanoid.RootPart
        else
            RootPart = Humanoid
        end
        local Character2 = p5.Character
        local v37_
        local Head
        local Accessory
        local Handle
        local Humanoid2
        if Character2:FindFirstChildOfClass("Humanoid") then
            Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")
        else
            Humanoid2 = nil
        end
        if Humanoid2 then
            v37 = Humanoid2.RootPart
        end
        if v37 then
            v37 = Humanoid2.RootPart
            v37_ = v37
        else
            v37 = Character2
        end
        if Character2:FindFirstChild("Head") then
            Head = Character2.Head
        end
        if Character2:FindFirstChildOfClass("Accessory") then
            Accessory = Character2:FindFirstChildOfClass("Accessory")
        end
        local Accessoy_ = Accessoy
        if Accessoy_ then
            Accessoy_ = Accessory:FindFirstChild("Handle")
        end
        if Accessoy_ then
            Handle = Accessory.Handle
        end
        if Character then
            Accessoy_ = Humanoid and RootPart
        else
            Accessoy_ = Character
        end
        if not Accessoy_ then
            return v22("Error Occurred", "Random error", 5)
        end
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if not Humanoid2 then
            if Accessoy_ then
                return v22("Error Occurred", "Targeting is sitting", 5)
            else
                if Head then
                    workspace.CurrentCamera.CameraSubject = Head
                elseif not Head and Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                else
                    if not (Humanoid2 and v37_) then
                        if not Character2:FindFirstChildWhichIsA("BasePart") then
                            return
                        end

                        return
                    end

                    workspace.CurrentCamera.CameraSubject = Humanoid2
                end

                if not Character2:FindFirstChildWhichIsA("BasePart") then
                    return
                end

                return
            end

            return
        end
        Accessoy_ = Humanoid2.Sit
        if not Accessoy_ then
            if Accessoy_ then
                return v22("Error Occurred", "Targeting is sitting", 5)
            else
                if Head then
                    workspace.CurrentCamera.CameraSubject = Head
                elseif not Head and Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                else
                    if not (Humanoid2 and v37_) then
                        if not Character2:FindFirstChildWhichIsA("BasePart") then
                            return
                        end

                        return
                    end

                    workspace.CurrentCamera.CameraSubject = Humanoid2
                end

                if not Character2:FindFirstChildWhichIsA("BasePart") then
                    return
                end

                return
            end

            return
        end
        Accessoy_ = not u15
        if Accessoy_ then
            return v22("Error Occurred", "Targeting is sitting", 5)
        else
            if Head then
                workspace.CurrentCamera.CameraSubject = Head
            elseif not Head and Handle then
                workspace.CurrentCamera.CameraSubject = Handle
            else
                if not (Humanoid2 and v37_) then
                    if not Character2:FindFirstChildWhichIsA("BasePart") then
                        return
                    end

                    return
                end

                workspace.CurrentCamera.CameraSubject = Humanoid2
            end

            if not Character2:FindFirstChildWhichIsA("BasePart") then
                return
            end

            return
        end
    end
    if not Welcome then
        v22("Enjoy", "Enjoy!", 5)
    end
    getgenv().Welcome = true
    if not t2[1] then
        return
    end
    local next_ = next
    local v35 = t2
    local v36 = u15
    local v38
    while true do
        local v39

        v38, v39 = next_(t2, v38)

        if not v38 then
            break
        end

        v16(v39)
    end
    if not v36 then
        t2 = next
        game_ = nil

        while true do
            game_, next_ = t2(v35, game_)

            if not game_ then
                break
            end

            v38 = v16(next_)

            if v38 then
                v38 = v16(next_) ~= LocalPlayer
            end

            if v38 then
                if v16(next_).UserId == 1 then
                    v22("Error Occurred", "This user is whitelisted! (Owner)", 5)
                else
                    next_ = v16(next_)

                    if next_ then
                        v23(next_)
                    end
                end
            else
                next_ = not v16(next_)

                if next_ then
                    next_ = not v36
                end

                if next_ then
                    v22("Error Occurred", "Username Invalid", 5)
                end
            end
        end

        return
    end
    t2 = next
    game_, next_ = game_:GetPlayers()
    while true do
        next_, v38 = t2(game_, next_)

        if not next_ then
            break
        end

        v23(v38)
    end
    t2 = next
    game_ = nil
    while true do
        game_, next_ = t2(v35, game_)

        if not game_ then
            break
        end

        v38 = v16(next_)

        if v38 then
            v38 = v16(next_) ~= LocalPlayer
        end

        if v38 then
            if v16(next_).UserId == 1 then
                v22("Error Occurred", "This user is whitelisted! (Owner)", 5)
            else
                next_ = v16(next_)

                if next_ then
                    v23(next_)
                end
            end
        else
            next_ = not v16(next_)

            if next_ then
                next_ = not v36
            end

            if next_ then
                v22("Error Occurred", "Username Invalid", 5)
            end
        end
    end
end
})
uDim2.Main6:AddSection("World Configuration")
t1.value7 = game:GetService("Lighting")
RunService = game
RunService:GetService("Workspace")
game:GetService("RunService")
t1.value8 = game:GetService("Players").LocalPlayer
t1.value9 = {
	["Galaxy"] = {
		["SkyboxBk"] = "rbxassetid://159454288",
		["SkyboxDn"] = "rbxassetid://159454288",
		["SkyboxFt"] = "rbxassetid://159454288",
		["SkyboxLf"] = "rbxassetid://159454288",
		["SkyboxRt"] = "rbxassetid://159454288",
		["SkyboxUp"] = "rbxassetid://159454288"
	},
	["Night"] = {
		["SkyboxBk"] = "rbxassetid://1514717643",
		["SkyboxDn"] = "rbxassetid://1514716936",
		["SkyboxFt"] = "rbxassetid://1514715910",
		["SkyboxLf"] = "rbxassetid://1514714945",
		["SkyboxRt"] = "rbxassetid://1514714011",
		["SkyboxUp"] = "rbxassetid://1514713374"
	},
	["Ocean Sunset"] = {
		["SkyboxBk"] = "rbxassetid://17525686840",
		["SkyboxDn"] = "rbxassetid://17525678473",
		["SkyboxFt"] = "rbxassetid://17525684686",
		["SkyboxLf"] = "rbxassetid://17525680663",
		["SkyboxRt"] = "rbxassetid://17525682665",
		["SkyboxUp"] = "rbxassetid://17525674545"
	},
	["My Summer Car"] = {
		["SkyboxBk"] = "rbxassetid://16648590964",
		["SkyboxDn"] = "rbxassetid://16648617436",
		["SkyboxFt"] = "rbxassetid://16648595424",
		["SkyboxLf"] = "rbxassetid://16648566370",
		["SkyboxRt"] = "rbxassetid://16648577071",
		["SkyboxUp"] = "rbxassetid://16648598180"
	},
	["Standard"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=91458024",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=91457980",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=91458024",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=91458024",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=91458024",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=91458002"
	},
	["Minecraft"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=8735166756",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=8735166707",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=8735231668",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=8735166755",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=8735166751",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=8735166729"
	},
	["Spongebob"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=277099484",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=277099500",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=277099554",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=277099531",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=277099589",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=277101591"
	},
	["Clouded Sky"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=252760981",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=252763035",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=252761439",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=252760980",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=252760986",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=252762652"
	},
	["Retro"] = {
		["SkyboxBk"] = "rbxasset://sky/null_plainsky512_bk.jpg",
		["SkyboxDn"] = "rbxasset://sky/null_plainsky512_dn.jpg",
		["SkyboxFt"] = "rbxasset://sky/null_plainsky512_ft.jpg",
		["SkyboxLf"] = "rbxasset://sky/null_plainsky512_lf.jpg",
		["SkyboxRt"] = "rbxasset://sky/null_plainsky512_rt.jpg",
		["SkyboxUp"] = "rbxasset://sky/null_plainsky512_up.jpg"
	},
	["City"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=9134792889",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=9134791975",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=9134793457",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=9134791234",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=9134790419",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=9134791633"
	}
}
v10 = {}
v11 = {}
for k, _ in pairs(t1.value9) do
    table.insert(v10, k)
end
table.sort(v10)
t1.value10 = false
t1.value11 = v10[1]
function t1.value12(p6)
    local v41 = t1.value9[p6]
    if not v41 then
        return
    end
    for v44, v45 in pairs(t1.value7:GetChildren()) do

        if v45:IsA("Atmosphere") or v45:IsA("Clouds") then
            v45:Destroy()
        end
    end
    SSky = t1.value7:FindFirstChild("SSky")
    if SSky then
        SSky.SkyboxBk = v41.SkyboxBk
        SSky.SkyboxDn = v41.SkyboxDn
        SSky.SkyboxFt = v41.SkyboxFt
        SSky.SkyboxLf = v41.SkyboxLf
        SSky.SkyboxRt = v41.SkyboxRt
        SSky.SkyboxUp = v41.SkyboxUp
        SSky.SunTextureId = ""
        SSky.MoonTextureId = ""
        SSky.StarCount = 0

        return
    end
    for _, child in pairs(t1.value7:GetChildren()) do
        if child:IsA("Sky") then
            child:Destroy()
        end
    end
    SSky = Instance.new("Sky")
    SSky.Name = "SSky"
    SSky.Parent = t1.value7
    SSky.SkyboxBk = v41.SkyboxBk
    SSky.SkyboxDn = v41.SkyboxDn
    SSky.SkyboxFt = v41.SkyboxFt
    SSky.SkyboxLf = v41.SkyboxLf
    SSky.SkyboxRt = v41.SkyboxRt
    SSky.SkyboxUp = v41.SkyboxUp
    SSky.SunTextureId = ""
    SSky.MoonTextureId = ""
    SSky.StarCount = 0
end
RunService = uDim2.Main6
RunService:AddDropdown("SkyboxPreset", {
	["Title"] = "SkyBox Preset",
	["Values"] = v10,
	["Default"] = 1,
	["Callback"] = function(p7)
    if type(p7) == "table" then
        p7 = p7[1]
    end

    if not p7 then
        return
    end

    t1.value11 = tostring(p7)

    if not t1.value10 then
        return
    end

    t1.value12(t1.value11)
end
})
t1.value13 = game:GetService("RunService")
t1.value14 = game:GetService("Workspace")
t1.value15 = "None"
t1.value16 = nil
t1.value17 = nil
t1.value17 = false
t1.value16 = nil
t1.value18 = nil
function t1.value19(p8)
    if t1.value16 then
        t1.value16:Destroy()
        t1.value16 = nil
    end

    t1.value15 = p8

    if not t1.value17 or p8 == "None" then
        return
    end

    local CurrentCamera = t1.value14.CurrentCamera

    if not CurrentCamera then
        return
    end

    t1.value16 = Instance.new("Part")
    t1.value16.Name = "Optimized_Weather_Part"
    t1.value16.Size = Vector3.new(1, 1, 1)
    t1.value16.Transparency = 1
    t1.value16.Anchored = true
    t1.value16.CanCollide = false
    t1.value16.Parent = CurrentCamera
    CurrentCamera = Instance.new("ParticleEmitter")
    CurrentCamera.Parent = t1.value16
    CurrentCamera.EmissionDirection = Enum.NormalId.Bottom
    CurrentCamera.Enabled = true

    if p8 == "Rain" then
        CurrentCamera.Texture = "rbxassetid://241868005"
        CurrentCamera.Rate = 1200
        CurrentCamera.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        CurrentCamera.LightEmission = 0.2
        CurrentCamera.Transparency = NumberSequence.new(0)
        CurrentCamera.Size = NumberSequence.new(0.5, 1)
        CurrentCamera.Lifetime = NumberRange.new(1.5, 2)
        CurrentCamera.Speed = NumberRange.new(80, 100)
        CurrentCamera.SpreadAngle = Vector2.new(10, 10)
        CurrentCamera.Acceleration = Vector3.new(0, -60, 0)
        CurrentCamera.Orientation = Enum.ParticleOrientation.VelocityPerpendicular

        return
    end

    if p8 ~= "Snow" then
        return
    end

    CurrentCamera.Texture = "rbxassetid://99851851"
    CurrentCamera.Rate = 200
    CurrentCamera.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    CurrentCamera.Size = NumberSequence.new(0.3, 0.6)
    CurrentCamera.Speed = NumberRange.new(10, 20)
    CurrentCamera.Lifetime = NumberRange.new(4, 6)
    CurrentCamera.Acceleration = Vector3.new(0, -5, 0)
    CurrentCamera.SpreadAngle = Vector2.new(40, 40)
    CurrentCamera.LightEmission = 0.5
end
RunService = function(p9)
    t1.value17 = p9

    if p9 then
        t1.value19(t1.value15)

        if t1.value18 then
            return
        end

        return
    end

    if t1.value16 then
        t1.value16:Destroy()
    end

    if not t1.value18 then
        return
    end

    t1.value18:Disconnect()
end
Main = uDim2.Main6
Main:AddDropdown("WeatherDropdown", {
	["Title"] = "Weather Mode",
	["Description"] = "",
	["Values"] = { "None", "Rain", "Snow" },
	["Default"] = 1,
	["Callback"] = function(p10)
    t1.value19(p10)
end
})
Main = uDim2.Main6
Main:AddToggle("WeatherToggle", {
	["Title"] = "Enable Weather",
	["Description"] = "",
	["Default"] = false,
	["Callback"] = function(p11)
    RunService(p11)
end
})
RunService = uDim2.Main6
RunService:AddToggle("EnableSkybox", {
	["Title"] = "Enable Skybox",
	["Default"] = false,
	["Callback"] = function(p12)
    t1.value10 = p12

    if p12 then
        t1.value12(t1.value11)

        return
    end

    local SSky = t1.value7:FindFirstChild("SSky")

    if not SSky then
        return
    end

    SSky:Destroy()
end
})
uDim2.Main6:AddSection("Client Visuals")
RunService = uDim2.Main6
RunService:AddButton({
	["Title"] = "Enable Third Person Camera",
	["Description"] = "",
	["Callback"] = function()
    game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 200
    game:GetService("Players").LocalPlayer.CameraMode = Enum.CameraMode.Classic
end
})
RunService = uDim2.Main4
RunService:AddButton({
	["Title"] = "Free Hardcore TEST",
	["Description"] = "Game Teleport",
	["Callback"] = function()
    game:GetService("TeleportService"):Teleport(14633909260, t1.value8)
end
})
RunService = uDim2.Main4
RunService:AddButton({
	["Title"] = "Free Nightmare TEST",
	["Description"] = "Game Teleport",
	["Callback"] = function()
    game:GetService("TeleportService"):Teleport(102873092581478, t1.value8)
end
})
RunService = uDim2.Main6
RunService:AddButton({
	["Title"] = "ESP Kill Guns",
	["Description"] = "",
	["Callback"] = function()
    local pairs_ = pairs
    local KillsWeapons = workspace.Maps.MapArea51["Guns/Items"]:WaitForChild("KillsWeapons")

    for _, descendant in pairs_(KillsWeapons:GetDescendants()) do
        local isModel = descendant:IsA("Model")

        if isModel then
            isModel = not descendant:FindFirstChildOfClass("Highlight")
        end

        if isModel then
            Instance.new("Highlight", descendant)
        end
    end
end
})
RunService = uDim2.Main3
RunService:AddParagraph({
	["Title"] = "Warning!",
	["Content"] = "This Tab Is Not Supported For Low UNC Executors."
})
uDim2.Player:AddSection("Server Player Modifications")
t1.value20 = lib.Options
t1.value21 = game:GetService("RunService")
t1.value22 = game:GetService("Players").LocalPlayer
t1.value23 = nil
RunService = uDim2.Player
RunService = RunService:AddSlider("BarrierSize", {
	["Title"] = "God Mode Size",
	["Default"] = 5,
	["Min"] = 3,
	["Max"] = 50,
	["Rounding"] = 0
})
Main = uDim2.Player
Main = Main:AddToggle("AutoBarrier", {
	["Title"] = "God Mode",
	["Default"] = false
})
t1.value24 = nil
function t1.value24()
    local Maps = workspace:FindFirstChild("Maps")
    local NPCBarrier

    if not Maps then
        if Maps then
            NPCBarrier = Maps:FindFirstChild("NPCBarrier")
        else
            NPCBarrier = Maps
        end

        if NPCBarrier then
            Maps = Maps.NPCBarrier

            return Maps:FindFirstChild("NPCBarrier")
        else
            return nil
        end

        return
    end

    Maps = workspace.Maps:FindFirstChild("MapArea51")

    if Maps then
        NPCBarrier = Maps:FindFirstChild("NPCBarrier")
    else
        NPCBarrier = Maps
    end

    if NPCBarrier then
        Maps = Maps.NPCBarrier

        return Maps:FindFirstChild("NPCBarrier")
    else
        return nil
    end
end
RunService:OnChanged(function(p13)
    local v57 = t1.value24()

    if not v57 then
        return
    end

    v57.Size = Vector3.new(p13, p13, p13)
end)
Main:OnChanged(function(p14)
    if t1.value23 then
        t1.value23:Disconnect()
    end

    if not p14 then
        return
    end

    t1.value21.RenderStepped:Connect(function()
        local Character = t1.value22.Character

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        local v59 = t1.value24()

        if not (Character and v59) then
            return
        end

        local Value = t1.value20.BarrierSize.Value

        if v59.Size ~= Vector3.new(Value, Value, Value) then
            v59.Size = Vector3.new(Value, Value, Value)
        end

        v59.CFrame = Character.CFrame
    end)
end)
uDim2.Player:AddSection("Player Modifications")
RunService = uDim2.Main6
RunService:AddButton({
	["Title"] = "ESP",
	["Description"] = "Players",
	["Callback"] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KGuestCheatsJ2/Sc/refs/heads/main/UniversalESP"))()
end
})
RunService = uDim2.Main6
RunService:AddButton({
	["Title"] = "ESP",
	["Description"] = "Mobs",
	["Callback"] = function()
    local Mobs = workspace:WaitForChild("Mobs")
    local GetChildren = Mobs.GetChildren

    local function v63(p15)
        if p15:IsA("Model") then
            if p15:FindFirstChild("Mob_Highlight") then
                return
            else
                local Highlight = Instance.new("Highlight")

                Highlight.Name = "Mob_Highlight"
                Highlight.Adornee = p15
                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight.Parent = p15

                return
            end

            return
        else
            return
        end
    end

    for _, v in ipairs(GetChildren(Mobs)) do
        v63(v)
    end

    Mobs.ChildAdded:Connect(function(child)
        task.wait(0.1)
        v63(child)
    end)
    Mobs.ChildRemoved:Connect(function()
    end)
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "Open All",
	["Description"] = "Not Enables Risky Gun Mods!",
	["Callback"] = function()
    local next_ = next
    local v68, key = getgc(true)

    while true do
        local v70

        key, v70 = next_(v68, key)

        if not key then
            break
        end

        local v71 = type(v70) == "table"

        if v71 then
            v71 = rawget(v70, "AmmoPerMag")
        end

        if v71 then
            v70.Auto = true
            v70.Recoil = 0
            v70.CameraRecoilingEnabled = false
            v70.Range = 99999
            v70.BulletSpeed = 99999
            v70.Spread = 1
            v70.SpreadX = 1
            v70.SpreadY = 1
        end
    end
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "Make Ur Gun Auto",
	["Description"] = "",
	["Callback"] = function()
    local next_ = next
    local v73, key = getgc(true)

    while true do
        local v75

        key, v75 = next_(v73, key)

        if not key then
            break
        end

        local v76 = type(v75) == "table"

        if v76 then
            v76 = rawget(v75, "AmmoPerMag")
        end

        if v76 then
            v75.Auto = true
        end
    end
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "No Spread",
	["Description"] = "Click Again To Close It",
	["Callback"] = function()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    getgenv().SpreadToggle = not getgenv().SpreadToggle

    if not getgenv().SpreadToggle then
        return
    end

    task.spawn(function()
        while getgenv().SpreadToggle do
            task.wait(1)

            local t3 = { LocalPlayer.Character, (LocalPlayer:FindFirstChild("Backpack")) }

            for _, v in ipairs(t3) do
                if v then
                    local GetChildren = v.GetChildren

                    for _, v2 in ipairs(GetChildren(v)) do
                        if v2:IsA("Tool") then
                            if v2:GetAttribute("spread_x") ~= nil then
                                v2:SetAttribute("spread_x", 0)
                            end

                            if v2:GetAttribute("spread_y") ~= nil then
                                v2:SetAttribute("spread_y", 0)
                            end
                        end
                    end
                end
            end
        end
    end)
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "Low Spread Legit",
	["Description"] = "Click Again To Close It",
	["Callback"] = function()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    getgenv().SpreadToggle = not getgenv().SpreadToggle

    if not getgenv().SpreadToggle then
        return
    end

    task.spawn(function()
        while getgenv().SpreadToggle do
            task.wait(1)

            local t4 = { LocalPlayer.Character, (LocalPlayer:FindFirstChild("Backpack")) }

            for _, v in ipairs(t4) do
                if v then
                    local GetChildren = v.GetChildren

                    for _, v2 in ipairs(GetChildren(v)) do
                        if v2:IsA("Tool") then
                            if v2:GetAttribute("spread_x") ~= nil then
                                v2:SetAttribute("spread_x", 1)
                            end

                            if v2:GetAttribute("spread_y") ~= nil then
                                v2:SetAttribute("spread_y", 1)
                            end
                        end
                    end
                end
            end
        end
    end)
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "No Recoil",
	["Description"] = "",
	["Callback"] = function()
    local next_ = next
    local v92, key = getgc(true)

    while true do
        local v94

        key, v94 = next_(v92, key)

        if not key then
            break
        end

        local v95 = type(v94) == "table"

        if v95 then
            v95 = rawget(v94, "AmmoPerMag")
        end

        if v95 then
            v94.Recoil = 0
            v94.CameraRecoilingEnabled = false
        end
    end
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "INF Range",
	["Description"] = "",
	["Callback"] = function()
    local next_ = next
    local v97, key = getgc(true)

    while true do
        local v99

        key, v99 = next_(v97, key)

        if not key then
            break
        end

        local v100 = type(v99) == "table"

        if v100 then
            v100 = rawget(v99, "AmmoPerMag")
        end

        if v100 then
            v99.Range = 99999
        end
    end
end
})
RunService = uDim2.Main3
Main = RunService.AddButton
v11.value3 = 20968572757540
Main(RunService, {
	["Title"] = "Super Bullet Speed",
	["Description"] = "",
	["Callback"] = function()
    local next_ = next
    local v102, key = getgc(true)

    while true do
        local v104

        key, v104 = next_(v102, key)

        if not key then
            break
        end

        local v105 = type(v104) == "table"

        if v105 then
            v105 = rawget(v104, "AmmoPerMag")
        end

        if v105 then
            v104.BulletSpeed = 99999
        end
    end
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "Big Ammo",
	["Description"] = "",
	["Callback"] = function()
    local next_ = next
    local v107, key = getgc(true)

    while true do
        local v109

        key, v109 = next_(v107, key)

        if not key then
            break
        end

        local v110 = type(v109) == "table"

        if v110 then
            v110 = rawget(v109, "AmmoPerMag")
        end

        if v110 then
            v109.BulletSize = Vector3.new(4, 4, 4)
            v109.BulletTransparency = 0
        end
    end
end
})
uDim2.Main3:AddSection("Risky Gun Modifications")
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "Make Ur Gun Explosive Low Ban Risk",
	["Description"] = "",
	["Callback"] = function()
    local next_ = next
    local v112, key = getgc(true)

    while true do
        local v114

        key, v114 = next_(v112, key)

        if not key then
            break
        end

        local v115 = type(v114) == "table"

        if v115 then
            v115 = rawget(v114, "AmmoPerMag")
        end

        if v115 then
            v114.ExplosiveEnabled = true
        end
    end
end
})
RunService = uDim2.Main3
RunService:AddButton({
	["Title"] = "Equip All Guns",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
    game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool").Parent = game.Players.LocalPlayer.Character
end
})
t1.value25 = game:GetService("Players").LocalPlayer
RunService = uDim2.Player
t1.value26 = RunService:AddToggle("FlashSpeed", {
	["Title"] = "Flash Speed",
	["Default"] = false
})
t1.value26:OnChanged(function(p16)
    print("Toggle changed:", p16)

    if p16 then
        task.spawn(function()
            while t1.value26.Value do
                local Character = t1.value25.Character

                if Character then
                    Character = Character:FindFirstChildOfClass("Humanoid")
                end

                if Character then
                    Character.WalkSpeed = 100
                end

                task.wait(0.05)
            end
        end)

        return
    end

    local Character = t1.value25.Character

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not Character then
        return
    end

    Character.WalkSpeed = 16
end)
RunService = game
t1.value27 = RunService.GetService(RunService, "Players").LocalPlayer
uDim2.Player:AddToggle("FlashJump", {
	["Title"] = "High Jump",
	["Default"] = false
}):OnChanged(function(p17)
    print("Toggle changed:", p17)

    local Character = t1.value27.Character

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not Character then
        return
    end

    Character.UseJumpPower = p17
    Character.JumpPower = p17 and 140 or 65
end)
RunService = uDim2.Player
Main = RunService.AddButton
v11.value4 = 12604284360429
Main(RunService, {
	["Title"] = "Inf Jump",
	["Description"] = "",
	["Callback"] = function()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    game:GetService("UserInputService").JumpRequest:Connect(function()
        local Character = LocalPlayer

        if Character then
            Character = LocalPlayer.Character

            if Character then
                Character = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end

        if not Character then
            return
        end

        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end
})
RunService = uDim2.Player
RunService:AddButton({
	["Title"] = "Fly",
	["Description"] = "Click Again To Enable/Disable",
	["Callback"] = function()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    LocalPlayer = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = LocalPlayer:WaitForChild("HumanoidRootPart")
    LocalPlayer = LocalPlayer:WaitForChild("Humanoid")
    _G.IY_FLY = not _G.IY_FLY
    local RunService2 = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local connection
    local CurrentCamera = workspace.CurrentCamera
    local vector3 = Vector3.zero
    local vector32 = Vector3.zero
    local vector33 = Vector3.new(0, 1, 0)
    local vector34 = Vector3.zero
    local vector35 = Vector3.zero
    RunService2 = function()
        LocalPlayer.PlatformStand = true

        local BodyVelocity = Instance.new("BodyVelocity")

        BodyVelocity.Name = "IY_FlyBV"
        BodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
        BodyVelocity.Velocity = vector34
        BodyVelocity.Parent = HumanoidRootPart

        local BodyGyro = Instance.new("BodyGyro")

        BodyGyro.Name = "IY_FlyBG"
        BodyGyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
        BodyGyro.P = 90000
        BodyGyro.CFrame = CurrentCamera.CFrame
        BodyGyro.Parent = HumanoidRootPart
        connection = RunService2.Heartbeat:Connect(function()
            local CFrame_ = CurrentCamera.CFrame

            BodyGyro.CFrame = CFrame_
            vector3 = CFrame_.LookVector
            vector32 = CFrame_.RightVector
            vector35 = vector34

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                vector35 = vector35 + vector3
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                vector35 = vector35 - vector3
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                vector35 = vector35 - vector32
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                vector35 = vector35 + vector32
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                vector35 = vector35 + vector33
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                vector35 = vector35 - vector33
            end

            CFrame_ = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

            if not CFrame_[1] then
                if vector35.Magnitude > 0 then
                    BodyVelocity.Velocity = vector35.Unit * 80

                    return
                else
                    BodyVelocity.Velocity = vector34

                    return
                end

                return
            end

            vector35 = vector35 + vector32 * CFrame_[1].Position.X
            vector35 = vector35 + vector3 * -CFrame_[1].Position.Y

            if vector35.Magnitude > 0 then
                BodyVelocity.Velocity = vector35.Unit * 80

                return
            else
                BodyVelocity.Velocity = vector34

                return
            end
        end)
    end
    LocalPlayer = function()
        LocalPlayer.PlatformStand = false

        if connection then
            connection:Disconnect()
        end

        if HumanoidRootPart:FindFirstChild("IY_FlyBV") then
            HumanoidRootPart.IY_FlyBV:Destroy()
        end

        if not HumanoidRootPart:FindFirstChild("IY_FlyBG") then
            return
        end

        HumanoidRootPart.IY_FlyBG:Destroy()
    end
    if _G.IY_FLY then
        RunService2()
    else
        LocalPlayer()
    end
end
})
RunService = uDim2.Player
RunService:AddButton({
	["Title"] = "Noclip / Fly Noclip",
	["Description"] = "Click Again To Close It",
	["Callback"] = function()
    local Players = game:GetService("Players")
    local RunService2 = game:GetService("RunService")

    Players = Players.LocalPlayer
    Players = Players.Character or Players.CharacterAdded:Wait()
    getgenv().noclipEnabled = not getgenv().noclipEnabled

    if getgenv().noclipEnabled then
        getgenv().noclipConnection = RunService2.Stepped:Connect(function()
            local v137 = Players

            for _, descendant in ipairs(v137:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                end
            end
        end)
        print("Noclip Enabled")

        return
    end

    if not getgenv().noclipConnection then
        for _, descendant in ipairs(Players:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = true
            end
        end

        print("Noclip Disabled")

        return
    end

    getgenv().noclipConnection:Disconnect()
    getgenv().noclipConnection = nil

    for _, descendant in ipairs(Players:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = true
        end
    end

    print("Noclip Disabled")
end
})
RunService = uDim2.Player
RunService:AddButton({
	["Title"] = "FullBright",
	["Description"] = "",
	["Callback"] = function()
    local Lighting = game:GetService("Lighting")

    Lighting.FogEnd = 1000000000
    Lighting.FogStart = 0
    Lighting.ClockTime = 14
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end
})
RunService = uDim2.Main4
RunService:AddButton({
	["Title"] = "Inf Yield",
	["Description"] = "",
	["Callback"] = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end
})
RunService = uDim2.Main
RunService:AddButton({
	["Title"] = "Instant E Button",
	["Description"] = "",
	["Callback"] = function()
    local ipairs_ = ipairs
    local Workspace = game:GetService("Workspace")

    for _, descendant in ipairs_(Workspace:GetDescendants()) do
        if descendant.ClassName == "ProximityPrompt" then
            descendant.HoldDuration = 0
        end
    end
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get Starter Pistol",
	["Description"] = "Free",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(103.25531768799, 4.0000152587891, -28.698318481445)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"]["FREE-M1991"].EItem["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get UZI",
	["Description"] = "5 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(31.394836425781, 4.0000152587891, -64.208381652832)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons.UZI.EItem["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get Remington Shotgun",
	["Description"] = "15 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(-70.780815124512, 4.0000152587891, 146.85165405273)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons["Remington 870"].EItem["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get Ruger",
	["Description"] = "50 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(145.49629211426, 13.999968528748, 403.22598266602)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons["Ruger Mini 14"].EItem["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get AK47",
	["Description"] = "70 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(44.062725067139, 3.7960333824158, -198.05728149414)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons["AK-47"]["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
v11.value4 = 26052285902691
RunService:AddButton({
	["Title"] = "Get M16A2",
	["Description"] = "90 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(0.45726957917213, 24.000005722046, 147.70240783691)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons.M16A2["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get Heckler Sniper",
	["Description"] = "100 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(4.8957185745239, 13.999968528748, 230.27224731445312)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons["Heckler & Koch G3SG"]["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get Bazooka",
	["Description"] = "150 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(48.963626861572, 46.000003814697, 290.44537353516)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons.Bazooka.EItem["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main2
RunService:AddButton({
	["Title"] = "Get Ice Generator",
	["Description"] = "200 Kills Need",
	["Callback"] = function()
    local HumanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local CFrame_ = HumanoidRootPart.CFrame

    HumanoidRootPart.CFrame = CFrame.new(-95.781898498535, -5.9999394416809, 322.60180664062)
    task.wait(0.2)

    local ProximityPrompt = game.workspace.Maps.MapArea51["Guns/Items"].KillsWeapons["Ice Generator"].EItem["E to Equip"].ProximityPrompt

    fireproximityprompt(ProximityPrompt)
    task.wait(0.15)
    HumanoidRootPart.CFrame = CFrame_
end
})
RunService = uDim2.Main
RunService:AddButton({
	["Title"] = "Fake INF Rebirths",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.leaderstats.Rebirths.Value = 99999999
end
})
RunService = uDim2.Main
RunService:AddButton({
	["Title"] = "Fake INF Kills",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.leaderstats.Kills.Value = 99999999
end
})
RunService = uDim2.TP
RunService:AddButton({
	["Title"] = "Spawn",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(192.49691772461, 202.00001525879, -51.307079315186)
end
})
RunService = uDim2.TP
RunService:AddButton({
	["Title"] = "Lobby",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(102.49645996094, 4.0000143051147, -18.613000869751)
end
})
RunService = uDim2.TP
RunService:AddButton({
	["Title"] = "Cyborg Boss",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(558.58190917969, -5.9999408721924, 359.97604370117)
end
})
RunService = uDim2.TP
RunService:AddButton({
	["Title"] = "Mad Killer Boss",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(82.960571289062, 3.9294698238373, -761.46459960938)
end
})
RunService = uDim2.TP
RunService:AddButton({
	["Title"] = "Map Skeleton",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1529.5394287109, 3.9294698238373, 133.53607177734)
end
})
RunService = uDim2.TP
RunService:AddButton({
	["Title"] = "Robloxia Town",
	["Description"] = "",
	["Callback"] = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-942.26135253906, -3.2499923706055, -32.735427856445)
end
})
t1.value28 = lib.Options
RunService = uDim2.Main4
Main = RunService.AddToggle
v11.value4 = 8276954074894
Main(RunService, "Auto2", {
	["Title"] = "Spam Close All Doors",
	["Default"] = false
}):OnChanged(function()
    print("Toggle changed:", t1.value28.Auto2.Value)

    while t1.value28.Auto2.Value do
        local MapArea51 = workspace.Maps.MapArea51
        local ipairs_ = ipairs
        for _, descendant in ipairs_(MapArea51:GetDescendants()) do
            local isClickDetector = descendant:IsA("ClickDetector")

            if isClickDetector then
                isClickDetector = descendant.Parent

                if isClickDetector then
                    isClickDetector = descendant.Parent.Name == "Close"
                end
            end

            if isClickDetector then
                fireclickdetector(descendant)
            end
        end
        task.wait(0.5)
    end
end)
t1.value29 = lib.Options
v11.value4 = 11185956885592
RunService = uDim2.Main4
Main = RunService.AddToggle
v11.value4 = 22559802370313
Main(RunService, "Auto3", {
	["Title"] = "Spam Unlock All Doors",
	["Default"] = false
}):OnChanged(function()
    print("Toggle changed:", t1.value29.Auto3.Value)

    while t1.value29.Auto3.Value do
        local MapArea51 = workspace.Maps.MapArea51
        local ipairs_ = ipairs
        for _, descendant in ipairs_(MapArea51:GetDescendants()) do
            local isClickDetector = descendant:IsA("ClickDetector")

            if isClickDetector then
                isClickDetector = descendant.Parent

                if isClickDetector then
                    isClickDetector = descendant.Parent.Name == "Open"
                end
            end

            if isClickDetector then
                fireclickdetector(descendant)
            end
        end
        task.wait(0.45)
    end
end)
RunService = uDim2.Main4
v11.value4 = "\175q\212\159\20M\155\15D\149\250\167\\|\7"
function v11.value4()
    local MapArea51 = workspace.Maps.MapArea51
    local GetDescendants = MapArea51.GetDescendants
    local ipairs_ = ipairs
    for _, v in ipairs_(GetDescendants(MapArea51)) do
        local isClickDetector = v:IsA("ClickDetector")

        if isClickDetector then
            isClickDetector = v.Parent

            if isClickDetector then
                isClickDetector = v.Parent.Name == "Close"
            end
        end

        if isClickDetector then
            fireclickdetector(v)
        end
    end
end
Main = {
	["Title"] = "Close All Doors",
	["Description"] = "",
	["Callback"] = v11.value4
}
RunService:AddButton(Main)
v11.value4 = 17020171493109
RunService = uDim2.Main4
v11.value4 = "`%\2063\155\148\159\162\252\215\230m\223\17"
function v11.value4()
    local MapArea51 = workspace.Maps.MapArea51
    local ipairs_ = ipairs
    for _, descendant in ipairs_(MapArea51:GetDescendants()) do
        local isClickDetector = descendant:IsA("ClickDetector")

        if isClickDetector then
            isClickDetector = descendant.Parent

            if isClickDetector then
                isClickDetector = descendant.Parent.Name == "Open"
            end
        end

        if isClickDetector then
            fireclickdetector(descendant)
        end
    end
end
RunService:AddButton({
	["Title"] = "Open All Doors",
	["Description"] = "",
	["Callback"] = v11.value4
})
v11.value4 = "|\226\244gS"
RunService = uDim2.Main4
Main = RunService.AddSlider
v11.value1 = "\135\204\232"
v11.value5 = 1000
t1.value30 = Main(RunService, "SpinBotSpeed", {
	["Title"] = "Spin Speed",
	["Default"] = 50,
	["Min"] = 25,
	["Max"] = v11.value5,
	["Rounding"] = 0
})
RunService = game
Main = RunService.GetService
v11.value4 = "\221V\251\185"
RunService = Main(RunService, "RunService")
Main = workspace
v10 = Main.FindFirstChild
v11.value4 = "\196K\253\199\179"
t1.value31 = v10(Main, "Mobs")
Main = uDim2.Main4:AddSlider("HitboxSize2", {
	["Title"] = "Hitbox Size",
	["Default"] = 5,
	["Min"] = 2,
	["Max"] = 15,
	["Rounding"] = 1
})
v11.value6 = 31413141207331
v11.value2 = 9432356622632
v10 = Main.OnChanged
v11.value5 = 8116238110403
v10(Main, function(p18)
    _G.HitboxSize2 = p18
end)
Main = uDim2.Main4
v10 = Main.AddToggle
v11.value5 = false
v10(Main, "HitboxEnable2", {
	["Title"] = "Expand NPC Hitbox",
	["Default"] = v11.value5
}):OnChanged(function(p19)
    _G.HitboxEnabled = p19
end)
Main = uDim2.Main4
v11.value5 = "\171\2107\149B\254\25\t\250\154\141"
Main:AddToggle("HitboxShow2", {
	["Title"] = "Show Hitbox",
	["Default"] = false
}):OnChanged(function(p20)
    _G.HitboxVisible = p20
end)
t1.value32 = {}
RunService.Heartbeat:Connect(function()
    if not t1.value31 then
        return
    end
end)
v11.value4 = "game"
v11.value4 = game:GetService("RunService")
t1.value33 = v11.value4
RunService = game
Main = RunService.GetService
v11.value6 = "\251\162-\185r\203\15\195\166\f\4"
v11.value2 = 29281307342147
v11.value4 = Main(RunService, "Players").LocalPlayer
t1.value34 = v11.value4
t1.value35 = uDim2.Main4:AddToggle("SpinBotToggle", {
	["Title"] = "Enable SpinBot",
	["Default"] = false
})
t1.value36 = nil
t1.value37 = nil
function v11.value6(p21)
    if p21 then
        t1.value37()

        return
    end

    if not t1.value36 then
        return
    end

    t1.value36:Disconnect()
end
function t1.value37()
    if t1.value36 then
        t1.value36:Disconnect()
        t1.value36 = nil
    end

    t1.value36 = t1.value33.RenderStepped:Connect(function(dt)
        if not t1.value35.Value then
            return
        end

        local Character = t1.value34.Character

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        if not Character then
            return
        end

        local Value = t1.value30.Value or 50
        local CFrame_ = Character.CFrame
        local cFrame = CFrame.Angles

        Value = Value * dt * 10
        Character.CFrame = CFrame_ * cFrame(0, math.rad(Value), 0)
    end)
end
t1.value35:OnChanged(v11.value6)
RunService = t1.value29.Auto
v11.value6 = false
RunService:SetValue(v11.value6)
RunService = t1.value29.Auto2
v11.value6 = false
RunService:SetValue(v11.value6)
RunService = t1.value29.Auto3
v11.value1 = "21/\1992\156\136\"\209;\202\140\200j\\"
v11.value6 = false
RunService:SetValue(v11.value6)
lib2:SetLibrary(lib)
lib3:SetLibrary(lib)
lib2:IgnoreThemeSettings()
lib2:SetIgnoreIndexes({})
lib3:SetFolder("FluentScriptHub")
lib2:SetFolder("FluentScriptHub/specific-game")
lib3:BuildInterfaceSection(uDim2.Settings)
lib2:BuildConfigSection(uDim2.Settings)
value41:SelectTab(5)
lib3 = lib.Notify
v11.value3 = "\29\240O\180\172\128\27\182\189\127\161\242\'\154x}\246;\252r\253\168\19\231\3\253\225\184\179D\210\209[* }g\172t"
lib3(lib, {
	["Title"] = "KGuest Hub",
	["Content"] = "The Script Has Been Succesfully Loaded.",
	["Duration"] = 8
})
v11.value6 = "task"
lib2:LoadAutoloadConfig()
lib = task.wait
v11.value2 = "hookmetamethod"
v11.value6 = 1
v11.value1 = "newcclosure"
lib(v11.value6)
v11.value6 = "getnamecallmethod"
lib = getgenv
lib2 = getnamecallmethod
v11.value6 = hookmetamethod
v11.value2 = hookfunction
lib3 = newcclosure
v11.value1 = checkcaller
value41 = string.lower
value41 = string.gsub
uDim2 = string.match
t1.value38 = lib
t1.value39 = lib2
t1.value40 = v11.value1
t1.value41 = value41
if t1.value38().ED_AntiKick then
    return
end
lib = cloneref or function(...)
    return ...
end
v11.value7 = clonefunction or function(...)
    return ...
end
lib(game:GetService("Players"))
v11.value8 = lib(game:GetService("Players").LocalPlayer)
v11.value9 = lib(game:GetService("StarterGui"))
lib = v11.value8
lib2 = v11.value9
v11.value9 = v11.value7(lib2.SetCore)
value41 = v11.value9
v11.value9 = v11.value7(game.FindFirstChild)
uDim2 = v11.value9
v11.value9 = CompareInstances and function(p22, p23)
    local v201 = typeof(p22) == "Instance"

    if not v201 then
        if v201 then
            return CompareInstances(p22, p23)
        else
            return
        end

        return
    end

    v201 = typeof(p23) == "Instance"

    if v201 then
        return CompareInstances(p22, p23)
    else
        return
    end
end or function(p24, p25)
    local v202 = typeof(p24) == "Instance"

    if not v202 then
        return v202
    end

    v202 = typeof(p25) == "Instance"

    return v202
end
RunService = v11.value9
uDim2 = function(...)
    return pcall(uDim2, game, ...)
end
v11.value10 = t1.value38()
v11.value10.ED_AntiKick = {
	["Enabled"] = true,
	["SendNotifications"] = true,
	["CheckCaller"] = true
}
local v203
v203 = v11.value6(game, "__namecall", lib3(function(...)
    local t5 = { ... }
    local v205 = t5[2]
    local v206 = t5[1]
    local v207 = t1.value39()
    local v208 = t1.value38().ED_AntiKick.CheckCaller and not t1.value40() or true

    if v208 then
        v208 = RunService(v206, lib)

        if v208 then
            v208 = t1.value41(v207, "^%l", string.upper) == "Kick"

            if v208 then
                v208 = ED_AntiKick.Enabled
            end
        end
    end

    if not (v208 and uDim2(v205)) then
        return v203(unpack_(t5))
    end

    if not t1.value38().ED_AntiKick.SendNotifications then
        return
    end

    value41(lib2, "SendNotification", {
		["Title"] = "AntiKick",
		["Text"] = "Successfully intercepted an attempted kick.",
		["Icon"] = "rbxassetid://6238540373",
		["Duration"] = 2
	})
end))
v11.value2(lib.Kick, function(...)
    local t6 = { ... }
    local v210 = t6[1]
    local ED_AntiKick_ = ED_AntiKick

    t6 = t6[2]
    ED_AntiKick_ = ED_AntiKick_.CheckCaller and not t1.value40() or true

    if ED_AntiKick_ then
        ED_AntiKick_ = RunService(v210, lib)

        if ED_AntiKick_ then
            ED_AntiKick_ = ED_AntiKick.Enabled
        end
    end

    if not (ED_AntiKick_ and uDim2(t6)) then
        return
    end

    if not ED_AntiKick.SendNotifications then
        return
    end

    value41(lib2, "SendNotification", {
		["Title"] = "AntiKick",
		["Text"] = "Successfully intercepted an attempted kick.",
		["Icon"] = "rbxassetid://6238540373",
		["Duration"] = 2
	})
end)
v11.value11 = t1.value38().ED_AntiKick
if not v11.value11.SendNotifications then
    return
end
lib2:SetCore("SendNotification", {
	["Title"] = "For Unknown Kicks",
	["Text"] = "Anti Kick Loaded",
	["Icon"] = "rbxassetid://6238537240",
	["Duration"] = 3
})
