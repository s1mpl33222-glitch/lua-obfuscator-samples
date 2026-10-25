local v84 = game:GetObjects("rbxassetid://12594482248")[1]
v84.Parent = game.Players.LocalPlayer.Backpack
local v87 = _G.scanner_fps or ((48 - (5 + 37)) + (59 - 35))
local v88 = _G.disable_static or false
local v89 = v84:WaitForChild("Storage")
local v90 = v84:WaitForChild("Handle", 1 + 0 + (0 - 0))
local v91 = v89.ScreenUI
local v92 = tick()
local v93 = Instance.new("Camera")
local v94 = game:GetService("TweenService")
local v95 = game.Players.LocalPlayer
local v96 = -((2 + 1) - (3 - 1))
local v97 = (1995 - ((413 - 304) + 1885)) / v87
local v98 = false
local v99 = false
local v100 = {
    "KeyObtain",
    "LeverForGate",
    "LiveBreakerPolePickup",
    "LiveHintBook",
    "FuseObtain",
    "MinesAnchor",
    "WaterPump",
    "TimerLever",
}
local v101 = { "rbxassetid://8681113666", "rbxassetid://8681113503" }
local v102 = {}
local function v103()
    local v138 = 0 - (0 - 0)
    while true do
        if v138 == 1 then
            local v206 = 0
            local v207
            while true do
                if (317 - (301 + 16)) == v206 then
                    v207 = 0 - 0
                    while true do
                        if v207 == 0 then
                            v94
                                :Create(
                                    v91.Static2,
                                    TweenInfo.new(1 + 2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
                                    { ["ImageTransparency"] = (2 - 1) + 0 }
                                )
                                :Play()
                            v91.ViewSpecial.ImageColor3 =
                                Color3.fromRGB(566 - 349, 39 + 3 + 121 + 92, (95 - 50) + 97 + 64)
                            v207 = 1
                        end
                        if v207 == (1 + 1) then
                            v138 = (6 - 4) + 0 + 0
                            break
                        end
                        if v207 == 1 then
                            v94
                                :Create(
                                    v91.ViewSpecial,
                                    TweenInfo.new(
                                        (1019.2 - (829 + 190)) - (0 - 0),
                                        Enum.EasingStyle.Quart,
                                        Enum.EasingDirection.InOut,
                                        (41 - 8) - (30 - 7),
                                        true
                                    ),
                                    { ["ImageColor3"] = Color3.fromRGB((46 - 27) + 34, 10 + 28 + 55, 17 + 35) }
                                )
                                :Play()
                            v93.FieldOfView = (2 - 1) + 0 + 0
                            v207 = 615 - (520 + 93)
                        end
                    end
                    break
                end
            end
        end
        if (278 - (259 + 17)) == v138 then
            v94:Create(
                v93,
                TweenInfo.new(2 + 1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
                { ["FieldOfView"] = 2 + 28 }
            ):Play()
            v84.Handle.Use:Play()
            v84.Handle.Idle:Play()
            break
        end
        if (1433 - (287 + 510 + (2153 - 1517))) == v138 then
            local v208 = 591 - (396 + 195)
            while true do
                if 2 == v208 then
                    v138 = 1
                    break
                end
                if v208 == (2 - 1) then
                    v91.Static2.ImageTransparency = (3380 - (440 + 1321)) - (1427 + (2021 - (1059 + 770)))
                    v94:Create(
                        v91.Static1,
                        TweenInfo.new(13 - 10, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
                        { ["ImageTransparency"] = 545.9 - (424 + 121) }
                    ):Play()
                    v208 = 1 + 1
                end
                if v208 == (1347 - (641 + 706)) then
                    v91.OffScreen.Visible = false
                    v91.Static1.ImageTransparency = 0 - (0 + 0)
                    v208 = 441 - (249 + 191)
                end
            end
        end
    end
end
local function v104()
    local v139 = (0 - 0) + 0 + 0
    while true do
        if v139 == ((15 - 11) - (429 - (183 + 244))) then
            local v209 = 0 + 0
            while true do
                if v209 == (730 - (434 + 296)) then
                    v91.OffScreen.BackgroundColor3 =
                        Color3.fromRGB(36 + (9 - 6), 27 + 32, (871 - (169 + 343)) - (192 + 118 + 16))
                    v94
                        :Create(
                            v91.OffScreen,
                            TweenInfo.new(
                                (2248 - 970) - ((927 - 611) + 787 + 173),
                                Enum.EasingStyle.Quart,
                                Enum.EasingDirection.Out,
                                (0 - 0) + (1123 - (651 + 472))
                            ),
                            { ["BackgroundColor3"] = Color3.fromRGB(3 + 0 + 0, 3 + 3, (2 - 0) + (483 - (397 + 86))) }
                        )
                        :Play()
                    v209 = 877 - (423 + 453)
                end
                if v209 == (1 + 0) then
                    v139 = (2 + 9) - (7 + 1)
                    break
                end
            end
        end
        if v139 == ((443 + 111) - (75 + 8 + (1658 - (50 + 1140)))) then
            v84.Handle.Disable:Play()
            v84.Handle.Idle:Stop()
            break
        end
        if v139 == ((1562 + 244) - (710 + 492 + 38 + 566)) then
            local v210 = 0
            while true do
                if v210 == (0 - 0) then
                    v91.OffScreen.Visible = true
                    v91.OffScreen.Frame.Size =
                        UDim2.new((3 + 1) - (599 - (157 + 439)), 0 - 0, (3 - 2) - (0 - 0), 918 - (782 + 136))
                    v210 = 856 - (112 + 743)
                end
                if v210 == 1 then
                    v139 = 2 - 1
                    break
                end
            end
        end
        if v139 == (1172 - (1026 + 145)) then
            local v211 = 0 + 0
            while true do
                if v211 == (719 - (493 + 225)) then
                    v139 = 2
                    break
                end
                if v211 == 0 then
                    v94
                        :Create(
                            v91.OffScreen.Frame,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            { ["Size"] = UDim2.new(
                                3 - 2,
                                (198 + 127) - ((120 - 75) + 6 + 274),
                                (0.1 - 0) + 0 + 0,
                                0 - 0
                            ) }
                        )
                        :Play()
                    task.delay(1595.31 - (210 + 1385), function()
                        v94:Create(
                            v91.OffScreen.Frame,
                            TweenInfo.new(
                                0.4 + (1689 - (1201 + 488)),
                                Enum.EasingStyle.Quad,
                                Enum.EasingDirection.In,
                                0
                            ),
                            {
                                ["Size"] = UDim2.new(
                                    0 + 0 + 0,
                                    (0 - 0) + (0 - 0),
                                    (585.1 - (352 + 233)) + (0 - 0),
                                    (0 + 0) - 0
                                ),
                            }
                        ):Play()
                    end)
                    v211 = 1
                end
            end
        end
    end
end
local function v105()
    local v140 = 0 - 0
    local v141
    local v142
    while true do
        if v140 == (575 - (489 + 85)) then
            while true do
                if v141 == 1 then
                    v142 = v101[math.random(1502 - (277 + 1224), #v101)]
                    v91.Static1.Image = v142
                    break
                end
                if v141 == (0 + (1493 - (663 + 830))) then
                    local v323 = 0 + 0
                    while true do
                        if v323 == (2 - 1) then
                            v141 = (1602 - (461 + 414)) - (39 + 189 + 200 + 298)
                            break
                        end
                        if (0 + 0) == v323 then
                            v91.Static1.Position = UDim2.new(
                                1772.5 - (1709 + 24 + (289 - (172 + 78))),
                                math.random(-((121 - 45) - (18 + 30)), 1062 - ((180 - 55) + 248 + 661))
                                    * ((653 + 1301) - ((1836 - 740) + (1072 - 220))),
                                0.5 + 0 + 0 + 0,
                                math.random(-(25 - 7), 7 + 11 + (0 - 0)) * (518 - (409 + (239 - 136)))
                            )
                            v91.Static2.Position = UDim2.new(
                                0.5,
                                math.random(-(9 + 19), (151 + 113) - (46 + (637 - (133 + 314)))) * (2 + 4),
                                (308.5 - (199 + 14)) - ((182 - 131) + (1593 - (647 + 902))),
                                math.random(
                                    -((17 - 11) + (245 - (85 + 148))),
                                    1335 - ((2403 - (426 + 863)) + (950 - 747))
                                ) * 6
                            )
                            v323 = 1655 - (873 + 781)
                        end
                    end
                end
            end
            break
        end
        if v140 == (0 - 0) then
            local v212 = 0 - 0
            while true do
                if v212 == (1 + 0) then
                    v140 = 3 - 2
                    break
                end
                if v212 == (0 - 0) then
                    v141 = (5674 - 3763) - ((2287 - (414 + 1533)) + 1363 + 208)
                    v142 = nil
                    v212 = 556 - (443 + 112)
                end
            end
        end
    end
end
local function v106(v143)
    local v144 = 0
    local v145
    local v146
    local v147
    local v148
    while true do
        if v144 == 2 then
            while true do
                if v145 == (0 + (1479 - (888 + 591))) then
                    local v324 = 0 + (0 - 0)
                    while true do
                        if v324 == ((38 + 626) - ((655 - 481) + 191 + 298)) then
                            v145 = (1 + 1) - (1 + 0)
                            break
                        end
                        if v324 == ((3630 - 1725) - ((1537 - 707) + (2753 - (136 + 1542)))) then
                            v146 = Instance.new("Model", v91.ViewNormal)
                            v146.Name = v143.Name
                            v324 = (1721 - 1196) - (301 + 2 + (351 - 130))
                        end
                    end
                end
                if (1271 - (231 + 1038)) == v145 then
                    for v357, v358 in pairs(v143:GetDescendants()) do
                        v147(v358)
                    end
                    v148 = v143.DescendantAdded:Connect(function(v359)
                        v147(v359)
                    end)
                    v145 = 3
                end
                if v145 == (3 + 0) then
                    v146.AncestryChanged:Connect(function()
                        v148:Disconnect()
                    end)
                    break
                end
                if v145 == ((842 + 321) - ((657 - (68 + 418)) + (2686 - 1695))) then
                    v147 = nil
                    function v147(v360)
                        local v361 = 0
                        local v362
                        local v363
                        while true do
                            if v361 == (1 - 0) then
                                while true do
                                    if v362 == (0 + 0) then
                                        v363 = (1092 - (770 + 322)) - (0 + 0)
                                        while true do
                                            if ((0 + 0) - (0 + 0)) == v363 then
                                                if
                                                    v360:IsA("BasePart")
                                                    and (v360.Transparency ~= (1 + (0 - 0)))
                                                    and (v360.Size.Magnitude > (0.2 - 0))
                                                then
                                                    local v497 = (0 - 0) - (0 - 0)
                                                    local v498
                                                    while true do
                                                        if v497 == ((3 - 2) - (0 + 0)) then
                                                            v498.Parent = v146
                                                            if not v360.Anchored then
                                                                task.spawn(function()
                                                                    local v532 = 0 - 0
                                                                    local v533
                                                                    while true do
                                                                        if v532 == (0 + 0) then
                                                                            v533 = (0 + 0) - (0 + 0)
                                                                            while true do
                                                                                if
                                                                                    v533
                                                                                    == (
                                                                                        (4699 - 3451) - (
                                                                                            (154 - 43) + 1137
                                                                                        )
                                                                                    )
                                                                                then
                                                                                    while
                                                                                        task.wait(
                                                                                            (54.5 + 104)
                                                                                                - (91 + (308 - 241))
                                                                                        )
                                                                                    do
                                                                                        if
                                                                                            not v360 or not v360.Parent
                                                                                        then
                                                                                            break
                                                                                        end
                                                                                        v498.Position = v360.Position
                                                                                    end
                                                                                    v498:Destroy()
                                                                                    break
                                                                                end
                                                                            end
                                                                            break
                                                                        end
                                                                    end
                                                                end)
                                                            end
                                                            break
                                                        end
                                                        if v497 == ((0 - 0) - (0 + 0)) then
                                                            v498 = v360:Clone()
                                                            v498.CanQuery = false
                                                            v497 = 4 - 3
                                                        end
                                                    end
                                                end
                                                if v360:IsA("Model") and table.find(v100, v360.Name) then
                                                    local v499 = 0
                                                    local v500
                                                    local v501
                                                    while true do
                                                        if v499 == 1 then
                                                            while true do
                                                                if v500 == (832 - (762 + 69)) then
                                                                    v501.Parent = v91.ViewSpecial
                                                                    break
                                                                end
                                                                if v500 == (0 + 0) then
                                                                    local v536 = 0
                                                                    local v537
                                                                    while true do
                                                                        if 0 == v536 then
                                                                            v537 = 0
                                                                            while true do
                                                                                if
                                                                                    (523 - ((1369 - 946) + 100)) == v537
                                                                                then
                                                                                    local v551 = 0
                                                                                    while true do
                                                                                        if 1 == v551 then
                                                                                            v537 = 1 + 0 + 0
                                                                                            break
                                                                                        end
                                                                                        if v551 == (0 + 0) then
                                                                                            v501 = v89.Star:Clone()
                                                                                            v501.CFrame = v360.PrimaryPart.CFrame
                                                                                                or v360:GetPivot()
                                                                                            v551 = 2 - 1
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if v537 == (2 - (1 + 0)) then
                                                                                    v500 = 1 + 0 + 0
                                                                                    break
                                                                                end
                                                                            end
                                                                            break
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            break
                                                        end
                                                        if (0 - 0) == v499 then
                                                            v500 = 0
                                                            v501 = nil
                                                            v499 = 1
                                                        end
                                                    end
                                                end
                                                break
                                            end
                                        end
                                        break
                                    end
                                end
                                break
                            end
                            if v361 == (157 - (8 + 149)) then
                                v362 = (1320 - (1199 + 121)) - (0 - 0)
                                v363 = nil
                                v361 = 1
                            end
                        end
                    end
                    v145 = (1744 - 971) - (135 + 191 + 445)
                end
            end
            break
        end
        if v144 == (0 - 0) then
            v145 = 0 - 0
            v146 = nil
            v144 = 1
        end
        if v144 == (1 + 0) then
            local v213 = 0
            while true do
                if v213 == (1808 - (518 + 1289)) then
                    v144 = 2 - 0
                    break
                end
                if v213 == 0 then
                    v147 = nil
                    v148 = nil
                    v213 = 1
                end
            end
        end
    end
end
local function v107()
    for v157, v158 in pairs(v91.ViewNormal:GetChildren()) do
        if v158:IsA("Model") then
            v158:Destroy()
        end
    end
    for v159, v160 in pairs(v91.ViewSpecial:GetChildren()) do
        if v160:IsA("BasePart") then
            v160:Destroy()
        end
    end
end
v93.Parent = v91
v93.FieldOfView = 218 - (23 + 145)
v91.ViewNormal.CurrentCamera = v93
v91.ViewSpecial.CurrentCamera = v93
v84.Activated:Connect(function()
    local v149 = 0 - (0 - 0)
    local v150
    while true do
        if ((0 + 0) - 0) == v149 then
            v150 = 469 - (304 + 165)
            while true do
                if v150 == ((673 + 39) - ((690 - (54 + 106)) + 181)) then
                    v103()
                    break
                end
                if v150 == ((2850 - (1618 + 351)) - (434 + 180 + 267)) then
                    local v325 = 1016 - (10 + 1006)
                    local v326
                    while true do
                        if v325 == 0 then
                            v326 = 0 + 0
                            while true do
                                if v326 == (0 + 0) then
                                    if not (v92 <= tick()) then
                                        return
                                    end
                                    if v92 <= tick() then
                                        local v466 = (103 - 71) - (19 + (1046 - (912 + 121)))
                                        local v467
                                        while true do
                                            if v466 == ((0 + 0) - (1289 - (1140 + 149))) then
                                                v467 = 0 - (0 + 0)
                                                while true do
                                                    if (5 - (3 - 0)) == v467 then
                                                        if not v98 then
                                                            return v104()
                                                        end
                                                        break
                                                    end
                                                    if (0 + 0) == v467 then
                                                        local v517 = 0 - 0
                                                        local v518
                                                        while true do
                                                            if v517 == (0 - 0) then
                                                                v518 = 0
                                                                while true do
                                                                    if v518 == (0 + 0) then
                                                                        v92 = tick() + (0.5 - 0)
                                                                        v102.fire:Play(
                                                                            (186.05 - (165 + 21)) + 0,
                                                                            1 - (111 - (61 + 50)),
                                                                            1 + 0
                                                                        )
                                                                        v518 = 4 - 3
                                                                    end
                                                                    if v518 == (1 - 0) then
                                                                        v467 = 1 - (0 + 0)
                                                                        break
                                                                    end
                                                                end
                                                                break
                                                            end
                                                        end
                                                    end
                                                    if v467 == (1461 - (1295 + 165)) then
                                                        local v519 = 0 + 0
                                                        while true do
                                                            if v519 == (1 + 0) then
                                                                v467 = (1400 - (819 + 578)) - 1
                                                                break
                                                            end
                                                            if 0 == v519 then
                                                                task.wait(1812.2 - (1293 + (1921 - (331 + 1071))))
                                                                v98 = not v98
                                                                v519 = 1
                                                            end
                                                        end
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                    v326 = 1
                                end
                                if v326 == (744 - (588 + 155)) then
                                    v150 = 1283 - (546 + 736)
                                    break
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
end)
v84.Equipped:Connect(function()
    local v151 = 0 - 0
    local v152
    local v153
    while true do
        if (1940 - (1834 + 103)) == v151 then
            local v214 = 0 + 0
            while true do
                if (0 - 0) == v214 then
                    if v153 and (v91.ViewNormal:FindFirstChild(v152) == nil) then
                        v106(v153)
                    end
                    task.wait(1766.2 - (1536 + 230))
                    v214 = 492 - (128 + 363)
                end
                if v214 == (1 + 0) then
                    v99 = true
                    v151 = 9 - 5
                    break
                end
            end
        end
        if v151 == (1 + 1) then
            local v215 = 0 - 0
            local v216
            while true do
                if v215 == (0 - 0) then
                    v216 = 0 - 0
                    while true do
                        if v216 == (1 + 0) then
                            v153 = workspace.CurrentRooms:FindFirstChild(v152)
                            v151 = 1012 - (615 + 394)
                            break
                        end
                        if v216 == (0 + 0) then
                            v152 = v95:GetAttribute("CurrentRoom")
                            v96 = v152
                            v216 = 1 + 0
                        end
                    end
                    break
                end
            end
        end
        if v151 == 1 then
            local v217 = 0 - 0
            while true do
                if v217 == (4 - 3) then
                    v91.Adornee = v84:WaitForChild("Handle"):WaitForChild("Screen")
                    v151 = (654 - (59 + 592)) - 1
                    break
                end
                if v217 == 0 then
                    v91.Parent = v95.PlayerGui
                    v91.Enabled = true
                    v217 = 2 - 1
                end
            end
        end
        if v151 == (0 - (0 - 0)) then
            for v237, v238 in pairs(v84:WaitForChild("Animations"):GetChildren()) do
                v102[v238.Name] = v95.Character.Humanoid:LoadAnimation(v238)
            end
            v102.equip:Play()
            v102.idle:Play()
            v151 = 1 + 0
        end
        if ((180 - (70 + 101)) - (12 - 7)) == v151 then
            v98 = true
            v103()
            while v99 do
                if v98 then
                    local v331 = 0 + 0 + (0 - 0)
                    local v332
                    local v333
                    while true do
                        if v331 == ((241 - (123 + 118)) + 0 + 0) then
                            v332, v333 = pcall(function()
                                local v422 = 0 + 0
                                while true do
                                    if v422 == ((1399 - (653 + 746)) - (0 - 0)) then
                                        v152 = v95:GetAttribute("CurrentRoom")
                                        if not v88 then
                                            local v470 = 0 - 0
                                            local v471
                                            while true do
                                                if v470 == 0 then
                                                    v471 = 0 - 0
                                                    while true do
                                                        if v471 == (1 + 0 + 0) then
                                                            v105()
                                                            break
                                                        end
                                                        if v471 == (0 + 0) then
                                                            local v523 = 0 + 0
                                                            while true do
                                                                if v523 == (1 + 0) then
                                                                    v471 = (1 + 0) - 0
                                                                    break
                                                                end
                                                                if v523 == 0 then
                                                                    v93.CFrame = v84.Handle.Screen.CFrame
                                                                        * CFrame.Angles(
                                                                            0 + (0 - 0),
                                                                            2.15 + 1 + 0,
                                                                            (2024 - 928)
                                                                                - ((1943 - (885 + 349)) + 308 + 79)
                                                                        )
                                                                    v91.ViewNormal.LightDirection = v93.CFrame.LookVector
                                                                        - Vector3.new(
                                                                            (5066 - 3208)
                                                                                - ((1957 - 1284) + (2153 - (915 + 53))),
                                                                            (803 - (768 + 33)) - 1,
                                                                            (0 - 0) - (0 - 0)
                                                                        )
                                                                    v523 = 329 - (287 + 41)
                                                                end
                                                            end
                                                        end
                                                    end
                                                    break
                                                end
                                            end
                                        end
                                        v422 = (848 - (638 + 209)) + 0 + 0
                                    end
                                    if v422 == (1687 - (96 + 1590)) then
                                        local v462 = 0
                                        while true do
                                            if v462 == (1673 - (741 + 931)) then
                                                v422 = 1 + 1 + (0 - 0)
                                                break
                                            end
                                            if 0 == v462 then
                                                if v88 and not v91.Static1.Visible then
                                                    local v502 = 0 - 0
                                                    local v503
                                                    while true do
                                                        if v502 == (0 + 0) then
                                                            v503 = 0 + 0
                                                            while true do
                                                                if 0 == v503 then
                                                                    v91.Static1.Visible = false
                                                                    v91.Static2.Visible = false
                                                                    break
                                                                end
                                                            end
                                                            break
                                                        end
                                                    end
                                                end
                                                for v495, v496 in pairs(v91.ViewSpecial:GetChildren()) do
                                                    if v496:IsA("BasePart") then
                                                        v496.CFrame = CFrame.new(v496.Position, v93.CFrame.Position)
                                                    end
                                                end
                                                v462 = 1 + 0
                                            end
                                        end
                                    end
                                    if v422 == ((7 - 5) - (0 + 0)) then
                                        if v152 ~= v96 then
                                            local v472 = 0 + 0
                                            local v473
                                            while true do
                                                if v472 == (0 - 0) then
                                                    v473 = 0
                                                    while true do
                                                        if v473 == (0 + 0 + 0) then
                                                            local v524 = 494 - (64 + 430)
                                                            local v525
                                                            while true do
                                                                if v524 == (0 + 0) then
                                                                    v525 = 0
                                                                    while true do
                                                                        if (364 - (106 + 257)) == v525 then
                                                                            v473 = (1 + 0) - 0
                                                                            break
                                                                        end
                                                                        if v525 == 0 then
                                                                            v96 = v152
                                                                            v103()
                                                                            v525 = 722 - (496 + 225)
                                                                        end
                                                                    end
                                                                    break
                                                                end
                                                            end
                                                        end
                                                        if v473 == ((1 - 0) - (0 - 0)) then
                                                            local v526 = 1658 - (256 + 1402)
                                                            local v527
                                                            while true do
                                                                if 0 == v526 then
                                                                    v527 = 0
                                                                    while true do
                                                                        if 1 == v527 then
                                                                            v473 = 1901 - (30 + 1869)
                                                                            break
                                                                        end
                                                                        if v527 == (1369 - (213 + 1156)) then
                                                                            v107()
                                                                            v153 =
                                                                                workspace.CurrentRooms:FindFirstChild(
                                                                                    v152
                                                                                )
                                                                            v527 = 189 - (96 + 92)
                                                                        end
                                                                    end
                                                                    break
                                                                end
                                                            end
                                                        end
                                                        if
                                                            v473 == ((321 + 1561) - ((1345 - (142 + 757)) + 1169 + 265))
                                                        then
                                                            if
                                                                v153 and (v91.ViewNormal:FindFirstChild(v152) == nil)
                                                            then
                                                                v106(v153)
                                                            end
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
                            end)
                            if v333 then
                                warn(v333)
                            end
                            break
                        end
                    end
                end
                if not v99 then
                    break
                end
                task.wait(v97)
            end
            break
        end
    end
end)
v84.Unequipped:Connect(function()
    local v154 = 0 + 0
    while true do
        if v154 == 0 then
            local v218 = 79 - (32 + 47)
            while true do
                if v218 == (1977 - (1053 + 924)) then
                    v91.Parent = script
                    v91.Enabled = false
                    v218 = 1
                end
                if v218 == (1 + 0) then
                    v154 = (2210 - 926) - ((2688 - (685 + 963)) + (493 - 250))
                    break
                end
            end
        end
        if v154 == (1 - 0) then
            local v219 = 1709 - (541 + 1168)
            local v220
            while true do
                if v219 == 0 then
                    v220 = 1597 - (645 + 952)
                    while true do
                        if v220 == (838 - (669 + 169)) then
                            v99 = false
                            for v423, v424 in pairs(v90:GetChildren()) do
                                if v424:IsA("Sound") then
                                    v424:Stop()
                                end
                            end
                            v220 = 3 - 2
                        end
                        if (1 - 0) == v220 then
                            v154 = 1 + 1
                            break
                        end
                    end
                    break
                end
            end
        end
        if v154 == (5 - 3) then
            local v221 = 0 + 0
            while true do
                if v221 == 0 then
                    v84.Handle.Disable:Play()
                    v107()
                    v221 = 766 - (181 + 584)
                end
                if v221 == 1 then
                    v154 = 1850 - ((1954 - (665 + 730)) + (3712 - 2424))
                    break
                end
            end
        end
        if ((3943 - 2009) - (609 + 1322)) == v154 then
            v102.equip:Stop()
            v102.idle:Stop()
            break
        end
    end
end)
