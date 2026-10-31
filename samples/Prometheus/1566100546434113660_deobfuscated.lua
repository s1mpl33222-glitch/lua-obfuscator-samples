-- This file was generated at discord.gg/syncrypt

local capturedValues1 = {}
local v709, v710, v711, v715
local v706 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
if v706 then
    v709 = (v706:FindFirstChild("Kick")) or (v706:WaitForChild("Kick", 5))
    if v709 then
        v709.Name = "Kicks"
        if getconnections then
            v710 = ipairs
            v711 = getconnections
            for v715, v711 in v710(v711(v709.OnClientEvent)) do
                v711:Disable()
            end
        end
    end
end
v710 = game:GetService("Workspace")
capturedValues1.value1 = v710
v715 = CFrame;
(function(arg7_1)
    local v140
    local v134 = arg7_1
    local v135 = ipairs
    local v136 = capturedValues1.value1
    local v137 = v136.GetDescendants
    for v139, v137 in v135(v137(v136)) do
        v135 = v137:IsA("BasePart")
        if v135 then
            v140 = (v137.CFrame.Position - v134.Position)
            if (v140.Magnitude < .1) then
                v137:Destroy()
            end
        end
    end
    return
end)(v715.new(70, 20.5, 40.5, 0, 0, 1, 0, 1, 0, -1, 0, 0))
local v708 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
capturedValues1.value2 = v708
v715 = capturedValues1.value2:CreateWindow({["Name"] = "Script Hub", ["LoadingTitle"] = "Welcome back!", ["LoadingSubtitle"] = "by @Hikari-IIV", ["ConfigurationSaving"] = {["Enabled"] = true, ["FolderName"] = "ScriptHubConfig", ["FileName"] = "MainConfig"}})
v708 = v715:CreateTab("Main", 4483362458)
v708:CreateSection("Credits")
v708:CreateLabel("Creator: @Hikari-IIV")
v708:CreateSection("Support & Bug Report")
v711 = v708.CreateButton
local v721 = function()
    local v149 = "https://www.youtube.com/@Hikari-IIV"
    if setclipboard then
        setclipboard(v149)
        capturedValues1.value2:Notify({["Title"] = "Success!", ["Content"] = "YouTube link copied to clipboard.", ["Duration"] = 3, ["Image"] = 4483362458})
    else
        capturedValues1.value2:Notify({["Title"] = "Error", ["Content"] = "Your executor does not support setclipboard.", ["Duration"] = 3, ["Image"] = 4483362458})
    end
    return
end
v711(v708, {["Name"] = "Report Bug (Copy YouTube Link)", ["Callback"] = v721})
v711 = v715:CreateTab("ESP", 4483362458)
local v737 = game:GetService("Players")
local v713 = v737.LocalPlayer
capturedValues1.value3 = v713
local v718 = workspace:FindFirstChild("ItemSpots")
capturedValues1.value4 = v718
v718 = workspace
v721 = v718.FindFirstChild
v721 = v721(v718, "JerryCans")
capturedValues1.value5 = v721
capturedValues1.value6 = {}
capturedValues1.value7 = false
local v723 = Color3.fromRGB(0, 255, 0)
local v731 = Color3.fromRGB(255, 255, 0)
local v733 = Color3.fromRGB(0, 170, 255)
v721 = {["JerryCan"] = v723, ["Key"] = v731, ["ItemSpots"] = v733}
v723 = function(arg9_1)
    local v163, v166, v167
    local v162 = arg9_1
    local v164 = v162:IsA("BasePart")
    if v164 then
        return v162
    else
        v163 = v162:FindFirstChild("Main", true)
        v167 = v163
        if not (v163) then
            v166 = v162:FindFirstChild("Handle", true)
            v163 = v166
            if not (v166) then
                v163 = (v162:FindFirstChild("HumanoidRootPart", true))
            end
            v167 = v163
        end
        v163 = v167
        v167 = v163 and (v163:IsA("BasePart"))
        if v167 then
            return v163
        else
            v167 = "BasePart"
            v166 = v162.FindFirstChildWhichIsA
            return v166(v162, v167, true)
        end
    end
end
capturedValues1.value8 = nil
local v728 = function(arg10_1, arg10_2)
    local v178
    local v173 = arg10_2
    if (v173 == "JerryCan") then
        v178 = capturedValues1.value8.JerryCan
        return v178
    else
        if (v173 == "Key") then
            v178 = capturedValues1.value8.Key
            return v178
        else
            if (v173 == "ItemSpots") then
                v178 = capturedValues1.value8.ItemSpots
                return v178
            else
                v178 = Color3.fromRGB
                return v178(255, 255, 255)
            end
        end
    end
end
v731 = function()
    for v183, v184 in pairs(capturedValues1.value6) do
        local up2 = v184
        pcall(function()
            local v616 = up2
            if v616.Highlight then
                up2.Highlight:Destroy()
            end
            v616 = up2
            if v616.Gui then
                up2.Gui:Destroy()
            end
            return
        end)
        v184 = nil
    end
    capturedValues1.value6 = {}
    return
end
capturedValues1.value8 = v721
capturedValues1.value9 = nil
local v724 = function(arg12_1, arg12_2, arg12_3)
    local v192, v193, v195, v196, v197
    local v187 = capturedValues1.value6
    local v188 = arg12_1
    local v189 = v187[v188]
    local v190 = arg12_2
    local v191 = arg12_3
    if v189 then
        return
    else
        v187 = (not v188.Parent) or (not v190)
        if v187 then
            return
        else
            v197 = (capturedValues1.value9(v188, v191))
            v196 = (Instance.new("Highlight"))
            v196.Name = "ItemESP"
            v196.Adornee = v188
            v196.FillTransparency = 1
            v196.OutlineTransparency = 0
            v196.OutlineColor = v197
            v187 = Enum.HighlightDepthMode.AlwaysOnTop
            v196.DepthMode = v187
            v196.Parent = v188
            v195 = (Instance.new("BillboardGui"))
            v195.Name = "ESPInfo"
            v195.Adornee = v190
            v192 = UDim2.fromOffset(200, 30)
            v195.Size = v192
            v192 = Vector3.new(0, 2.5, 0)
            v195.StudsOffset = v192
            v195.AlwaysOnTop = true
            v195.Parent = v188
            v192 = (Instance.new("TextLabel"))
            v192.Name = "ESPText"
            v193 = UDim2.fromScale(1, 1)
            v192.Size = v193
            v192.BackgroundTransparency = 1
            v192.TextColor3 = v197
            v192.TextStrokeTransparency = 0
            v192.TextSize = 14
            v187 = Enum.Font.SourceSansBold
            v192.Font = v187
            v187 = Enum.TextXAlignment.Center
            v192.TextXAlignment = v187
            v187 = Enum.TextYAlignment.Center
            v192.TextYAlignment = v187
            v193 = v188.Name
            v192.Text = (v193 .. " [0m]")
            v192.Parent = v195
            v189 = capturedValues1.value6
            v187 = {["Root"] = v190, ["Text"] = v192, ["Highlight"] = v196, ["Gui"] = v195, ["Category"] = v191}
            v189[v188] = v187
            return
        end
    end
end
capturedValues1.value9 = v728
capturedValues1.value10 = v723
capturedValues1.value11 = nil
local v730 = function()
    local v205, v207
    local v209 = workspace:FindFirstChild("Key")
    if v209 then
        v205 = v209:FindFirstChildWhichIsA("ClickDetector", true)
        if v205 then
            v207 = (capturedValues1.value10(v209))
            if v207 then
                capturedValues1.value11(v209, v207, "Key")
            end
        end
    end
    return
end
local v738 = function()
    local v214, v215, v216, v218, v221, v223, v224
    if (not capturedValues1.value5) then
        return
    else
        v214 = ipairs
        v215 = capturedValues1.value5
        v216 = v215.GetDescendants
        for v218, v216 in v214(v216(v215)) do
            v224 = (v216:IsA("Model")) or (v216:IsA("Tool"))
            if v224 then
                v224 = (v216:FindFirstChild("Main"))
                v214 = v216:FindFirstChildWhichIsA("ClickDetector")
                v223 = v224
                v221 = v214
                if v224 then
                    v223 = ((v224:IsA("BasePart")) and v221)
                end
                if v223 then
                    capturedValues1.value11(v216, v224, "JerryCan")
                end
            end
        end
        return
    end
end
capturedValues1.value11 = v724
capturedValues1.value12 = v731
v733 = function()
    local v230, v231, v232, v234, v235, v238
    if (not capturedValues1.value4) then
        return
    else
        v230 = ipairs
        v231 = capturedValues1.value4
        v232 = v231.GetDescendants
        for v234, v232 in v230(v232(v231)) do
            v230 = v232:IsA("ClickDetector")
            if v230 then
                v238 = v232.Parent
                while true do
                    v235 = v238 and (v238 ~= capturedValues1.value4)
                    if v235 then
                        v235 = (v238:IsA("Model")) or (v238:IsA("Tool"))
                        if v235 then
                            v235 = capturedValues1.value10(v238)
                            if v235 then
                                capturedValues1.value11(v238, v235, "ItemSpots")
                            end
                        else
                            v238 = v238.Parent
                            continue
                        end
                    end
                    break
                end
            end
        end
        return
    end
end
capturedValues1.value13 = v730
capturedValues1.value14 = v733
capturedValues1.value15 = v738
task.spawn(function()
    while true do
        if capturedValues1.value7 then
            pcall(capturedValues1.value13)
            pcall(capturedValues1.value14)
            pcall(capturedValues1.value15)
        end
        task.wait(0.5)
    end
end)
task.spawn(function()
    while true do
        if capturedValues1.value7 then
            pcall(function()
                local v87, v89, v91, v92, v93, v95, v96, v97, v98
                local v88 = capturedValues1.value3.Character
                local v84 = v88
                if v88 then
                    v84 = (v88:FindFirstChild("HumanoidRootPart"))
                end
                local v85 = v84
                if (not v85) then
                    return
                else
                    v89 = pairs
                    for v87, v92 in v89(capturedValues1.value6) do
                        v91 = v87
                        local up1 = v92
                        v97 = v91.Parent
                        v98 = v97
                        if v97 then
                            v93 = up1.Root
                            v97 = v93
                            if v93 then
                                v95 = up1.Root.Parent
                                v93 = v95
                                if v95 then
                                    v93 = up1.Text
                                end
                                v97 = v93
                            end
                            v98 = v97
                        end
                        if v98 then
                            v98 = (v85.Position - up1.Root.Position).Magnitude
                            v89 = up1.Text
                            v96 = (v91.Name .. (" [" .. ((math.floor (v98)) .. "m]")))
                            v89.Text = v96
                        else
                            pcall(function()
                                local v110 = up1
                                if v110.Highlight then
                                    up1.Highlight:Destroy()
                                end
                                v110 = up1
                                if v110.Gui then
                                    up1.Gui:Destroy()
                                end
                                return
                            end)
                            v89 = capturedValues1.value6
                            v89[v91] = nil
                        end
                        v92 = nil
                    end
                    return
                end
            end)
        end
        task.wait(.1)
    end
end)
local v745 = function(arg18_1)
    capturedValues1.value7 = arg18_1
    local v255 = (not arg18_1)
    if v255 then
        capturedValues1.value12()
    end
    return
end
v711:CreateToggle({["Name"] = "Item ESP", ["CurrentValue"] = false, ["Callback"] = v745})
capturedValues1.value16 = {}
local v743 = function(arg19_1)
    local v257 = arg19_1
    local v262 = v257:FindFirstChild("HumanoidRootPart", true)
    local v263 = v262
    if not (v262) then
        v263 = v257.PrimaryPart or (v257:FindFirstChildWhichIsA("BasePart", true))
    end
    return v263
end
local v742 = function(arg20_1, arg20_2)
    local v266 = arg20_1
    local v267 = capturedValues1.value2
    local v268 = arg20_2
    if v267 then
        capturedValues1.value2:Notify({["Title"] = v266, ["Content"] = v268, ["Duration"] = 3})
    end
    return
end
capturedValues1.value17 = {}
capturedValues1.value18 = false
capturedValues1.value19 = nil
local v746 = function(arg21_1)
    local v279, v281, v282
    local v277 = capturedValues1.value17
    local v278 = arg21_1
    if v277[v278] then
        return
    else
        v279 = (v278:FindFirstChild("Config"))
        v277 = v279
        if v279 then
            v277 = (v279:FindFirstChild("Active"))
        end
        local up3 = v277
        v281 = (not up3)
        v277 = v281
        if not (v281) then
            v277 = (not (up3:IsA("BoolValue")))
        end
        if v277 then
            return
        else
            v282 = up3.Value
            local up4 = v282
            v282 = capturedValues1.value17
            v277 = up3:GetPropertyChangedSignal("Value"):Connect(function()
                local v677 = up3.Value
                local v673 = v677 and (not up4)
                if v673 then
                    capturedValues1.value19("⚠️ Monster Spawn", "BunkerRat has spawned!")
                else
                    v673 = (not v677) and up4
                    if v673 then
                        capturedValues1.value19("Monster Despawn", "BunkerRat has despawned!")
                    end
                end
                return
            end)
            v282[v278] = v277
            return
        end
    end
end
capturedValues1.value19 = v742
v745 = function()
    local v295
    for v293, v294 in pairs(capturedValues1.value16) do
        local up5 = v294
        v295 = function()
            local v575 = up5
            if v575.Highlight then
                up5.Highlight:Destroy()
            end
            v575 = up5
            if v575.Gui then
                up5.Gui:Destroy()
            end
            return
        end
        pcall(v295)
        v294 = nil
    end
    capturedValues1.value16 = {}
    return
end
capturedValues1.value20 = v743
local v744 = function(arg23_1)
    local v299, v300, v301, v302, v303, v304
    local v297 = capturedValues1.value16
    local v298 = arg23_1
    if v297[v298] then
        return
    else
        v300 = (capturedValues1.value20(v298))
        if (not v300) then
            return
        else
            v304 = (Instance.new("Highlight"))
            v304.Name = "BunkerRatESP"
            v304.Adornee = v298
            v304.FillTransparency = 1
            v304.OutlineTransparency = 0
            v301 = Color3.fromRGB(255, 0, 0)
            v304.OutlineColor = v301
            v297 = Enum.HighlightDepthMode.AlwaysOnTop
            v304.DepthMode = v297
            v304.Parent = v298
            v301 = (Instance.new("BillboardGui"))
            v301.Name = "BunkerRatInfo"
            v301.Adornee = v300
            v302 = UDim2.fromOffset(200, 30)
            v301.Size = v302
            v302 = Vector3.new(0, 3, 0)
            v301.StudsOffset = v302
            v301.AlwaysOnTop = true
            v301.Parent = v298
            v302 = (Instance.new("TextLabel"))
            v302.Name = "ESPText"
            v303 = UDim2.fromScale(1, 1)
            v302.Size = v303
            v302.BackgroundTransparency = 1
            v303 = Color3.fromRGB(255, 0, 0)
            v302.TextColor3 = v303
            v302.TextStrokeTransparency = 0
            v302.TextSize = 14
            v297 = Enum.Font.SourceSansBold
            v302.Font = v297
            v297 = Enum.TextXAlignment.Center
            v302.TextXAlignment = v297
            v297 = Enum.TextYAlignment.Center
            v302.TextYAlignment = v297
            v303 = v298.Name
            v302.Text = (v303 .. " [0m]")
            v302.Parent = v301
            v299 = capturedValues1.value16
            v297 = {["Root"] = v300, ["Text"] = v302, ["Highlight"] = v304, ["Gui"] = v301}
            v299[v298] = v297
            return
        end
    end
end
capturedValues1.value21 = v744
capturedValues1.value22 = v745
capturedValues1.value23 = v746
task.spawn(function()
    local v313
    while true do
        if capturedValues1.value18 then
            v313 = function()
                local v622, v624, v625, v626, v628, v630
                local v627 = (workspace:FindFirstChild("BunkerRat"))
                if v627 then
                    capturedValues1.value21(v627)
                    capturedValues1.value23(v627)
                else
                    v622, v624, v625 = pairs(capturedValues1.value16)
                    v626 = v622
                    while true do
                        v625 = v626(v624, v625)
                        if not v625 then
                            break
                        end
                        capturedValues1.value22()
                    end
                    for v626, v628 in pairs(capturedValues1.value17) do
                        local up13 = v628
                        v630 = function()
                            up13:Disconnect()
                            return
                        end
                        v628 = nil
                        pcall(v630)
                    end
                    capturedValues1.value17 = {}
                end
                return
            end
            pcall(v313)
        end
        task.wait(0.5)
    end
end)
task.spawn(function()
    local v318
    while true do
        if capturedValues1.value18 then
            v318 = function()
                local v587, v589, v591, v592, v593, v595, v596, v597, v598
                local v588 = capturedValues1.value3.Character
                local v584 = v588
                if v588 then
                    v584 = (v588:FindFirstChild("HumanoidRootPart"))
                end
                local v585 = v584
                if v585 then
                    v589 = pairs
                    for v587, v592 in v589(capturedValues1.value16) do
                        v591 = v587
                        local up12 = v592
                        v597 = v591.Parent
                        v598 = v597
                        if v597 then
                            v593 = up12.Root
                            v597 = v593
                            if v593 then
                                v595 = up12.Root.Parent
                                v593 = v595
                                if v595 then
                                    v593 = up12.Text
                                end
                                v597 = v593
                            end
                            v598 = v597
                        end
                        if v598 then
                            v589 = (v585.Position - up12.Root.Position).Magnitude
                            v597 = up12
                            v598 = v589
                            v589 = v597.Text
                            v596 = (v591.Name .. (" [" .. ((math.floor (v598)) .. "m]")))
                            v589.Text = v596
                        else
                            v597 = function()
                                local v699 = up12
                                if v699.Highlight then
                                    up12.Highlight:Destroy()
                                end
                                v699 = up12
                                if v699.Gui then
                                    up12.Gui:Destroy()
                                end
                                return
                            end
                            pcall(v597)                            v589 = capturedValues1.value16
                            v589[v591] = nil
                        end
                        v592 = nil
                    end
                end
                return
            end
            pcall(v318)
        end
        task.wait(.1)
    end
end)
local v753 = function(arg26_1)
    local v328, v329
    capturedValues1.value18 = arg26_1
    local v324 = (not arg26_1)
    if v324 then
        capturedValues1.value22()
        for v328, v329 in pairs(capturedValues1.value17) do
            local up6 = v329
            pcall(function()
                up6:Disconnect()
                return
            end)
            v329 = nil
        end
    end
    return
end
v711:CreateToggle({["Name"] = "Bunker Rat ESP", ["CurrentValue"] = false, ["Callback"] = v753})
v746 = v715:CreateTab("Player Setting", 4483362458)
local v747 = v737.LocalPlayer
capturedValues1.value24 = v747
capturedValues1.value25 = {["Stamina"] = false}
capturedValues1.value26 = {["Stam"] = nil}
task.spawn(function()
    local v332, v333, v334, v335, v336, v337
    while true do
        v332 = task.wait(.1)
        if not v332 then
            break
        end
        v336 = capturedValues1.value24.Character
        if not ((not v336))then
            v333 = (v336:FindFirstChild("Sprint"))
            v334 = v333 and (v333:FindFirstChild("Stam"))
            if v334 then
                v332 = capturedValues1.value25
                if v332.Stamina then
                    v335 = capturedValues1.value26
                    if (v335.Stam == nil) then
                        v337 = capturedValues1.value26
                        v335 = v334.Value
                        v337.Stam = v335
                    end
                    v334.Value = 3
                else
                    v335 = capturedValues1.value26
                    if (v335.Stam ~= nil) then
                        v332 = capturedValues1.value26.Stam
                        v334.Value = v332
                        v337 = capturedValues1.value26
                        v337.Stam = nil
                    end
                end
            end
        end
    end
    return
end)
v746:CreateSection("Movement")
v747 = v746.CreateToggle
local v757 = function(arg28_1)
    capturedValues1.value25.Stamina = arg28_1
    return
end
v747(v746, {["Name"] = "Infinite Stamina", ["CurrentValue"] = false, ["Callback"] = v757})
v747 = v715:CreateTab("Automatically", 4483362458)
v747:CreateSection("PowerGrids")
v753 = function(arg29_1)
    local v348, v350, v352
    local v347 = arg29_1
    if (not v347) then
        v348 = nil
        return v348
    else
        v352 = "ClickDetector"
        v350 = v347.FindFirstChildWhichIsA
        return v350(v347, v352, true)
    end
end
capturedValues1.value27 = false
capturedValues1.value28 = v753
local v754 = function(arg30_1)
    local v354, v359, v361, v362, v363, v364, v365
    local v353 = arg30_1
    local v355 = {}
    if (not v353) then
        return v355
    else
        v354 = ipairs
        for v359, v361 in v354(v353:GetChildren()) do
            v365 = (v361:FindFirstChild("Part", true))
            v362 = v365
            if v365 then
                v362 = (v365:FindFirstChild("TextLabel", true))
            end
            v363 = capturedValues1.value28(v361)
            v364 = (v362 and v363)
            if v364 then
                v364 = v362.Text:match("%S+")
                if v364 then
                    table.insert(v355, {["Letter"] = v364, ["Detector"] = v363, ["Object"] = v361})
                end
            end
        end
        return v355
    end
end
capturedValues1.value29 = v754
v754 = task.spawn
local v756 = function()
    local v374, v375, v376, v377, v378, v379, v381, v382, v383, v384, v385, v386, v387, v388, v389, v390
    local v391, v394, v395, v396, v397, v398
    local v399
    while true do
        task.wait(.2)
        if capturedValues1.value27 then
            v379 = workspace.CurrentCamera
            if (not v379) then
                continue
            else
                v376 = (workspace:FindFirstChild("PowerGrids"))
                if (not v376) then
                    continue
                else
                    v377 = nil
                    v378 = math.huge
                    v381 = 4
                    v382 = 1
                    for v384 = 1, v381, v382 do
                        v386 = (v376:FindFirstChild(tostring(v384)))
                        if v386 then
                            v391 = v386:FindFirstChild("Cam")
                            v375 = v391
                            if not (v391) then
                                v387 = v386:FindFirstChild("CamPart")
                                v391 = v387
                                if not (v387) then
                                    v391 = (v386:FindFirstChildWhichIsA("BasePart", true))
                                end
                                v375 = v391
                            end
                            v391 = v375
                            if v391 then
                                v390 = (v379.CFrame.Position - v391.Position).Magnitude
                                if (v390 < v378) then
                                    v374 = v390
                                    v377 = v386
                                    v378 = v374
                                end
                            end
                        end
                    end
                    if (not v377) then
                        continue
                    else
                        v394 = v377
                        v395 = (v394:FindFirstChild("Detector"))
                        v384 = v395
                        if v395 then
                            v384 = (v395:FindFirstChildWhichIsA("ClickDetector"))
                        end
                        local up7 = v384
                        if up7 then
                            pcall(function()
                                fireclickdetector(up7)
                                return
                            end)
                            task.wait(.05)
                        end
                        v381 = v394:FindFirstChild("Cam")
                        v384 = v381
                        if not (v381) then
                            v384 = (v394:FindFirstChild("CamPart")) or (v394:FindFirstChildWhichIsA("BasePart", true))
                        end
                        v396 = v384
                        if (not v396) then
                            continue
                        else
                            v384 = (v379.CFrame.Position - v396.Position)
                            if (v384["Magnitude"] > 2) then
                                continue
                            else
                                v397 = (v394:FindFirstChild("Tally"))
                                v384 = v397 and (v397:FindFirstChild("TextLabel", true))
                                v398 = v384
                                v381 = v398
                                if v398 then
                                    v381 = (tonumber(v398.Text:match("%d+")))
                                end
                                if ((v381 or 0) > 0) then
                                    v384 = v394:FindFirstChild("LeftWires")
                                    v381 = v394:FindFirstChild("RightWires")
                                    v382 = (v384 and v381)
                                    if v382 then
                                        v383 = capturedValues1.value29(v384)
                                        v385 = capturedValues1.value29(v381)
                                        v382 = ((#v383) == 4) and ((#v385) == 4)
                                        if v382 then
                                            v382 = {}
                                            v391, v390, v387 = ipairs(v385)
                                            while true do
                                                v387, v388 = v391(v390, v387)
                                                if not v387 then
                                                    break
                                                end
                                                v389 = v388.Letter
                                                v382[v389] = v388
                                            end
                                            for v387, v388 in ipairs(v383) do
                                                local up8 = v388
                                                v389 = (not capturedValues1.value27)
                                                if v389 then
                                                    break
                                                else
                                                    v399 = up8
                                                    local up9 = v382[v399.Letter]
                                                    if up9 then
                                                        pcall(function()
                                                            fireclickdetector(up8.Detector)
                                                            task.wait(.1)
                                                            fireclickdetector(up9.Detector)
                                                            return
                                                        end)
                                                        task.wait(.15)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
v754(v756)
local v761 = function(arg32_1)
    capturedValues1.value27 = arg32_1
    if arg32_1 then
        capturedValues1.value2:Notify({["Title"] = "PowerGrid Aura", ["Content"] = "Activated (Nearest Grid, Radius 2 Studs from Camera)", ["Duration"] = 2})
    end
    return
end
v747:CreateToggle({["Name"] = "Aura PowerGrids", ["CurrentValue"] = false, ["Callback"] = v761})
capturedValues1.value30 = false
capturedValues1.value31 = 0.5
v757 = workspace:FindFirstChild("PowerGrids")
capturedValues1.value32 = v757
local v760 = function(arg33_1)
    local v416, v417, v420, v421, v423
    local v418 = {}
    v416, v420, v421 = ipairs(arg33_1:GetDescendants())
    local v422 = v416
    while true do
        v421, v423 = v422(v420, v421)
        if not v421 then
            break
        end
        v417 = v423:IsA("BasePart")
        if v417 then
            table.insert(v418, v423)
        end
    end
    if ((#v418) ~= 4) then
        v417 = false
        return v417
    else
        v417 = ipairs
        for v422, v423 in v417(v418) do
            if (v423["Transparency"] ~= 0) then
                v417 = false
                return v417
            end
        end
        v417 = true
        return v417
    end
end
local v759 = function(arg34_1)
    local v432
    local v429 = arg34_1
    local v430 = (v429:FindFirstChild("Lever"))
    if v430 then
        v432 = (v430:FindFirstChildWhichIsA("BasePart", true))
        if v432 then
            return v432
        end
    end
    local v434 = "BasePart"
    return v429:FindFirstChildWhichIsA(v434, true)
end
local up70 = function()
    local v436, v437, v441
    local v440 = capturedValues1.value24.Character
    if (not v440) then
        v441 = nil
        return v441
    else
        v436 = "HumanoidRootPart"
        v437 = v440.FindFirstChild
        return v437(v440, v436)
    end
end
capturedValues1.value33 = v759
v761 = function()
    local v442, v443, v445, v447, v448, v449, v450, v452, v453, v458
    local v444 = (up70())
    if (not v444) then
        v442 = nil
        return v442
    else
        if (not capturedValues1.value32) then
            v442 = nil
            return v442
        else
            v443 = math
            v450 = nil
            v445 = v443.huge
            v448 = 4
            v449 = 1
            for v447 = 1, v448, v449 do
                v452 = (capturedValues1.value32:FindFirstChild(tostring(v447)))
                if v452 then
                    v453 = (capturedValues1.value33(v452))
                    if v453 then
                        v458 = (v444.Position - v453.Position).Magnitude
                        if (v458 < v445) then
                            v442 = v458
                            v450 = v452
                            v445 = v442
                        end
                    end
                end
            end
            return v450
        end
    end
end
capturedValues1.value34 = v760
capturedValues1.value35 = v761
local up74 = function()
    local v460, v461, v462, v463, v464, v465, v466
    if (not capturedValues1.value30) then
        return
    else
        v462 = (capturedValues1.value35())
        if (not v462) then
            return
        else
            v463 = (v462:FindFirstChild("Lever"))
            v465 = (not v463)
            v460 = v462:FindFirstChild("Temp")
            v461 = v465
            v464 = v460
            if not (v465) then
                v461 = (not v464)
            end
            if v461 then
                return
            else
                v460 = v463:FindFirstChildWhichIsA("ClickDetector", true)
                local up10 = v460
                if (not up10) then
                    return
                else
                    v461 = capturedValues1.value34(v464)
                    if v461 then
                        v466 = function()
                            fireclickdetector(up10)
                            return
                        end
                        pcall(v466)
                    end
                    return
                end
            end
        end
    end
end
task.spawn(function()
    while true do
        task.wait(capturedValues1.value31)
        pcall(up74)
    end
end)
local v762 = v747.CreateToggle
local v769 = function(arg39_1)
    capturedValues1.value30 = arg39_1
    if arg39_1 then
        capturedValues1.value2:Notify({["Title"] = "Auto Lever", ["Content"] = "Activated (Will click lever when Temp is ready)", ["Duration"] = 2})
    end
    return
end
v762(v747, {["Name"] = "Auto Lever PowerGrids", ["CurrentValue"] = false, ["Callback"] = v769})
v762 = v747.CreateSection
local v764 = function()
    local v486, v487, v491
    local v490 = capturedValues1.value24.Character
    if (not v490) then
        v491 = nil
        return v491
    else
        v486 = "HumanoidRootPart"
        v487 = v490.FindFirstChild
        return v487(v490, v486)
    end
end
v762(v747, "Ventilation")
capturedValues1.value36 = false
capturedValues1.value37 = 10
capturedValues1.value38 = v764
task.spawn(function()
    while true do
        task.wait(.1)
        if capturedValues1.value36 then
            local up11 = (capturedValues1.value38())
            if up11 then
                pcall(function()
                    local v684, v686, v687, v688, v695, v696, v697, v698
                    local v681 = (workspace.Ventilation:FindFirstChild("Debris"))
                    if (not v681) then
                        return
                    else
                        v687 = v681.GetChildren
                        for v684, v688 in ipairs(v687(v681)) do
                            if not ((not capturedValues1.value36))then
                                v695 = ((v688:IsA("BasePart")) and v688)
                                v696 = v695
                                if not (v695) then
                                    v696 = (v688:FindFirstChildWhichIsA("BasePart", true))
                                end
                                v698 = v696
                                v686 = v688:FindFirstChildWhichIsA("ClickDetector", true)
                                v696 = v698
                                local up14 = v686
                                if v698 then
                                    v696 = up14
                                end
                                if v696 then
                                    v696 = (up11.Position - v698.Position)
                                    if (v696.Magnitude <= capturedValues1.value37) then
                                        v686 = up14
                                        v686.MaxActivationDistance = 9999
                                        v697 = function()
                                            fireclickdetector(up14, 0)
                                            return
                                        end
                                        pcall(v697)
                                        task.wait(.05)
                                    end
                                end
                                continue
                            end
                            break
                        end
                        return
                    end
                end)
            end
        end
    end
end)
v764 = v747.CreateToggle
local v772 = function(arg42_1)
    capturedValues1.value36 = arg42_1
    if arg42_1 then
        capturedValues1.value2:Notify({["Title"] = "Vent Aura", ["Content"] = "Activated (Radius: 10 Studs)", ["Duration"] = 2})
    end
    return
end
v764(v747, {["Name"] = "Auto Vent Aura", ["CurrentValue"] = false, ["Callback"] = v772})
v747:CreateSection("Safe Spot")
local v765 = CFrame.new(80.253746, 13.4999943, 27.69104, 1, 0, 0, 0, 1, 0, 0, 0, 1)
capturedValues1.value39 = v765
local v766 = CFrame.new(-2.99999237, -1.69455185, -41.0000229, 1, 0, 0, 0, 1, 0, 0, 0, 1)
capturedValues1.value40 = v766
local v768 = Vector3.new(225.15356445312, 16.796829223633, 319.37844848633)
capturedValues1.value41 = nil
v769 = function()
    local v511, v512, v514, v517, v521, v523, v524
    local v515 = (workspace:FindFirstChild("Folder_Hub"))
    if (not v515) then
        v515 = (Instance.new("Folder"))
        v515.Name = "Folder_Hub"
        v512 = workspace
        v515.Parent = v512
    else
        v511 = ipairs
        v517 = v515.GetChildren
        for v514, v517 in v511(v517(v515)) do
            v523 = (v517.Name == "Main")
            v524 = v523
            if not (v523) then
                v521 = (v517.Name == "AntiFallMap")
                v523 = v521
                if not (v521) then
                    v523 = (v517.Name == "Part")
                end
                v524 = v523
            end
            if v524 then
                v517:Destroy()
            end
        end
    end
    v512 = Instance.new("Part")
    v512.Name = "Main"
    v512.Anchored = true
    v512.CanCollide = true
    v512.Material = Enum.Material.SmoothPlastic
    v512.Color = Color3.fromRGB(40, 40, 40)
    v512.Size = Vector3.new(15, 2.2, 27)
    v512.CFrame = capturedValues1.value39
    v512.Parent = v515
    local v513 = Instance.new("PointLight")
    v513.Range = 100
    v513.Brightness = 1.5
    v513.Parent = v512
    v514 = Instance.new("Part")
    v514.Name = "Part"
    v514.Anchored = true
    v514.CanCollide = true
    v514.Material = Enum.Material.SmoothPlastic
    v514.Size = Vector3.new(1, 11.2, 29)
    v514.CFrame = CFrame.new(86.3636475, 19.5999889, 27.6306458, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    v514.Parent = v512
    local v516 = Instance.new("Part")
    v516.Name = "AntiFallMap"
    v516.Anchored = true
    v516.CanCollide = true
    v516.Transparency = 0.75
    v516.Color = Color3.fromRGB(255, 0, 0)
    v516.Size = capturedValues1.value41
    v516.CFrame = capturedValues1.value40
    v516.Parent = v515
    return
end
capturedValues1.value41 = v768
capturedValues1.value42 = v769
local v774 = function()
    capturedValues1.value42()
    capturedValues1.value2:Notify({["Title"] = "Safe Spot", ["Content"] = "Safe Spot has been set up!", ["Duration"] = 2})
    return
end
v747:CreateButton({["Name"] = "Setup Safe Spot", ["Callback"] = v774})
v747:CreateSection("Teleport")
v769 = v747.CreateButton
v774 = function()
    local v540, v545
    local v538 = game.Players.LocalPlayer
    local v539 = ((v538.Character or (v538.CharacterAdded:Wait())):FindFirstChild("HumanoidRootPart"))
    if v539 then
        v540 = capturedValues1.value39
        v545 = Vector3.new(0, 3, 0)
        v539.CFrame = (v540 + v545)
        capturedValues1.value2:Notify({["Title"] = "Teleport", ["Content"] = "Teleported to Safe Spot!", ["Duration"] = 2})
    else
        capturedValues1.value2:Notify({["Title"] = "Teleport", ["Content"] = "HumanoidRootPart not found!", ["Duration"] = 2})
    end
    return
end
v769(v747, {["Name"] = "TP to Safe Spot", ["Callback"] = v774})
v769 = v747.CreateButton
v774 = function()
    local v554, v558
    local v552 = game.Players.LocalPlayer
    local v553 = ((v552.Character or (v552.CharacterAdded:Wait())):FindFirstChild("HumanoidRootPart"))
    if v553 then
        v554 = CFrame.new(-26.9844055, 12.6, -153.410004)
        v553.CFrame = v554
        capturedValues1.value2:Notify({["Title"] = "Teleport", ["Content"] = "Teleported to Gen Spot!", ["Duration"] = 2})
    else
        v558 = capturedValues1.value2
        v554 = {["Title"] = "Teleport", ["Content"] = "HumanoidRootPart not found!", ["Duration"] = 2}
        v558:Notify(v554)
    end
    return
end
v769(v747, {["Name"] = "TP to Gen Spot", ["Callback"] = v774})
task.spawn(function()
    task.wait(1)
    pcall(capturedValues1.value42)
    print("Safe Spot setup complete")
    return
end)

return
