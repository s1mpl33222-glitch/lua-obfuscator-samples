local u1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local v2 = u1:CreateWindow({
    Title = "IsmaHub",
    Footer = "v1.0.0",
    Center = true,
    AutoShow = true,
})
local v3 = v2:AddTab("Main", "house")
local v4 = v2:AddTab("Gens/Misc", "wrench")
local v5 = v2:AddTab("Aimbot", "target")
local v6 = v2:AddTab("Settings", "settings"):AddLeftGroupbox("Settings")
v6:AddButton({
    Text = "Copy Discord Invite",
    Func = function()
        setclipboard("https://discord.gg/J8cmkd4vma")
    end,
    DoubleClick = false,
})
v6:AddButton({
    Text = "Unload",
    Func = function()
        u1:Unload()
        u1.ShowCustomCursor = false
    end,
    DoubleClick = true,
})
local v7 = v3:AddLeftGroupbox("Stamina Settings")
local v8 = v3:AddRightGroupbox("ESP")
local v9 = v4:AddLeftGroupbox("Generators")
local v10 = v4:AddRightGroupbox("Misc")
local v11 = v5:AddLeftGroupbox("Killer Aimbot")
local v12 = v5:AddRightGroupbox("Survivor Aimbot")
local color3 = Color3.new(1, 0, 0)
local color3_2 = Color3.new(0, 1, 0)
local color3_3 = Color3.new(0, 0, 1)
local u16 = false
local t1 = {
    "Two Time",
    "TwoTime",
    "Guest 1337",
    "Guest1337",
    "007n7",
    "Builderman",
    "Dusekkar",
    "Taph",
    "Chance",
    "Elliot",
    "Shedletsky",
    "Noob",
}
local t2 = {
    "1x1x1x1",
    "John Doe",
    "JohnDoe",
    "c00lkidd",
}
local t3 = {
    "Medkit",
    "BloxyCola",
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Q = Enum.KeyCode.Q
local n1 = 500
local n2 = 10
local n3 = 24
local n4 = 0
local u29 = false
local u30 = false
local u31 = false
local u32 = nil
local t4 = {
    "rbxassetid://79782181585087",
    "rbxassetid://128711903717226",
}
local t5 = {
    "rbxassetid://201858045",
    "rbxassetid://139012439429121",
}
local t6 = {
    "rbxassetid://109525294317144",
}
local _ = {
    "rbxassetid://112809109188560",
    "rbxassetid://102228729296384",
}
local t7 = {
    "rbxassetid://12222225",
    "rbxassetid://83851356262523",
}
local t8 = {
    "rbxassetid://609342351",
}
local _ = nil
local connection = nil
local connection2 = nil
local u42 = nil
local connection3 = nil
local _ = game.Players.LocalPlayer
local u45 = false
local u46 = false
local _ = false
local u48 = false
identifyexecutor()
u1:Notify("Join the discord... pls https://discord.gg/xn8aNh8kWD", 10)
u1:Notify("Enjoy, Feel free to post any bugs or suggestions in the server.", 10)
local function u49(p1, p2)
    if p1 then
        local ObjectHighlight = p1:FindFirstChild("ObjectHighlight")
        if ObjectHighlight then
            ObjectHighlight:Destroy()
        end
        local Highlight = Instance.new("Highlight", p1)
        Highlight.Name = "ObjectHighlight"
        Highlight.FillColor = p2
        Highlight.OutlineColor = p2
        Highlight.FillTransparency = 0.5
        Highlight.Enabled = true
        if u16 then
            Highlight.FillTransparency = 1
        else
            Highlight.OutlineTransparency = 0
        end
        return
    end
end
local VirtualInputManager2 = game:GetService("VirtualInputManager")
local function u51()
    while true do
        if Do1x1PopupsLoop then
            local LocalPlayer2 = game:GetService("Players").LocalPlayer
            local children = LocalPlayer2.PlayerGui.TemporaryUI:GetChildren()
            local v75, v76, v77 = ipairs(children)
            for _, v79 in v75, v76, v77 do
                local v80 = v79
                if v80.Name == "1x1x1x1Popup" then
                    local v81 = v80.AbsolutePosition.X + v80.AbsoluteSize.X / 2
                    local v82 = v80.AbsolutePosition.Y + v80.AbsoluteSize.Y / 2
                    VirtualInputManager2:SendMouseButtonEvent(v81, v82, Enum.UserInputType.MouseButton1.Value, true, LocalPlayer2.PlayerGui, 1)
                    VirtualInputManager2:SendMouseButtonEvent(v81, v82, Enum.UserInputType.MouseButton1.Value, false, LocalPlayer2.PlayerGui, 1)
                end
            end
        end
        task.wait(0.1)
    end
end
local function u52(p3)
    if not p3 then
        return
    end
    local ObjectHighlight = p3:FindFirstChild("ObjectHighlight")
    if ObjectHighlight then
        ObjectHighlight:Destroy()
    end
end
local function u53(p4)
    u31 = p4
    if game.Players.LocalPlayer.Character.Name ~= "Chance" and p4 then
        u1:Notify("Uh-oh! Looks like you're not using Chance right now. To avoid any weird glitches, make sure this is turned off unless you're playing as Chance!", 5)
        return
    end
    if not p4 then
        if u32 then
            u32:Disconnect()
            u32 = nil
        end
    else
        u32 = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not u31 then
                return
            end
            local v183, v184, v185 = pairs(t5)
            for _, v187 in v183, v184, v185 do
                if v187 == child.Name then
                    local Model = game.Workspace.Players:FindFirstChild("Killers"):FindFirstChildOfClass("Model")
                    if Model and Model:FindFirstChild("HumanoidRootPart") then
                        local HumanoidRootPart = Model.HumanoidRootPart
                        local HumanoidRootPart2 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart2 then
                            local _ = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Unit
                            local n5 = 1
                            while n5 <= 100 do
                                task.wait(0.01)
                                n5 += 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, HumanoidRootPart.Position)
                                HumanoidRootPart2.CFrame = CFrame.lookAt(HumanoidRootPart2.Position, Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, HumanoidRootPart.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    end
end
local function u54(p5)
    u48 = p5
    if game.Players.LocalPlayer.Character.Name ~= "Shedletsky" and p5 then
        u1:Notify("Heads up! You're not Shedletsky. This might cause issues, so please disable this unless you're playing as Shedletsky!", 5)
        return
    end
    if p5 then
        connection3 = game.Players.LocalPlayer.Character.Sword.ChildAdded:Connect(function(child)
            if not u48 then
                return
            end
            local v194, v195, v196 = pairs(t7)
            for _, v198 in v194, v195, v196 do
                if v198 == child.Name then
                    local Killers = game.Workspace.Players:FindFirstChild("Killers")
                    if Killers then
                        local Model = Killers:FindFirstChildOfClass("Model")
                        if Model and Model:FindFirstChild("HumanoidRootPart") then
                            local HumanoidRootPart = Model.HumanoidRootPart
                            local HumanoidRootPart3 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if HumanoidRootPart3 then
                                local n6 = 1
                                while n6 <= 100 do
                                    task.wait(0.01)
                                    n6 += 1
                                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, HumanoidRootPart.Position)
                                    HumanoidRootPart3.CFrame = CFrame.lookAt(HumanoidRootPart3.Position, HumanoidRootPart.Position)
                                end
                            end
                        end
                    end
                end
            end
        end)
    elseif connection3 then
        connection3:Disconnect()
        connection3 = nil
    end
end
local function u55(p6)
    u48 = p6
    if game.Players.LocalPlayer.Character.Name == "Guest1337" or not p6 then
        if p6 then
            connection3 = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
                if u48 then
                    local v205, v206, v207 = pairs(t8)
                    for _, v209 in v205, v206, v207 do
                        if v209 == child.Name then
                            local Killers = game.Workspace.Players:FindFirstChild("Killers")
                            if Killers then
                                local Model = Killers:FindFirstChildOfClass("Model")
                                if Model and Model:FindFirstChild("HumanoidRootPart") then
                                    local HumanoidRootPart = Model.HumanoidRootPart
                                    local HumanoidRootPart4 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if HumanoidRootPart4 then
                                        local n7 = 1
                                        while n7 <= 100 do
                                            task.wait(0.01)
                                            n7 += 1
                                            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, HumanoidRootPart.Position)
                                            HumanoidRootPart4.CFrame = CFrame.lookAt(HumanoidRootPart4.Position, HumanoidRootPart.Position)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return
                end
            end)
        elseif u42 then
            u42:Disconnect()
            u42 = nil
        end
        return
    end
    u1:Notify("Whoops! You're not Guest right now. This could lead to bugs, so turn it off if you're not on Guest!", 5)
end
local function u56(p7)
    u45 = p7
    if game.Players.LocalPlayer.Character.Name == "1x1x1x1" or not p7 then
        if p7 then
            connection = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
                if not u45 then
                    return
                end
                local v216, v217, v218 = pairs(t4)
                for _, v220 in v216, v217, v218 do
                    if v220 == child.Name then
                        local t9 = {}
                        local v222, v223, v224 = pairs(game.Players:GetPlayers())
                        for _, v226 in v222, v223, v224 do
                            local v227 = v226
                            if v227 ~= game.Players.LocalPlayer then
                                local Character = v227.Character
                                if Character and Character:FindFirstChild("HumanoidRootPart") then
                                    table.insert(t9, Character)
                                end
                            end
                        end
                        local v229 = nil
                        local huge = math.huge
                        for _, v in pairs(t9) do
                            local HumanoidRootPart = v.HumanoidRootPart
                            local HumanoidRootPart5 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if HumanoidRootPart5 then
                                local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart5.Position).Magnitude
                                if Magnitude < huge then
                                    huge = Magnitude
                                    v229 = v
                                end
                            end
                        end
                        if v229 then
                            local HumanoidRootPart = v229.HumanoidRootPart
                            local HumanoidRootPart6 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if HumanoidRootPart6 then
                                local _ = (HumanoidRootPart.Position - HumanoidRootPart6.Position).Unit
                                local n8 = 1
                                local n9 = 100
                                if child.Name == "rbxassetid://79782181585087" then
                                    n9 = 220
                                end
                                while n8 <= n9 do
                                    task.wait(0.01)
                                    n8 += 1
                                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, HumanoidRootPart.Position)
                                    HumanoidRootPart6.CFrame = CFrame.lookAt(HumanoidRootPart6.Position, Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, HumanoidRootPart.Position.Z))
                                end
                            end
                        end
                    end
                end
            end)
        elseif connection then
            connection:Disconnect()
            connection = nil
        end
        return
    end
    u1:Notify("Heads up! You're not 1x1x1x1. This might cause glitches, so only use this if you're playing as 1x1x1x1!", 5)
end
local function u57(p8)
    u46 = p8
    if game.Players.LocalPlayer.Character.Name ~= "JohnDoe" and p8 then
        u1:Notify("Heads up! You're not John Doe. This might bug out, so turn it off if you're not him!", 5)
        return
    end
    if p8 then
        connection2 = game.Players.LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(child)
            if not u46 then
                return
            end
            local v242, v243, v244 = pairs(t6)
            for _, v246 in v242, v243, v244 do
                if v246 == child.Name then
                    local t10 = {}
                    local v248, v249, v250 = pairs(game.Players:GetPlayers())
                    for _, v252 in v248, v249, v250 do
                        local v253 = v252
                        if v253 ~= game.Players.LocalPlayer then
                            local Character = v253.Character
                            if Character and Character:FindFirstChild("HumanoidRootPart") then
                                table.insert(t10, Character)
                            end
                        end
                    end
                    local v255 = nil
                    local huge = math.huge
                    local v257, v258, v259 = pairs(t10)
                    for _, v261 in v257, v258, v259 do
                        local v262 = v261
                        local HumanoidRootPart = v262.HumanoidRootPart
                        local HumanoidRootPart7 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart7 then
                            local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart7.Position).Magnitude
                            if Magnitude < huge then
                                huge = Magnitude
                                v255 = v262
                            end
                        end
                    end
                    if v255 then
                        local HumanoidRootPart = v255.HumanoidRootPart
                        local HumanoidRootPart8 = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart8 then
                            local _ = (HumanoidRootPart.Position - HumanoidRootPart8.Position).Unit
                            local n10 = 1
                            while n10 <= 330 do
                                task.wait(0.01)
                                n10 += 1
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, HumanoidRootPart.Position)
                                HumanoidRootPart8.CFrame = CFrame.lookAt(HumanoidRootPart8.Position, Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y, HumanoidRootPart.Position.Z))
                            end
                        end
                    end
                end
            end
        end)
    elseif connection2 then
        connection2:Disconnect()
        connection2 = nil
    end
end
local function u58(p9, p10)
    if p9 and (p9.Character and p9.Character:FindFirstChild("Humanoid")) then
        u49(p9.Character, p10)
        return
    end
end
local function u59(p11)
    if not p11 or not p11.Character then
        return
    end
    u52(p11.Character)
end
local function u60()
    print("Killer ESP Enabled")
    local v94, v95, v96 = pairs(game.Players:GetPlayers())
    for _, v98 in v94, v95, v96 do
        local v99 = v98
        if v99.Character then
            local CharacterName = v99.Character.Name
            local v101, v102, v103 = ipairs(t2)
            for _, v105 in v101, v102, v103 do
                if CharacterName == v105 then
                    u58(v99, color3)
                    break
                end
            end
        end
    end
end
local function u61()
    print("Killer ESP Disabled")
    for _, player in pairs(game.Players:GetPlayers()) do
        u59(player)
    end
end
local function u62()
    print("Survivor ESP Enabled")
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local CharacterName = player.Character.Name
            local v111 = false
            for _, v in ipairs(t1) do
                if CharacterName == v then
                    v111 = true
                    break
                end
            end
            if v111 then
                u58(player, color3_2)
            end
        end
    end
end
local function u63()
    print("Survivor ESP Disabled")
    for _, player in pairs(game.Players:GetPlayers()) do
        u59(player)
    end
end
local function u64()
    print("Item ESP Enabled")
    local v116, v117, v118 = pairs(game.Workspace.Map.Ingame:GetChildren())
    for _, v120 in v116, v117, v118 do
        local v121 = v120
        if v121:IsA("Tool") then
            local v122, v123, v124 = ipairs(t3)
            for _, v126 in v122, v123, v124 do
                if v126 == v121.Name then
                    u49(v121, color3_3)
                    break
                end
            end
        end
    end
    game.Workspace.Map.Ingame.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            local v296, v297, v298 = ipairs(t3)
            for _, v300 in v296, v297, v298 do
                if v300 == child.Name then
                    u49(child, color3_3)
                    return
                end
            end
        end
    end)
    game.Workspace.Map.Ingame.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            u52(child)
        end
    end)
end
local function u65()
    print("Item ESP Disabled")
    for _, child in pairs(game.Workspace.Map.Ingame:GetChildren()) do
        if child:IsA("Tool") then
            u52(child)
        end
    end
end
v8:AddToggle("SurvivorESP", {
    Text = "Enable Survivor ESP",
    Default = false,
    Tooltip = "Highlights survivors",
    Callback = function(p12)
        if not p12 then
            u63()
        else
            u62()
        end
    end,
})
local function u66(p13)
    stam = p13
    local Sprinting = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
    local connection4 = nil
    connection4 = game:GetService("RunService").Heartbeat:Connect(function()
        if stam then
            Sprinting.StaminaLossDisabled = function()
            end
            return
        end
        connection4:Disconnect()
        Sprinting.StaminaLossDisabled = nil
    end)
end
v8:AddToggle("KillerESP", {
    Text = "Enable Killer ESP",
    Default = false,
    Tooltip = "Highlights the killer",
    Callback = function(p14)
        if p14 then
            u60()
        else
            u61()
        end
    end,
})
v8:AddToggle("ItemESP", {
    Text = "Enable Item ESP",
    Default = false,
    Tooltip = "Highlights interactable items",
    Callback = function(p15)
        if not p15 then
            u65()
        else
            u64()
        end
    end,
})
v7:AddLabel({
    Text = "This might not work on free executors!",
    DoesWrap = true,
})
v7:AddSlider("MaxStamina", {
    Text = "Max Stamina",
    Default = 100,
    Min = 0,
    Max = 300,
    Rounding = 0,
    Callback = function(p16)
        local Sprinting = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
        local lib = require(Sprinting)
        print("Max Stamina set to:", p16)
        if lib and lib.MaxStamina then
            lib.MaxStamina = p16
        end
    end,
})
v7:AddSlider("StaminaDepletion", {
    Text = "Stamina Depletion",
    Default = 10,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Callback = function(p17)
        local Sprinting = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
        local lib = require(Sprinting)
        print("Stamina Depletion set to:", p17)
        if lib and lib.StaminaLoss then
            lib.StaminaLoss = p17
        end
    end,
})
v7:AddSlider("StaminaRegeneration", {
    Text = "Stamina Regeneration",
    Default = 20,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Callback = function(p18)
        local Sprinting = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
        local lib = require(Sprinting)
        print("Stamina Regeneration set to:", p18)
        if lib and lib.StaminaGain then
            lib.StaminaGain = p18
        end
    end,
})
v7:AddToggle("infstaminatoggle", {
    Text = "Enable Infinite Stamina",
    Default = false,
    Tooltip = "Enables/Disables Infinite Stamina",
    Callback = function(p19)
        u66(p19)
    end,
})
local u67 = v10:AddToggle("JumpToggle", {
    Text = "Enable Jumping",
    Default = false,
    Tooltip = "Allows both Killers and Survivors to jump",
    Callback = function(p20)
        if not p20 then
            print("Jumping Disabled")
            if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
            end
            JumpPowerSlider.Disabled = true
        else
            print("Jumping Enabled")
            if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
            end
            JumpPowerSlider.Disabled = false
        end
    end,
})
v11:AddToggle("coolkidaimbot", {
    Text = "Enable c00lkidd Aimbot",
    Default = false,
    Tooltip = "Makes the game think ur on mobile",
    Callback = function(p21)
        game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer("SetDevice", p21 and "Mobile" or "PC")
    end,
})
v12:AddToggle("chanceaimbot", {
    Text = "Enable Chance Aimbot",
    Default = false,
    Tooltip = "Enables/Disables Chance Aimbot",
    Callback = function(p22)
        u53(p22)
    end,
})
v12:AddToggle("shedaimbot", {
    Text = "Enable Shedletsky Aimbot",
    Default = false,
    Tooltip = "Enables/Disables Shedletsky Aimbot",
    Callback = function(p23)
        u54(p23)
    end,
})
v12:AddToggle("guestaimbot", {
    Text = "Enable Guest1337 Aimbot",
    Default = false,
    Tooltip = "Enables/Disables Guest1337 Aimbot",
    Callback = function(p24)
        u55(p24)
    end,
})
v11:AddToggle("johnaimbot", {
    Text = "Enable John Doe Aimbot",
    Default = false,
    Tooltip = "Enables/Disables John Doe Spike Aimbot",
    Callback = function(p25)
        u57(p25)
    end,
})
v11:AddToggle("onexoneaimbot", {
    Text = "Enable 1x1x1x1 Aimbot",
    Default = false,
    Tooltip = "Enables/Disables 1x4 Aimbot",
    Callback = function(p26)
        u56(p26)
    end,
})
v10:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Callback = function(p27)
        print("Jump Power set to: ", p27)
        if u67.Value and game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = p27
        end
    end,
})
v10:AddToggle("AutoDo1x1x1x1Popups", {
    Text = "Auto do 1x1x1x1 popups",
    Default = false,
    Tooltip = "Automatically does 1x1x1x1 popups",
    Callback = function(p28)
        Do1x1PopupsLoop = p28 and task.spawn(u51)
    end,
})
v10:AddToggle("Autoblockguestt", {
    Text = "Auto Block Guest1337",
    Default = false,
    Tooltip = "MAKE SURE YOUR KEYBIND IS Q FOR BLOCKING",
    Callback = function(_)
        u29 = not u29
    end,
})
v9:AddToggle("HighlightGenerators", {
    Text = "Enable Generator ESP",
    Default = false,
    Tooltip = "Highlights all generators",
    Callback = function(p30)
        local function u157(p31)
            if p31.Name == "Generator" then
                local GeneratorHighlight = p31:FindFirstChild("GeneratorHighlight")
                local Progress = p31:FindFirstChild("Progress")
                if not p30 then
                    if GeneratorHighlight then
                        GeneratorHighlight:Destroy()
                    end
                    return
                end
                if not GeneratorHighlight then
                    local Highlight = Instance.new("Highlight")
                    Highlight.Parent = p31
                    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    Highlight.Name = "GeneratorHighlight"
                end
                if Progress then
                    if Progress.Value == 100 then
                        local GeneratorHighlight2 = p31:FindFirstChild("GeneratorHighlight")
                        if GeneratorHighlight2 then
                            GeneratorHighlight2:Destroy()
                        end
                        return
                    end
                    Progress:GetPropertyChangedSignal("Value"):Connect(function()
                        if Progress.Value == 100 then
                            local GeneratorHighlight3 = p31:FindFirstChild("GeneratorHighlight")
                            if GeneratorHighlight3 then
                                GeneratorHighlight3:Destroy()
                            end
                        elseif p30 and not p31:FindFirstChild("GeneratorHighlight") then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Parent = p31
                            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            Highlight.Name = "GeneratorHighlight"
                        end
                    end)
                end
            end
        end
        for _, child in pairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
            u157(child)
        end
        game.Workspace.Map.Ingame.Map.ChildAdded:Connect(function(child)
            u157(child)
        end)
    end,
})
v9:AddButton("Solve Generator", function()
    for _, child in pairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
        if child.name == "Generator" then
            child:WaitForChild("Remotes"):WaitForChild("RE"):FireServer()
        end
    end
end, "Solves the one puzzle.")
v9:AddButton("Insta-Solve Generator", function()
    for _, child in pairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
        if child.name == "Generator" then
            local n11 = 0
            repeat
                n11 += 1
                child:WaitForChild("Remotes"):WaitForChild("RE"):FireServer()
            until n11 == 4
        end
    end
end, "Instantly solves the generator.")
v9:AddButton("Insta-Solve All", function()
    local v165, v166, v167 = pairs(game.Workspace.Map.Ingame.Map.Generators:GetChildren())
    for _, v169 in v165, v166, v167 do
        local v170 = v169
        if v170:IsA("Model") then
            local n12 = 0
            repeat
                n12 += 1
                v170:WaitForChild("Remotes"):WaitForChild("RE"):FireServer()
            until n12 == 4
        end
    end
end, "Instantly solves all generators.")
local function u68()
    n4 = tick()
    VirtualInputManager:SendKeyEvent(true, Q, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Q, false, game)
end
RunService.Heartbeat:Connect(function()
    if not u29 then
        return
    end
    local Character = LocalPlayer.Character
    local v173 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v173 then
        local v174, v175, v176 = pairs(Players:GetPlayers())
        for _, v178 in v174, v175, v176 do
            local v179 = v178
            if v179 ~= LocalPlayer then
                if not v179.Character or not v179.Character:FindFirstChild("Humanoid") then
                    continue
                end
                local Humanoid = v179.Character.Humanoid
                local HumanoidRootPart = v179.Character:FindFirstChild("HumanoidRootPart")
                if not (Humanoid.Health > n1) then
                    continue
                end
                if not HumanoidRootPart or not ((HumanoidRootPart.Position - v173.Position).Magnitude <= n2) or not u30 and not (tick() - n4 >= n3) then
                    continue
                end
                u68()
                return
            end
        end
        return
    end
end)
u1:Toggle(true)
