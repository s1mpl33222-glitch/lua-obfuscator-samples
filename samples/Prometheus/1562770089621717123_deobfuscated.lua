-- This file was generated at discord.gg/syncrypt

local v555, v559, v563, v564, v565, v566, v567, v568, v569, v576, v577, v578, v579
local v580, v581, v583, v584, v588, v590, v591, v592, v593, v594, v595, v597, v598, v599, v600, v601
local v603, v604
local v605, v606, v607, v608, v609, v610, v611, v612, v613, v614, v615, v616, v617, v618, v619, v620
local v621, v622, v623, v624, v625, v626, v627, v628
local v629, v630, v631, v632, v633, v634, v635, v636, v637, v638, v639, v640, v641, v643, v644, v645
local v646, v647, v649, v651
local v556 = "https://sparkhub.wtf/key"
local up31 = v556
local v560 = getgenv()
if v560["SparkHubKeySystem"] then
    return
else
    v559 = getgenv()
    v559.SparkHubKeySystem = true
    v559 = getgenv()
    v559.UI_CLOSED = false
    v556 = game
    v565, v559 = 32235748178594, "GetService"
    v559 = v556:GetService("TweenService")
    local up32 = v559
    v560 = game:GetService("UserInputService")
    v563 = game:GetService("CoreGui")
    v564 = game:GetService("RunService")
    local up33 = v564
    v564 = {["142823291"] = "ab0a4b56eabc57c167e7ac114e4a7e46"}
    v567 = tostring(game.PlaceId)
    v566 = function()
        local v69
        local v65 = identifyexecutor
        local v66 = v65
        if not (v65) then
            v65 = getexecutorname or function()
                return "Unknown"
            end
            v69, v66 = 8352483, v65
        end
        v65 = (v66():lower())
        local v68 = v65:find("xeno")
        v66 = v68
        if not (v68) then
            v66 = (v65:find("solara"))
        end
        if v66 then
            v66 = "xeno_solara"
            return v66
        else
            v66 = "default"
            return v66
        end
    end
    local up34 = v564[v567]
    local up35 = v566
    if up34 then
        v576 = function()
            local v179 = loadstring
            local v180 = game
            local v188 = ("https://api.luarmor.net/files/v4/loaders/" .. (up34 .. ".lua"))
            v179(v180:HttpGet(v188))()
            return
        end
        v590, v591 = pcall(v576)
        v569, v566 = v591, (not v590)
        if v566 then
            warn(("[Spark Hub] Keyless loader failed: " .. (tostring(v569))))
        end
        v576 = getgenv()
        v576.SparkHubKeySystem = nil
        return
    else
        v566 = function()
            local v91, v92, v94, v95, v97
            local v90 = tostring
            local v96 = (v90(game.PlaceId))
            local v89 = (v96 == "11815767793") or (v96 == "101993432229107")
            if v89 then
                v89 = up35()
                if (v89 == "xeno_solara") then
                    v90 = "d40809af9c8a9656fe4de72793008c15"
                    return v90
                else
                    v90 = "33ae7de816736908dbce2232d3f9f4b8"
                    return v90
                end
            else
                v89 = (v96 == "94217045453265") or (v96 == "100484168444874")
                if v89 then
                    v91 = up35()
                    if (v91 == "xeno_solara") then
                        game.Players .LocalPlayer:Kick("unsupported executor")
                        v90 = nil
                        return v90
                    else
                        v90 = "0f1e1ed816bba3a52ed4b62fae059a96"
                        return v90
                    end
                else
                    v91 = (v96 == "10449761463")
                    v89 = v91
                    if not (v91) then
                        v95 = v90
                        v91 = (v96 == "12360882630") or (v96 == "13635175275")
                        v90, v89 = v95, v91
                    end
                    if v89 then
                        v90 = "4f3ce5ad68f12541980ad94d636140e1"
                        return v90
                    else
                        v91 = (v96 == "606849621")
                        v89 = v91
                        if not (v91) then
                            v95 = v90
                            v92 = (v96 == "17190407811")
                            v91 = v92
                            if not (v92) then
                                v94 = (v96 == "17190408132")
                                v92 = v94
                                if not (v94) then
                                    v97 = v90
                                    v94 = (v96 == "108098425719662") or (v96 == "9780994092")
                                    v90, v92 = v97, v94
                                end
                                v91 = v92
                            end
                            v90, v89 = v95, v91
                        end
                        if v89 then
                            v90 = "929e5fcc132d987d208489e1ecd54c8b"
                            return v90
                        else
                            v90 = nil
                            return v90
                        end
                    end
                end
            end
        end
        v568 = v566()
        local up36 = v568
        if (not up36) then
            warn(("[Spark Hub] Unsupported game (PlaceId: " .. ((tostring(game.PlaceId)) .. ")")))
            v576 = getgenv()
            v576.SparkHubKeySystem = nil
            return
        else
            local up37
            v579 = function()
                local v290 = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))

                return v290()
            end
            v578, v577 = pcall(v579)
            v568 = v578
            if v578 then
                v568 = ((type(v577)) == "table")
            end
            if v568 then
                up37 = v577
            else
                warn(("[Spark Hub] Failed to load Luarmor API: " .. (tostring(v577))))
                up37 = nil
            end
            v577, v584, v583 = nil, "!\129.Di\004}\218+\220c\211\233!h>", 34151152451102
            v588 = function(arg19_1, arg19_2)
                local v258, v259, v261, v262, v263
                local up3 = arg19_1
                local v257 = arg19_2
                if (not up37) then
                    v259 = false
                    v262 = "Luarmor API failed to load"
                    return v259, v262
                else
                    v259 = up37
                    v259.script_id = v257
                    v262, v258 = pcall(function()
                        return up37.check_key(up3)
                    end)
                    if (not v262) then
                        v259 = false
                        v262 = ("API request failed: " .. (tostring(v258)))

                        return v259, v262
                    else
                        v261 = type(v258)
                        if (v261 ~= "table") then
                            v262 = "Invalid API response"
                            v259 = false
                            return v259, v262
                        else
                            v262 = v258.code
                            if (v262 == "KEY_VALID") then
                                v259 = true
                                v262 = "Key valid"
                                return v259, v262
                            else
                                v262 = v258.code
                                if (v262 == "KEY_EXPIRED") then
                                    v259 = false
                                    v262 = "Key has expired!"
                                    return v259, v262
                                else
                                    v262 = v258.code
                                    if (v262 == "KEY_BANNED") then
                                        v259 = false
                                        v262 = "Key is blacklisted!"
                                        return v259, v262
                                    else
                                        v262 = v258.code
                                        if (v262 == "KEY_HWID_LOCKED") then
                                            v259 = false
                                            v262 = "HWID mismatch! Reset key."
                                            return v259, v262
                                        else
                                            v262 = v258.code
                                            if (v262 == "KEY_INCORRECT") then
                                                v259 = false
                                                v262 = "Key is incorrect or deleted!"
                                                return v259, v262
                                            else
                                                v262 = v258.code
                                                if (v262 == "KEY_INVALID") then
                                                    v259 = false
                                                    v262 = "Invalid key format!"
                                                    return v259, v262
                                                else
                                                    v262 = v258.code
                                                    if (v262 == "INVALID_EXECUTOR") then
                                                        v259 = false
                                                        v262 = "Executor not supported!"
                                                        return v259, v262
                                                    else
                                                        v262 = v258.code
                                                        if (v262 == "SECURITY_ERROR") then
                                                            v259 = false
                                                            v262 = "Security validation failed!"
                                                            return v259, v262
                                                        else
                                                            v262 = v258.code
                                                            if (v262 == "TIME_ERROR") then
                                                                v259 = false
                                                                v262 = "Client time error!"
                                                                return v259, v262
                                                            else
                                                                v261 = false
                                                                v263 = v258.message
                                                                v262 = v263
                                                                if not (v263) then
                                                                    v262 = ("Check failed: " .. (tostring(v258.code)))
                                                                end
                                                                v259 = v261
                                                                return v259, v262
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
            local up38 = "sparkhub_key.txt"
            v581 = function()
                return ((type(writefile)) == "function")
            end
            v580 = pcall(v581)
            local up39 = v580
            v581 = function(arg21_1)
                local v279
                local up4 = arg21_1
                if (not up39) then
                    return
                else
                    v279 = function()
                        writefile(up38, up4)
                        return
                    end
                    pcall(v279)
                    return
                end
            end
            local up41 = v581
            v581 = function()
                local v282, v283, v284, v285
                if (not up39) then
                    v282 = nil
                    return v282
                else
                    v284 = function()
                        local v298
                        local v299 = (readfile(up38))
                        local v297 = (not v299) or (v299 == "")
                        if v297 then
                            v298 = nil
                            return v298
                        else
                            return v299
                        end
                    end
                    v283, v285 = pcall(v284)
                    v283 = ((v283 and v285) or nil)

                    return v283
                end
            end
            v584 = function()
                local v288 = function()
                    local v82 = type(delfile)
                    if (v82 == "function") then
                        delfile(up38)
                    end
                    return
                end
                pcall(v288)

                return
            end
            local up40 = v588
            v588 = v581()
            v592 = v588 and (v588 ~= "")
            if v592 then
                v593, v594 = up40(v588, up36)
                if v593 then
                    v598 = getgenv()
                    v598.script_key = v588
                    v592 = loadstring
                    v595 = game
                    v597 = ("https://api.luarmor.net/files/v4/loaders/" .. (up36 .. ".lua"))
                    v592(v595:HttpGet(v597))()
                    v598 = getgenv()
                    v598.SparkHubKeySystem = nil
                    return
                else
                    v584()
                end
            end
            v593 = v560.TouchEnabled
            v588, v592 = v593, v555
            if v593 then
                v588 = (not v560.KeyboardEnabled)
            end
            v555, v598 = v592, "workspace"
            v592 = workspace.CurrentCamera.ViewportSize
            v593 = (v592.X > v592.Y)
            v595 = (not v588)
            v594, v598 = v595, v555
            v594 = (v595 or v593)
            v555 = v598
            v597 = Color3.fromRGB(4, 4, 4)
            v599 = Color3.fromRGB(10, 10, 10)
            v601 = Color3.fromRGB(17, 17, 17)
            v604 = Color3.fromRGB(255, 255, 255)
            v606 = Color3.fromRGB(48, 48, 48)
            v608 = Color3.fromRGB(22, 22, 22)
            v610 = Color3.fromRGB(8, 8, 8)
            v612 = Color3.fromRGB(255, 255, 255)
            v614 = Color3.fromRGB(13, 13, 13)
            v616 = Color3.fromRGB(210, 210, 210)
            v618 = Color3.fromRGB(26, 26, 26)
            v620 = Color3.fromRGB(255, 255, 255)
            v622 = Color3.fromRGB(118, 118, 118)
            v624 = Color3.fromRGB(55, 55, 55)
            v626 = Color3.fromRGB(255, 255, 255)
            v628 = Color3.fromRGB(190, 62, 62)
            v630 = Color3.fromRGB(82, 182, 92)
            v632 = Color3.fromRGB(88, 101, 242)
            v634 = Color3.fromRGB(71, 82, 214)
            local up42 = {["Background"] = v597, ["Surface"] = v599, ["SurfaceAlt"] = v601, ["Border"] = v604, ["BorderDim"] = v606, ["BorderFaint"] = v608, ["Input"] = v610, ["ButtonPrimary"] = v612, ["ButtonSecondary"] = v614, ["HoverPrimary"] = v616, ["HoverSecondary"] = v618, ["TextPrimary"] = v620, ["TextSecondary"] = v622, ["TextMuted"] = v624, ["Star"] = v626, ["Error"] = v628, ["Success"] = v630, ["Discord"] = v632, ["DiscordHover"] = v634}
            local up43
            v598 = (v588 and v593)
            if v598 then
                v599 = math.min(510, (v592.X * .87))
                v601 = math.min (228, (v592.Y * .76))
                up43 = {["MainWidth"] = v599, ["MainHeight"] = v601, ["TitleBarHeight"] = 42, ["ButtonHeight"] = 33, ["InputHeight"] = 35, ["FontSizeTitle"] = 15, ["FontSizeButton"] = 12, ["FontSizeInput"] = 12, ["FontSizeStatus"] = 10, ["FontSizeInfo"] = 10, ["Padding"] = 11, ["PanelSplit"] = .55}
            else
                if v588 then
                    v600 = math.min (365, (v592.X * .93))
                    up43 = {["MainWidth"] = v600, ["MainHeight"] = 275, ["TitleBarHeight"] = 44, ["ButtonHeight"] = 36, ["InputHeight"] = 38, ["FontSizeTitle"] = 17, ["FontSizeButton"] = 13, ["FontSizeInput"] = 13, ["FontSizeStatus"] = 11, ["FontSizeInfo"] = 11, ["Padding"] = 14, ["PanelSplit"] = 1}
                else
                    up43 = {["MainWidth"] = 560, ["MainHeight"] = 290, ["TitleBarHeight"] = 46, ["ButtonHeight"] = 36, ["InputHeight"] = 40, ["FontSizeTitle"] = 20, ["FontSizeButton"] = 13, ["FontSizeInput"] = 13, ["FontSizeStatus"] = 11, ["FontSizeInfo"] = 11, ["Padding"] = 18, ["PanelSplit"] = .57}
                end
            end
            v600 = function(arg38_1, arg38_2)
                local v428, v429, v430, v431, v432, v434, v435, v438
                v428, v429 = arg38_2, "Instance"
                v429 = (Instance.new(arg38_1))
                v430, v431, v432 = pairs(v428)
                local v433 = v430
                while true do
                    v432, v435 = v433(v431, v432)
                    if not v432 then
                        break
                    end
                    v438 = v432
                    if (v438 ~= "Parent") then
                        v434 = v435
                        v429[v438] = v434
                    end
                end
                if v428["Parent"] then
                    v431 = v428.Parent
                    v429.Parent = v431
                end
                return v429
            end
            v601 = function(arg39_1, arg39_2, arg39_3, arg39_4, arg39_5)
                local v440, v441, v442, v443, v444, v447, v448, v457
                v440, v441, v442, v443, v444 = arg39_5, arg39_1, arg39_2, "TweenInfo", arg39_3
                local v445 = up32
                local v450 = TweenInfo.new
                v443 = arg39_4
                if not (arg39_4) then
                    v443 = Enum.EasingStyle.Quint
                end
                v448, v447 = v445, v440
                if not (v440) then
                    v447 = Enum.EasingDirection.Out
                end
                v445, v457 = v448, "Create"
                v457 = v445:Create(v441, (v450(v442, v443, v447)), v444)
                v457:Play()
                return v457
            end
            local up44 = v600
            local up45 = v601
            v601 = up44
            v612 = Enum.ZIndexBehavior.Sibling
            v603 = v601("ScreenGui", {["Name"] = "SparkHubKeySystem", ["Parent"] = v563, ["ResetOnSpawn"] = false, ["ZIndexBehavior"] = v612, ["DisplayOrder"] = 999, ["IgnoreGuiInset"] = true})
            local up46 = v603
            v603 = up44
            v610 = up46
            v612 = up42.Background
            v615 = UDim2.new(0.5, 0, 0.5, 0)
            v617 = Vector2.new(0.5, 0.5)
            v619 = UDim2.new(0, up43.MainWidth, 0, up43.MainHeight )
            v604 = v603("Frame", {["Name"] = "MainFrame", ["Parent"] = v610, ["BackgroundColor3"] = v612, ["Position"] = v615, ["AnchorPoint"] = v617, ["Size"] = v619, ["ClipsDescendants"] = true, ["ZIndex"] = 10})
            local up47 = v604
            v604 = up44
            v611, v610 = 16588848406060, "I\2188a\rbs\004"
            v609 = UDim.new
            v611, v612 = 0, 10
            v610 = v609(v611, v612)
            v612, v607 = "\127\200\216\1653\243", {["CornerRadius"] = v610, ["Parent"] = up47}
            v604("UICorner", v607)
            v604 = up44
            v609 = up47
            v611 = up42.Border
            v605 = v604("UIStroke", {["Parent"] = v609, ["Color"] = v611, ["Thickness"] = 1.2, ["Transparency"] = .45})
            v611, v612 = "\006d\173\221}\164\r/\193^", 29317142099283
            v604 = up44
            v611 = ColorSequence.new
            v615 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
            v616 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 75))
            v614 = ColorSequenceKeypoint.new
            v619 = Color3.fromRGB
            v612 = v611({v615, v616, v614(1, v619(255, 255, 255))})
            v606 = v604("UIGradient", {["Parent"] = v605, ["Color"] = v612, ["Rotation"] = 0})
            local up48 = v606
            task.spawn(function()
                local v458, v459, v460, v462, v463, v464, v465, v471
                while true do
                    v458 = up47
                    v459 = v458
                    if v458 then
                        v459 = up47.Parent
                    end
                    if v459 then
                        v460 = 360
                        v464 = 2
                        for v458 = 0, v460, v464 do
                            v465 = up47
                            v462, v463 = v458, (not v465)
                            v459 = v463
                            if not (v463) then
                                v459 = (not up47.Parent)
                            end
                            if not (v459) then
                                v471 = up48
                                v471.Rotation = v462
                                task.wait(.05)

                                continue
                            end
                            break
                        end
                    else
                        break
                    end
                end
                return
            end)
            v606 = up44
            v611 = up47
            v616 = UDim2.new (1, 0, 1, 0)
            v607 = v606("Frame", {["Parent"] = v611, ["BackgroundTransparency"] = 1, ["Size"] = v616, ["ClipsDescendants"] = true, ["ZIndex"] = 11})
            local up49 = v607
            v610, v607 = v555, {}
            local up50 = v607
            v612, v611 = v555, (v588 and 28)
            v610 = (v611 or 46)
            v611 = 1
            for v609 = 1, v610, v611 do
                v614 = math.random(1, 2)
                v613 = up44
                v619 = up49
                v621 = up42.Star
                v624 = UDim2.new(0, v614, 0, v614)
                v626 = UDim2.new((math.random()), 0, (math.random()), 0)
                v631 = (((math.random()) * .3) + 0.5)
                v615 = v613("Frame", {["Parent"] = v619, ["BackgroundColor3"] = v621, ["Size"] = v624, ["Position"] = v626, ["BorderSizePixel"] = 0, ["ZIndex"] = 11, ["BackgroundTransparency"] = v631})
                v613 = up44
                v621 = UDim.new(1, 0)
                v613("UICorner", {["CornerRadius"] = v621, ["Parent"] = v615})
                v613 = table.insert
                v617 = up50
                v621 = ((math.random(2, 6)) / 15000)
                v623 = (((math.random()) * 0.25) + 0.5)
                v613(v617, {["frame"] = v615, ["speed"] = v621, ["base"] = v623})
            end
            task.spawn(function()
                local v472, v473, v474, v476, v477, v479, v480, v481, v484
                while true do
                    v472 = up46
                    v473 = v472
                    if v472 then
                        v473 = up46.Parent
                    end
                    if v473 then
                        v479 = ipairs
                        for v474, v476 in v479(up50) do
                            v484 = v476.frame
                            v477 = v484
                            if v484 then
                                v477 = v476.frame.Parent
                            end
                            if v477 then
                                v477 = (v476.frame.Position.Y.Scale + v476.speed)
                                if (v477 > 1.05) then
                                    v479 = -0.05
                                    v484 = v476.frame
                                    v481 = UDim2.new((math.random()), 0, v479, 0)
                                    v484.Position = v481
                                else
                                    v484 = v476.frame
                                    v481 = UDim2.new(v476.frame.Position.X.Scale, 0, v477, 0)
                                    v484.Position = v481
                                end
                                v484 = v476.frame
                                v480 = (v476.base + ((math.sin(((tick()) * .6))) * .12))
                                v484.BackgroundTransparency = v480
                            end
                        end
                        up33.Heartbeat:Wait()
                    else
                        break
                    end
                end
                return
            end)
            v607 = task.spawn
            v610 = function()
                local v492, v493, v494, v495, v496, v497, v499, v500, v501, v502, v503, v504, v505
                while true do
                    v492 = up46
                    v493 = v492
                    if v492 then
                        v493 = up46.Parent
                    end
                    if v493 then
                        task.wait(math.random(6, 14))
                        v499 = up44
                        v495 = up49
                        v497 = up42.Star
                        v502 = UDim2.new(0, 30, 0, 2)
                        v504 = UDim2.new(1.1, 0, ((math.random()) * .4), 0)
                        v493 = v499("Frame", {["Parent"] = v495, ["BackgroundColor3"] = v497, ["Size"] = v502, ["Position"] = v504, ["Rotation"] = 25, ["BorderSizePixel"] = 0, ["ZIndex"] = 11})
                        local up7 = v493
                        v499 = up44
                        v496 = up7
                        v500 = NumberSequence.new
                        v504 = NumberSequenceKeypoint.new(0, 0)
                        v505 = NumberSequenceKeypoint.new(0.5, 0.5)
                        v503 = NumberSequenceKeypoint.new
                        v501 = v500({v504, v505, v503(1, 1)})
                        v499("UIGradient", {["Parent"] = v496, ["Transparency"] = v501})
                        v499 = up45
                        v494 = up7
                        v497 = UDim2.new
                        v504 = up7.Position.Y.Scale
                        v500 = v497(-0.2, 0, (v504 + .22), 0)
                        v499(v494, 1, {["Position"] = v500}, Enum.EasingStyle.Linear )
                        task.delay(1, function()
                            local v417 = up7
                            local v418 = v417
                            if v417 then
                                v418 = up7.Parent
                            end
                            if v418 then
                                up7:Destroy()
                            end
                            return
                        end)
                    else
                        break
                    end
                end
                return
            end
            v607(v610)
            v607 = up44
            v615 = up47
            v617 = up42.Surface
            v620 = UDim2.new(1, 0, 0, up43.TitleBarHeight)
            v609 = v607("Frame", {["Name"] = "TitleBar", ["Parent"] = v615, ["BackgroundColor3"] = v617, ["Size"] = v620, ["BorderSizePixel"] = 0, ["ZIndex"] = 15})
            v607 = up44
            v615 = UDim.new(0, 10)
            v607("UICorner", {["CornerRadius"] = v615, ["Parent"] = v609})
            v607 = up44
            v615 = up42.Surface
            v618 = UDim2.new(1, 0, 0, 12)
            v620 = UDim2.new(0, 0, 1, -12)
            v607("Frame", {["Parent"] = v609, ["BackgroundColor3"] = v615, ["Size"] = v618, ["Position"] = v620, ["BorderSizePixel"] = 0, ["ZIndex"] = 15})
            v607 = up44
            v615 = up42.BorderFaint
            v618 = UDim2.new(1, 0, 0, 1)
            v620 = UDim2.new(0, 0, 1, 0)
            v612 = {["Parent"] = v609, ["BackgroundColor3"] = v615, ["Size"] = v618, ["Position"] = v620, ["BorderSizePixel"] = 0, ["ZIndex"] = 16}
            v617, v616 = "Hw\244\136\191p", 25368135970340
            v607("Frame", v612)
            v607 = up44
            v615 = up42.Background
            v618 = UDim2.new(0, 12, 0.5, 0)
            v620 = Vector2.new(0, 0.5)
            v622 = UDim2.new(0, 30, 0, 30)
            v610 = v607("Frame", {["Parent"] = v609, ["BackgroundColor3"] = v615, ["Position"] = v618, ["AnchorPoint"] = v620, ["Size"] = v622, ["ZIndex"] = 16})
            v607 = up44
            v616 = UDim.new(0, 6)
            v617, v613 = 1812286702411, {["CornerRadius"] = v616, ["Parent"] = v610}
            v607("UICorner", v613)
            v607 = up44
            v616 = up42.BorderDim
            v607("UIStroke", {["Parent"] = v610, ["Color"] = v616, ["Thickness"] = 1})
            v607 = up44
            v619 = UDim2.new(0.5, 0, 0.5, 0)
            v621 = Vector2.new(0.5, 0.5)
            v623 = UDim2.new(.85, 0, .85, 0)
            v607("ImageLabel", {["Parent"] = v610, ["BackgroundTransparency"] = 1, ["Position"] = v619, ["AnchorPoint"] = v621, ["Size"] = v623, ["Image"] = "rbxassetid://83027430816737", ["ZIndex"] = 17})
            v607 = up44
            v621 = UDim2.new(0, 50, 0.5, 0)
            v623 = Vector2.new(0, 0.5)
            v625 = UDim2.new(0, 140, 0, 24)
            v626 = Enum.Font.GothamBlack
            v628 = up42.TextPrimary
            v630 = up43.FontSizeTitle
            v632 = Enum.TextXAlignment.Left
            v607("TextLabel", {["Parent"] = v609, ["BackgroundTransparency"] = 1, ["Text"] = "Spark Hub", ["Position"] = v621, ["AnchorPoint"] = v623, ["Size"] = v625, ["Font"] = v626, ["TextColor3"] = v628, ["TextSize"] = v630, ["TextXAlignment"] = v632, ["ZIndex"] = 16})
            v607 = up44
            v616, v617 = "\211\174\200\148\199", 29417785357698
            v616 = up42.SurfaceAlt
            v619 = UDim2.new(1, -44, 0.5, 0)
            v621 = Vector2.new(1, 0.5)
            v623 = UDim2.new(0, 82, 0, 18)
            v611 = v607("Frame", {["Parent"] = v609, ["BackgroundColor3"] = v616, ["Position"] = v619, ["AnchorPoint"] = v621, ["Size"] = v623, ["ZIndex"] = 16})
            v607 = up44
            v617 = UDim.new(1, 0)
            v607("UICorner", {["CornerRadius"] = v617, ["Parent"] = v611})
            v607 = up44
            v617 = up42.BorderDim
            v607("UIStroke", {["Parent"] = v611, ["Color"] = v617, ["Thickness"] = 1, ["Transparency"] = .4})
            v607 = up44
            v622 = UDim2.new(0.5, 0, 0.5, 0)
            v624 = Vector2.new(0.5, 0.5)
            v626 = UDim2.new(1, 0, 1, 0)
            v627 = Enum.Font.GothamBold
            v629 = up42.TextMuted
            v607("TextLabel", {["Parent"] = v611, ["BackgroundTransparency"] = 1, ["Text"] = "KEY SYSTEM", ["Position"] = v622, ["AnchorPoint"] = v624, ["Size"] = v626, ["Font"] = v627, ["TextColor3"] = v629, ["TextSize"] = 8, ["ZIndex"] = 17})
            v607 = up44
            v617 = up42.SurfaceAlt
            v622 = UDim2.new(1, -10, 0.5, 0)
            v624 = Vector2.new(1, 0.5)
            v626 = UDim2.new(0, 26, 0, 26)
            v629 = Enum.Font.GothamBold
            v633 = up42.TextMuted
            v612 = v607("TextButton", {["Parent"] = v609, ["BackgroundColor3"] = v617, ["BackgroundTransparency"] = 1, ["Position"] = v622, ["AnchorPoint"] = v624, ["Size"] = v626, ["Text"] = "X", ["Font"] = v629, ["TextSize"] = 12, ["TextColor3"] = v633, ["AutoButtonColor"] = false, ["ZIndex"] = 18})
            local up51 = v612
            v612 = up44
            v618 = UDim.new(0, 6)
            v612("UICorner", {["CornerRadius"] = v618, ["Parent"] = up51})
            up51.MouseEnter:Connect(function()
                local v514 = up45
                local v515 = up51
                local v518 = up42.TextPrimary
                v514(v515, .12, {["BackgroundTransparency"] = 0, ["TextColor3"] = v518})

                return
            end)
            v612 = up51.MouseLeave
            v614 = function()
                local v527 = up45
                local v528 = up51
                local v531 = up42.TextMuted
                v527(v528, .12, {["BackgroundTransparency"] = 1, ["TextColor3"] = v531})

                return
            end
            v612:Connect(v614)
            local up52 = function()
                local v540 = getgenv()
                v540.UI_CLOSED = true
                local v541 = up45
                local v542 = up47
                local v546 = UDim2.new(0, up43.MainWidth, 0, 0)
                v541(v542, .3, {["Size"] = v546, ["BackgroundTransparency"] = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(.35)
                up46:Destroy()
                v540 = getgenv()
                v540.SparkHubKeySystem = nil
                return
            end
            up51.MouseButton1Click:Connect(up52)
            v613 = up44
            v618 = up47
            v623 = UDim2.new(0, 0, 0, up43.TitleBarHeight)
            v625 = UDim2.new(1, 0, 1, (-up43.TitleBarHeight))
            v614 = v613("Frame", {["Parent"] = v618, ["BackgroundTransparency"] = 1, ["Position"] = v623, ["Size"] = v625, ["ZIndex"] = 15})
            v616 = v594
            if v594 then
                v616 = up43.PanelSplit
            end
            v627, v555 = 21264687589038, v555
            v615 = up44
            v613, v624 = (v616 or 1), 27968414560991
            v623 = UDim2.new
            v625, v628 = 0, 0
            v624 = v623(v625, 0, 0, v628)
            v625 = UDim2.new
            v627, v628 = 0, 1
            v626 = v625(v613, v627, v628, 0)
            v616 = v615("Frame", {["Parent"] = v614, ["BackgroundTransparency"] = 1, ["Position"] = v624, ["Size"] = v626, ["ZIndex"] = 15})
            local up53 = v616
            v616 = up43.Padding
            local up54 = v616
            v618 = up44
            v623 = up53
            v630 = UDim2.new(0, up54, 0, 14)
            v632 = UDim2.new(1, ((-up54) * 2), 0, 14)
            v633 = Enum.Font.GothamBold
            v635 = up42.TextMuted
            v639 = Enum.TextXAlignment.Left
            v618("TextLabel", {["Parent"] = v623, ["BackgroundTransparency"] = 1, ["Text"] = "ENTER YOUR KEY", ["Position"] = v630, ["Size"] = v632, ["Font"] = v633, ["TextColor3"] = v635, ["TextSize"] = 9, ["TextXAlignment"] = v639, ["ZIndex"] = 16})
            v618 = ((14 + 14) + 7)
            v619 = up44
            v624 = up53
            v626 = up42.Input
            v629 = UDim2.new(0, up54, 0, v618)
            v631 = UDim2.new(1, ((-up54) * 2), 0, up43.InputHeight)
            v620 = v619("Frame", {["Parent"] = v624, ["BackgroundColor3"] = v626, ["Position"] = v629, ["Size"] = v631, ["ZIndex"] = 16})
            local up55 = v620
            v620 = up44
            v626 = UDim.new(0, 7)
            v623, v628 = {["CornerRadius"] = v626, ["Parent"] = up55}, "a\000v\003\008'"
            v620("UICorner", v623)
            v620 = up44
            v625 = up55
            v627 = up42.BorderDim
            v621 = v620("UIStroke", {["Parent"] = v625, ["Color"] = v627, ["Thickness"] = 1, ["Transparency"] = .2})
            v628, v627 = 22174709737557, "\007z@\230\240A\178"
            local up56 = v621
            v621 = up44
            v626 = up55
            v635 = UDim2.new(0, 12, 0, 0)
            v637 = UDim2.new(1, -24, 1, 0)
            v638 = Enum.Font.Gotham
            v640 = up43.FontSizeInput
            v645 = up42.TextPrimary
            v643 = up42.TextSecondary
            v646 = Enum.TextXAlignment.Left
            v622 = v621("TextBox", {["Parent"] = v626, ["BackgroundTransparency"] = 1, ["Text"] = "", ["PlaceholderText"] = "Paste your key here...", ["Position"] = v635, ["Size"] = v637, ["Font"] = v638, ["TextSize"] = v640, ["TextColor3"] = v645, ["PlaceholderColor3"] = v643, ["TextXAlignment"] = v646, ["ClearTextOnFocus"] = false, ["ZIndex"] = 17})
            local up57 = v622
            v622 = ((v618 + up43.InputHeight) + 10)
            v623 = function(arg14_1, arg14_2, arg14_3)
                local v198, v199, v200, v201, v206, v207, v210, v212, v213, v214, v215, v216, v218, v219
                v198, v199 = arg14_2, arg14_1
                local up1 = arg14_3
                v200, v201 = 11675785909564, 19730850931683
                local v202 = up44
                v206, v207 = "\190\242{7\213s3\021{\155\142\1694\139j\137", 14157444536768
                local v204 = up53
                v207 = v202
                local v211 = up1
                v201, v206 = v211, v202
                if v211 then
                    v201 = up42.ButtonPrimary
                end
                v210, v202 = v201, v206
                if not (v201) then
                    v210 = up42.ButtonSecondary
                end
                v202, v212, v216 = v207, "}\240:\190", 16816753434262
                v206 = UDim2.new(0.5, (-(up54 + 4)), 0, up43.ButtonHeight)
                v213, v214 = "ra\000\021", 32247274912424
                v213 = Enum
                v219, v218 = 30449734334307, "ts\208\201i\135\023\245P\014"
                v212 = v213.Font .GothamBold
                v213 = up43.FontSizeButton
                local v217 = v202
                local v220 = up1
                v218 = v220
                if v220 then
                    v218 = up42.Background
                end
                v202, v215 = v202, v218
                if not (v218) then
                    v215 = up42.TextPrimary
                end
                local v226 = v217("TextButton", {["Name"] = v199, ["Parent"] = v204, ["BackgroundColor3"] = v210, ["Size"] = v206, ["Text"] = v198, ["Font"] = v212, ["TextSize"] = v213, ["TextColor3"] = v215, ["AutoButtonColor"] = false, ["ZIndex"] = 17})
                local up2 = v226
                v202 = up44
                v200 = UDim.new(0, 7)
                v204 = "Parent"
                v210 = up2
                v202("UICorner", {["CornerRadius"] = v200, [v204] = v210})
                if (not up1) then
                    v202 = up44
                    v204 = up2
                    v210 = up42.BorderDim
                    v202("UIStroke", {["Parent"] = v204, ["Color"] = v210, ["Thickness"] = 1, ["Transparency"] = .3})
                end
                v202 = up2.MouseEnter
                local v203 = function()
                    local v147, v148, v150, v151, v160
                    local v146 = up45
                    v147, v148 = .12, "0\162\172Z.5\144\218\022\017\143\025B)\127\239"
                    local v149 = up2
                    v151, v148 = v146, v146
                    local v154 = up1
                    local v152 = v154
                    if v154 then
                        v152 = up42.HoverPrimary
                    end
                    v150, v146 = v152, v148
                    if not (v152) then
                        v150 = up42.HoverSecondary
                    end
                    v146, v160 = v151, {["BackgroundColor3"] = v150}
                    v146(v149, v147, v160)

                    return
                end
                v202:Connect(v203)
                v202 = up2.MouseLeave
                v203 = function()
                    local v165, v166, v167, v176
                    local v163 = up45
                    local v164 = up2
                    v166, v167 = v163, v163
                    local v170 = up1
                    local v168 = v170
                    if v170 then
                        v168 = up42.ButtonPrimary
                    end
                    v165, v163 = v168, v167
                    if not (v168) then
                        v165 = up42.ButtonSecondary
                    end
                    v176, v163 = {["BackgroundColor3"] = v165}, v166
                    v163(v164, .12, v176)

                    return
                end
                v202:Connect(v203)

                return up2
            end
            v624 = v623("VerifyButton", "VERIFY KEY", true)
            local up58 = v624
            v624 = up58
            v628 = UDim2.new(0, up54, 0, v622)
            v624.Position = v628
            v624 = v623("GetKeyButton", "GET KEY", false)
            v628 = UDim2.new(0.5, 4, 0, v622)
            v624.Position = v628
            v626 = ((v622 + up43.ButtonHeight) + 10)
            v627 = up44
            v632 = up53
            v634 = up42.Discord
            v637 = UDim2.new(0, up54, 0, v626)
            v639 = UDim2.new(1, ((-up54) * 2), 0, up43.ButtonHeight)
            v645 = Enum.Font.GothamBold
            v643 = up43.FontSizeButton
            v647 = Color3.fromRGB(255, 255, 255)
            v628 = v627("TextButton", {["Parent"] = v632, ["BackgroundColor3"] = v634, ["Position"] = v637, ["Size"] = v639, ["Text"] = "Join Discord", ["Font"] = v645, ["TextSize"] = v643, ["TextColor3"] = v647, ["AutoButtonColor"] = false, ["ZIndex"] = 17})
            local up59 = v628
            v628 = up44
            v634 = UDim.new(0, 7)
            v628("UICorner", {["CornerRadius"] = v634, ["Parent"] = up59})
            v628 = up59.MouseEnter
            v630 = function()
                local v227 = up45
                local v228 = up59
                local v229 = up42.DiscordHover
                v227(v228, .12, {["BackgroundColor3"] = v229})

                return
            end
            v628:Connect(v630)
            up59.MouseLeave:Connect(function()
                local v238 = up45
                local v239 = up59
                local v240 = up42.Discord
                v238(v239, .12, {["BackgroundColor3"] = v240})

                return
            end)
            v628 = up44
            v633 = up53
            v638 = UDim2.new(0, up54, 1, -24)
            v640 = UDim2.new(1, ((-up54) * 2), 0, 18)
            v641 = Enum.Font.GothamMedium
            v644 = up42.TextSecondary
            v647 = up43.FontSizeStatus
            v649 = Enum.TextXAlignment.Left
            v629 = v628("TextLabel", {["Parent"] = v633, ["BackgroundTransparency"] = 1, ["Position"] = v638, ["Size"] = v640, ["Font"] = v641, ["Text"] = "", ["TextColor3"] = v644, ["TextSize"] = v647, ["TextXAlignment"] = v649, ["ZIndex"] = 16, ["TextTransparency"] = 1})
            local up60 = v629
            if v594 then
                v629 = up44
                v635 = up42.BorderFaint
                v638 = UDim2.new(v613, 0, 0, 12)
                v640 = UDim2.new(0, 1, 1, -24)
                v629("Frame", {["Parent"] = v614, ["BackgroundColor3"] = v635, ["Position"] = v638, ["Size"] = v640, ["ZIndex"] = 16, ["BorderSizePixel"] = 0})
                v629 = up44
                v638 = UDim2.new(v613, 1, 0, 0)
                v640 = UDim2.new((1 - v613), -1, 1, 0)
                v630 = v629("Frame", {["Parent"] = v614, ["BackgroundTransparency"] = 1, ["Position"] = v638, ["Size"] = v640, ["ZIndex"] = 15})
                v631 = up44
                v645 = UDim2.new(0, 16, 0, 18)
                v643 = UDim2.new(1, -16, 0, 16)
                v644 = Enum.Font.GothamBold
                v647 = up42.TextSecondary
                v651 = Enum.TextXAlignment.Left
                v631("TextLabel", {["Parent"] = v630, ["BackgroundTransparency"] = 1, ["Text"] = "How long does the", ["Position"] = v645, ["Size"] = v643, ["Font"] = v644, ["TextColor3"] = v647, ["TextSize"] = 11, ["TextXAlignment"] = v651, ["ZIndex"] = 17})
                v631 = up44
                v645 = UDim2.new(0, 16, 0, 34)
                v643 = UDim2.new(1, -16, 0, 16)
                v644 = Enum.Font.GothamBold
                v647 = up42.TextSecondary
                v651 = Enum.TextXAlignment.Left
                v631("TextLabel", {["Parent"] = v630, ["BackgroundTransparency"] = 1, ["Text"] = "key system take?", ["Position"] = v645, ["Size"] = v643, ["Font"] = v644, ["TextColor3"] = v647, ["TextSize"] = 11, ["TextXAlignment"] = v651, ["ZIndex"] = 17})
                v631 = up44
                v645 = UDim2.new(0, 16, 0, 56)
                v643 = UDim2.new(1, -16, 0, 26)
                v644 = Enum.Font.GothamBlack
                v647 = up42.TextPrimary
                v651 = Enum.TextXAlignment.Left
                v631("TextLabel", {["Parent"] = v630, ["BackgroundTransparency"] = 1, ["Text"] = "Less than 2 mins.", ["Position"] = v645, ["Size"] = v643, ["Font"] = v644, ["TextColor3"] = v647, ["TextSize"] = 15, ["TextXAlignment"] = v651, ["ZIndex"] = 17})
                v631 = up44
                v637 = up42.BorderFaint
                v640 = UDim2.new(0, 0, 1, -56)
                v645 = UDim2.new(1, -16, 0, 1)
                v631("Frame", {["Parent"] = v630, ["BackgroundColor3"] = v637, ["Position"] = v640, ["Size"] = v645, ["ZIndex"] = 16, ["BorderSizePixel"] = 0})
                v631 = up44
                v645 = UDim2.new(0, 16, 1, -50)
                v643 = UDim2.new(1, -16, 0, 16)
                v644 = Enum.Font.GothamBold
                v647 = up42.TextPrimary
                v651 = Enum.TextXAlignment.Left
                v631("TextLabel", {["Parent"] = v630, ["BackgroundTransparency"] = 1, ["Text"] = "Need help?", ["Position"] = v645, ["Size"] = v643, ["Font"] = v644, ["TextColor3"] = v647, ["TextSize"] = 11, ["TextXAlignment"] = v651, ["ZIndex"] = 17})
                v631 = up44
                v645 = UDim2.new(0, 16, 1, -34)
                v643 = UDim2.new(1, -16, 0, 14)
                v644 = Enum.Font.Gotham
                v647 = up42.TextSecondary
                v651 = Enum.TextXAlignment.Left
                v631("TextLabel", {["Parent"] = v630, ["BackgroundTransparency"] = 1, ["Text"] = "Join our Discord server.", ["Position"] = v645, ["Size"] = v643, ["Font"] = v644, ["TextColor3"] = v647, ["TextSize"] = 10, ["TextXAlignment"] = v651, ["ZIndex"] = 17})
            end
            v630 = function(arg26_1, arg26_2, arg26_3)
                local v306, v307, v308, v309
                local up5 = arg26_1
                local v305 = up60
                v306, v307 = "Q\183\136\029", arg26_3
                v305.Text = up5
                v305 = up60
                v306, v309 = v305, v305
                local v310 = arg26_2
                if arg26_2 then
                    v310 = up42.Error
                end
                v305, v308 = v306, v310
                if not (v310) then
                    v308 = up42.TextPrimary
                end
                v309.TextColor3 = v308
                up45(up60, .2, {["TextTransparency"] = 0})
                if (not v307) then
                    task.spawn(function()
                        task.wait(4)
                        local v401 = up60
                        if (v401.Text == up5) then
                            up45(up60, .35, {["TextTransparency"] = 1})
                        end
                        return
                    end)
                end
                return
            end
            local up61 = v630
            v630 = v624.MouseButton1Click
            v632 = function()
                if setclipboard then
                    setclipboard(up31)
                    up61("Get Key link copied to clipboard!", false)
                else
                    up61(up31, false, true)
                end
                return
            end
            v630:Connect(v632)
            v630 = up58.MouseButton1Click
            v632 = function()
                local v324, v325, v326, v327, v329, v330, v331, v333, v334, v335, v336
                local v328 = (up57.Text:gsub("%s+", ""))
                if (v328 == "") then
                    up61("Please enter a key!", true)
                    v329 = up55.Position
                    v326, v325 = 3, v329
                    v327 = v326
                    v330 = 1
                    for v326 = 1, v327, v330 do
                        v329 = up45
                        v333 = up55
                        v334 = (v325 + (UDim2.new(0, 4, 0, 0)))
                        v335 = Enum
                        v329(v333, .04, {["Position"] = v334}, v335.EasingStyle .Linear)
                        task.wait(.04)
                        v329 = up45
                        v333 = up55
                        v336 = UDim2.new (0, 4, 0, 0)
                        v329(v333, .04, {["Position"] = (v325 - v336)}, Enum.EasingStyle.Linear )
                        task.wait(.04)
                    end
                    up45(up55, .04, {["Position"] = v325}, Enum.EasingStyle.Linear)

                    return
                else
                    up61("Verifying...", false, true)
                    v324, v325 = up40(v328, up36)
                    if v324 then
                        up41(v328)
                        up61("Key verified!", false, true)
                        v329 = up45
                        v327 = up56
                        v333 = up42.Success
                        v329(v327, 0.25, {["Color"] = v333, ["Thickness"] = 2})
                        task.wait(1)
                        up52()
                        v324 = getgenv()
                        v324.script_key = v328
                        v329 = loadstring
                        v327 = game
                        v331 = ("https://api.luarmor.net/files/v4/loaders/" .. (up36 .. ".lua"))
                        v329(v327:HttpGet(v331))()
                    else
                        up61(v325, true)
                        v329 = up45
                        v327 = up56
                        v333 = up42.Error
                        v329(v327, 0.25, {["Color"] = v333})
                        task.wait(.8)
                        v329 = up45
                        v327 = up56
                        v333 = up42.BorderDim
                        v329(v327, 0.25, {["Color"] = v333})
                    end
                    return
                end
            end
            v630:Connect(v632)
            v630 = up57.FocusLost
            v632 = function(arg29_1)
                if arg29_1 then
                    up58.MouseButton1Click:Fire()
                end
                return
            end
            v630:Connect(v632)
            v630 = up57.Focused
            v632 = function()
                local v350 = up45
                local v351 = up56
                local v352 = up42.Border
                v350(v351, .18, {["Color"] = v352, ["Transparency"] = 0, ["Thickness"] = 1.5})

                return
            end
            v630:Connect(v632)
            up59.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard("https://discord.gg/ABwF3VcNyC")
                    up61("Discord invite copied!", false)
                else
                    up61("discord.gg/ABwF3VcNyC", false, true)
                end
                return
            end)
            local up62
            local up63
            local up64
            v635 = function(arg32_1)
                local v372, v373
                local up6 = arg32_1
                local v376 = (up6.UserInputType == Enum.UserInputType.MouseButton1)
                local v377 = v376
                if not (v376) then
                    v377 = (up6.UserInputType == Enum.UserInputType.Touch)
                end
                if v377 then
                    up62 = true
                    up63 = up6.Position
                    up64 = up47.Position
                    v373 = up6.Changed
                    v372 = function()
                        local v194 = up6.UserInputState
                        local v193 = Enum.UserInputState
                        if (v194 == v193["End"]) then
                            up62 = false
                        end
                        return
                    end
                    v373:Connect(v372)
                end
                return
            end
            v609.InputBegan :Connect(v635)
            v635 = function(arg33_1)
                local v381, v382, v385, v392, v393
                local v380 = up62
                v381, v382 = v380, arg33_1
                if v380 then
                    v385 = 990585
                    v392 = (v382.UserInputType == Enum.UserInputType.MouseMovement)
                    v380 = v392
                    if not (v392) then
                        v380 = (v382.UserInputType == Enum.UserInputType.Touch)
                    end
                    v393, v381 = v385, v380
                end
                if v381 then
                    v380 = (v382.Position - up63)
                    v393 = up47
                    v392 = UDim2.new(up64.X.Scale, (up64.X.Offset + v380.X), up64.Y.Scale, (up64.Y .Offset + v380.Y))
                    v393.Position = v392
                end
                return
            end
            v560.InputChanged :Connect(v635)
            v632 = up47
            v636 = UDim2.new(0, up43.MainWidth, 0, 0)
            v632.Size = v636
            v632 = up47
            v632.BackgroundTransparency = 1
            v632 = up45
            v635 = up47
            v640 = UDim2.new(0, up43.MainWidth, 0, up43.MainHeight)
            v632(v635, .45, {["Size"] = v640, ["BackgroundTransparency"] = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            return
        end
    end
end
