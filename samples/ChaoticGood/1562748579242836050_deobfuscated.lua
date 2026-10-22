local v8 = game:GetService("Players")
local v9 = v8.LocalPlayer
local v10 = v9:WaitForChild("PlayerGui")
local v11 = game:GetService("ReplicatedStorage")
local v12 = v11:FindFirstChild("RE")
if not v12 then
    warn("⚠️ RE non trouvé")
end
local v13
pcall(function()
    v13 = require(v11.Packages.Remotes)
end)
if not v13 then
    v13 = { ["fireServerComponent"] = function() end }
end
local v14 = Instance.new("ScreenGui")
v14.Name = "Brookhaven_Free"
v14.ResetOnSpawn = false
v14.IgnoreGuiInset = true
v14.Parent = v10
local v19 = Instance.new("Frame")
v19.Name = "MainFrame"
v19.Size = UDim2.new(0 - 0, 2298 - 1598, 360 - (151 + 209), 339 + 91)
v19.Position = UDim2.new(1480.5 - (641 + 839), -(1263 - (910 + 3)), 0.5, -(548 - 333))
v19.BackgroundColor3 = Color3.fromRGB(1702 - (1466 + 218), 18, 22)
v19.BorderSizePixel = 0 + 0
v19.Parent = v14
Instance.new("UICorner", v19).CornerRadius = UDim.new(0, 1160 - (556 + 592))
local v27 = Instance.new("UIStroke", v19)
v27.Thickness = 1.5 + 0
v27.Color = Color3.fromRGB(80, 888 - (329 + 479), 110)
local v30 = game:GetService("UserInputService")
local v31, v32, v33
local function v34(v276)
    if not v32 then
        return
    end
    local v277 = v276.Position - v32
    v19.Position = UDim2.new(v33.X.Scale, v33.X.Offset + v277.X, v33.Y.Scale, v33.Y.Offset + v277.Y)
end
v19.InputBegan:Connect(function(v279)
    if (v279.UserInputType == Enum.UserInputType.MouseButton1) or (v279.UserInputType == Enum.UserInputType.Touch) then
        local v355 = 854 - (174 + 680)
        while true do
            if v355 == 0 then
                v31 = true
                v32 = v279.Position
                v355 = 3 - 2
            end
            if v355 == 1 then
                v33 = v19.Position
                break
            end
        end
    end
end)
v19.InputEnded:Connect(function(v280)
    if (v280.UserInputType == Enum.UserInputType.MouseButton1) or (v280.UserInputType == Enum.UserInputType.Touch) then
        v31 = false
        v32 = nil
    end
end)
v19.InputChanged:Connect(function(v281)
    if
        v31
        and (
            (v281.UserInputType == Enum.UserInputType.MouseMovement) or (v281.UserInputType == Enum.UserInputType.Touch)
        )
    then
        v34(v281)
    end
end)
v30.InputChanged:Connect(function(v282)
    if
        v31
        and (
            (v282.UserInputType == Enum.UserInputType.MouseMovement) or (v282.UserInputType == Enum.UserInputType.Touch)
        )
    then
        v34(v282)
    end
end)
local v35 = Instance.new("Frame")
v35.Name = "Sidebar"
v35.Size = UDim2.new(0 - 0, 122 + 48, 1, 739 - (396 + 343))
v35.BackgroundColor3 = Color3.fromRGB(2 + 12, 1491 - (29 + 1448), 1407 - (135 + 1254))
v35.Parent = v19
Instance.new("UICorner", v35).CornerRadius = UDim.new(0, 44 - 32)
local v41 = Instance.new("UIStroke", v35)
v41.Thickness = 4 - 3
v41.Color = Color3.fromRGB(40 + 20, 60, 1617 - (389 + 1138))
local v44 = Instance.new("TextLabel")
v44.Text = "💎 VIP PROPS\nULTIMATE"
v44.Font = Enum.Font.GothamBold
v44.TextSize = 592 - (102 + 472)
v44.TextColor3 = Color3.fromRGB(241 + 14, 142 + 113, 238 + 17)
v44.BackgroundTransparency = 1
v44.Position = UDim2.new(1545 - (320 + 1225), 17 - 7, 0 + 0, 1474 - (157 + 1307))
v44.Size = UDim2.new(1860 - (821 + 1038), -20, 0, 124 - 74)
v44.TextXAlignment = Enum.TextXAlignment.Left
v44.Parent = v35
local function v56(v283, v284)
    local v285 = 0 + 0
    local v286
    while true do
        local v342 = 0
        while true do
            if (0 - 0) == v342 then
                if 2 == v285 then
                    v286.TextColor3 = Color3.fromRGB(82 + 138, 220, 570 - 340)
                    v286.Font = Enum.Font.GothamBold
                    v286.TextSize = 14
                    v285 = 3
                end
                if v285 == (1027 - (834 + 192)) then
                    v286.Size = UDim2.new(1 + 0, -20, 0, 9 + 23)
                    v286.Position = UDim2.new(0 + 0, 15 - 5, 304 - (300 + 4), v284)
                    v286.BackgroundColor3 = Color3.fromRGB(24, 7 + 17, 30)
                    v285 = 5 - 3
                end
                v342 = 1
            end
            if 2 == v342 then
                if v285 == (366 - (112 + 250)) then
                    return v286
                end
                break
            end
            if v342 == (1 + 0) then
                if v285 == 3 then
                    local v406 = 0 - 0
                    while true do
                        if (1 + 0) == v406 then
                            Instance.new("UIStroke", v286).Thickness = 1 + 0
                            v285 = 3 + 1
                            break
                        end
                        if v406 == (0 + 0) then
                            v286.Parent = v35
                            Instance.new("UICorner", v286).CornerRadius = UDim.new(0, 6 + 2)
                            v406 = 1415 - (1001 + 413)
                        end
                    end
                end
                if v285 == (0 - 0) then
                    v286 = Instance.new("TextButton")
                    v286.Text = v283
                    v286.Name = v283 .. "Tab"
                    v285 = 1
                end
                v342 = 884 - (244 + 638)
            end
        end
    end
end
local v57 = v56("Menu", 763 - (627 + 66))
local v58 = v56("VIP Props", 110)
local v59 = v56("Give Tools", 446 - 296)
local v60 = v56("Theme", 792 - (512 + 90))
local v61 = v56("Information", 2136 - (1665 + 241))
local v62 = Instance.new("TextButton")
v62.Text = "✖"
v62.Font = Enum.Font.GothamBold
v62.TextSize = 735 - (373 + 344)
v62.TextColor3 = Color3.fromRGB(116 + 139, 22 + 58, 80)
v62.BackgroundTransparency = 2 - 1
v62.Size = UDim2.new(0, 67 - 27, 1099 - (35 + 1064), 30)
v62.Position = UDim2.new(0 + 0, 120, 2 - 1, -(1 + 39))
v62.Parent = v35
v62.MouseButton1Click:Connect(function()
    v14.Enabled = false
end)
local v71 = Instance.new("Frame")
v71.Name = "Content"
v71.Size = UDim2.new(1, -180, 1237 - (298 + 938), -(1279 - (233 + 1026)))
v71.Position = UDim2.new(0, 1846 - (636 + 1030), 0 + 0, 10 + 0)
v71.BackgroundColor3 = Color3.fromRGB(7 + 15, 2 + 20, 249 - (55 + 166))
v71.Parent = v19
Instance.new("UICorner", v71).CornerRadius = UDim.new(0 + 0, 2 + 10)
local v78 = Instance.new("UIStroke", v71)
v78.Thickness = 1
v78.Color = Color3.fromRGB(267 - 197, 367 - (36 + 261), 174 - 74)
local function v81(v288)
    local v289 = 1368 - (34 + 1334)
    local v290
    while true do
        local v343 = 0 + 0
        while true do
            if v343 == (1 + 0) then
                if 0 == v289 then
                    v290 = Instance.new("Frame")
                    v290.Name = v288 .. "Page"
                    v289 = 1
                end
                if 1 == v289 then
                    v290.Size = UDim2.new(1284 - (1035 + 248), -(41 - (20 + 1)), 1 + 0, -20)
                    v290.Position = UDim2.new(0, 10, 319 - (134 + 185), 10)
                    v289 = 1135 - (549 + 584)
                end
                break
            end
            if v343 == 0 then
                if v289 == (688 - (314 + 371)) then
                    local v412 = 0
                    while true do
                        if v412 == (0 - 0) then
                            v290.Parent = v71
                            return v290
                        end
                    end
                end
                if v289 == 2 then
                    v290.BackgroundTransparency = 969 - (478 + 490)
                    v290.Visible = false
                    v289 = 2 + 1
                end
                v343 = 1173 - (786 + 386)
            end
        end
    end
end
local v82 = v81("Menu")
local v83 = v81("Props")
local v84 = v81("Give")
local v85 = v81("Theme")
local v86 = v81("Info")
local function v87(v291)
    for v344, v345 in ipairs(v71:GetChildren()) do
        if v345:IsA("Frame") then
            v345.Visible = v345.Name == (v291 .. "Page")
        end
    end
end
v57.MouseButton1Click:Connect(function()
    v87("Menu")
end)
v58.MouseButton1Click:Connect(function()
    v87("Props")
end)
v59.MouseButton1Click:Connect(function()
    v87("Give")
end)
v60.MouseButton1Click:Connect(function()
    v87("Theme")
end)
v61.MouseButton1Click:Connect(function()
    v87("Info")
end)
v87("Menu")
local function v88(v292, v293, v294)
    v294 = v294 or 260
    local v295 = Instance.new("TextButton")
    v295.Text = v293
    v295.Size = UDim2.new(0 - 0, v294, 1379 - (1055 + 324), 1374 - (1093 + 247))
    v295.BackgroundColor3 = Color3.fromRGB(30, 30, 34 + 4)
    v295.TextColor3 = Color3.fromRGB(25 + 205, 230, 952 - 712)
    v295.Font = Enum.Font.GothamBold
    v295.TextSize = 47 - 33
    v295.Parent = v292
    Instance.new("UICorner", v295).CornerRadius = UDim.new(0, 22 - 14)
    Instance.new("UIStroke", v295).Thickness = 2 - 1
    return v295
end
local v89 = {
    "VIPGunRack",
    "AnimalFishBigVIP",
    "BenchSwing",
    "BoyPlayTable",
    "CarEngineBlower",
    "CarFullColorVIP",
    "CarRaceScoopeVIP",
    "CarTruckLightsOrange",
    "CarTruckTurbo3",
    "CarWingHalfColorVIP",
    "DunkTank",
    "FlashingLightArch",
    "GirlPlayTable",
    "GoldenToilet",
    "GraffitiAgency",
    "MilitaryCarMiniGunVIP",
    "MilitaryMiniGunVIP",
    "PropAkhal-Teke",
    "PropClydesdale",
    "PropDonkey",
    "PropFriesian",
    "PropMiniHorse",
    "PropShire",
    "ToolsFart",
    "UnicornPlush",
    "BearPlush",
    "CarnivalBooth",
    "CarnivalSign1",
    "CarnivalSign2",
    "CarnivalSign5",
    "CarnivalTent",
    "PopcornMachine",
    "Summer2026BobcatProp",
    "Summer2026PhotoBooth",
    "Summer2026SlipAndSlide",
    "Summer2026Trampoline",
}
local v90 = {
    "MoneyGun",
    "Skis",
    "Snowboard",
    "YummyBread",
    "Animals",
    "Apple",
    "AppleGreen",
    "Assault",
    "Axe",
    "BabyBottle",
    "Balloon",
    "Baseball",
    "Basketball",
    "Boombox",
    "BurgerTray",
    "CakePink",
    "Coke",
    "CookieChip",
    "Donkey",
    "Glock",
    "Hamburger",
    "Katana",
    "Laptop",
    "Pizza",
    "Shotgun",
    "SwordWood",
    "Taser",
    "Vacuum",
    "Summer2026Cannon",
    "Summer2026Glider",
    "Summer2026GoldenBasketball",
    "Summer2026WaterBalloonLauncher",
    "GoldenBasketball",
    "Glider",
    "EggLauncher",
    "Cannon",
    "UraniumRod",
}
function SpawnProp(v306)
    local v307 = 1453 - (28 + 1425)
    local v308
    local v309
    local v310
    local v311
    local v312
    local v313
    local v314
    while true do
        if 1 == v307 then
            if not v309 then
                v309 = v308:FindFirstChild("PropMaker")
            end
            if not v309 then
                local v386 = 1993 - (941 + 1052)
                while true do
                    if (0 + 0) == v386 then
                        warn("❌ PropMaker non trouvé! Va dans l'onglet Menu et clique sur 'Equip PropMaker'")
                        return
                    end
                end
            end
            if v12 and v12:FindFirstChild("1Clea1rTool1s") then
                v12["1Clea1rTool1s"]:FireServer("RequestingPropName", v306, "Car", "Gamepass")
            end
            v310 = workspace:FindFirstChild("Model")
            v307 = 1516 - (822 + 692)
        end
        if v307 == (0 - 0) then
            print("🚗 Spawn: " .. v306)
            v308 = v9.Character
            if not v308 then
                local v387 = 0 + 0
                local v388
                while true do
                    if v387 == (297 - (45 + 252)) then
                        v388 = 0
                        while true do
                            if v388 == 0 then
                                warn("❌ Personnage introuvable")
                                return
                            end
                        end
                        break
                    end
                end
            end
            v309 = v9.Backpack:FindFirstChild("PropMaker")
            v307 = 1 + 0
        end
        if v307 == (2 + 1) then
            v312 = math.random() * 2 * math.pi
            v313 = (12 - 7) + (math.random() * 3)
            v314 = v311.CFrame * CFrame.new(math.cos(v312) * v313, 433 - (114 + 319), math.sin(v312) * v313)
            if v13 and v13.fireServerComponent then
                pcall(function()
                    local v415 = 0
                    while true do
                        if v415 == 0 then
                            v13.fireServerComponent(v309, "Tool_PropMake", v310, v314)
                            print("✅ Prop spawné: " .. v306)
                            break
                        end
                    end
                end)
            end
            break
        end
        if v307 == (2 - 0) then
            if v310 then
                v310 = v310:FindFirstChild("Baseplate")
            end
            if not v310 then
                v310 = workspace.Terrain
            end
            v311 = v308:FindFirstChild("HumanoidRootPart")
            if not v311 then
                return
            end
            v307 = 3 - 0
        end
    end
end
function GiveToolToPlayer(v315, v316)
    local v317 = 0
    while true do
        if v317 == (0 + 0) then
            if not v12 or not v12:FindFirstChild("1Playe1rTrigge1rEven1t") then
                local v390 = 0 - 0
                while true do
                    if v390 == (0 - 0) then
                        local v442 = 1963 - (556 + 1407)
                        while true do
                            if 0 == v442 then
                                warn("❌ Remote non trouvé")
                                return
                            end
                        end
                    end
                end
            end
            if v315 and v316 then
                v12["1Playe1rTrigge1rEven1t"]:FireServer("ToolGiveToServer", v315, v316)
                print("✅ Donné " .. v316 .. " à " .. v315.Name)
            end
            break
        end
    end
end
local v91 = v88(v82, "🔫 Equip PropMaker")
v91.Position = UDim2.new(1206.5 - (741 + 465), -130, 0.25, 0)
v91.MouseButton1Click:Connect(function()
    local v318 = 0
    local v319
    local v320
    local v321
    while true do
        if (465 - (170 + 295)) == v318 then
            v319 = 0
            v320 = nil
            v318 = 1
        end
        if v318 == (1 + 0) then
            v321 = nil
            while true do
                if v319 == (1 + 0) then
                    v321 = v9.Backpack:FindFirstChild("PropMaker")
                    if v321 then
                        local v443 = 0
                        while true do
                            if v443 == (0 - 0) then
                                v321.Parent = v320
                                print("✅ PropMaker équipé!")
                                break
                            end
                        end
                    elseif v12 and v12:FindFirstChild("1Too1l") then
                        pcall(function()
                            local v453 = 0 + 0
                            local v454
                            while true do
                                if (1 + 0) == v453 then
                                    v454 = v9.Backpack:FindFirstChild("PropMaker")
                                    if v454 then
                                        local v463 = 0 + 0
                                        local v464
                                        while true do
                                            if v463 == 0 then
                                                v464 = 1230 - (957 + 273)
                                                while true do
                                                    if v464 == (0 + 0) then
                                                        v454.Parent = v320
                                                        print("✅ PropMaker équipé via remote!")
                                                        break
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                    break
                                end
                                if v453 == 0 then
                                    v12["1Too1l"]:InvokeServer("PickingTools", "PropMaker")
                                    task.wait(0.3)
                                    v453 = 1 + 0
                                end
                            end
                        end)
                    end
                    break
                end
                if v319 == (0 - 0) then
                    v320 = v9.Character
                    if not v320 then
                        return
                    end
                    v319 = 2 - 1
                end
            end
            break
        end
    end
end)
local v93 = v88(v82, "🧹 Clear All Props")
v93.Position = UDim2.new(0.5 - 0, -130, 0.5 - 0, 1780 - (389 + 1391))
v93.MouseButton1Click:Connect(function()
    if v12 and v12:FindFirstChild("1Clea1rTool1s") then
        local v356 = 0 + 0
        while true do
            if v356 == (0 + 0) then
                v12["1Clea1rTool1s"]:FireServer("ClearAllProps")
                print("🧹 Props nettoyés")
                break
            end
        end
    end
end)
local v95 = Instance.new("TextLabel")
v95.Text = "⚠️ Clique sur 'Equip PropMaker'\nLes props spawnent autour de toi !"
v95.Font = Enum.Font.Gotham
v95.TextSize = 14
v95.TextColor3 = Color3.fromRGB(255, 455 - 255, 100)
v95.BackgroundTransparency = 952 - (783 + 168)
v95.Size = UDim2.new(0, 1006 - 706, 0, 40)
v95.Position = UDim2.new(0.5, -(148 + 2), 0.7, 0)
v95.TextXAlignment = Enum.TextXAlignment.Center
v95.TextWrapped = true
v95.Parent = v82
local v108 = Instance.new("ScrollingFrame")
v108.Size = UDim2.new(312 - (309 + 2), -20, 1, -(61 - 41))
v108.Position = UDim2.new(1212 - (1090 + 122), 4 + 6, 0, 33 - 23)
v108.CanvasSize = UDim2.new(0, 0, 0, 0 + 0)
v108.ScrollBarThickness = 1124 - (628 + 490)
v108.BackgroundTransparency = 1 + 0
v108.Parent = v83
local v115 = Instance.new("UIListLayout", v108)
v115.Padding = UDim.new(0 - 0, 27 - 21)
for v322, v323 in ipairs(v89) do
    local v324 = v88(v108, "🚗 " .. v323)
    v324.MouseButton1Click:Connect(function()
        SpawnProp(v323)
    end)
end
v108.CanvasSize = UDim2.new(774 - (431 + 343), 0 - 0, 0 - 0, #v89 * (32 + 8))
local v117 = Instance.new("Frame")
v117.Size = UDim2.new(1, -(3 + 17), 1, -20)
v117.Position = UDim2.new(1695 - (556 + 1139), 25 - (6 + 9), 0 + 0, 6 + 4)
v117.BackgroundTransparency = 1
v117.Parent = v84
local v122 = Instance.new("TextLabel")
v122.Text = "🎁 Give Tools to Players"
v122.Font = Enum.Font.GothamBold
v122.TextSize = 189 - (28 + 141)
v122.TextColor3 = Color3.fromRGB(99 + 156, 314 - 59, 255)
v122.BackgroundTransparency = 1 + 0
v122.Size = UDim2.new(1318 - (486 + 831), -(26 - 16), 0 - 0, 6 + 24)
v122.Parent = v117
local v130 = nil
local v131 = "MoneyGun"
local v132 = 230
local v133 = 63 - 43
local v134 = 1278 - (668 + 595)
local v135 = v88(v117, "👤 Select Player", v132)
v135.Position = UDim2.new(0, v134, 0.15 + 0, 0 + 0)
local v137 = Instance.new("Frame")
v137.Size = UDim2.new(0 - 0, v132, 290 - (23 + 267), 0)
v137.Position = UDim2.new(1944 - (1129 + 815), v134, 387.15 - (371 + 16), 1788 - (1326 + 424))
v137.BackgroundTransparency = 1 - 0
v137.ClipsDescendants = true
v137.Parent = v117
local v143 = Instance.new("Frame")
v143.Size = UDim2.new(1, 0, 0 - 0, 180)
v143.Position = UDim2.new(118 - (88 + 30), 771 - (720 + 51), 0, 0 - 0)
v143.BackgroundColor3 = Color3.fromRGB(1800 - (421 + 1355), 39 - 15, 15 + 15)
v143.Parent = v137
Instance.new("UICorner", v143).CornerRadius = UDim.new(1083 - (286 + 797), 29 - 21)
Instance.new("UIStroke", v143).Thickness = 1 - 0
local v150 = Instance.new("ScrollingFrame")
v150.Size = UDim2.new(440 - (397 + 42), -(4 + 6), 1, -(810 - (24 + 776)))
v150.Position = UDim2.new(0 - 0, 790 - (222 + 563), 0 - 0, 4 + 1)
v150.BackgroundTransparency = 191 - (23 + 167)
v150.ScrollBarThickness = 1804 - (690 + 1108)
v150.CanvasSize = UDim2.new(0, 0 + 0, 0, 0 + 0)
v150.Parent = v143
Instance.new("UIListLayout", v150).Padding = UDim.new(848 - (40 + 808), 1 + 3)
local v158 = false
v135.MouseButton1Click:Connect(function()
    local v325 = 0 - 0
    while true do
        if v325 == 0 then
            v158 = not v158
            if v158 then
                local v391 = 0 + 0
                while true do
                    if v391 == (0 + 0) then
                        v137.Size = UDim2.new(0, v132, 0 + 0, 751 - (47 + 524))
                        UpdatePlayerDropdown()
                        break
                    end
                end
            else
                v137.Size = UDim2.new(0 + 0, v132, 0 - 0, 0 - 0)
            end
            break
        end
    end
end)
local v159 = v88(v117, "🔧 Select Item", v132)
v159.Position = UDim2.new(0, v134 + v132 + v133, 0.15, 0 - 0)
local v161 = Instance.new("Frame")
v161.Size = UDim2.new(0, v132, 0, 0)
v161.Position = UDim2.new(1726 - (1165 + 561), v134 + v132 + v133, 0.15 + 0, 38)
v161.BackgroundTransparency = 1
v161.ClipsDescendants = true
v161.Parent = v117
local v167 = Instance.new("Frame")
v167.Size = UDim2.new(3 - 2, 0 + 0, 0, 180)
v167.Position = UDim2.new(479 - (341 + 138), 0, 0, 0 + 0)
v167.BackgroundColor3 = Color3.fromRGB(48 - 24, 350 - (89 + 237), 96 - 66)
v167.Parent = v161
Instance.new("UICorner", v167).CornerRadius = UDim.new(0 - 0, 889 - (581 + 300))
Instance.new("UIStroke", v167).Thickness = 1
local v174 = Instance.new("ScrollingFrame")
v174.Size = UDim2.new(1221 - (855 + 365), -(23 - 13), 1, -10)
v174.Position = UDim2.new(0 + 0, 1240 - (1030 + 205), 0 + 0, 5 + 0)
v174.BackgroundTransparency = 1
v174.ScrollBarThickness = 292 - (156 + 130)
v174.CanvasSize = UDim2.new(0 - 0, 0 - 0, 0 - 0, 0 + 0)
v174.Parent = v167
Instance.new("UIListLayout", v174).Padding = UDim.new(0, 3 + 1)
local v182 = false
v159.MouseButton1Click:Connect(function()
    local v326 = 0
    while true do
        if v326 == 0 then
            v182 = not v182
            if v182 then
                local v393 = 69 - (10 + 59)
                while true do
                    if (0 + 0) == v393 then
                        v161.Size = UDim2.new(0 - 0, v132, 1163 - (671 + 492), 180)
                        UpdateItemDropdown()
                        break
                    end
                end
            else
                v161.Size = UDim2.new(0 + 0, v132, 1215 - (369 + 846), 0 + 0)
            end
            break
        end
    end
end)
function UpdatePlayerDropdown()
    for v346, v347 in ipairs(v150:GetChildren()) do
        if v347:IsA("TextButton") then
            v347:Destroy()
        end
    end
    local v327 = 0 + 0
    for v348, v349 in ipairs(v8:GetPlayers()) do
        local v350 = 1945 - (1036 + 909)
        local v351
        while true do
            if v350 == (3 + 0) then
                v351.Parent = v150
                Instance.new("UICorner", v351).CornerRadius = UDim.new(0 - 0, 6)
                v351.MouseButton1Click:Connect(function()
                    local v395 = 203 - (11 + 192)
                    local v396
                    while true do
                        if v395 == 0 then
                            v396 = 0 + 0
                            while true do
                                if v396 == (176 - (135 + 40)) then
                                    v158 = false
                                    v137.Size = UDim2.new(0, v132, 0 - 0, 0)
                                    v396 = 2
                                end
                                if v396 == (0 + 0) then
                                    v130 = v349
                                    v135.Text = "👤 " .. v349.Name .. (((v349 == v9) and " (Vous)") or "")
                                    v396 = 2 - 1
                                end
                                if v396 == (2 - 0) then
                                    UpdatePlayerDropdown()
                                    break
                                end
                            end
                            break
                        end
                    end
                end)
                v350 = 180 - (50 + 126)
            end
            if v350 == (0 - 0) then
                local v364 = 0
                while true do
                    if v364 == (1 + 0) then
                        v351.Size = UDim2.new(1414 - (1233 + 180), -(979 - (522 + 447)), 1421 - (107 + 1314), 13 + 15)
                        v350 = 2 - 1
                        break
                    end
                    if v364 == (0 + 0) then
                        v351 = Instance.new("TextButton")
                        v351.Text = v349.Name .. (((v349 == v9) and " (Vous)") or "")
                        v364 = 1 - 0
                    end
                end
            end
            if v350 == (15 - 11) then
                v327 = v327 + (1911 - (716 + 1194))
                break
            end
            if v350 == (1 + 0) then
                local v365 = 0
                while true do
                    if v365 == 1 then
                        v351.Font = Enum.Font.Gotham
                        v350 = 1 + 1
                        break
                    end
                    if v365 == (503 - (74 + 429)) then
                        v351.BackgroundColor3 = ((v130 == v349) and Color3.fromRGB(40, 77 - 37, 80))
                            or Color3.fromRGB(30, 30, 19 + 19)
                        v351.TextColor3 = ((v130 == v349) and Color3.fromRGB(583 - 328, 181 + 74, 255))
                            or Color3.fromRGB(616 - 416, 494 - 294, 643 - (279 + 154))
                        v365 = 1
                    end
                end
            end
            if v350 == (780 - (454 + 324)) then
                local v366 = 0 + 0
                while true do
                    if v366 == (18 - (12 + 5)) then
                        v351.AutoButtonColor = true
                        v350 = 3
                        break
                    end
                    if v366 == (0 + 0) then
                        v351.TextSize = 32 - 19
                        v351.TextXAlignment = Enum.TextXAlignment.Left
                        v366 = 1 + 0
                    end
                end
            end
        end
    end
    v150.CanvasSize = UDim2.new(1093 - (277 + 816), 0 - 0, 1183 - (1058 + 125), (v327 * (6 + 26)) + (985 - (815 + 160)))
end
function UpdateItemDropdown()
    local v329 = 0
    local v330
    while true do
        if v329 == 0 then
            for v367, v368 in ipairs(v174:GetChildren()) do
                if v368:IsA("TextButton") then
                    v368:Destroy()
                end
            end
            v330 = 0 - 0
            v329 = 1
        end
        if v329 == (2 - 1) then
            for v369, v370 in ipairs(v90) do
                local v371 = Instance.new("TextButton")
                v371.Text = v370
                v371.Size = UDim2.new(1 + 0, -10, 0, 81 - 53)
                v371.BackgroundColor3 = (
                    (v131 == v370) and Color3.fromRGB(1938 - (41 + 1857), 1933 - (1222 + 671), 206 - 126)
                ) or Color3.fromRGB(43 - 13, 1212 - (229 + 953), 1812 - (1111 + 663))
                v371.TextColor3 = ((v131 == v370) and Color3.fromRGB(255, 255, 1834 - (874 + 705)))
                    or Color3.fromRGB(28 + 172, 137 + 63, 210)
                v371.Font = Enum.Font.Gotham
                v371.TextSize = 26 - 13
                v371.TextXAlignment = Enum.TextXAlignment.Left
                v371.AutoButtonColor = true
                v371.Parent = v174
                Instance.new("UICorner", v371).CornerRadius = UDim.new(0, 6)
                v371.MouseButton1Click:Connect(function()
                    v131 = v370
                    v159.Text = "🔧 " .. v370
                    v182 = false
                    v161.Size = UDim2.new(0, v132, 0 + 0, 679 - (642 + 37))
                    UpdateItemDropdown()
                end)
                v330 = v330 + 1
            end
            v174.CanvasSize = UDim2.new(0 + 0, 0, 0 + 0, (v330 * 32) + 10)
            break
        end
    end
end
local v183 = v88(v117, "📤 Give to Selected Player", v132)
v183.Position = UDim2.new(0, v134, 0.7 - 0, 0)
v183.MouseButton1Click:Connect(function()
    if v130 then
        GiveToolToPlayer(v130, v131)
    end
end)
local v185 = v88(v117, "📤 Give to ALL Players", v132)
v185.Position = UDim2.new(454 - (233 + 221), v134 + v132 + v133, 0.7, 0 - 0)
v185.MouseButton1Click:Connect(function()
    for v352, v353 in ipairs(v8:GetPlayers()) do
        local v354 = 0 + 0
        while true do
            if v354 == (1541 - (718 + 823)) then
                GiveToolToPlayer(v353, v131)
                task.wait(0.05 + 0)
                break
            end
        end
    end
end)
v8.PlayerAdded:Connect(function()
    if v158 then
        UpdatePlayerDropdown()
    end
end)
v8.PlayerRemoving:Connect(function()
    if v158 then
        UpdatePlayerDropdown()
    end
end)
task.wait(805.5 - (266 + 539))
UpdatePlayerDropdown()
UpdateItemDropdown()
local v187 = Instance.new("ScrollingFrame")
v187.Size = UDim2.new(1, -(56 - 36), 1, -20)
v187.Position = UDim2.new(0, 1235 - (636 + 589), 0, 23 - 13)
v187.CanvasSize = UDim2.new(0 - 0, 0, 0 + 0, 0 + 0)
v187.ScrollBarThickness = 1021 - (657 + 358)
v187.BackgroundTransparency = 2 - 1
v187.Parent = v85
local v194 = Instance.new("UIListLayout", v187)
v194.Padding = UDim.new(0 - 0, 1199 - (1151 + 36))
local v196 = {
    {
        ["Name"] = "Dark",
        ["Main"] = Color3.fromRGB(18 + 0, 18, 6 + 16),
        ["Sidebar"] = Color3.fromRGB(41 - 27, 1846 - (1552 + 280), 852 - (64 + 770)),
        ["Content"] = Color3.fromRGB(22, 15 + 7, 63 - 35),
        ["Stroke"] = Color3.fromRGB(15 + 65, 80, 110),
        ["Button"] = Color3.fromRGB(1273 - (157 + 1086), 60 - 30, 166 - 128),
        ["Text"] = Color3.fromRGB(352 - 122, 230, 327 - 87),
    },
    {
        ["Name"] = "Red Modern",
        ["Main"] = Color3.fromRGB(238 - 118, 1931 - (1813 + 118), 0),
        ["Sidebar"] = Color3.fromRGB(90, 0, 0 + 0),
        ["Content"] = Color3.fromRGB(1357 - (841 + 376), 0 - 0, 0 + 0),
        ["Stroke"] = Color3.fromRGB(696 - 441, 939 - (464 + 395), 205 - 125),
        ["Button"] = Color3.fromRGB(77 + 83, 857 - (467 + 370), 41 - 21),
        ["Text"] = Color3.fromRGB(188 + 67, 230, 788 - 558),
    },
    {
        ["Name"] = "Blue Neon",
        ["Main"] = Color3.fromRGB(0, 93 - 53, 640 - (150 + 370)),
        ["Sidebar"] = Color3.fromRGB(1282 - (74 + 1208), 30, 90),
        ["Content"] = Color3.fromRGB(0, 147 - 87, 711 - 561),
        ["Stroke"] = Color3.fromRGB(0, 86 + 34, 645 - (14 + 376)),
        ["Button"] = Color3.fromRGB(0 - 0, 52 + 28, 200),
        ["Text"] = Color3.fromRGB(194 + 26, 229 + 11, 747 - 492),
    },
    {
        ["Name"] = "Aqua",
        ["Main"] = Color3.fromRGB(0, 198 - (23 + 55), 331 - 191),
        ["Sidebar"] = Color3.fromRGB(0, 67 + 33, 108 + 12),
        ["Content"] = Color3.fromRGB(0 - 0, 140, 51 + 109),
        ["Stroke"] = Color3.fromRGB(901 - (652 + 249), 535 - 335, 220),
        ["Button"] = Color3.fromRGB(0, 160, 2048 - (708 + 1160)),
        ["Text"] = Color3.fromRGB(624 - 394, 255, 255),
    },
    {
        ["Name"] = "Gold Premium",
        ["Main"] = Color3.fromRGB(60, 72 - 32, 0),
        ["Sidebar"] = Color3.fromRGB(77 - (10 + 17), 7 + 23, 1732 - (1400 + 332)),
        ["Content"] = Color3.fromRGB(80, 95 - 45, 1908 - (242 + 1666)),
        ["Stroke"] = Color3.fromRGB(110 + 145, 74 + 126, 0 + 0),
        ["Button"] = Color3.fromRGB(1060 - (850 + 90), 80, 0),
        ["Text"] = Color3.fromRGB(446 - 191, 1630 - (360 + 1030), 177 + 23),
    },
    {
        ["Name"] = "Cyber Purple",
        ["Main"] = Color3.fromRGB(41 - 11, 1661 - (909 + 752), 1283 - (109 + 1114)),
        ["Sidebar"] = Color3.fromRGB(20, 0 - 0, 50),
        ["Content"] = Color3.fromRGB(40, 0, 32 + 48),
        ["Stroke"] = Color3.fromRGB(422 - (6 + 236), 0 + 0, 255),
        ["Button"] = Color3.fromRGB(49 + 11, 0, 283 - 163),
        ["Text"] = Color3.fromRGB(230, 349 - 149, 1388 - (1076 + 57)),
    },
    {
        ["Name"] = "Pink Love",
        ["Main"] = Color3.fromRGB(809 - (579 + 110), 2 + 18, 54 + 6),
        ["Sidebar"] = Color3.fromRGB(100, 6 + 4, 457 - (174 + 233)),
        ["Content"] = Color3.fromRGB(391 - 251, 52 - 22, 36 + 44),
        ["Stroke"] = Color3.fromRGB(1429 - (663 + 511), 100, 179 + 21),
        ["Button"] = Color3.fromRGB(35 + 125, 123 - 83, 100),
        ["Text"] = Color3.fromRGB(155 + 100, 517 - 297, 240),
    },
    {
        ["Name"] = "Green Matrix",
        ["Main"] = Color3.fromRGB(0 - 0, 15 + 15, 0),
        ["Sidebar"] = Color3.fromRGB(0 - 0, 20, 0 + 0),
        ["Content"] = Color3.fromRGB(0 + 0, 772 - (478 + 244), 0),
        ["Stroke"] = Color3.fromRGB(517 - (440 + 77), 116 + 139, 0),
        ["Button"] = Color3.fromRGB(0 - 0, 1636 - (655 + 901), 0 + 0),
        ["Text"] = Color3.fromRGB(115 + 35, 255, 102 + 48),
    },
    {
        ["Name"] = "Orange Fire",
        ["Main"] = Color3.fromRGB(322 - 242, 1475 - (695 + 750), 0 - 0),
        ["Sidebar"] = Color3.fromRGB(60, 30 - 10, 0),
        ["Content"] = Color3.fromRGB(402 - 302, 40, 351 - (285 + 66)),
        ["Stroke"] = Color3.fromRGB(255, 349 - 199, 0),
        ["Button"] = Color3.fromRGB(1430 - (682 + 628), 50, 0),
        ["Text"] = Color3.fromRGB(255, 220, 30 + 150),
    },
}
local function v197(v331)
    local v332 = 0
    local v333
    while true do
        if (299 - (176 + 123)) == v332 then
            v333 = 0
            while true do
                if v333 == (0 + 0) then
                    v19.BackgroundColor3 = v331.Main
                    v35.BackgroundColor3 = v331.Sidebar
                    v333 = 1 + 0
                end
                if 3 == v333 then
                    for v440, v441 in ipairs(v19:GetDescendants()) do
                        if v441:IsA("TextButton") then
                            local v450 = 269 - (239 + 30)
                            local v451
                            while true do
                                if (0 + 0) == v450 then
                                    v441.BackgroundColor3 = v331.Button
                                    v441.TextColor3 = v331.Text
                                    v450 = 1
                                end
                                if v450 == 1 then
                                    v451 = v441:FindFirstChild("UIStroke")
                                    if v451 then
                                        v451.Color = v331.Stroke
                                    end
                                    break
                                end
                            end
                        end
                    end
                    break
                end
                if v333 == 1 then
                    v71.BackgroundColor3 = v331.Content
                    v27.Color = v331.Stroke
                    v333 = 2 + 0
                end
                if v333 == (3 - 1) then
                    v41.Color = v331.Stroke
                    v78.Color = v331.Stroke
                    v333 = 3
                end
            end
            break
        end
    end
end
for v334, v335 in ipairs(v196) do
    local v336 = 0
    local v337
    while true do
        if v336 == (0 - 0) then
            v337 = v88(v187, "🎨 " .. v335.Name)
            v337.MouseButton1Click:Connect(function()
                v197(v335)
            end)
            break
        end
    end
end
v187.CanvasSize = UDim2.new(0, 0, 315 - (306 + 9), #v196 * (157 - 112))
local v198 = Instance.new("Frame")
v198.Size = UDim2.new(1 + 0, -(13 + 7), 1, -(10 + 10))
v198.Position = UDim2.new(0 - 0, 1385 - (1140 + 235), 0 + 0, 10 + 0)
v198.BackgroundColor3 = Color3.fromRGB(8 + 20, 28, 87 - (33 + 19))
v198.Parent = v86
Instance.new("UICorner", v198).CornerRadius = UDim.new(0, 5 + 7)
Instance.new("UIStroke", v198).Thickness = 1
local v205 = Instance.new("TextLabel")
v205.Text = "💎 VIP PROPS ULTIMATE"
v205.Font = Enum.Font.GothamBold
v205.TextSize = 83 - 55
v205.TextColor3 = Color3.fromRGB(113 + 142, 215, 0)
v205.BackgroundTransparency = 1 - 0
v205.Size = UDim2.new(1 + 0, -(709 - (586 + 103)), 0 + 0, 153 - 103)
v205.Position = UDim2.new(1488 - (1309 + 179), 18 - 8, 0, 7 + 8)
v205.TextXAlignment = Enum.TextXAlignment.Center
v205.Parent = v198
local v215 = Instance.new("TextLabel")
v215.Text =
    "✅ Spawn all VIP Props around you\n✅ Give tools to players\n✅ Custom themes\n\n⚠️ Educational purposes only"
v215.Font = Enum.Font.Gotham
v215.TextSize = 15
v215.TextColor3 = Color3.fromRGB(537 - 337, 152 + 48, 220)
v215.BackgroundTransparency = 1 - 0
v215.Size = UDim2.new(1 - 0, -40, 609 - (295 + 314), 442 - 262)
v215.Position = UDim2.new(1962 - (1300 + 662), 62 - 42, 0, 80)
v215.TextXAlignment = Enum.TextXAlignment.Center
v215.TextYAlignment = Enum.TextYAlignment.Top
v215.Parent = v198
local v227 = Instance.new("Frame")
v227.Size = UDim2.new(1756 - (1178 + 577), -40, 0, 21 + 19)
v227.Position = UDim2.new(0, 59 - 39, 1, -(1460 - (851 + 554)))
v227.BackgroundTransparency = 1
v227.Parent = v198
local v232 = Instance.new("TextLabel")
v232.Text = "🚗 " .. #v89 .. " Props"
v232.Font = Enum.Font.Gotham
v232.TextSize = 14
v232.TextColor3 = Color3.fromRGB(133 + 17, 554 - 354, 553 - 298)
v232.BackgroundTransparency = 303 - (115 + 187)
v232.Size = UDim2.new(0.5 + 0, -(5 + 0), 3 - 2, 1161 - (160 + 1001))
v232.TextXAlignment = Enum.TextXAlignment.Left
v232.Parent = v227
local v241 = Instance.new("TextLabel")
v241.Text = "🔧 " .. #v90 .. " Tools"
v241.Font = Enum.Font.Gotham
v241.TextSize = 14
v241.TextColor3 = Color3.fromRGB(132 + 18, 255, 138 + 62)
v241.BackgroundTransparency = 1
v241.Size = UDim2.new(0.5, -5, 1 - 0, 358 - (237 + 121))
v241.Position = UDim2.new(897.5 - (525 + 372), 0 - 0, 0 - 0, 0)
v241.TextXAlignment = Enum.TextXAlignment.Right
v241.Parent = v227
local v252 = Instance.new("TextButton")
v252.Text = "💎"
v252.Font = Enum.Font.GothamBold
v252.TextSize = 24
v252.TextColor3 = Color3.fromRGB(397 - (96 + 46), 1032 - (643 + 134), 93 + 162)
v252.Size = UDim2.new(0, 50, 0, 119 - 69)
v252.Position = UDim2.new(0, 37 - 27, 0 + 0, 19 - 9)
v252.BackgroundColor3 = Color3.fromRGB(30, 61 - 31, 40)
v252.Visible = false
v252.Parent = v14
Instance.new("UICorner", v252).CornerRadius = UDim.new(720 - (316 + 403), 0)
v252.MouseButton1Click:Connect(function()
    local v338 = 0 + 0
    local v339
    while true do
        if v338 == 0 then
            v339 = 0 - 0
            while true do
                if v339 == (0 + 0) then
                    v14.Enabled = true
                    v252.Visible = false
                    break
                end
            end
            break
        end
    end
end)
v62.MouseButton1Click:Connect(function()
    local v340 = 0 - 0
    while true do
        if v340 == (0 + 0) then
            v14.Enabled = false
            v252.Visible = true
            break
        end
    end
end)
local v263 = Instance.new("TextLabel")
v263.Text = "💎 VIP Props Ultimate chargé!"
v263.Font = Enum.Font.GothamBold
v263.TextSize = 18
v263.TextColor3 = Color3.fromRGB(83 + 172, 744 - 529, 0)
v263.BackgroundColor3 = Color3.fromRGB(0 - 0, 0 - 0, 0 + 0, 393 - 193)
v263.Size = UDim2.new(0, 15 + 285, 0 - 0, 57 - (12 + 5))
v263.Position = UDim2.new(0.5 - 0, -(320 - 170), 0.1 - 0, 0)
v263.Parent = v14
Instance.new("UICorner", v263).CornerRadius = UDim.new(0 - 0, 3 + 7)
task.wait(1976 - (1656 + 317))
v263:TweenPosition(UDim2.new(0.5, -150, -(0.1 + 0), 0 + 0), "Out", "Quad", 0.5 - 0)
task.wait(0.6)
v263:Destroy()
print("✅ UI chargé avec succès!")
print("🚗 " .. #v89 .. " Props | 🔧 " .. #v90 .. " Tools")
