local v8 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local v9 = v8:CreateWindow({
    ["Name"] = "EnygmaXIT, by Enygma",
    ["Icon"] = 95163577003929 - 51569223,
    ["LoadingTitle"] = "EnygmaXIT",
    ["LoadingSubtitle"] = "by Enygma",
    ["ShowText"] = "⬇️",
    ["Theme"] = "Black",
    ["ToggleUIKeybind"] = "K",
    ["DisableRayfieldPrompts"] = true,
    ["DisableBuildWarnings"] = true,
    ["ConfigurationSaving"] = { ["Enabled"] = false, ["FolderName"] = nil, ["FileName"] = "EnygmaXIT" },
})
local v10 = v9:CreateTab("PVP⚔️", 95163525436522 - (126 + 1690))
local v11 = v9:CreateTab("Farm⚡", 95163525434706 - 0)
local v12 = v9:CreateTab("Player👤", 95163525435188 - (14 + 468))
local v13 = v9:CreateTab("Gamepass🌌", 95163525434706 - 0)
local v14 = v9:CreateTab("Troll🎭", 95163525434706 - 0)
local v15 = game:GetService("Players")
local v16 = game:GetService("ReplicatedStorage")
local v17 = v15.LocalPlayer
local v18 = v16:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
local v19 = 300
local v20 = 42 + 38
local v21 = 2 + 1
local function v22()
    local v171 = 0
    local v172
    while true do
        if 0 == v171 then
            local v380 = 0
            while true do
                if v380 == (0 + 0) then
                    v172 = v17.Character or v17.CharacterAdded:Wait()
                    return v172, v172:WaitForChild("HumanoidRootPart")
                end
            end
        end
    end
end
local function v23(v173, v174, v175)
    local v176 = 0
    local v177
    while true do
        if v176 == (1 + 0) then
            return v177
        end
        if v176 == 0 then
            v177 = v173.Position
            for v453 = 1 + 0, v21 do
                local v454 = 0 - 0
                local v455
                local v456
                local v457
                while true do
                    if v454 == 1 then
                        v457 = nil
                        while true do
                            if v455 == (1 + 0) then
                                v177 = v173.Position + (v173.Velocity * v457)
                                break
                            end
                            if v455 == (0 - 0) then
                                v456 = (v177 - v174).Magnitude
                                v457 = v456 / v175
                                v455 = 1
                            end
                        end
                        break
                    end
                    if v454 == 0 then
                        v455 = 0
                        v456 = nil
                        v454 = 1
                    end
                end
            end
            v176 = 1
        end
    end
end
local function v24()
    local v178 = 0 + 0
    local v179
    local v180
    local v181
    local v182
    local v183
    while true do
        if 3 == v178 then
            if v181 and v181.Character then
                return v181, v181.Character:FindFirstChild("HumanoidRootPart")
            end
            return nil, nil
        end
        if v178 == (52 - (12 + 39)) then
            v181 = nil
            v182 = v19
            v178 = 2 + 0
        end
        if v178 == (5 - 3) then
            v183 = v180.Position
            for v458, v459 in ipairs(v15:GetPlayers()) do
                if v459 ~= v17 then
                    local v513 = v459.Character
                    if v513 then
                        local v559 = 0 - 0
                        local v560
                        local v561
                        while true do
                            if v559 == 0 then
                                local v615 = 0 + 0
                                local v616
                                while true do
                                    if v615 == (0 + 0) then
                                        v616 = 0 - 0
                                        while true do
                                            if v616 == 1 then
                                                v559 = 1 + 0
                                                break
                                            end
                                            if v616 == 0 then
                                                v560 = v513:FindFirstChild("HumanoidRootPart")
                                                v561 = v513:FindFirstChildOfClass("Humanoid")
                                                v616 = 4 - 3
                                            end
                                        end
                                        break
                                    end
                                end
                            end
                            if v559 == (1711 - (1596 + 114)) then
                                if v560 and v561 and (v561.Health > 0) then
                                    local v626 = 0
                                    local v627
                                    while true do
                                        if v626 == 0 then
                                            v627 = (v560.Position - v183).Magnitude
                                            if v627 < v182 then
                                                local v640 = 0 - 0
                                                local v641
                                                while true do
                                                    if v640 == 0 then
                                                        v641 = 713 - (164 + 549)
                                                        while true do
                                                            if v641 == (1438 - (1059 + 379)) then
                                                                v182 = v627
                                                                v181 = v459
                                                                break
                                                            end
                                                        end
                                                        break
                                                    end
                                                end
                                            end
                                            break
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
            v178 = 3 - 0
        end
        if v178 == (0 + 0) then
            v179, v180 = v22()
            if not v179 or not v180 then
                return nil, nil
            end
            v178 = 1
        end
    end
end
local function v25()
    local v184 = 0 + 0
    local v185
    local v186
    local v187
    local v188
    local v189
    while true do
        if v184 == (394 - (145 + 247)) then
            v189 = nil
            while true do
                if 1 == v185 then
                    v188, v189 = v24()
                    if v188 and v189 then
                        local v562 = v187.Position
                        local v563 = v23(v189, v562, v20)
                        pcall(function()
                            v18:FireServer(v563, "NewFireball")
                        end)
                    end
                    break
                end
                if v185 == (0 + 0) then
                    v186, v187 = v22()
                    if not v186 or not v187 then
                        return
                    end
                    v185 = 1 + 0
                end
            end
            break
        end
        if v184 == 1 then
            v187 = nil
            v188 = nil
            v184 = 5 - 3
        end
        if v184 == (0 + 0) then
            v185 = 0
            v186 = nil
            v184 = 1
        end
    end
end
local function v26()
    local v190 = 0
    local v191
    while true do
        if v190 == (0 + 0) then
            if
                v17.Backpack:FindFirstChild("Enygma FireBall")
                or (v17.Character and v17.Character:FindFirstChild("Enygma FireBall"))
            then
                return
            end
            v191 = Instance.new("Tool")
            v190 = 1 - 0
        end
        if v190 == (721 - (254 + 466)) then
            v191.Name = "Enygma FireBall"
            v191.RequiresHandle = false
            v190 = 562 - (544 + 16)
        end
        if v190 == 3 then
            v191.Activated:Connect(function()
                v25()
            end)
            break
        end
        if (5 - 3) == v190 then
            v191.CanBeDropped = false
            v191.Parent = v17.Backpack
            v190 = 3
        end
    end
end
v10:CreateButton({
    ["Name"] = "Auto Aim Fireball",
    ["Callback"] = function()
        v26()
    end,
})
local v27 = false
v10:CreateToggle({
    ["Name"] = "Auto Aim Fireball Spam",
    ["CurrentValue"] = false,
    ["Callback"] = function(v192)
        v27 = v192
        if v27 then
            task.spawn(function()
                while v27 do
                    local v460 = 628 - (294 + 334)
                    while true do
                        if v460 == (253 - (236 + 17)) then
                            v25()
                            task.wait(0.1 + 0)
                            break
                        end
                    end
                end
            end)
        end
    end,
})
v10:CreateSlider({
    ["Name"] = "Predict Level",
    ["Range"] = { 0 - 0, 2 + 1 },
    ["Increment"] = 0.5 + 0,
    ["CurrentValue"] = 797 - (413 + 381),
    ["Callback"] = function(v193)
        v21 = v193
    end,
})
local v16 = game:GetService("ReplicatedStorage")
local v28 = v16:FindFirstChild("Events")
local v29 = v28 and v28:FindFirstChild("CoinEvent")
local v30 = 0.1 + 0
local v31 = false
local v32 = nil
local function v33()
    local v194 = 0 - 0
    local v195
    while true do
        if v194 == (0 - 0) then
            v195 = 1970 - (582 + 1388)
            while true do
                if 0 == v195 then
                    if v32 then
                        return
                    end
                    v31 = true
                    v195 = 1
                end
                if v195 == 1 then
                    v32 = task.spawn(function()
                        while v31 do
                            local v564 = 0 - 0
                            while true do
                                if v564 == 0 then
                                    if v29 then
                                        pcall(function()
                                            v29:FireServer()
                                        end)
                                    end
                                    task.wait(v30)
                                    break
                                end
                            end
                        end
                    end)
                    break
                end
            end
            break
        end
    end
end
local function v34()
    local v196 = 0
    while true do
        if v196 == (0 + 0) then
            v31 = false
            v32 = nil
            break
        end
    end
end
local function v35(v197)
    if v197 then
        v33()
    else
        v34()
    end
end
v11:CreateToggle({
    ["Name"] = "Auto Coin",
    ["CurrentValue"] = false,
    ["Callback"] = function(v198)
        v35(v198)
    end,
})
local v15 = game:GetService("Players")
local v16 = game:GetService("ReplicatedStorage")
local v36 = game:GetService("Workspace")
local v17 = v15.LocalPlayer
local v37 = v16:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local v18 = v16:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
local v38 = v36:FindFirstChild("MAP") or Instance.new("Folder", v36)
v38.Name = "MAP"
local v40 = v38:FindFirstChild("5k_dummies") or Instance.new("Folder", v38)
v40.Name = "5k_dummies"
local v42 = v38:FindFirstChild("dummies") or Instance.new("Folder", v38)
v42.Name = "dummies"
local v44 = 364.1 - (326 + 38)
local v45 = 4
local v46 = 2 - 1
local v47 = 0 - 0
local function v22()
    local v199 = 620 - (47 + 573)
    local v200
    while true do
        if v199 == 0 then
            v200 = v17.Character or v17.CharacterAdded:Wait()
            return v200, v200:WaitForChild("Humanoid"), v200:WaitForChild("HumanoidRootPart")
        end
    end
end
local function v48(v201)
    local v202 = 0 + 0
    local v203
    while true do
        if v202 == (0 - 0) then
            v203 = v201 and v201:FindFirstChildOfClass("Humanoid")
            if v203 and (v203.Health > 0) then
                return v203
            end
            break
        end
    end
end
local function v49(v204)
    for v342, v343 in ipairs(v204:GetChildren()) do
        local v344 = v48(v343)
        if v344 then
            return v343, v344
        end
    end
end
local function v50(v205, v206)
    local v207 = 0
    local v208
    local v209
    local v210
    while true do
        if (0 - 0) == v207 then
            v208 = 1664 - (1269 + 395)
            v209 = nil
            v207 = 1
        end
        if v207 == (493 - (76 + 416)) then
            v210 = nil
            while true do
                if v208 == 0 then
                    v209 = -v206.CFrame.LookVector * v45
                    v210 = v206.Position + v209 + Vector3.new(443 - (319 + 124), 0 - 0, 0)
                    v208 = 1
                end
                if v208 == 1 then
                    v205.CFrame = CFrame.new(v210, v206.Position)
                    v205.Velocity = Vector3.zero
                    break
                end
            end
            break
        end
    end
end
local v51 = false
local v52 = false
task.spawn(function()
    while true do
        local v345, v345, v346 = v22()
        if v51 then
            local v388, v389 = v49(v40)
            if v388 and v389 then
                local v486 = v388:FindFirstChild("HumanoidRootPart")
                if v346 and v486 then
                    local v540 = 0
                    local v541
                    while true do
                        if 0 == v540 then
                            v541 = 1007 - (564 + 443)
                            while true do
                                if v541 == (0 - 0) then
                                    if (tick() - v47) >= v46 then
                                        local v636 = 0
                                        while true do
                                            if v636 == 0 then
                                                v50(v346, v486)
                                                v47 = tick()
                                                break
                                            end
                                        end
                                    end
                                    pcall(function()
                                        v18:FireServer(v486.Position, "NewFireball")
                                    end)
                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
        if v52 then
            local v390, v391 = v49(v42)
            if v390 and v391 then
                local v487 = 458 - (337 + 121)
                local v488
                while true do
                    if v487 == 0 then
                        v488 = v390:FindFirstChild("HumanoidRootPart")
                        if v346 and v488 then
                            local v601 = 0
                            local v602
                            while true do
                                if 0 == v601 then
                                    v602 = 0 - 0
                                    while true do
                                        if 0 == v602 then
                                            if (tick() - v47) >= v46 then
                                                local v642 = 0
                                                local v643
                                                while true do
                                                    if v642 == (0 - 0) then
                                                        v643 = 1911 - (1261 + 650)
                                                        while true do
                                                            if v643 == (0 + 0) then
                                                                v50(v346, v488)
                                                                v47 = tick()
                                                                break
                                                            end
                                                        end
                                                        break
                                                    end
                                                end
                                            end
                                            pcall(function()
                                                v18:FireServer(v488.Position, "NewFireball")
                                            end)
                                            break
                                        end
                                    end
                                    break
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
        task.wait(v44)
    end
end)
v11:CreateToggle({
    ["Name"] = "Auto Dummy 5K",
    ["CurrentValue"] = false,
    ["Callback"] = function(v211)
        v51 = v211
    end,
})
v11:CreateToggle({
    ["Name"] = "Auto Dummy Normal",
    ["CurrentValue"] = false,
    ["Callback"] = function(v212)
        v52 = v212
    end,
})
local v15 = game:GetService("Players")
local v16 = game:GetService("ReplicatedStorage")
local v17 = v15.LocalPlayer
local v18 = v16:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
local v53 = "Fireball"
local v54 = "Lightning"
local v55 = nil
local function v56(v213)
    local v214 = 0 - 0
    local v215
    local v216
    while true do
        if v214 == (1817 - (772 + 1045)) then
            v215 = v17.Backpack:FindFirstChild(v213)
            if v215 then
                v215:Destroy()
            end
            v214 = 1 + 0
        end
        if v214 == 1 then
            v216 = v17.Character and v17.Character:FindFirstChild(v213)
            if v216 then
                v216:Destroy()
            end
            break
        end
    end
end
local function v26()
    local v217 = 0
    local v218
    local v219
    while true do
        if 4 == v217 then
            v218.Activated:Connect(function()
                pcall(function()
                    v18:FireServer(v219.Hit.Position, "NewFireball")
                end)
            end)
            v55 = "Fireball"
            break
        end
        if v217 == 2 then
            v218.RequiresHandle = false
            v218.CanBeDropped = false
            v217 = 3
        end
        if v217 == (144 - (102 + 42)) then
            v56(v53)
            v56(v54)
            v217 = 1
        end
        if v217 == 3 then
            v218.Parent = v17.Backpack
            v219 = v17:GetMouse()
            v217 = 4
        end
        if v217 == (1845 - (1524 + 320)) then
            v218 = Instance.new("Tool")
            v218.Name = v53
            v217 = 2
        end
    end
end
local function v57()
    local v220 = 1270 - (1049 + 221)
    local v221
    local v222
    while true do
        if v220 == (158 - (18 + 138)) then
            v221.RequiresHandle = false
            v221.CanBeDropped = false
            v220 = 3
        end
        if v220 == (0 - 0) then
            v56(v53)
            v56(v54)
            v220 = 1
        end
        if (1103 - (67 + 1035)) == v220 then
            v221 = Instance.new("Tool")
            v221.Name = v54
            v220 = 350 - (136 + 212)
        end
        if v220 == (16 - 12) then
            v221.Activated:Connect(function()
                pcall(function()
                    v18:FireServer(v222.Hit.Position, "NewLightningball")
                end)
            end)
            v55 = "Lightning"
            break
        end
        if v220 == 3 then
            v221.Parent = v17.Backpack
            v222 = v17:GetMouse()
            v220 = 4 + 0
        end
    end
end
v17.CharacterAdded:Connect(function()
    local v223 = 0 + 0
    while true do
        if v223 == (1604 - (240 + 1364)) then
            task.wait(1082.5 - (1050 + 32))
            if v55 == "Fireball" then
                v26()
            elseif v55 == "Lightning" then
                v57()
            end
            break
        end
    end
end)
task.spawn(function()
    while true do
        local v347 = 0 - 0
        while true do
            if v347 == (0 + 0) then
                task.wait(1057 - (331 + 724))
                if v55 == "Fireball" then
                    local v517 = 0
                    local v518
                    while true do
                        if v517 == (0 + 0) then
                            v518 = v17.Backpack:FindFirstChild(v53)
                                or (v17.Character and v17.Character:FindFirstChild(v53))
                            if not v518 then
                                v26()
                            end
                            break
                        end
                    end
                elseif v55 == "Lightning" then
                    local v565 = 644 - (269 + 375)
                    local v566
                    while true do
                        if v565 == (725 - (267 + 458)) then
                            v566 = v17.Backpack:FindFirstChild(v54)
                                or (v17.Character and v17.Character:FindFirstChild(v54))
                            if not v566 then
                                v57()
                            end
                            break
                        end
                    end
                end
                break
            end
        end
    end
end)
v13:CreateButton({
    ["Name"] = "Fireball",
    ["Callback"] = function()
        v26()
    end,
})
v13:CreateButton({
    ["Name"] = "Lightning",
    ["Callback"] = function()
        v57()
    end,
})
local v15 = game:GetService("Players")
local v36 = game:GetService("Workspace")
local v16 = game:GetService("ReplicatedStorage")
local v17 = v15.LocalPlayer
local v18 = v16:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
local v58 = { "Griffin", "BOSSBEAR", "BOSSDEER", "CENTAUR", "CRABBOSS", "DragonGiraffe", "LavaGorilla", "BOSSDINO" }
local v44 = 0.1 - 0
local v46 = 0 - 0
local v59 = "All"
local v60 = false
local v47 = 796 - (461 + 335)
local v61 = 13 + 87
local v62 = 1762 - (1730 + 31)
local function v22()
    local v224 = v17.Character or v17.CharacterAdded:Wait()
    return v224:WaitForChild("HumanoidRootPart")
end
local function v48(v225)
    local v226 = 1667 - (728 + 939)
    local v227
    while true do
        if (0 - 0) == v226 then
            v227 = v225 and v225:FindFirstChildOfClass("Humanoid")
            if v227 and (v227.Health > (0 - 0)) then
                return v227
            end
            break
        end
    end
end
local function v63(v228)
    local v229 = 0 - 0
    local v230
    while true do
        if v229 == 0 then
            v230 = v228 and v228:FindFirstChild("Head")
            if v230 then
                local v489 = 0
                local v490
                while true do
                    if v489 == 1 then
                        v230.Size = Vector3.new(v490, v490, v490)
                        v230.Transparency = v62
                        v489 = 1070 - (138 + 930)
                    end
                    if v489 == (0 + 0) then
                        v490 = v61
                        if v228.Name == "LavaGorilla" then
                            v490 = 106 + 29
                        end
                        v489 = 1
                    end
                    if v489 == (2 + 0) then
                        v230.CanCollide = false
                        v230.Massless = true
                        break
                    end
                end
            end
            break
        end
    end
end
local function v64(v231)
    local v232 = 0 - 0
    local v233
    while true do
        if v232 == 0 then
            v233 = v231 and v231:FindFirstChild("HumanoidRootPart")
            if v233 then
                pcall(function()
                    v18:FireServer(v233.Position, "NewFireball")
                end)
            end
            break
        end
    end
end
local function v65(v234)
    local v235 = 1766 - (459 + 1307)
    local v236
    local v237
    while true do
        if v235 == (1870 - (474 + 1396)) then
            v236 = v22()
            v237 = v234 and v234:FindFirstChild("HumanoidRootPart")
            v235 = 1 - 0
        end
        if v235 == (1 + 0) then
            if v236 and v237 then
                if (tick() - v47) >= v46 then
                    local v542 = 0 + 0
                    local v543
                    while true do
                        if v542 == (0 - 0) then
                            local v603 = 0 + 0
                            while true do
                                if v603 == 0 then
                                    v543 = 166 - 116
                                    if v234.Name == "Griffin" then
                                        v543 = 305 - 235
                                    end
                                    v603 = 592 - (562 + 29)
                                end
                                if (1 + 0) == v603 then
                                    v542 = 1420 - (374 + 1045)
                                    break
                                end
                            end
                        end
                        if v542 == 2 then
                            v47 = tick()
                            break
                        end
                        if v542 == 1 then
                            v236.CFrame = v237.CFrame * CFrame.new(0 + 0, v543, 0 - 0)
                            v236.Velocity = Vector3.zero
                            v542 = 640 - (448 + 190)
                        end
                    end
                end
            end
            break
        end
    end
end
local function v66(v238)
    local v239 = nil
    local v240 = math.huge
    local v241 = math.huge
    local v242 = v22()
    for v348, v349 in ipairs(v58) do
        local v350 = 0
        local v351
        local v352
        local v353
        while true do
            if v350 == (1 + 0) then
                v353 = v351 and v351:FindFirstChild("HumanoidRootPart")
                if v352 and v353 and v242 then
                    local v519 = 0 + 0
                    local v520
                    local v521
                    while true do
                        if 0 == v519 then
                            v520 = v352.Health
                            v521 = (v242.Position - v353.Position).Magnitude
                            v519 = 1
                        end
                        if v519 == 1 then
                            if (v520 < v240) or ((v520 == v240) and (v521 < v241)) then
                                local v617 = 0 + 0
                                while true do
                                    if v617 == 1 then
                                        v239 = v351
                                        break
                                    end
                                    if v617 == (0 - 0) then
                                        v240 = v520
                                        v241 = v521
                                        v617 = 1
                                    end
                                end
                            end
                            break
                        end
                    end
                end
                break
            end
            if v350 == 0 then
                v351 = v238:FindFirstChild(v349)
                v352 = v48(v351)
                v350 = 2 - 1
            end
        end
    end
    return v239
end
task.spawn(function()
    while true do
        local v354 = 1494 - (1307 + 187)
        while true do
            if v354 == 0 then
                if v60 then
                    local v522 = 0
                    local v523
                    while true do
                        if (0 - 0) == v522 then
                            v523 = v36:FindFirstChild("NPC")
                            if v523 then
                                if v59 == "All" then
                                    local v628 = 0 - 0
                                    local v629
                                    while true do
                                        if v628 == (0 - 0) then
                                            v629 = v66(v523)
                                            if v629 then
                                                v63(v629)
                                                v65(v629)
                                                v64(v629)
                                            end
                                            break
                                        end
                                    end
                                else
                                    local v630 = 0
                                    local v631
                                    local v632
                                    while true do
                                        if v630 == (683 - (232 + 451)) then
                                            v631 = v523:FindFirstChild(v59)
                                            v632 = v48(v631)
                                            v630 = 1 + 0
                                        end
                                        if v630 == (1 + 0) then
                                            if v632 then
                                                local v644 = 564 - (510 + 54)
                                                while true do
                                                    if v644 == (1 - 0) then
                                                        v64(v631)
                                                        break
                                                    end
                                                    if (36 - (13 + 23)) == v644 then
                                                        v63(v631)
                                                        v65(v631)
                                                        v644 = 1
                                                    end
                                                end
                                            end
                                            break
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
                task.wait(v44)
                break
            end
        end
    end
end)
local v67 = { "All" }
for v243, v244 in ipairs(v58) do
    table.insert(v67, v244)
end
v11:CreateDropdown({
    ["Name"] = "Bosses",
    ["Options"] = v67,
    ["CurrentOption"] = { "All" },
    ["Callback"] = function(v245)
        v59 = v245[1]
    end,
})
v11:CreateToggle({
    ["Name"] = "Auto Boss",
    ["CurrentValue"] = false,
    ["Callback"] = function(v247)
        v60 = v247
    end,
})
local v68 = 10
local v15 = game:GetService("Players")
local v69 = game:GetService("RunService")
local v17 = v15.LocalPlayer
local v70, v71, v72
local v73 = nil
local v74 = false
local function v75(v248)
    local v249 = 0
    while true do
        if v249 == (0 - 0) then
            v70 = v248
            v71 = v70:WaitForChild("HumanoidRootPart")
            v249 = 1
        end
        if v249 == (1089 - (830 + 258)) then
            v72 = v70:WaitForChild("Humanoid")
            break
        end
    end
end
v75(v17.Character or v17.CharacterAdded:Wait())
v17.CharacterAdded:Connect(function(v250)
    v75(v250)
end)
local function v76()
    local v251 = 0
    local v252
    local v253
    while true do
        local v355 = 0 - 0
        while true do
            if v355 == 0 then
                if v251 == (2 + 0) then
                    return v252
                end
                if v251 == (1 + 0) then
                    v253 = v68
                    for v544, v545 in ipairs(v15:GetPlayers()) do
                        if
                            (v545 ~= v17)
                            and v545.Character
                            and v545.Character:FindFirstChild("HumanoidRootPart")
                            and v545.Character:FindFirstChildOfClass("Humanoid")
                            and (v545.Character.Humanoid.Health > (1441 - (860 + 581)))
                        then
                            local v592 = 0 - 0
                            local v593
                            local v594
                            while true do
                                if v592 == 0 then
                                    v593 = v545.Character.HumanoidRootPart
                                    v594 = (v71.Position - v593.Position).Magnitude
                                    v592 = 1
                                end
                                if 1 == v592 then
                                    if v594 < v253 then
                                        local v634 = 0 + 0
                                        local v635
                                        while true do
                                            if v634 == (241 - (237 + 4)) then
                                                v635 = 0
                                                while true do
                                                    if v635 == (0 - 0) then
                                                        v252 = v545
                                                        v253 = v594
                                                        break
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                    v251 = 4 - 2
                end
                v355 = 1 - 0
            end
            if v355 == (1 + 0) then
                if v251 == 0 then
                    if not v71 then
                        return nil
                    end
                    v252 = nil
                    v251 = 1
                end
                break
            end
        end
    end
end
local function v77()
    if v73 then
        return
    end
    v73 = v69.Heartbeat:Connect(function()
        local v356 = 0
        local v357
        while true do
            if v356 == 0 then
                if not v74 or not v71 then
                    return
                end
                v357 = v76()
                v356 = 1 + 0
            end
            if (3 - 2) == v356 then
                if v357 and v357.Character then
                    local v524 = 0
                    local v525
                    while true do
                        if v524 == 0 then
                            v525 = v357.Character:FindFirstChild("HumanoidRootPart")
                            if v525 then
                                v71.CFrame = CFrame.lookAt(
                                    v71.Position,
                                    Vector3.new(v525.Position.X, v71.Position.Y, v525.Position.Z)
                                )
                            end
                            break
                        end
                    end
                end
                break
            end
        end
    end)
end
local function v78()
    if v73 then
        v73:Disconnect()
        v73 = nil
    end
end
v10:CreateToggle({
    ["Name"] = "Auto Aim Punch",
    ["CurrentValue"] = false,
    ["Callback"] = function(v254)
        local v255 = 0 + 0
        while true do
            if v255 == (0 + 0) then
                v74 = v254
                if v254 then
                    v77()
                else
                    v78()
                end
                break
            end
        end
    end,
})
local v15 = game:GetService("Players")
local v69 = game:GetService("RunService")
local v79 = v15.LocalPlayer
local v80 = false
local v81 = 1452 - (85 + 1341)
local v82 = 1
local v83 = nil
local v84 = false
local v85 = false
local function v86(v256)
    if (v256 ~= v79) and v256.Character then
        local v366 = 0 - 0
        local v367
        while true do
            if v366 == 0 then
                v367 = v256.Character:FindFirstChild("HumanoidRootPart")
                if v367 then
                    local v546 = 0 - 0
                    while true do
                        if v546 == (374 - (45 + 327)) then
                            v367.CanCollide = false
                            break
                        end
                        if 0 == v546 then
                            v367.Size = Vector3.new(v81, v81, v81)
                            v367.Transparency = v82
                            v546 = 1
                        end
                        if v546 == (1 - 0) then
                            v367.BrickColor = BrickColor.new("Really red")
                            v367.Material = Enum.Material.Neon
                            v546 = 504 - (444 + 58)
                        end
                    end
                end
                break
            end
        end
    end
end
local function v87(v257)
    if (v257 ~= v79) and v257.Character then
        local v368 = v257.Character:FindFirstChild("HumanoidRootPart")
        if v368 then
            local v461 = 0 + 0
            while true do
                if v461 == (1 + 0) then
                    v368.BrickColor = BrickColor.new("Medium stone grey")
                    v368.Material = Enum.Material.Plastic
                    v461 = 2
                end
                if v461 == (0 + 0) then
                    v368.Size = Vector3.new(2, 2, 2 - 1)
                    v368.Transparency = 0
                    v461 = 1733 - (64 + 1668)
                end
                if v461 == (1975 - (1227 + 746)) then
                    v368.CanCollide = true
                    break
                end
            end
        end
    end
end
local function v88()
    if not v80 then
        return
    end
    for v358, v359 in ipairs(v15:GetPlayers()) do
        if v359 ~= v79 then
            v86(v359)
        end
    end
end
local function v89(v258)
    v258.CharacterAdded:Connect(function()
        if v80 then
            repeat
                task.wait()
            until v258.Character and v258.Character:FindFirstChild("HumanoidRootPart")
            v86(v258)
        end
    end)
end
local function v90(v259)
    local v260 = 0 - 0
    local v261
    while true do
        if v260 == (0 - 0) then
            v261 = 0
            while true do
                if (495 - (415 + 79)) == v261 then
                    for v553, v554 in ipairs(v15:GetPlayers()) do
                        if v554 ~= v79 then
                            local v595 = 0
                            while true do
                                if v595 == 0 then
                                    v89(v554)
                                    if v554.Character and v554.Character:FindFirstChild("HumanoidRootPart") then
                                        v86(v554)
                                    end
                                    break
                                end
                            end
                        end
                    end
                    v15.PlayerAdded:Connect(v89)
                    v261 = 1 + 1
                end
                if v261 == (493 - (142 + 349)) then
                    if v83 then
                        v83:Disconnect()
                    end
                    v83 = v69.Heartbeat:Connect(v88)
                    break
                end
                if v261 == (0 + 0) then
                    v80 = true
                    v81 = v259
                    v261 = 1
                end
            end
            break
        end
    end
end
local function v91()
    local v262 = 0
    local v263
    while true do
        if 0 == v262 then
            v263 = 0 - 0
            while true do
                if v263 == (1 + 0) then
                    for v555, v556 in ipairs(v15:GetPlayers()) do
                        v87(v556)
                    end
                    break
                end
                if v263 == (0 + 0) then
                    v80 = false
                    if v83 then
                        local v571 = 0
                        while true do
                            if v571 == (0 - 0) then
                                v83:Disconnect()
                                v83 = nil
                                break
                            end
                        end
                    end
                    v263 = 1865 - (1710 + 154)
                end
            end
            break
        end
    end
end
v10:CreateToggle({
    ["Name"] = "Max Reach",
    ["CurrentValue"] = false,
    ["Callback"] = function(v264)
        local v265 = 318 - (200 + 118)
        while true do
            if v265 == (0 + 0) then
                v84 = v264
                if v264 then
                    local v491 = 0
                    while true do
                        if v491 == (0 - 0) then
                            v85 = false
                            v90(38 - 12)
                            break
                        end
                    end
                elseif not v85 then
                    v91()
                end
                break
            end
        end
    end,
})
v10:CreateToggle({
    ["Name"] = "Legit Reach",
    ["CurrentValue"] = false,
    ["Callback"] = function(v266)
        local v267 = 0 + 0
        while true do
            if v267 == (0 + 0) then
                v85 = v266
                if v266 then
                    local v492 = 0 + 0
                    while true do
                        if v492 == 0 then
                            v84 = false
                            v90(2 + 5)
                            break
                        end
                    end
                elseif not v84 then
                    v91()
                end
                break
            end
        end
    end,
})
local v15 = game:GetService("Players")
local v69 = game:GetService("RunService")
local v79 = v15.LocalPlayer
local v92 = nil
local v93 = true
local v94 = false
local v95 = 2 - 1
local v96 = 1250 - (363 + 887)
local v97 = 2
local function v98()
    local v268 = 0 - 0
    local v269
    while true do
        if 0 == v268 then
            v269 = { "ALL" }
            for v462, v463 in pairs(v15:GetPlayers()) do
                if v463 ~= v79 then
                    table.insert(v269, v463.Name)
                end
            end
            v268 = 4 - 3
        end
        if v268 == (1 + 0) then
            return v269
        end
    end
end
local function v99()
    local v270 = 0 - 0
    local v271
    while true do
        if v270 == (0 + 0) then
            v271 = {}
            for v464, v465 in pairs(v15:GetPlayers()) do
                if v465 ~= v79 then
                    table.insert(v271, v465)
                end
            end
            v270 = 1665 - (674 + 990)
        end
        if v270 == 1 then
            return v271
        end
    end
end
local v100 = v98()
local v101 = v11:CreateDropdown({
    ["Name"] = "Players",
    ["Options"] = v100,
    ["CurrentOption"] = { "ALL" },
    ["MultipleOptions"] = false,
    ["Callback"] = function(v272)
        local v273 = 0 + 0
        local v274
        while true do
            if v273 == 0 then
                v274 = v272[1 - 0]
                if v274 == "ALL" then
                    local v493 = 0
                    while true do
                        if v493 == (1055 - (507 + 548)) then
                            v93 = true
                            v92 = nil
                            break
                        end
                    end
                else
                    local v494 = 837 - (289 + 548)
                    while true do
                        if v494 == 0 then
                            v93 = false
                            v92 = v15:FindFirstChild(v274)
                            break
                        end
                    end
                end
                break
            end
        end
    end,
})
v11:CreateButton({
    ["Name"] = "Refresh Players list",
    ["Callback"] = function()
        v101:Refresh(v98())
    end,
})
local function v102(v275)
    if v275 and v275.Character and v275.Character:FindFirstChild("HumanoidRootPart") then
        local v369 = 1818 - (821 + 997)
        local v370
        local v371
        while true do
            if v369 == (256 - (195 + 60)) then
                if v371 and v371:FindFirstChild("HumanoidRootPart") then
                    v371.HumanoidRootPart.CFrame = v370.CFrame * CFrame.new(0 + 0, -10, 0)
                end
                break
            end
            if v369 == 0 then
                v370 = v275.Character.HumanoidRootPart
                v371 = v79.Character
                v369 = 1
            end
        end
    end
end
v69.Stepped:Connect(function()
    if v94 then
        local v372 = 1501 - (251 + 1250)
        local v373
        while true do
            if v372 == 0 then
                v373 = v79.Character
                if v373 then
                    for v572, v573 in pairs(v373:GetDescendants()) do
                        if v573:IsA("BasePart") then
                            v573.CanCollide = false
                        end
                    end
                end
                break
            end
        end
    end
end)
task.spawn(function()
    while true do
        local v360 = 0 - 0
        while true do
            if v360 == (0 + 0) then
                if v94 then
                    if v93 then
                        local v574 = 1032 - (809 + 223)
                        local v575
                        while true do
                            if v574 == 0 then
                                v575 = v99()
                                if #v575 > (0 - 0) then
                                    if (tick() - v96) >= v97 then
                                        local v637 = 0 - 0
                                        local v638
                                        while true do
                                            if 0 == v637 then
                                                v638 = 0 - 0
                                                while true do
                                                    if v638 == 0 then
                                                        v95 = v95 + 1 + 0
                                                        if v95 > #v575 then
                                                            v95 = 1
                                                        end
                                                        v638 = 1 + 0
                                                    end
                                                    if 1 == v638 then
                                                        v96 = tick()
                                                        break
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                    v102(v575[v95])
                                end
                                break
                            end
                        end
                    else
                        v102(v92)
                    end
                end
                task.wait(617 - (14 + 603))
                break
            end
        end
    end
end)
v11:CreateToggle({
    ["Name"] = "auto player",
    ["CurrentValue"] = false,
    ["Callback"] = function(v276)
        v94 = v276
    end,
})
local v15 = game:GetService("Players")
local v103 = game:GetService("VirtualUser")
local v104 = game:GetService("VirtualInputManager")
local v17 = v15.LocalPlayer
local v105 = false
local v106 = Instance.new("ScreenGui")
v106.Name = "AntiAFK_UI"
v106.ResetOnSpawn = false
v106.Parent = v17:WaitForChild("PlayerGui")
local v110 = Instance.new("TextLabel")
v110.Size = UDim2.new(129 - (118 + 11), 49 + 251, 0, 42 + 8)
v110.Position = UDim2.new(0.5, -(437 - 287), 0.1, 949 - (551 + 398))
v110.BackgroundTransparency = 1
v110.TextScaled = true
v110.Font = Enum.Font.SourceSansBold
v110.Text = "AntiAfk By Enygma"
v110.Visible = false
v110.Parent = v106
task.spawn(function()
    while true do
        if v105 then
            v110.Visible = true
            v110.TextColor3 = Color3.fromRGB(255, 0 + 0, 0 + 0)
            task.wait(0.5 + 0)
            v110.TextColor3 = Color3.fromRGB(0, 0 - 0, 0 - 0)
            task.wait(0.5 + 0)
        else
            local v405 = 0 - 0
            while true do
                if (0 + 0) == v405 then
                    v110.Visible = false
                    task.wait(89.5 - (40 + 49))
                    break
                end
            end
        end
    end
end)
v17.Idled:Connect(function()
    if v105 then
        local v374 = 0 - 0
        local v375
        while true do
            if v374 == (490 - (99 + 391)) then
                v375 = 0 + 0
                while true do
                    if v375 == 0 then
                        v103:CaptureController()
                        v103:ClickButton2(Vector2.new())
                        break
                    end
                end
                break
            end
        end
    end
end)
task.spawn(function()
    while true do
        if v105 then
            local v406 = 0 - 0
            while true do
                if v406 == (0 - 0) then
                    v104:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    task.wait(0.05)
                    v406 = 1 + 0
                end
                if v406 == (2 - 1) then
                    v104:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    task.wait(0.05)
                    break
                end
            end
        else
            task.wait(1604.5 - (1032 + 572))
        end
    end
end)
v11:CreateToggle({
    ["Name"] = "Anti AFK",
    ["CurrentValue"] = false,
    ["Callback"] = function(v277)
        v105 = v277
    end,
})
local v15 = game:GetService("Players")
local v69 = game:GetService("RunService")
local v120 = game:GetService("UserInputService")
local v36 = game:GetService("Workspace")
local v79 = v15.LocalPlayer
local v121 = 433 - (203 + 214)
local v122 = false
local v123 = 16
local function v124()
    local v278 = 1817 - (568 + 1249)
    while true do
        if v278 == (0 + 0) then
            if v79.Character and v79.Character:FindFirstChildOfClass("Humanoid") then
                local v498 = v79.Character:FindFirstChildOfClass("Humanoid")
                v123 = v498.WalkSpeed
            end
            v122 = true
            break
        end
    end
end
local function v125()
    local v279 = 0 - 0
    while true do
        if v279 == (0 - 0) then
            v122 = false
            if v79.Character and v79.Character:FindFirstChildOfClass("Humanoid") then
                v79.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v123
            end
            break
        end
    end
end
v12:CreateInput({
    ["Name"] = "WalkSpeed",
    ["PlaceholderText"] = tostring(v121),
    ["RemoveTextAfterFocusLost"] = false,
    ["Callback"] = function(v280)
        local v281 = 1306 - (913 + 393)
        local v282
        while true do
            if v281 == 0 then
                v282 = tonumber(v280)
                if v282 then
                    v121 = v282
                end
                break
            end
        end
    end,
})
v12:CreateToggle({
    ["Name"] = "Loop WalkSpeed",
    ["CurrentValue"] = false,
    ["Flag"] = "Player_LoopWalkSpeed",
    ["Callback"] = function(v283)
        if v283 then
            v124()
        else
            v125()
        end
    end,
})
local v126 = 50
local v127 = false
local v128 = 141 - 91
local function v129()
    if v79.Character and v79.Character:FindFirstChildOfClass("Humanoid") then
        local v376 = 0
        local v377
        while true do
            if v376 == (0 - 0) then
                v377 = v79.Character:FindFirstChildOfClass("Humanoid")
                v128 = v377.JumpPower
                break
            end
        end
    end
    v127 = true
end
local function v130()
    local v284 = 410 - (269 + 141)
    while true do
        if v284 == 0 then
            v127 = false
            if v79.Character and v79.Character:FindFirstChildOfClass("Humanoid") then
                v79.Character:FindFirstChildOfClass("Humanoid").JumpPower = v128
            end
            break
        end
    end
end
v12:CreateInput({
    ["Name"] = "JumpPower",
    ["PlaceholderText"] = tostring(v126),
    ["RemoveTextAfterFocusLost"] = false,
    ["Callback"] = function(v285)
        local v286 = 0 - 0
        local v287
        while true do
            if v286 == (1981 - (362 + 1619)) then
                v287 = tonumber(v285)
                if v287 then
                    v126 = v287
                end
                break
            end
        end
    end,
})
v12:CreateToggle({
    ["Name"] = "Loop JumpPower",
    ["CurrentValue"] = false,
    ["Flag"] = "Player_LoopJumpPower",
    ["Callback"] = function(v288)
        if v288 then
            v129()
        else
            v130()
        end
    end,
})
local v131 = 1821.2 - (950 + 675)
local v132 = false
local v133 = v36.Gravity
local function v134()
    v133 = v36.Gravity
    v132 = true
end
local function v135()
    local v290 = 0 + 0
    while true do
        if v290 == (1179 - (216 + 963)) then
            v132 = false
            v36.Gravity = v133
            break
        end
    end
end
v12:CreateInput({
    ["Name"] = "Gravity Value",
    ["PlaceholderText"] = tostring(v131),
    ["RemoveTextAfterFocusLost"] = false,
    ["Callback"] = function(v291)
        local v292 = 1287 - (485 + 802)
        local v293
        while true do
            if v292 == 0 then
                v293 = tonumber(v291)
                if v293 then
                    v131 = v293
                end
                break
            end
        end
    end,
})
v12:CreateToggle({
    ["Name"] = "Loop Gravity",
    ["CurrentValue"] = false,
    ["Flag"] = "Player_LoopGravity",
    ["Callback"] = function(v294)
        if v294 then
            v134()
        else
            v135()
        end
    end,
})
local v136 = false
v120.JumpRequest:Connect(function()
    if v136 and v79.Character and v79.Character:FindFirstChildOfClass("Humanoid") then
        v79.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
v12:CreateToggle({
    ["Name"] = "Infinite Jump",
    ["CurrentValue"] = false,
    ["Flag"] = "Player_InfiniteJump",
    ["Callback"] = function(v295)
        v136 = v295
    end,
})
local v137 = false
v69.Stepped:Connect(function()
    if v137 and v79.Character then
        for v408, v409 in pairs(v79.Character:GetDescendants()) do
            if v409:IsA("BasePart") then
                v409.CanCollide = false
            end
        end
    end
end)
v12:CreateToggle({
    ["Name"] = "NoClip",
    ["CurrentValue"] = false,
    ["Flag"] = "Player_NoClip",
    ["Callback"] = function(v296)
        v137 = v296
    end,
})
if _G.FlyForRayfieldLoaded then
    return
end
_G.FlyForRayfieldLoaded = true
local v120 = game:GetService("UserInputService")
local v69 = game:GetService("RunService")
local v15 = game:GetService("Players")
local v17 = v15.LocalPlayer
local v138 = v17.Character or v17.CharacterAdded:Wait()
local v72 = v138:WaitForChild("Humanoid")
local v139 = v138:WaitForChild("HumanoidRootPart")
local v140 = 609 - (432 + 127)
local v141 = 1074 - (1065 + 8)
local v142 = false
local v143
local v144 = { F = 0, B = 0 + 0, L = 1601 - (635 + 966), R = 0 + 0, Q = 42 - (5 + 37), E = 0 }
local function v145()
    local v297 = 0 - 0
    local v298
    while true do
        if v297 == (0 + 0) then
            if not v138 or not v138:FindFirstChild("Head") then
                return
            end
            v142 = true
            v297 = 1
        end
        if v297 == (1 - 0) then
            v298 = v138.Head
            v298.Anchored = true
            v297 = 1 + 1
        end
        if v297 == 2 then
            v143 = v69.Heartbeat:Connect(function(v466)
                local v467 = v140 * 2
                local v468 = v72.MoveDirection * v467 * v466
                local v469, v470 = v298.CFrame, workspace.CurrentCamera
                local v471 = v470.CFrame
                local v472 = v469:ToObjectSpace(v471).Position
                v471 = v471 * CFrame.new(-v472.X, -v472.Y, -v472.Z + (1 - 0))
                local v473, v474 = v471.Position, v469.Position
                local v475 = CFrame.new(v473, Vector3.new(v474.X, v473.Y, v474.Z)):VectorToObjectSpace(v468)
                v298.CFrame = CFrame.new(v474) * (v471 - v473) * CFrame.new(v475)
            end)
            break
        end
    end
end
local function v146(v299)
    if (v142 == v299) or not v138 or not v138.Parent then
        return
    end
    if v299 then
        for v412, v413 in ipairs(v138:GetDescendants()) do
            if v413:IsA("BasePart") and (v413.Name ~= "HumanoidRootPart") then
                v413.Transparency = v141
            end
        end
        for v414, v415 in ipairs(v138:GetDescendants()) do
            if v415:IsA("BasePart") then
                v415.CanCollide = false
            end
        end
        v145()
    else
        local v378 = 0 - 0
        while true do
            if v378 == 0 then
                v142 = false
                if v143 then
                    v143:Disconnect()
                    v143 = nil
                end
                v378 = 1 - 0
            end
            if v378 == (2 - 1) then
                if v138 and v138:FindFirstChild("Head") then
                    v138.Head.Anchored = false
                end
                for v527, v528 in ipairs(v138:GetDescendants()) do
                    if v528:IsA("BasePart") then
                        local v576 = 0 + 0
                        while true do
                            if v576 == 0 then
                                v528.CanCollide = true
                                if v528.Name ~= "HumanoidRootPart" then
                                    v528.Transparency = 0
                                end
                                break
                            end
                        end
                    end
                end
                break
            end
        end
    end
end
local v147 = {
    [Enum.KeyCode.W] = "F",
    [Enum.KeyCode.S] = "B",
    [Enum.KeyCode.A] = "L",
    [Enum.KeyCode.D] = "R",
    [Enum.KeyCode.Q] = "Q",
    [Enum.KeyCode.E] = "E",
}
local v148 = {
    [Enum.KeyCode.W] = 530 - (318 + 211),
    [Enum.KeyCode.S] = -1,
    [Enum.KeyCode.A] = -(4 - 3),
    [Enum.KeyCode.D] = 1588 - (963 + 624),
    [Enum.KeyCode.Q] = -1,
    [Enum.KeyCode.E] = 1 + 0,
}
v120.InputBegan:Connect(function(v300, v301)
    local v302 = 846 - (518 + 328)
    while true do
        if v302 == (0 - 0) then
            if v301 or not v147[v300.KeyCode] then
                return
            end
            v144[v147[v300.KeyCode]] = v148[v300.KeyCode]
            break
        end
    end
end)
v120.InputEnded:Connect(function(v303)
    if v147[v303.KeyCode] then
        v144[v147[v303.KeyCode]] = 0 - 0
    end
end)
v17.CharacterAdded:Connect(function(v304)
    local v305 = 317 - (301 + 16)
    while true do
        if v305 == 1 then
            v138 = v304
            v72 = v304:WaitForChild("Humanoid")
            v305 = 5 - 3
        end
        if 2 == v305 then
            v139 = v304:WaitForChild("HumanoidRootPart")
            break
        end
        if v305 == (0 - 0) then
            if v143 then
                local v506 = 0 - 0
                while true do
                    if 0 == v506 then
                        v143:Disconnect()
                        v143 = nil
                        break
                    end
                end
            end
            v142 = false
            v305 = 1
        end
    end
end)
v12:CreateToggle({
    ["Name"] = "Fly spectator mode",
    ["CurrentValue"] = false,
    ["Flag"] = "FlyToggle",
    ["Callback"] = function(v306)
        v146(v306)
    end,
})
v12:CreateInput({
    ["Name"] = "Fly Speed",
    ["PlaceholderText"] = "Enter speed (1-500)",
    ["RemoveTextAfterFocusLost"] = false,
    ["Flag"] = "FlySpeedInput",
    ["Callback"] = function(v307)
        local v308 = 0 + 0
        local v309
        while true do
            if v308 == 0 then
                v309 = tonumber(v307)
                if v309 and (v309 >= 1) and (v309 <= (284 + 216)) then
                    v140 = v309
                end
                break
            end
        end
    end,
})
local v149 = false
local function v150()
    local v310 = 0
    local v311
    local v312
    local v313
    while true do
        if v310 == 0 then
            if not game.Players.LocalPlayer.Character then
                return
            end
            v149 = not v149
            v310 = 1
        end
        if v310 == (5 - 2) then
            if v149 then
                local v507 = 0 + 0
                local v508
                local v509
                local v510
                while true do
                    if v507 == (1 + 2) then
                        v509.Parent = workspace
                        v510 = Instance.new("Weld")
                        v510.Part0 = v509
                        v507 = 12 - 8
                    end
                    if (2 + 3) == v507 then
                        v509.CFrame = v508
                        for v596, v597 in pairs(v312:GetDescendants()) do
                            if v597:IsA("BasePart") or v597:IsA("Decal") then
                                v597.Transparency = 0.5
                            end
                        end
                        break
                    end
                    if v507 == 0 then
                        v508 = v313.CFrame
                        v311.Character:MoveTo(Vector3.new(-(1044.95 - (829 + 190)), 299 - 215, 4475.55 - 938))
                        task.wait(0.15 - 0)
                        v507 = 1
                    end
                    if v507 == (2 - 1) then
                        v509 = Instance.new("Seat")
                        v509.Name = "invischair"
                        v509.Anchored = false
                        v507 = 1 + 1
                    end
                    if v507 == (1 + 1) then
                        v509.CanCollide = false
                        v509.Transparency = 1
                        v509.Position = Vector3.new(-(75.95 - 50), 84, 3338.55 + 199)
                        v507 = 616 - (520 + 93)
                    end
                    if v507 == (280 - (259 + 17)) then
                        v510.Part1 = v312:FindFirstChild("Torso") or v312:FindFirstChild("UpperTorso")
                        v510.Parent = v509
                        task.wait()
                        v507 = 1 + 4
                    end
                end
            else
                local v511 = 0
                local v512
                while true do
                    if v511 == 0 then
                        local v588 = 0 + 0
                        while true do
                            if v588 == 0 then
                                v512 = workspace:FindFirstChild("invischair")
                                if v512 then
                                    v512:Destroy()
                                end
                                v588 = 3 - 2
                            end
                            if (592 - (396 + 195)) == v588 then
                                v511 = 1
                                break
                            end
                        end
                    end
                    if v511 == (2 - 1) then
                        for v598, v599 in pairs(v312:GetDescendants()) do
                            if v599:IsA("BasePart") or v599:IsA("Decal") then
                                v599.Transparency = 1761 - (440 + 1321)
                            end
                        end
                        break
                    end
                end
            end
            break
        end
        if v310 == (1831 - (1059 + 770)) then
            v313 = v312:FindFirstChild("HumanoidRootPart")
            if not v313 then
                return
            end
            v310 = 13 - 10
        end
        if v310 == (546 - (424 + 121)) then
            local v418 = 0 + 0
            while true do
                if v418 == 0 then
                    v311 = game.Players.LocalPlayer
                    v312 = v311.Character
                    v418 = 1348 - (641 + 706)
                end
                if v418 == 1 then
                    v310 = 2
                    break
                end
            end
        end
    end
end
v12:CreateToggle({
    ["Name"] = "Invisibility",
    ["CurrentValue"] = false,
    ["Flag"] = "InvisibilityToggle",
    ["Callback"] = function(v314)
        v150()
    end,
})
local function v151()
    local v315 = 0 + 0
    local v316
    local v317
    local v318
    local v319
    while true do
        if (440 - (249 + 191)) == v315 then
            v316 = game.Players.LocalPlayer
            v317 = v316:WaitForChild("Backpack")
            v315 = 1
        end
        if v315 == (4 - 3) then
            if v317:FindFirstChild("EnygmaTp") then
                v317:FindFirstChild("EnygmaTp"):Destroy()
            end
            if v316.Character and v316.Character:FindFirstChild("EnygmaTp") then
                v316.Character:FindFirstChild("EnygmaTp"):Destroy()
            end
            v315 = 1 + 1
        end
        if v315 == (7 - 5) then
            v318 = v316:GetMouse()
            v319 = Instance.new("Tool")
            v315 = 430 - (183 + 244)
        end
        if v315 == 3 then
            v319.RequiresHandle = false
            v319.Name = "EnygmaTp"
            v315 = 4
        end
        if v315 == 4 then
            v319.Activated:Connect(function()
                local v477 = v318.Hit + Vector3.new(0, 1.5 + 1, 730 - (434 + 296))
                v477 = CFrame.new(v477.X, v477.Y, v477.Z)
                local v478 = v316.Character and v316.Character:FindFirstChild("HumanoidRootPart")
                if v478 then
                    v478.CFrame = v477
                end
            end)
            v319.Parent = v317
            break
        end
    end
end
v12:CreateButton({
    ["Name"] = "Give TP Tool",
    ["Callback"] = function()
        v151()
    end,
})
local function v152()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Enygmaxit/Fly-gui/main/fly-gui.txt"))()
end
v12:CreateButton({
    ["Name"] = "Fly GUI",
    ["Callback"] = function()
        v152()
    end,
})
task.spawn(function()
    while true do
        local v361 = 0 - 0
        while true do
            if v361 == (512 - (169 + 343)) then
                task.wait(0.1)
                if v79.Character and v79.Character:FindFirstChildOfClass("Humanoid") then
                    local v532 = 0 + 0
                    local v533
                    while true do
                        if (1 - 0) == v532 then
                            if v127 then
                                v533.JumpPower = v126
                            end
                            break
                        end
                        if v532 == (0 - 0) then
                            v533 = v79.Character:FindFirstChildOfClass("Humanoid")
                            if v122 then
                                v533.WalkSpeed = v121
                            end
                            v532 = 1
                        end
                    end
                end
                v361 = 1 + 0
            end
            if v361 == 1 then
                if v132 then
                    v36.Gravity = v131
                end
                if loopHipHeight then
                    local v535 = getHumanoid()
                    if v535 then
                        v535.HipHeight = HipHeightValue
                    end
                end
                break
            end
        end
    end
end)
v12:CreateButton({
    ["Name"] = "Anti-Lag",
    ["Callback"] = function()
        local v320 = 0 - 0
        local v321
        while true do
            if v320 == (1124 - (651 + 472)) then
                v321.GlobalShadows = false
                v321.FogEnd = 100000
                v320 = 2 + 0
            end
            if 3 == v320 then
                v321.Brightness = 1
                for v479, v480 in pairs(v321:GetChildren()) do
                    if
                        v480:IsA("BloomEffect")
                        or v480:IsA("BlurEffect")
                        or v480:IsA("ColorCorrectionEffect")
                        or v480:IsA("SunRaysEffect")
                    then
                        v480.Enabled = false
                    end
                end
                v320 = 2 + 2
            end
            if v320 == 2 then
                v321.FogStart = 0
                v321.FogColor = Color3.new(1, 1 - 0, 1)
                v320 = 486 - (397 + 86)
            end
            if v320 == 0 then
                for v481, v482 in pairs(workspace:GetDescendants()) do
                    if v482:IsA("ParticleEmitter") or v482:IsA("Trail") or v482:IsA("Smoke") or v482:IsA("Fire") then
                        v482.Enabled = false
                    elseif v482:IsA("Explosion") then
                        v482:Destroy()
                    elseif v482:IsA("Decal") then
                        v482.Transparency = 1
                    elseif v482:IsA("Texture") then
                        v482:Destroy()
                    end
                end
                v321 = game:GetService("Lighting")
                v320 = 877 - (423 + 453)
            end
            if v320 == 4 then
                for v483, v484 in pairs(workspace:GetDescendants()) do
                    if v484:IsA("MeshPart") then
                        v484.RenderFidelity = Enum.RenderFidelity.Automatic
                    end
                end
                break
            end
        end
    end,
})
local v16 = game:GetService("ReplicatedStorage")
local v153 = v16:WaitForChild("Events"):WaitForChild("ClanEvent")
local v154 = "EnygmaXIT"
local v155 = "95163525434706"
v14:CreateButton({
    ["Name"] = "EnygmaXIT Clan",
    ["Callback"] = function()
        pcall(function()
            v153:FireServer({ ["action"] = "create_clan", ["clanToCreate"] = v154, ["ClanIcon"] = v155 })
        end)
    end,
})
local v15 = game:GetService("Players")
local v16 = game:GetService("ReplicatedStorage")
local v79 = v15.LocalPlayer
local v156 = v16:WaitForChild("invitationEvent")
local function v157(v322)
    if v322 and (v322 ~= v79) then
        pcall(function()
            v156:FireServer({ ["action"] = "invite_clan", ["oplr"] = v322 })
        end)
    end
end
local function v158()
    local v323 = v15:GetPlayers()
    for v362, v363 in ipairs(v323) do
        if v363 ~= v79 then
            v157(v363)
        end
    end
end
local v159 = false
local v160 = nil
local function v161()
    local v324 = 0 + 0
    while true do
        if v324 == 0 then
            if v160 then
                return
            end
            v160 = task.spawn(function()
                while v159 do
                    v158()
                    task.wait(0.05 + 0)
                end
            end)
            break
        end
    end
end
local function v162()
    local v325 = 0 + 0
    while true do
        if v325 == (0 + 0) then
            v159 = false
            v160 = nil
            break
        end
    end
end
local function v163(v326)
    local v327 = 0
    while true do
        if v327 == (0 + 0) then
            v159 = v326
            if v326 then
                v161()
            else
                v162()
            end
            break
        end
    end
end
v14:CreateToggle({
    ["Name"] = "Clan invite server",
    ["CurrentValue"] = false,
    ["Callback"] = function(v328)
        v163(v328)
    end,
})
v13:CreateButton({
    ["Name"] = "Boombox",
    ["Callback"] = function()
        local v329 = 1190 - (50 + 1140)
        local v330
        local v331
        local v332
        local v333
        local v334
        local v335
        local v336
        local v337
        while true do
            if v329 == (0 + 0) then
                if v17:FindFirstChild("PlayerGui"):FindFirstChild("BoomBoxMini") then
                    return
                end
                v330 = Instance.new("ScreenGui")
                v330.Name = "BoomBoxMini"
                v330.ResetOnSpawn = false
                v329 = 1
            end
            if v329 == (3 + 2) then
                v332.BackgroundColor3 = Color3.fromRGB(0 + 0, 287 - 87, 0)
                v332.TextColor3 = Color3.fromRGB(185 + 70, 851 - (157 + 439), 442 - 187)
                v332.TextScaled = true
                Instance.new("UICorner", v332)
                v329 = 19 - 13
            end
            if v329 == 8 then
                Instance.new("UICorner", v333)
                v334 = game:GetService("ReplicatedStorage")
                v335 = v334:WaitForChild("Events"):WaitForChild("PLAYEvent")
                v336 = nil
                v329 = 26 - 17
            end
            if 10 == v329 then
                v333.MouseButton1Click:Connect(function()
                    v337()
                end)
                break
            end
            if v329 == 6 then
                v333 = Instance.new("TextButton")
                v333.Parent = v330
                v333.Size = UDim2.new(918 - (782 + 136), 24, 855 - (112 + 743), 1187 - (1026 + 145))
                v333.Position = UDim2.new(0 + 0, 70, 0.15, 740 - (493 + 225))
                v329 = 7
            end
            if v329 == 3 then
                v331.TextColor3 = Color3.fromRGB(0, 0 - 0, 0 + 0)
                v331.TextScaled = true
                Instance.new("UICorner", v331)
                v332 = Instance.new("TextButton")
                v329 = 10 - 6
            end
            if (1 + 8) == v329 then
                function v336(v485)
                    if not v485 or (v485 == "") then
                        return
                    end
                    pcall(function()
                        v335:FireServer(v485)
                    end)
                end
                v337 = nil
                function v337()
                    pcall(function()
                        v335:FireServer("0")
                    end)
                end
                v332.MouseButton1Click:Connect(function()
                    v336(v331.Text)
                end)
                v329 = 10
            end
            if 4 == v329 then
                v332.Parent = v330
                v332.Size = UDim2.new(0 - 0, 24, 0 + 0, 26 - 10)
                v332.Position = UDim2.new(1595 - (210 + 1385), 5, 1689.15 - (1201 + 488), 14 + 8)
                v332.Text = "▶"
                v329 = 8 - 3
            end
            if v329 == 7 then
                v333.Text = "■"
                v333.BackgroundColor3 = Color3.fromRGB(358 - 158, 585 - (352 + 233), 0 - 0)
                v333.TextColor3 = Color3.fromRGB(139 + 116, 725 - 470, 255)
                v333.TextScaled = true
                v329 = 8
            end
            if v329 == 2 then
                v331.Position = UDim2.new(0, 579 - (489 + 85), 1501.15 - (277 + 1224), 1493 - (663 + 830))
                v331.PlaceholderText = "ID"
                v331.Text = ""
                v331.BackgroundColor3 = Color3.fromRGB(224 + 31, 624 - 369, 255)
                v329 = 878 - (461 + 414)
            end
            if v329 == (1 + 0) then
                v330.Parent = v17:WaitForChild("PlayerGui")
                v331 = Instance.new("TextBox")
                v331.Parent = v330
                v331.Size = UDim2.new(0 + 0, 90, 0, 2 + 14)
                v329 = 2 + 0
            end
        end
    end,
})
local v15 = game:GetService("Players")
local v16 = game:GetService("ReplicatedStorage")
local v17 = v15.LocalPlayer
local v164 = v16:WaitForChild("Events"):WaitForChild("WeaponEvent")
v13:CreateParagraph({ ["Title"] = "Premium Weapons", ["Content"] = "Secret Weapons" })
local function v165(v338)
    local v339 = 250 - (172 + 78)
    while true do
        if v339 == (0 - 0) then
            v164:FireServer(v338)
            task.wait(0.3 + 0)
            v339 = 1 - 0
        end
        if v339 == (1 + 0) then
            if v17.Character then
                v17.Character:BreakJoints()
            end
            break
        end
    end
end
v13:CreateButton({
    ["Name"] = "Premium Weapon 1",
    ["Callback"] = function()
        v165("SS4")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 2",
    ["Callback"] = function()
        v165("SS5")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 3",
    ["Callback"] = function()
        v165("SS6")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 4",
    ["Callback"] = function()
        v165("SS9")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 5",
    ["Callback"] = function()
        v165("SSS1")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 6",
    ["Callback"] = function()
        v165("SSS2")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 7",
    ["Callback"] = function()
        v165("SSS3")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 8",
    ["Callback"] = function()
        v165("SSSSSS2")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 9",
    ["Callback"] = function()
        v165("SSSSSS9")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 10",
    ["Callback"] = function()
        v165("SSSSSSS1")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 11",
    ["Callback"] = function()
        v165("SSSSSSS3")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 12",
    ["Callback"] = function()
        v165("SSSSSSS5")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 13",
    ["Callback"] = function()
        v165("SSSSSSS6")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 14",
    ["Callback"] = function()
        v165("SSSSSSSS6")
    end,
})
v13:CreateButton({
    ["Name"] = "Premium Weapon 15",
    ["Callback"] = function()
        v165("SSSSSSSS7")
    end,
})
v13:CreateButton({
    ["Name"] = "Secret Weapon 1",
    ["Callback"] = function()
        v165("SSSSSSS4")
    end,
})
v13:CreateButton({
    ["Name"] = "Secret Weapon 2",
    ["Callback"] = function()
        v165("SSSSSSS2")
    end,
})
v13:CreateButton({
    ["Name"] = "Secret Weapon 3",
    ["Callback"] = function()
        v165("SSSS2")
    end,
})
v13:CreateButton({
    ["Name"] = "Secret Weapon 4",
    ["Callback"] = function()
        v165("SSSS1")
    end,
})
local v15 = game:GetService("Players")
local v16 = game:GetService("ReplicatedStorage")
local v17 = v15.LocalPlayer
local v166 = v16:WaitForChild("Events"):WaitForChild("FireworksEvent")
local v167 = false
task.spawn(function()
    while true do
        local v364 = 0 + 0
        local v365
        while true do
            if v364 == (0 - 0) then
                v365 = 0
                while true do
                    if v365 == (0 - 0) then
                        if v167 then
                            v166:FireServer(v17)
                        end
                        task.wait()
                        break
                    end
                end
                break
            end
        end
    end
end)
v14:CreateToggle({
    ["Name"] = "Fireworks Spam",
    ["CurrentValue"] = false,
    ["Callback"] = function(v340)
        v167 = v340
    end,
})
