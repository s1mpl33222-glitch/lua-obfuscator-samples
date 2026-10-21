-- This file was generated at discord.gg/syncrypt

local spilledValues1 = {}
local capturedValues1 = {}


while true do
    task.wait ()
    spilledValues1.value1 = game:IsLoaded()
    if spilledValues1.value1 then
        break
    end
end
spilledValues1.value2, spilledValues1.value3 = 12834712622936, 4828406859976
local v894 = "Games Hub"
capturedValues1.value1 = "rbxassetid://126937210066343"
local v928 = function(arg26_1)
    local up2 = arg26_1
    local v356 = function()
        if setclipboard then
            setclipboard(up2)
        else
            if toclipboard then
                toclipboard(up2)
            else
                error("Clipboard unsupported")
            end
        end
        return
    end
    return pcall(v356)
end
capturedValues1.value2 = "rbxassetid://0"
capturedValues1.value3 = "rbxassetid://111092517538982"
capturedValues1.value4 = "https://s0ftkillz.sellhub.cx/product/Key/"
capturedValues1.value5 = "rbxassetid://113639632389270"
capturedValues1.value6 = "https://s0ftkillz.dillydally586.workers.dev/"
capturedValues1.value7 = "rbxassetid://120926108125796"
capturedValues1.value8 = "https://stfly.vip/HubKeys1"
capturedValues1.value9 = "rbxassetid://89792003818413"
capturedValues1.value10 = "https://discord.gg/D2ZAvkx63j"
capturedValues1.value11 = "rbxassetid://126946140959629"
capturedValues1.value12 = (v894 .. "_Key.txt")
capturedValues1.value13 = ""
capturedValues1.value14 = (v894 .. "_Welcome_V1335.txt")
local v922 = function()
    local v358 = isfile(capturedValues1.value12)
    if v358 then
        capturedValues1.value13 = (readfile(capturedValues1.value12))
    end
    return
end
pcall(v922)
local v919 = function(arg28_1)
    local up3 = arg28_1
    local v362 = (not up3)
    local v363 = v362
    if not (v362) then
        v363 = (up3 == "")
    end
    if v363 then
        return
    else
        pcall(function()
            writefile(capturedValues1.value12, up3)
            return
        end)
        return
    end
end
v922 = function(arg29_1)
    local v370 = arg29_1
    local v376 = ((type(v370)) == "string")
    local v377 = v376
    if v376 then
        v377 = (v370 ~= "") and (v370 ~= "rbxassetid://0")
    end
    return v377
end
capturedValues1.value15 = v919
capturedValues1.value16 = v922
local v921 = game:GetService("Players")
local v925 = game:GetService("TweenService")
capturedValues1.value17 = v925
local v932 = game:GetService("CoreGui")
capturedValues1.value18 = v932
local v933 = game:GetService("UserInputService")
capturedValues1.value19 = v933
local v934 = game:GetService("Workspace")
capturedValues1.value20 = v934
v934 = v921.LocalPlayer
capturedValues1.value21 = v934
local v936 = Color3.fromRGB(183, 85, 255)
capturedValues1.value22 = v936
local v930 = Color3.fromRGB(55, 215, 255)
capturedValues1.value23 = v930
local v931 = Color3.fromRGB(85, 255, 135)
capturedValues1.value24 = v931
local v938 = Color3.fromRGB(15, 15, 18)
capturedValues1.value25 = v938
Color3.fromRGB(22, 22, 27)
v938 = Color3.fromRGB
local v940 = v938(58, 58, 68)
local v944 = function()
    local v384
    local v383 = capturedValues1.value20.CurrentCamera
    if v383 then
        v384 = v383.ViewportSize
        return v384
    else
        v384 = Vector2.new
        return v384(1920, 1080)
    end
end
local v937 = function(arg31_1, arg31_2)
    local v390 = (Instance.new("UICorner"))
    v390.CornerRadius = UDim.new(0, (arg31_2 or 5))
    v390.Parent = arg31_1
    return v390
end
capturedValues1.value26 = v940
local v942 = function(arg32_1)
    local v394, v396, v397, v404
    local up4 = arg32_1
    local v395 = function()
        return Instance.new("UIShadow")
    end
    v394, v397 = pcall(v395)
    v395 = v394
    v394 = v395
    local up5 = v397
    if v395 then
        v394 = up5
    end
    if v394 then
        v397 = (pcall(function()
            up5.Name = "CyberUIShadow"
            up5.BlurRadius = UDim.new(0, 20)
            up5.Color = capturedValues1.value22
            up5.Transparency = .48
            up5.Offset = UDim2.new(0, 0, 0, 9)
            up5.Spread = UDim2.new(0, 9, 0, 9)
            up5.ZIndex = 0
            up5.Parent = up4
            return
        end))
        v394 = v397
        if v397 then
            v394 = (up5.Parent == up4)
        end
        if v394 then
            v396 = up5
            return v396
        else
            v404 = function()
                up5:Destroy()
                return
            end
            pcall(v404)
        end
    end
    v397 = (Instance.new("ImageLabel"))
    v397.Name = "CyberShadowFallback"
    v397.AnchorPoint = Vector2.new(0.5, 0.5)
    v397.Position = UDim2.fromScale(0.5, 0.5)
    v397.Size = UDim2.new(1, 42, 1, 42)
    v397.BackgroundTransparency = 1
    v397.Image = "rbxassetid://1316045217"
    v397.ImageColor3 = capturedValues1.value22
    v397.ImageTransparency = .62
    v397.ScaleType = Enum.ScaleType.Stretch
    v397.ZIndex = math.max(0, (up4.ZIndex - 1))
    v397.Parent = up4
    return v397
end
local v941 = function(arg33_1, arg33_2, arg33_3, arg33_4)
    local v407, v408, v409, v412
    v407, v408, v409 = arg33_3, arg33_1, "Instance"
    local v410 = Instance
    local v411 = arg33_4
    v410 = v410.new("UIStroke")
    v409 = v410
    v412, v410 = "Color", arg33_2
    if not (arg33_2) then
        v410 = capturedValues1.value22
    end
    v409[v412] = v410
    v409.Thickness = (v407 or 1)
    v409.Transparency = (v411 or 0)
    v409.Parent = v408
    return v409
end
capturedValues1.value27 = v937
capturedValues1.value28 = v941
local v943 = function(arg34_1, arg34_2)
    local v416 = Instance.new("Frame")
    local up6 = v416
    up6.Name = "CyberScanLine"
    up6.Size = UDim2.new(.3, 0, 0, 2)
    up6.Position = UDim2.new(0, 0, 0, 0)
    up6.BackgroundColor3 = capturedValues1.value23
    up6.BorderSizePixel = 0
    up6.ZIndex = (arg34_2 or 30)
    up6.Parent = arg34_1
    local v417 = Instance.new("UIGradient")
    local v418 = NumberSequence.new
    local v424 = NumberSequenceKeypoint.new(0, 1)
    local v425 = NumberSequenceKeypoint.new(.22, .28)
    local v426 = NumberSequenceKeypoint.new(0.5, 0)
    local v427 = NumberSequenceKeypoint.new(.78, .28)
    v417.Transparency = v418({v424, v425, v426, v427, NumberSequenceKeypoint.new(1, 1)})
    v417.Parent = up6
    task.spawn(function()
        local v339, v340, v341, v343, v344, v345, v346, v347, v348, v351
        while true do
            v339 = up6
            v340 = v339
            if v339 then
                v340 = up6.Parent
            end
            if v340 then
                v346 = capturedValues1.value17
                v339 = up6
                v341 = TweenInfo.new
                v343 = Enum.EasingStyle.Sine
                v347 = Enum.EasingDirection
                v340 = v346.Create
                v345 = v341(1.55, v343, v347.InOut )
                v344 = UDim2.new(.7, 0, 0, 0)
                v347 = capturedValues1.value22
                v340 = v340(v346, v339, v345, {["Position"] = v344, ["BackgroundColor3"] = v347})
                v346, v339 = "Play", v340
                v339:Play()
                v339.Completed:Wait()
                v341 = up6
                if not ((not v341.Parent )) then
                    v346 = capturedValues1.value17
                    v345 = up6
                    v343 = TweenInfo.new(1.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    v347 = UDim2.new
                    v340 = v346.Create
                    v351 = v347(0, 0, 0, 0)
                    v348 = capturedValues1.value23
                    v340 = v340(v346, v345, v343, {["Position"] = v351, ["BackgroundColor3"] = v348})
                    v346, v341 = "Play", v340
                    v341:Play()
                    v341.Completed:Wait()
                    continue
                end
            end
            break
        end
        return
    end)

    return up6
end
capturedValues1.value29 = v942
capturedValues1.value30 = v943
capturedValues1.value31 = v944
capturedValues1.value32 = v928
v944 = function()
    local v435 = (capturedValues1.value31())
    local v439 = (math.min(480, math.max(280, (v435.X - 24))))
    local v436 = (math.min(320, math.max(230, (v435.Y - 80))))
    local v433 = UDim2.fromOffset
    local v438 = math.floor(v439)
    return v433(v438, math.floor(v436))
end
local v945 = function()
    local v447
    local v450 = (capturedValues1.value31())
    if (v450["X"] <= 500) then
        v447 = 110
        return v447
    else
        if (v450["X"] <= 700) then
            v447 = 130
            return v447
        else
            v447 = 160
            return v447
        end
    end
end
v928 = function()
    local v453, v455, v456, v457, v458, v459, v460, v464, v465, v466, v467, v468, v469, v470, v471, v472
    local v473, v474, v475, v476
    local v477, v478, v479, v480, v481, v482, v483, v484, v485, v486, v487, v489, v490, v491, v492, v494
    local v495, v498
    local up7
    local v454 = function()
        up7 = (isfile(capturedValues1.value14))

        return
    end
    up7 = false
    pcall(v454)
    if up7 then
        return
    else
        v455 = Instance.new("ScreenGui")
        local up8 = v455
        v453 = up8
        v453.Name = "S0ftKillz_FirstWelcome"
        v453 = up8
        v453.ResetOnSpawn = false
        v453 = up8
        v453.IgnoreGuiInset = true
        v453 = up8
        v453.DisplayOrder = 1000000000
        v453 = up8
        v456 = Enum.ZIndexBehavior.Global
        v453.ZIndexBehavior = v456
        v456 = function()
            up8.Parent = capturedValues1.value18
            return
        end
        v455 = pcall(v456)
        if (not v455) then
            v453 = up8
            v458 = capturedValues1.value21:WaitForChild("PlayerGui")
            v453.Parent = v458
        end
        v455 = Instance.new("Frame")
        v457, v464 = v455, "\249`\235\240\t\190\202\210T"
        v457.Name = "TransparentBackdrop"
        v459, v465 = "UDim2", 33729039564122
        v455 = UDim2.fromScale
        v459, v460 = 1, 1
        v458 = v455(v459, v460)
        v457.Size = v458
        v464, v466, v460 = 32477607639827, 14995557423942, "7 \157\240\228\027\149\135O\232\1630v\178\005Y7EQ\138\248I"
        v457.BackgroundTransparency = 1
        v457.BorderSizePixel = 0
        v457.Active = true
        v457.Parent = up8
        v455 = Instance.new("Frame")
        local up9 = v455
        v453 = up9
        v453.Name = "CyberWelcome"
        v453 = up9
        v460 = Vector2.new(0.5, 0.5)
        v453.AnchorPoint = v460
        v453 = up9
        v460 = UDim2.fromScale(0.5, 0.5)
        v453.Position = v460
        v453 = up9
        v460 = UDim2.fromOffset (660, 545)
        v453.Size = v460
        v453 = up9
        v453.BackgroundColor3 = capturedValues1.value25
        v453 = up9
        v464, v459 = 3505773069920, 0
        v453.BorderSizePixel = v459
        v453 = up9
        v459, v464 = false, 18676145758712
        v453.ClipsDescendants = v459
        v453 = up9
        v453.ZIndex = 10
        v453 = up9
        v453.Parent = up8
        capturedValues1.value27(up9, 6)
        v459 = up9
        v455 = capturedValues1.value28(v459, capturedValues1.value22, 2, 0)
        local up11 = v455
        capturedValues1.value29(up9)
        v460 = up9
        capturedValues1.value30(v460, 40)
        v469, v453 = 10706433774457, false
        local up13 = v453
        local up14
        local up12
        local up15
        local up10
        v453 = up9.InputBegan
        v473 = function(arg62_1)
            local v784, v785, v792
            local up58 = arg62_1
            local v786 = up58.UserInputType
            local v783 = (v786 ~= Enum.UserInputType.MouseButton1)
            local v782 = v783
            if v783 then
                v782 = (v786 ~= Enum.UserInputType.Touch)
            end
            if v782 then
                return
            else
                v782 = up58.Position.Y
                v784 = up9.AbsolutePosition
                if ((v782 - v784["Y"]) > 128) then
                    return
                else
                    up13 = true
                    up12 = up58.Position
                    up15 = up9.Position
                    v785 = up58.Changed
                    v792 = function()
                        local v778 = up58.UserInputState
                        local v777 = Enum.UserInputState
                        if (v778 == v777["End"]) then
                            up13 = false
                        end
                        return
                    end
                    v785:Connect(v792)
                    return
                end
            end
        end
        v469, v455 = 23463765830318, "Connect"
        v453:Connect(v473)
        up9.InputChanged:Connect(function(arg63_1)
            local v793 = arg63_1
            local v794 = v793.UserInputType
            local v795 = (v794 == Enum.UserInputType.MouseMovement)
            local v797 = v795
            if not (v795) then
                v797 = (v794 == Enum.UserInputType.Touch)
            end
            if v797 then
                up14 = v793
            end
            return
        end)
        v453 = capturedValues1.value19.InputChanged
        v473 = function(arg64_1)
            local v806, v807, v809, v810, v811, v812
            local v805 = up8
            local v808 = arg64_1
            if (not v805["Parent"]) then
                if up10 then
                    up10:Disconnect()
                    up10 = nil
                end
                return
            else
                v812 = up13
                v811 = v812
                if v812 then
                    v809 = up14
                    v806 = 6917351
                    v807 = (v808 == v809)
                    v812 = v807
                    if v807 then
                        v812 = up12 and up15
                    end
                    v811, v810 = v812, v806
                end
                if v811 then
                    v805 = (v808.Position - up12)
                    v811 = up9
                    v807 = UDim2.new(up15.X.Scale, (up15.X.Offset + v805.X), up15.Y.Scale, (up15.Y .Offset + v805.Y))
                    v811.Position = v807
                end
                return
            end
        end
        up10 = (v453:Connect(v473))
        v473 = Instance.new("Frame")
        v471 = UDim2.new(0, 0, 0, 24)
        v473.Position = v471
        v471 = UDim2.new(0, 2, 0, 72)
        v469, v476 = 15865251142875, 33180666936410
        v473.Size = v471
        v473.BackgroundColor3 = capturedValues1.value23
        v473.BorderSizePixel = 0
        v467, v469 = "\031g\193", 29825244608064
        v473.ZIndex = 20
        v473.Parent = up9
        v470 = Instance.new("Frame")
        v472 = Vector2.new(1, 1)
        v470.AnchorPoint = v472
        v471 = UDim2.new
        v467, v469 = "\196\2283", 0
        v472 = v471(1, v469, 1, -20)
        v470.Position = v472
        v472 = UDim2.new(0, 2, 0, 68)
        v470.Size = v472
        v470.BackgroundColor3 = capturedValues1.value22
        v470.BorderSizePixel = 0
        v470.ZIndex = 20
        v470.Parent = up9
        v471 = Instance.new("TextLabel")
        v474 = UDim2.fromOffset(22, 18)
        v471.Position = v474
        v474 = UDim2.fromOffset(136, 28)
        v471.Size = v474
        v474 = Color3.fromRGB(25, 25, 31)
        v471.BackgroundColor3 = v474
        v471.BorderSizePixel = 0
        v471.Text = "// FIRST LAUNCH"
        v471.TextColor3 = capturedValues1.value23
        v472 = Enum.Font.RobotoMono
        v471.Font = v472
        v471.TextSize = 13
        v471.ZIndex = 20
        v471.Parent = up9
        capturedValues1.value27(v471, 3)
        capturedValues1.value28(v471, capturedValues1.value26, 1, 0)
        v453 = Instance.new
        v481, v467 = "q\030\195", "p\226\136#\166\192\000t\225\252"
        v472 = v453("ImageLabel")
        v469 = Vector2.new(1, 0)
        v472.AnchorPoint = v469
        v469 = UDim2.new(1, -20, 0, 16)
        v472.Position = v469
        v469 = UDim2.fromOffset(44, 44)
        v472.Size = v469
        v469 = Color3.fromRGB(20, 20, 25)
        v472.BackgroundColor3 = v469
        v472.BackgroundTransparency = .05
        v472.BorderSizePixel = 0
        v472.Image = capturedValues1.value1
        v474 = Enum.ScaleType.Fit
        v472.ScaleType = v474
        v472.ZIndex = 20
        v472.Parent = up9
        capturedValues1.value27(v472, 4)
        capturedValues1.value28(v472, capturedValues1.value22, 1, .15)
        v474 = Instance.new("TextLabel")
        local up16 = v474
        v453 = up16
        v477 = UDim2.fromOffset(22, 52)
        v453.Position = v477
        v453 = up16
        v477 = UDim2.new(1, -110, 0, 38)
        v453.Size = v477
        v453 = up16
        v453.BackgroundTransparency = 1
        v453 = up16
        v453.Text = "TEAM S0FTKILLZ ROBLOX HUB"
        v453 = up16
        v453.TextColor3 = capturedValues1.value22
        v453 = up16
        v475 = Enum.Font.GothamBold
        v453.Font = v475
        v453 = up16
        v453.TextSize = 28
        v453 = up16
        v475 = Enum.TextXAlignment.Left
        v453.TextXAlignment = v475
        v453 = up16
        v453.ZIndex = 20
        v453 = up16
        v453.Parent = up9
        pcall(function()
            up16.TextStrokeTransparency = .85
            up16.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

            return
        end)
        v474 = Instance.new("TextLabel")
        local up17 = v474
        v453 = up17
        v467 = UDim2.fromOffset(23, 90)
        v453.Position = v467
        v453 = up17
        v467 = UDim2.new(1, -46, 0, 26)
        v453.Size = v467
        v453 = up17
        v453.BackgroundTransparency = 1
        v453 = up17
        v453.Text = "WELCOME //  PREMIUM ACCESS SYSTEM"
        v453 = up17
        v467 = Color3.fromRGB(175, 175, 190)
        v453.TextColor3 = v467
        v453 = up17
        v467 = Enum.Font
        v465, v476 = "\210;\254HW\188", 21220005357209
        v477 = v467.Gotham
        v453.Font = v477
        v453 = up17
        v453.TextSize = 14
        v453 = up17
        v477 = Enum.TextXAlignment.Left
        v453.TextXAlignment = v477
        v453 = up17
        v453.ZIndex = 20
        v453 = up17
        v453.Parent = up9
        v477 = function()
            up17.TextStrokeTransparency = .85
            up17.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

            return
        end
        pcall(v477)
        v474 = Instance.new("Frame")
        v476, v465 = 21888037873616, "\142\2530\185\1354\140\169\227\158"
        v467 = UDim2.fromOffset(22, 122)
        v474.Position = v467
        v467 = UDim2.new(1, -44, 0, 1)
        v474.Size = v467
        v467 = Color3.fromRGB(48, 48, 58)
        v474.BackgroundColor3 = v467
        v474.BorderSizePixel = 0
        v474.ZIndex = 20
        v474.Parent = up9
        v477 = Instance.new("Frame")
        local up18 = v477
        v453 = up18
        v482 = UDim2.fromOffset(22, 138)
        v453.Position = v482
        v453 = up18
        v482 = UDim2.new(1, -44, 0, 300)
        v453.Size = v482
        v453 = up18
        v482 = Color3.fromRGB(18, 18, 23)
        v453.BackgroundColor3 = v482
        v453 = up18
        v476, v465 = "ZT\134", 15035257527129
        v453.BorderSizePixel = 0
        v453 = up18
        v453.ClipsDescendants = true
        v453 = up18
        v453.ZIndex = 20
        v453 = up18
        v453.Parent = up9
        capturedValues1.value27(up18, 4)
        capturedValues1.value28(up18, capturedValues1.value26, 1, 0)
        v480 = Instance.new("TextLabel")
        v483 = UDim2.fromScale(1, 1)
        v480.Size = v483
        v465, v478, v487 = "\2125q\002\209oXl\233Y,\217'\204\220\197KD/\184\249\003", 7312846245197, 10232623878812
        v480.BackgroundTransparency = 1
        v465, v476 = "\220\189y\005", 31069088004227
        v476, v465 = 18215467393314, "\213q\160\157\236\232*\r\008\227"
        v480.Text = "[ LOADING... ]\nWelcome Team S0ftKillz Roblox Hub"
        v482 = Color3.fromRGB
        v476, v465 = 128, 112
        v483 = v482(112, v465, v476)
        v480.TextColor3 = v483
        v476, v465 = 19617420059567, "C\231\174T"
        v482 = Enum.Font.GothamBold
        v480.Font = v482
        v476, v465 = 13876307401021, "\245\180y\173d\233>&"
        v466, v465 = 31580094380401, "5\015*k\002n\220\187A\194L"
        v480.TextSize = 18
        v480.TextWrapped = true
        v480.ZIndex = 21
        v480.Parent = up18
        v453 = Instance.new
        v485, v478 = 34651139817223, "e\146U\015\127\209\164d\170"
        v482 = v453("ImageLabel")
        v483 = UDim2.fromScale
        v476, v465 = 1, 1
        v484 = v483(v465, v476)
        v482.Size = v484
        v482.BackgroundTransparency = 1
        v482.Image = capturedValues1.value3
        v465 = Enum
        v478, v466 = "\008\225p\210", 27246293430671
        v483 = v465.ScaleType .Crop
        v482.ScaleType = v483
        v482.ZIndex = 22
        v465, v476 = 8, 0
        v482.Parent = up18
        v453 = function(arg67_1, arg67_2, arg67_3, arg67_4, arg67_5, arg67_6)
            local v843 = (Instance.new("Frame"))
            v843.AnchorPoint = Vector2.new(arg67_1, arg67_3)
            v843.Position = UDim2.new(arg67_1, arg67_2, arg67_3, arg67_4)
            v843.Size = UDim2.fromOffset(22, 2)
            v843.BackgroundColor3 = capturedValues1.value22
            v843.BorderSizePixel = 0
            v843.ZIndex = 25
            v843.Parent = up18
            local v840 = (Instance.new("Frame"))
            v840.AnchorPoint = Vector2.new(arg67_1, arg67_3)
            v840.Position = UDim2.new(arg67_1, arg67_2, arg67_3, arg67_4)
            v840.Size = UDim2.fromOffset(2, 22)
            v840.BackgroundColor3 = capturedValues1.value23
            v840.BorderSizePixel = 0
            v840.ZIndex = 25
            v840.Parent = up18
            return
        end
        v483, v478 = v453, "\133\n\014"
        v483(0, v465, v476, 8)
        v476, v465 = 0, -8
        v483(1, v465, v476, 8)
        v476, v465 = 1, 8
        v483(0, v465, v476, -8)
        v466, v476, v465 = 20358903768328, 1, -8
        v483(1, v465, v476, -8)
        v484 = Instance.new("TextButton")
        v478, v479 = "\188\140\128\006", 12733816805161
        local up19 = v484
        v453 = up19
        v453.Name = "ContinueCyberButton"
        v466, v478 = 10706092626809, "\173^\1543\001g\242\168u\211]"
        v453 = up19
        v476 = Vector2.new
        v466, v485, v478 = 16768331832960, 0.5, 0
        v486 = v476(v485, v478)
        v478, v481 = "(\212-\188\"\181j1", ",B\179"
        v453.AnchorPoint = v486
        v453 = up19
        v476 = UDim2.new
        v485, v466, v478 = 0.5, 0, 0
        v486 = v476(v485, v478, v466, 456)
        v453.Position = v486
        v453 = up19
        v478, v481 = "\232\205\031\214", "\137f\252h\153c\191\008\128w"
        v486 = UDim2.fromOffset(390, 60)
        v453.Size = v486
        v453 = up19
        v468, v466 = 20976789890600, 21776500877212
        v481, v485 = "\014\190\026\0294\028\239", "Color3"
        v476 = Color3.fromRGB
        v466, v478, v485 = 27, 21, 21
        v486 = v476(v485, v478, v466)
        v453.BackgroundColor3 = v486
        v478, v466 = "\199|/{\198\022\146\238/\164#\000`\141\006", 8221047033588
        v453 = up19
        v478, v476 = "\141\240\011\168", 0
        v453.BorderSizePixel = v476
        v453 = up19
        v453.Text = ""
        v453 = up19
        v468, v478 = "\004\228f", "J\178\205?\217hz\132\218F\148\227\159\024\151"
        v476, v478, v466 = false, "r\132\130\198\166\229", 32500783004446
        v453.AutoButtonColor = v476
        v453 = up19
        v453.ZIndex = 20
        v453 = up19
        v453.Parent = up9
        capturedValues1.value27(up19, 4)
        v476 = up19
        v484 = capturedValues1.value28(v476, capturedValues1.value22, 2, 0)
        local up20 = v484
        v453 = Instance.new
        v479, v481 = "\031\221\007\007\204", 7933756149358
        v484 = v453("Frame")
        v486 = UDim2.new
        v481, v478, v466, v479 = 0, 0, 6, 1
        v485 = v486(v478, v466, v479, v481)
        v484.Size = v485
        v484.BackgroundColor3 = capturedValues1.value24
        v484.BorderSizePixel = 0
        v466, v481 = "\169\220\015\233\142w", "\152\137\175"
        v484.ZIndex = 21
        v484.Parent = up19
        capturedValues1.value27(v484, 2)
        v453 = Instance.new
        v468, v481 = 1278156751443, "\219\140\190\133`\128>7e"
        v486 = v453("TextLabel")
        local up21 = v486
        v453 = up21
        v478 = UDim2.fromOffset
        v479, v481 = 20, 8
        v466 = v478(v479, v481)
        v453.Position = v466
        v453 = up21
        v478 = UDim2.new
        v479, v481, v468 = 1, -104, 0
        v466 = v478(v479, v481, v468, 16)
        v453.Size = v466
        v453 = up21
        v468, v481 = 7776075714085, "\205e\n\019"
        v453.BackgroundTransparency = 1
        v453 = up21
        v453.Text = "INITIALIZE HUB"
        v468, v481 = 21548387346226, "\184\244&|\021i\137\017\175S"
        v453 = up21
        v466 = Color3
        v481, v468 = 125, 145
        v466 = v466.fromRGB (125, v481, v468)
        v453.TextColor3 = v466
        v453 = up21
        v478 = Enum.Font.GothamMedium
        v453.Font = v478
        v453 = up21
        v468, v481, v478 = 14115535608237, "g0W\234\175\236\148\tD\250wTZ\205", 11
        v453.TextSize = v478
        v453 = up21
        v478 = Enum.TextXAlignment.Left
        v453.TextXAlignment = v478
        v453 = up21
        v468, v487 = 8127447502536, 18747851579930
        v468, v478, v481 = 13572309440688, 22, "K\198H\216\182\253"
        v453.ZIndex = v478
        v453 = up21
        v453.Parent = up19
        v486 = Instance.new("TextLabel")
        local up22 = v486
        v453 = up22
        v466 = UDim2.fromOffset
        v481, v487 = 20, 13377614551125
        v479 = v466(v481, 22)
        v453.Position = v479
        v453 = up22
        v466 = UDim2.new
        v481, v468 = 1, -104
        v479 = v466(v481, v468, 0, 28)
        v453.Size = v479
        v453 = up22
        v453.BackgroundTransparency = 1
        v453 = up22
        v453.Text = "CONTINUE"
        v453 = up22
        v466 = Color3.fromRGB
        v481, v468, v487 = 242, 242, 248
        v479 = v466(v481, v468, v487)
        v453.TextColor3 = v479
        v453 = up22
        v466 = Enum.Font.GothamBold
        v453.Font = v466
        v453 = up22
        v466, v487 = 22, 10975781491702
        v453.TextSize = v466
        v453 = up22
        v466 = Enum.TextXAlignment.Left
        v453.TextXAlignment = v466
        v487, v468 = 18751857222172, "\0059\130\227\180\189"
        v453 = up22
        v453.ZIndex = 22
        v453 = up22
        v453.Parent = up19
        v466 = function()
            up22.TextStrokeTransparency = .85
            up22.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

            return
        end
        pcall(v466)
        v486 = Instance.new("TextLabel")
        local up23 = v486
        v453 = up23
        v479 = Vector2.new
        v468, v487 = 1, 0.5
        v481 = v479(v468, v487)
        v453.AnchorPoint = v481
        v453 = up23
        v481 = UDim2.new(1, -18, 0.5, 0)
        v453.Position = v481
        v453 = up23
        v479 = UDim2.fromOffset
        v487, v468 = 34, 74
        v481 = v479(v468, v487)
        v453.Size = v481
        v453 = up23
        v487, v479 = "\247i(\006", 1
        v453.BackgroundTransparency = v479
        v453 = up23
        v453.Text = ">>>"
        v453 = up23
        v453.TextColor3 = capturedValues1.value24
        v453 = up23
        v479 = Enum.Font.RobotoMono
        v453.Font = v479
        v453 = up23
        v453.TextSize = 24
        v453 = up23
        v479 = Enum.TextXAlignment.Right
        v453.TextXAlignment = v479
        v453 = up23
        v479, v487 = 22, "\173\171\174\160\007\135"
        v453.ZIndex = v479
        v453 = up23
        v453.Parent = up19
        v486 = Instance.new("Frame")
        v481 = UDim2.new(0, 42, 0, 1)
        v486.Size = v481
        v481 = UDim2.new(0, 8, 1, -2)
        v486.Position = v481
        v486.BackgroundColor3 = capturedValues1.value23
        v486.BorderSizePixel = 0
        v486.ZIndex = 23
        v486.Parent = up19
        v453 = up19.MouseEnter
        v481 = function()
            local v856 = capturedValues1.value17
            local v857 = up19
            local v858 = TweenInfo.new(.12)
            local v860 = Color3
            local v866 = v856.Create
            v860 = v860.fromRGB (28, 28, 36)
            v866 = v866(v856, v857, v858, {["BackgroundColor3"] = v860})
            v866:Play()
            v856 = capturedValues1.value17
            v857 = up20
            v858 = TweenInfo
            v866 = v856.Create
            v858 = v858.new (.12)
            v866 = v866(v856, v857, v858, {["Color"] = capturedValues1.value23, ["Thickness"] = 2.4})
            v866:Play()
            v856 = capturedValues1.value17
            v857 = up23
            v858 = TweenInfo.new(.12)
            v856:Create(v857, v858, {["TextColor3"] = capturedValues1.value23}):Play()
            return
        end
        v453:Connect(v481)
        v453 = up19.MouseLeave
        v481 = function()
            local v875, v876
            local v868 = capturedValues1.value17
            local v869 = up19
            local v870 = TweenInfo.new(.12)
            local v872 = Color3.fromRGB(21, 21, 27)
            v876, v875 = v868.Create, {["BackgroundColor3"] = v872}
            v876 = v876(v868, v869, v870, v875)
            v876:Play()
            v868 = capturedValues1.value17
            v869 = up20
            v870 = TweenInfo.new(.12)
            v868:Create(v869, v870, {["Color"] = capturedValues1.value22, ["Thickness"] = 2}):Play()
            v868 = capturedValues1.value17
            v869 = up23
            v870 = TweenInfo.new(.12)
            v868:Create(v869, v870, {["TextColor3"] = capturedValues1.value24}):Play()
            return
        end
        v453:Connect(v481)
        v479 = Instance.new("UIScale")
        local up24 = v479
        v453 = up24
        v453.Scale = .9
        v453 = up24
        v468 = up9
        v453.Parent = v468
        local up25
        local up26 = function()
            local v882, v883
            v882, v883 = capturedValues1.value31(), "math"
            local v881 = math.clamp((math.min(((v882.X - 20) / 660), ((v882.Y - 20) / 545))), .38, 1)
            local v880 = up9
            v883 = v881
            v880:SetAttribute("ResponsiveScale", v883)
            local v884 = up9:GetAttribute("Opening")
            if (not v884) then
                v880 = up24
                v880.Scale = v883
            end
            return
        end
        up9:SetAttribute("Opening", true)
        up26()
        v487 = capturedValues1.value20.CurrentCamera
        if v487 then
            v453 = v487:GetPropertyChangedSignal("ViewportSize")
            v489 = up26
            up25 = (v453:Connect(v489))
        end
        v453 = up9
        v453.BackgroundTransparency = 1
        v453 = up11
        v453.Transparency = 1
        v489 = ((up9:GetAttribute("ResponsiveScale")) or 1)
        v490 = capturedValues1.value17
        v492 = up24
        v494 = TweenInfo.new
        v498 = Enum.EasingStyle
        v490:Create(v492, (v494(.28, v498.Back, Enum.EasingDirection.Out)), {["Scale"] = v489}):Play()
        v490 = capturedValues1.value17
        v492 = up9
        v495 = TweenInfo.new(.2)
        v490:Create(v492, v495, {["BackgroundTransparency"] = 0}):Play()
        v490 = capturedValues1.value17
        v492 = up11
        v495 = TweenInfo.new(.24)
        v490:Create(v492, v495, {["Transparency"] = 0}):Play()
        task.delay(.3, function()
            local v140 = up9
            local v141 = v140
            if v140 then
                v141 = up9.Parent
            end
            if v141 then
                up9:SetAttribute("Opening", false)
                up26()
            end
            return
        end)
        v491 = Instance.new("BindableEvent")
        local up27 = v491
        local up28 = false
        up19.Activated:Connect(function()
            local v150, v153, v154, v155
            local v148 = up28
            local v149 = v148
            if not (v148) then
                v149 = (not up8.Parent)
            end
            if v149 then
                return
            else
                v149 = up19
                v149.Active = false
                v149 = up22
                v149.Text = "ACCESS GRANTED"
                v149 = up21
                v149.Text = "LOADING KEY SYSTEM..."
                v149 = up23
                v149.Text = ">>>"
                v149 = up20
                v149.Color = capturedValues1.value24
                pcall(function()
                    writefile(capturedValues1.value14, "seen")

                    return
                end)
                v149 = capturedValues1.value17
                v155 = up24
                v154 = TweenInfo.new(.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                v153 = math
                v148 = v149.Create
                v153 = v153.max(.2, (((up9:GetAttribute("ResponsiveScale")) or 1) * .94))
                v148 = v148(v149, v155, v154, {["Scale"] = v153})
                v148:Play()
                v149 = capturedValues1.value17
                v155 = up9
                v154 = TweenInfo.new(.16)
                v149:Create(v155, v154, {["BackgroundTransparency"] = 1}):Play()
                v149 = capturedValues1.value17
                v155 = up11
                v154 = TweenInfo.new(.16)
                v149:Create(v155, v154, {["Transparency"] = 1}):Play()
                v148 = task
                v150 = function()
                    if up25 then
                        up25:Disconnect()
                    end
                    if up10 then
                        up10:Disconnect()
                    end
                    up8:Destroy()
                    up27:Fire()
                    return
                end
                v148.delay(.18, v150)

                return
            end
        end)
        up27.Event :Wait()
        up27:Destroy()
        return
    end
end
v928()
local v946 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
capturedValues1.value33 = v946
v946 = loadstring
local v952 = game
spilledValues1.value4, spilledValues1.value5 = v952.HttpGet, "\143\232j\t\173\235\199\201H"
v946 = v946(spilledValues1.value4(v952, "https://sdkAPI-public.luarmor.net/library.lua"))()
capturedValues1.value34 = v946
capturedValues1.value34.script_id = "07a73d589fafa2f1762aa93563002584"
v946 = capturedValues1.value33
v952 = v946.CreateWindow
local v954 = v945()
local v956 = v944()
local v962 = Enum.KeyCode.RightControl
v952 = v952(v946, {["Title"] = v894, ["SubTitle"] = "Key System", ["TabWidth"] = v954, ["Size"] = v956, ["Acrylic"] = true, ["Theme"] = "Darker", ["MinimizeKey"] = v962})
local v948 = v952:AddTab({["Title"] = "Verification", ["Icon"] = capturedValues1.value1})
v946 = {["Main"] = v948}
v948 = function(arg38_1, arg38_2)
    capturedValues1.value33:Notify({["Title"] = arg38_1, ["Content"] = arg38_2, ["Duration"] = 6})
    return
end
capturedValues1.value35 = v948
capturedValues1.value36 = nil
local up117 = function(arg39_1)
    local v515, v517, v520
    local v514 = arg39_1
    local v516 = (not v514) or (v514 == "")
    if v516 then
        capturedValues1.value35("Error", "Please enter a key first.")

        return
    else
        capturedValues1.value35("Checking...", "Verifying your key...")
        v515 = (capturedValues1.value34.check_key(v514))
        v516 = v515.code
        if (v516 == "KEY_VALID") then
            capturedValues1.value15(v514)
            capturedValues1.value13 = v514
            capturedValues1.value33:Destroy()
            v520 = getgenv()
            v520.script_key = v514
            capturedValues1.value34.load_script()
        else
            v520 = v515.code:find("KEY_")
            if v520 then
                v520 = {["KEY_HWID_LOCKED"] = "Key is linked to another HWID.", ["KEY_INCORRECT"] = "The key is incorrect.", ["KEY_INVALID"] = "The key is invalid or expired."}
                v516 = capturedValues1.value35
                v516("Key Denied", v520[v515.code] or v515.message)
            else
                v516 = capturedValues1.value21
                v517 = ("System Error: " .. (tostring(v515.message)))
                v516:Kick(v517)
            end
        end
        return
    end
end
capturedValues1.value37 = nil
v954 = function()
    local v529, v531, v532, v533, v534, v535, v536, v539, v541
    if (not capturedValues1.value37) then
        return
    else
        if capturedValues1.value36 then
            capturedValues1.value36:Disconnect()
            capturedValues1.value36 = nil
        end
        v529 = capturedValues1.value37
        local up29 = v529
        capturedValues1.value37 = nil
        v533 = up29:FindFirstChild("Dim")
        v536 = up29:FindFirstChild("Popup")
        if v536 then
            v531 = v536.Size
            v534 = math.max(260, (v531.X.Offset - 28))
            v535 = math.max(220, (v531.Y.Offset - 24))
            v532 = capturedValues1.value17
            v539 = TweenInfo.new(.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In )
            v541 = UDim2.fromOffset (v534, v535)
            v532:Create(v536, v539, {["Size"] = v541, ["BackgroundTransparency"] = 1}):Play()
        end
        if v533 then
            v531 = capturedValues1.value17
            v535 = TweenInfo.new(.18)
            v531:Create(v533, v535, {["BackgroundTransparency"] = 1}):Play()
        end
        task.delay(.2, function()
            if up29 then
                up29:Destroy()
            end
            return
        end)

        return
    end
end
capturedValues1.value36 = nil
capturedValues1.value38 = v954
local v955 = function()
    local v557, v558, v559, v560, v561, v562, v563, v564, v565, v566, v567, v570, v571
    local v574, v575, v576, v577, v578, v579, v581, v584
    if capturedValues1.value37 then
        capturedValues1.value38()
        task.wait(.22)
    end
    local v550 = Instance.new("ScreenGui")
    local up30 = v550
    up30.Name = "S0ftKillz_KeyPopup"
    up30.ResetOnSpawn = false
    up30.IgnoreGuiInset = true
    up30.DisplayOrder = 999999999
    local v549 = up30
    local v553 = Enum
    v549.ZIndexBehavior = v553.ZIndexBehavior.Global
    v550 = pcall(function()
        up30.Parent = capturedValues1.value18
        return
    end)
    if (not v550) then
        v549 = up30
        v553 = capturedValues1.value21:WaitForChild("PlayerGui")
        v549.Parent = v553
    end
    capturedValues1.value37 = up30
    local v552 = Instance
    v561, v559 = "\162\213\023%~A\244e\183", 5881607899826
    v552 = v552.new ("Frame")
    v552.Name = "Dim"
    v558, v562 = 6200851024711, 4456777762843
    v553 = UDim2.fromScale
    v557, v558 = 1, 8006270160528
    v552.Size = v553(1, v557)
    v552.BackgroundTransparency = 1
    v552.BorderSizePixel = 0
    v552.Active = true
    v557, v558 = "\166\r\029\202\247\133", 5658506332746
    v552.Parent = up30
    v553 = Instance.new("Frame")
    local up31 = v553
    v559, v561 = "\\L\203\154", 22818652973441
    up31.Name = "Popup"
    v550 = up31
    v559, v561 = "\241-E!.\239\173\164\024\236+", 3548589442676
    local v556 = Vector2.new
    v561, v559, v558 = 2482502599812, 0.5, 0.5
    v550.AnchorPoint = v556(v558, v559)
    v550 = up31
    v564, v558, v563 = 13853708966195, "UDim2", "Ib\188\164v\241\228Z\140"
    v556 = UDim2.fromScale
    v558, v563, v559, v561 = 0.5, "\244\2556\181\228\019\226\255UA", 0.5, 17466611720133
    v550.Position = v556(v558, v559)
    v550 = up31
    v564, v558 = 15360965925873, "UDim2"
    v550.Size = UDim2.fromOffset(900, 500)
    up31.BackgroundColor3 = capturedValues1.value25
    up31.BackgroundTransparency = 1
    v550 = up31
    v561, v559 = 32101888309860, "V0\203\197\021\201y\131q\030\250\008Xg&"
    v550.BorderSizePixel = 0
    v550 = up31
    v561, v559 = 19920142230588, "\186\161\232\008\218`"
    v550.Active = true
    v550 = up31
    v561, v559 = 6709983939636, "\016nkg\164Y$\216\243\237\238\004\015+\\\199"
    v550.ClipsDescendants = false
    up31.Parent = up30
    capturedValues1.value27(up31, 7)
    v558, v559 = 2, 1
    v553 = capturedValues1.value28(up31, capturedValues1.value22, v558, v559)
    capturedValues1.value29(up31)
    v556 = Instance.new("Frame")
    local up32 = v556
    v563, v562 = 26507296485431, "\202\215\150\176"
    up32.Name = "TopAccent"
    v550 = up32
    v558 = UDim2.new
    v562, v564, v561 = 0, 2, .3
    v550.Size = v558(v561, v562, 0, v564)
    v550 = up32
    v559 = UDim2
    v564, v562 = 0, 0
    v558 = v559.new
    v563, v561 = 0, 0
    v550.Position = v558(v561, v562, v563, v564)
    up32.BackgroundColor3 = capturedValues1.value23
    up32.BorderSizePixel = 0
    v550 = up32
    v563, v567 = 11526967350519, 28264667181929
    v550.ZIndex = 20
    up32.Parent = up31
    v550 = Instance.new
    v563, v564 = "vp\235\223\239\212\149\203\020\160", 12014842910170
    v556 = v550("UIGradient")
    v558 = ColorSequence.new
    v562 = ColorSequenceKeypoint.new
    v564, v570 = 0, "Color3"
    local v568 = Color3.fromRGB
    v565, v570, v567 = 45, 105, 235
    v563 = v562(v564, v568(v570, v565, v567))
    v562 = ColorSequenceKeypoint.new
    local v569 = Color3.fromRGB
    v566, v567, v565 = 11010587350023, 65, 195
    v564 = v562(0.5, v569(v565, v567, 255))
    v562 = ColorSequenceKeypoint.new
    v570 = Color3.fromRGB
    v567, v571 = 65, 205
    v556.Color = v558({v563, v564, v562(1, v570(v567, v571, 255))})
    v556.Parent = up32
    task.spawn(function()
        local v231, v232, v233, v234, v236, v237, v238, v239, v240, v241, v242
        local v235 = 16767352
        while true do
            v233 = (capturedValues1.value37 == up30)
            v234 = v233
            if v233 then
                v232 = up32
                v231, v233 = v235, v232
                if v232 then
                    v233 = up32.Parent
                end
                v234, v235 = v233, v231
            end
            if v234 then
                v235 = capturedValues1.value17
                v233 = up32
                v231 = TweenInfo.new
                v240 = Enum.EasingStyle.Sine
                v239 = Enum
                v234 = v235.Create
                v232 = v231(1.55, v240, v239.EasingDirection.InOut )
                v237 = UDim2.new(.7, 0, 0, 0)
                v238 = capturedValues1.value22
                v234 = v234(v235, v233, v232, {["Position"] = v237, ["BackgroundColor3"] = v238})
                v233, v235 = v234, "Play"
                v233:Play()
                v235 = v233.Completed
                v235:Wait()
                v231 = up32
                if not ((not v231.Parent )) then
                    v235 = capturedValues1.value17
                    v232 = up32
                    v236 = TweenInfo.new
                    v238 = Enum.EasingStyle.Sine
                    v242 = Enum
                    v234 = v235.Create
                    v240 = v236(1.55, v238, v242.EasingDirection.InOut )
                    v239 = UDim2.new(0, 0, 0, 0)
                    v241 = capturedValues1.value23
                    v234 = v234(v235, v232, v240, {["Position"] = v239, ["BackgroundColor3"] = v241})
                    v231, v235 = v234, "Play"
                    v231:Play()
                    v235 = v231.Completed
                    v235:Wait()
                    continue
                end
            end
            break
        end
        return
    end)
    v559, v564 = "Instance", "\216\135\202"
    v550 = Instance.new
    v571, v560 = "\231\204W\137\019j\176\228\\\218", 12664341665545
    v558 = v550("UIScale")
    local up33 = v558
    up33.Name = "ResponsiveScale"
    v550 = up33
    v564, v566 = "i\213YI\145", 22292284598412
    v550.Scale = .94
    v550 = up33
    v561 = up31
    v550.Parent = v561
    local up37 = false
    local up38
    local up36
    local up35
    local up34
    up31.InputBegan:Connect(function(arg14_1)
        local v247, v248, v252
        local up1 = arg14_1
        local v255 = (up1.UserInputType == Enum.UserInputType.MouseButton1)
        local v256 = v255
        if not (v255) then
            v256 = (up1.UserInputType == Enum.UserInputType.Touch)
        end
        if v256 then
            v256 = up1.Position.Y
            v252 = up31.AbsolutePosition
            if ((v256 - v252.Y ) > 92) then
                return
            else
                up37 = true
                up36 = up1.Position
                up35 = up31.Position
                v247 = up1.Changed
                v248 = function()
                    local v208 = up1.UserInputState
                    local v207 = Enum.UserInputState
                    if (v208 == v207.End ) then
                        up37 = false
                    end
                    return
                end
                v247:Connect(v248)
            end
        end
        return
    end)
    v550 = up31.InputChanged
    v569 = function(arg15_1)
        local v258 = arg15_1
        local v267 = (v258.UserInputType == Enum.UserInputType.MouseMovement)
        local v268 = v267
        if not (v267) then
            v268 = (v258.UserInputType == Enum.UserInputType.Touch)
        end
        if v268 then
            up38 = v258
        end
        return
    end
    v568, v571 = v550.Connect, "x\022\018\161\188o\\\026\20592g"
    v568(v550, v569)
    v550 = capturedValues1.value19.InputChanged
    v569 = function(arg16_1)
        local v270, v271, v274, v275, v276, v277
        local v272 = (capturedValues1.value37 ~= up30)
        local v273 = arg16_1
        if v272 then
            if up34 then
                up34:Disconnect()
                up34 = nil
            end
            return
        else
            v274 = up37
            v270 = v274
            if v274 then
                v276 = (v273 == up38)
                v274 = v276
                if v276 then
                    v277 = up36
                    v275 = v272
                    v276 = v277 and up35
                    v272, v274 = v275, v276
                end
                v270 = v274
            end
            if v270 then
                v271 = (v273.Position - up36)
                v270 = up31
                v276 = UDim2.new(up35.X.Scale, (up35.X.Offset + v271.X), up35.Y.Scale, (up35.Y .Offset + v271.Y))
                v270.Position = v276
            end
            return
        end
    end
    v568, v570 = v550.Connect, "Instance"
    v568 = v568(v550, v569)
    up34 = v568
    v550 = Instance.new
    v560, v566 = 1545132409551, "\245\185\1317\004\166\2527\000\029"
    v569 = v550("TextButton")
    local up39 = v569
    up39.Name = "CloseButton"
    v550 = up39
    v565 = UDim2.fromOffset
    v571, v566 = 18, 18
    v550.Position = v565(v571, v566)
    v550 = up39
    v565 = UDim2.fromOffset
    v571, v566 = 42, 42
    v550.Size = v565(v571, v566)
    v550 = up39
    v565 = Color3.fromRGB
    v571, v566, v560 = 34, 22, 27
    v550.BackgroundColor3 = v565(v571, v566, v560)
    up39.BorderSizePixel = 0
    v550 = up39
    v560, v566 = 6719636229177, "\217\171I\241"
    v550.Text = "X"
    v550 = up39
    v565 = Color3.fromRGB
    v560, v571, v566 = 82, 255, 72
    v550.TextColor3 = v565(v571, v566, v560)
    up39.Font = Enum.Font.GothamBold
    v550 = up39
    v560, v566 = 21506137188126, "tF\031\133\n-\226k"
    v566, v565 = "\154\254\128\236q\014A\137\157\161#'\137b\160", 24
    v550.TextSize = v565
    up39.AutoButtonColor = false
    v550 = up39
    v566, v565 = "\231\202i\133q\237", 25
    v550.ZIndex = v565
    up39.Parent = up31
    capturedValues1.value27(up39, 5)
    v550 = capturedValues1.value28
    v565 = up39
    v571 = Color3.fromRGB(130, 45, 55)
    v566, v567 = .1, 1
    v569 = v550(v565, v571, v567, v566)
    local up40 = v569
    v550 = up39.MouseEnter
    v567 = function()
        local v288 = capturedValues1.value17
        local v289 = up39
        local v291 = TweenInfo.new(.12)
        local v293 = Color3
        local v290 = v288.Create
        v293 = v293.fromRGB(62, 25, 32)
        v290 = v290(v288, v289, v291, {["BackgroundColor3"] = v293})
        v290:Play()
        v288 = capturedValues1.value17
        v289 = up40
        v291 = TweenInfo.new(.12)
        v293 = Color3
        v290 = v288.Create
        v293 = v293.fromRGB(255, 72, 82)
        v290 = v290(v288, v289, v291, {["Color"] = v293})
        v290:Play()
        return
    end
    v550:Connect(v567)
    v550 = up39.MouseLeave
    v567 = function()
        local v307
        local v300 = capturedValues1.value17
        local v301 = up39
        local v302 = TweenInfo.new(.12)
        local v304 = Color3
        local v310 = v300.Create
        v304 = v304.fromRGB (34, 22, 27)
        v310 = v310(v300, v301, v302, {["BackgroundColor3"] = v304})
        v310:Play()
        v300 = capturedValues1.value17
        v301 = up40
        v302 = TweenInfo.new(.12)
        v304 = Color3.fromRGB(130, 45, 55)
        v310, v307 = v300.Create, {["Color"] = v304}
        v310 = v310(v300, v301, v302, v307)
        v310:Play()
        return
    end
    v550:Connect(v567)
    up39.Activated:Connect(function()
        capturedValues1.value38()
        return
    end)
    v569 = Instance.new("ImageLabel")
    local up41 = v569
    up41.Name = "BrandLogo"
    up41.Position = UDim2.fromOffset(74, 14)
    up41.Size = UDim2.fromOffset(50, 50)
    up41.BackgroundTransparency = 1
    up41.Image = capturedValues1.value1
    up41.ScaleType = Enum.ScaleType.Fit
    up41.ZIndex = 25
    up41.Parent = up31
    v569 = Instance.new("TextLabel")
    local up42 = v569
    up42.Name = "BrandText"
    up42.Position = UDim2.fromOffset(132, 16)
    up42.Size = UDim2.fromOffset(190, 46)
    up42.BackgroundTransparency = 1
    up42.Text = "S0FTKILLZ"
    up42.TextColor3 = Color3.fromRGB(242, 170, 213)
    up42.Font = Enum.Font.GothamBold
    up42.TextSize = 20
    up42.TextXAlignment = Enum.TextXAlignment.Left
    up42.ZIndex = 25
    up42.Parent = up31
    v569 = Instance.new("Frame")
    local up43 = v569
    up43.Name = "CenterKey"
    up43.AnchorPoint = Vector2.new(0.5, 0)
    up43.Position = UDim2.new(0.5, 0, 0, 10)
    v550 = up43
    local v572 = UDim2.fromOffset(270, 62)
    v550.Size = v572
    up43.BackgroundTransparency = 1
    up43.ZIndex = 25
    up43.Parent = up31
    v569 = Instance.new("Frame")
    local up44 = v569
    up44.Name = "KeyHeaderLogo"
    up44.Position = UDim2.fromOffset(22, 7)
    v550 = up44
    local v573 = UDim2.fromOffset(48, 48)
    v550.Size = v573
    up44.BackgroundTransparency = 1
    up44.BorderSizePixel = 0
    up44.ZIndex = 26
    up44.Parent = up43
    v569 = capturedValues1.value16(capturedValues1.value2)
    if v569 then
        v569 = Instance.new("ImageLabel")
        v569.Name = "Image"
        v573 = UDim2.fromScale(1, 1)
        v569.Size = v573
        v569.BackgroundTransparency = 1
        v569.Image = capturedValues1.value2
        v572 = Enum.ScaleType.Fit
        v569.ScaleType = v572
        v569.ZIndex = 27
        v572 = up44
        v569.Parent = v572
    else
        v569 = Instance.new("Frame")
        v569.Name = "Ring"
        v573 = UDim2.fromOffset(3, 7)
        v569.Position = v573
        v573 = UDim2.fromOffset(22, 22)
        v569.Size = v573
        v569.BackgroundTransparency = 1
        v569.BorderSizePixel = 0
        v569.ZIndex = 27
        v569.Parent = up44
        capturedValues1.value27(v569, 11)
        capturedValues1.value28(v569, (Color3.fromRGB(255, 138, 47)), 4, 0)
        v572 = Instance.new("Frame")
        v572.Name = "Shaft"
        v574 = UDim2.fromOffset(21, 24)
        v572.Position = v574
        v574 = UDim2.fromOffset(23, 5)
        v572.Size = v574
        v572.Rotation = 40
        v574 = Color3.fromRGB(255, 138, 47)
        v572.BackgroundColor3 = v574
        v572.BorderSizePixel = 0
        v572.ZIndex = 27
        v572.Parent = up44
        capturedValues1.value27(v572, 3)
        v573 = Instance.new("Frame")
        v573.Name = "Tooth"
        v575 = UDim2.fromOffset(36, 31)
        v573.Position = v575
        v575 = UDim2.fromOffset(5, 10)
        v573.Size = v575
        v573.Rotation = 40
        v575 = Color3.fromRGB(255, 138, 47)
        v573.BackgroundColor3 = v575
        v573.BorderSizePixel = 0
        v573.ZIndex = 27
        v573.Parent = up44
        capturedValues1.value27(v573, 2)
    end
    v569 = Instance
    v577, v576 = 28604784489480, "d\133\238"
    v569 = v569.new("TextLabel")
    local up45 = v569
    v550 = up45
    v576, v577 = "\2134\t:\228\252\226j", 1001084682706
    v573 = UDim2.fromOffset
    v575, v576 = 80, 4
    v550.Position = v573(v575, v576)
    v550 = up45
    v573 = UDim2.fromOffset
    v575, v576 = 176, 30
    v550.Size = v573(v575, v576)
    v550 = up45
    v577, v578 = 27247917937040, 2700519359721
    v576, v573 = "|@\199\150", 1
    v550.BackgroundTransparency = v573
    v550 = up45
    v577, v579 = "\020]\023?\181\024\208\247\219w", ".\162T,\191\219\t"
    v550.Text = "KEY ACCESS"
    v550 = up45
    v573 = Color3.fromRGB
    v575, v576 = 255, 138
    v550.TextColor3 = v573(v575, v576, 47)
    v550 = up45
    v577, v576 = 6297532631924, "\156-{\234"
    v550.Font = Enum.Font.GothamBold
    v550 = up45
    v577, v576 = 22782663682417, "({\138\236\187\208v\193&R\173\007\022D"
    v550.TextSize = 24
    v550 = up45
    v573 = Enum.TextXAlignment.Left
    v576, v577 = "\251Q\135b5G", 30590692931492
    v550.TextXAlignment = v573
    v550 = up45
    v577, v573 = 21378036262626, 26
    v550.ZIndex = v573
    up45.Parent = up43
    v569 = Instance.new("TextLabel")
    local up46 = v569
    v550 = up46
    v574 = UDim2.fromOffset
    v577, v576 = 33, 81
    v550.Position = v574(v576, v577)
    v550 = up46
    v574 = UDim2.fromOffset
    v576, v577 = 180, 21
    v550.Size = v574(v576, v577)
    up46.BackgroundTransparency = 1
    v550 = up46
    v577, v579 = "r\145\015\237", 2400799114333
    v550.Text = "Choose your access method"
    v550 = up46
    v574 = Color3.fromRGB
    v576, v577 = 150, 150
    v550.TextColor3 = v574(v576, v577, 166)
    up46.Font = Enum.Font.Gotham
    v577, v578 = "\026!\214\254 \162\163V", 16594315025967
    up46.TextSize = 11
    up46.TextXAlignment = Enum.TextXAlignment.Left
    v578, v579 = 20291567232232, 4436042582033
    up46.ZIndex = 26
    up46.Parent = up43
    v578, v574 = "3q-", "Instance"
    v550 = Instance.new
    v578, v581, v579 = "N\138\t\0088\247\184Z\157\000", 34980161028000, 26368687009782
    v569 = v550("TextButton")
    local up47 = v569
    up47.Name = "DiscordButton"
    up47.AnchorPoint = Vector2.new(1, 0)
    v550 = up47
    v575 = UDim2.new
    v578, v577, v579 = -18, 1, 0
    v550.Position = v575(v577, v578, v579, 16)
    up47.Size = UDim2.fromOffset(168, 48)
    v550 = up47
    v575 = Color3.fromRGB
    v577, v579, v578 = 23, 36, 25
    v550.BackgroundColor3 = v575(v577, v578, v579)
    up47.BorderSizePixel = 0
    up47.Text = ""
    up47.AutoButtonColor = false
    v550 = up47
    v578, v579 = "\180\240\225+\194\025", 1573778309852
    v575, v578 = 25, "e\245Q\240\134\172"
    v550.ZIndex = v575
    up47.Parent = up31
    capturedValues1.value27(up47, 5)
    v550 = capturedValues1.value28
    v575 = up47
    v576 = Color3.fromRGB
    v579, v578 = 101, 88
    v577 = v576(v578, v579, 242)
    v576, v578 = 1.5, 0
    v569 = v550(v575, v577, v576, v578)
    local up48 = v569
    v569 = Instance.new("ImageLabel")
    local up49 = v569
    up49.AnchorPoint = Vector2.new(0, 0.5)
    v550 = up49
    v579, v581 = "UDim2", 23499934886591
    v550.Position = UDim2.new(0, 11, 0.5, 0)
    v550 = up49
    v579, v584 = "UDim2", 6807917775970
    v550.Size = UDim2.fromOffset(30, 30)
    up49.BackgroundTransparency = 1
    up49.Image = capturedValues1.value11
    up49.ScaleType = Enum.ScaleType.Fit
    up49.ZIndex = 26
    up49.Parent = up47
    v569 = Instance.new("TextLabel")
    local up50 = v569
    up50.Position = UDim2.fromOffset(48, 0)
    v550 = up50
    v584, v581 = 25230416932324, "\151\245'"
    v550.Size = UDim2.new(1, -58, 1, 0)
    up50.BackgroundTransparency = 1
    up50.Text = "DISCORD"
    up50.TextColor3 = Color3.fromRGB(196, 202, 255)
    v550 = up50
    v579 = Enum.Font
    v584, v581 = 8316170440480, "Od\206\236\025\192\136U\008\130"
    v550.Font = v579.GothamBold
    up50.TextSize = 15
    up50.TextXAlignment = Enum.TextXAlignment.Left
    up50.ZIndex = 26
    up50.Parent = up47
    v550 = up47.MouseEnter
    v578 = function()
        local v677 = capturedValues1.value17
        local v678 = up47
        local v679 = TweenInfo.new(.12)
        local v680 = Color3.fromRGB
        local v688 = v677.Create
        local v681 = v680(34, 37, 56)
        v688 = v688(v677, v678, v679, {["BackgroundColor3"] = v681})
        v688:Play()
        v677 = capturedValues1.value17
        v678 = up48
        v679 = TweenInfo.new(.12)
        v677:Create(v678, v679, {["Color"] = capturedValues1.value23, ["Thickness"] = 2}):Play()
        return
    end
    v550:Connect(v578)
    v550 = up47.MouseLeave
    v578 = function()
        local v689 = capturedValues1.value17
        local v690 = up47
        local v696 = TweenInfo.new
        local v697 = v689.Create
        local v691 = v696(.12)
        local v693 = Color3.fromRGB(23, 25, 36)
        v697 = v697(v689, v690, v691, {["BackgroundColor3"] = v693})
        v697:Play()
        v689 = capturedValues1.value17
        v690 = up48
        v691 = TweenInfo.new(.12)
        v697 = v689.Create
        v693 = Color3.fromRGB(88, 101, 242)
        v697 = v697(v689, v690, v691, {["Color"] = v693, ["Thickness"] = 1.5})
        v697:Play()
        return
    end
    v550:Connect(v578)
    v550 = up47.Activated
    v578 = function()
        local v702, v705
        local v704 = capturedValues1.value32(capturedValues1.value10)
        if v704 then
            v702 = up50
            v702.Text = "COPIED!"
            v702 = up50
            v702.TextColor3 = capturedValues1.value24
            capturedValues1.value35("Discord Copied!", "Discord invite copied to your clipboard.")
        else
            v702 = up50
            v702.Text = "COPY ERROR"
            v702 = up50
            v705 = Color3.fromRGB(255, 90, 100)
            v702.TextColor3 = v705
        end
        task.delay(1.3, function()
            local v225, v230
            local v223 = up50
            local v224 = v223
            if v223 then
                v224 = up50.Parent
            end
            if v224 then
                v230 = up50
                v230.Text = "DISCORD"
                v230 = up50
                v225 = Color3.fromRGB(196, 202, 255)
                v230.TextColor3 = v225
            end
            return
        end)

        return
    end
    v550:Connect(v578)
    v569 = Instance.new("Frame")
    local up51 = v569
    up51.Name = "HeaderLine"
    up51.Position = UDim2.fromOffset(18, 80)
    v550 = up51
    local v580 = UDim2
    v584, v581 = ":\230\030\251\158k\215", 1
    v580 = v580.new (1, -36, 0, v581)
    v550.Size = v580
    up51.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
    up51.BorderSizePixel = 0
    up51.ZIndex = 21
    up51.Parent = up31
    v579, v581 = "Instance", 16182577421679
    v569 = Instance.new("ScrollingFrame")
    local up52 = v569
    up52.Name = "AccessMethods"
    up52.Position = UDim2.fromOffset(6, 88)
    up52.Size = UDim2.new(1, -12, 1, -96)
    up52.BackgroundTransparency = 1
    up52.BorderSizePixel = 0
    up52.CanvasSize = UDim2.fromOffset(0, 0)
    up52.ScrollBarThickness = 5
    up52.ScrollBarImageColor3 = capturedValues1.value22
    up52.ScrollBarImageTransparency = .12
    up52.ScrollingDirection = Enum.ScrollingDirection.Y
    up52.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    up52.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    up52.Active = true
    up52.ZIndex = 10
    up52.Parent = up31
    local up53 = {}
    v550 = function(arg58_1)
        local v710, v711, v713, v714, v715, v720, v721, v723, v729, v730
        local up55 = arg58_1
        v710, v711 = "Instance", "2\022\030"
        v710, v715 = Instance.new("Frame"), "\243_\016("
        local v712 = up55.Name
        v715, v711 = "\159\254\002\206e'\252UF`\022\231\2232\246]", 25396869164594
        v710.Name = v712
        v712 = Color3.fromRGB
        v714, v715 = 21, 21
        v710.BackgroundColor3 = v712(v714, v715, 27)
        v715, v711 = "\015%@\186\193\164\204\237%\150\224\128G\247\161", 30681773406159
        v711, v715 = 10032794800703, "\193\232\184i5\008\025\180p\148\207R\224\218\019y"
        v710.BorderSizePixel = 0
        v710.ClipsDescendants = false
        v711, v715 = 23758427843383, "\001!\131\143\146o"
        v710.ZIndex = 12
        v710.Parent = up52
        capturedValues1.value27(v710, 6)
        local v716 = capturedValues1.value28
        v711 = v716
        local v718 = up55
        v714 = v716
        local v717 = v718.Popular
        v715 = v717
        if v717 then
            v715 = (Color3.fromRGB(255, 139, 34))
        end
        v713, v716 = v715, v711
        if not (v715) then
            v713 = (Color3.fromRGB(58, 58, 70))
        end
        v716 = v714
        v718 = up55.Popular
        v714, v715 = ((v718 and 2.5) or 1.2), 0
        v716(v710, v713, v714, v715)
        v714 = Instance.new("Frame")
        v714.Name = "AccentBar"
        v714.Position = UDim2.fromOffset(0, 0)
        v714.Size = UDim2.new(1, 0, 0, 4)
        v714.BackgroundColor3 = up55.Accent
        v714.BorderSizePixel = 0
        v714.ZIndex = 14
        v714.Parent = v710
        capturedValues1.value27(v714, 3)
        v711 = up55
        v715 = nil
        if v711["Popular"] then
            v715 = (Instance.new("TextLabel"))
            v715.Name = "PopularBadge"
            v718 = Vector2.new(0.5, 0)
            v715.AnchorPoint = v718
            v718 = UDim2.new(0.5, 0, 0, 12)
            v715.Position = v718
            v718 = UDim2.fromOffset(176, 28)
            v715.Size = v718
            v718 = Color3.fromRGB(50, 35, 18)
            v715.BackgroundColor3 = v718
            v715.BorderSizePixel = 0
            v715.Text = "MOST POPULAR  *"
            v718 = Color3.fromRGB(255, 191, 33)
            v715.TextColor3 = v718
            v717 = Enum.Font.GothamBold
            v715.Font = v717
            v715.TextSize = 13
            v715.ZIndex = 15
            v715.Parent = v710
            capturedValues1.value27(v715, 4)
            capturedValues1.value28(v715, (Color3.fromRGB(255, 146, 35)), 1, .15)
        end
        v717 = Instance.new("TextLabel")
        v717.Name = "CardTitle"
        v717.Position = UDim2.fromOffset(14, ((up55.Popular and 48) or 18))
        v717.Size = UDim2.new(1, -28, 0, 31)
        v717.BackgroundTransparency = 1
        v717.Text = up55.Title
        v717.TextColor3 = up55.Accent
        v717.Font = Enum.Font.GothamBold
        v717.TextSize = 23
        v717.TextXAlignment = Enum.TextXAlignment.Center
        v717.ZIndex = 15
        v717.Parent = v710
        v718 = Instance.new("Frame")
        v718.Name = "LogoBox"
        v718.Position = UDim2.fromOffset(14, ((up55.Popular and 86) or 58))
        v718.Size = UDim2.new(1, -28, 0, 76)
        local v719 = Color3.fromRGB(16, 16, 21)
        v718.BackgroundColor3 = v719
        v718.BorderSizePixel = 0
        v718.ZIndex = 13
        v718.Parent = v710
        capturedValues1.value27(v718, 4)
        capturedValues1.value28(v718, (Color3.fromRGB(50, 50, 62)), 1, .15)
        local v722 = capturedValues1.value16(up55.Logo)
        if v722 then
            v719 = Instance.new("ImageLabel")
            v719.Name = "CardLogo"
            v721 = Vector2.new(0.5, 0.5)
            v719.AnchorPoint = v721
            v721 = UDim2.fromScale(0.5, 0.5)
            v719.Position = v721
            v721 = UDim2.fromOffset(58, 58)
            v719.Size = v721
            v719.BackgroundTransparency = 1
            v720 = up55.Logo
            v719.Image = v720
            v720 = Enum.ScaleType.Fit
            v719.ScaleType = v720
            v719.ZIndex = 15
            v719.Parent = v718
        else
            v719 = up55.LogoKind
            if (v719 == "ADS") then
                v719 = Instance.new("Frame")
                v719.Name = "AdsLogo"
                v721 = Vector2.new(0.5, 0.5)
                v719.AnchorPoint = v721
                v721 = UDim2.fromScale(0.5, 0.5)
                v719.Position = v721
                v721 = UDim2.fromOffset(62, 50)
                v719.Size = v721
                v721 = Color3.fromRGB(18, 33, 38)
                v719.BackgroundColor3 = v721
                v719.BorderSizePixel = 0
                v719.ZIndex = 15
                v719.Parent = v718
                capturedValues1.value27(v719, 8)
                capturedValues1.value28(v719, up55.Accent, 2, 0)
                v720 = Instance.new("Frame")
                v720.Name = "AdScreen"
                v723 = UDim2.fromOffset(8, 7)
                v720.Position = v723
                v723 = UDim2.new(1, -16, 1, -18)
                v720.Size = v723
                v723 = Color3.fromRGB(12, 20, 24)
                v720.BackgroundColor3 = v723
                v720.BorderSizePixel = 0
                v720.ZIndex = 16
                v720.Parent = v719
                capturedValues1.value27(v720, 5)
                capturedValues1.value28(v720, (Color3.fromRGB(55, 105, 112)), 1, .15)
                v721 = Instance.new("TextLabel")
                v721.Name = "AdText"
                v730 = UDim2.fromScale(1, 1)
                v721.Size = v730
                v721.BackgroundTransparency = 1
                v721.Text = "AD"
                v723 = up55.Accent
                v721.TextColor3 = v723
                v723 = Enum.Font.GothamBold
                v721.Font = v723
                v721.TextSize = 23
                v721.ZIndex = 17
                v721.Parent = v720
                v723 = Instance.new("Frame")
                v723.Name = "AdStand"
                v729 = Vector2.new(0.5, 0)
                v723.AnchorPoint = v729
                v729 = UDim2.new(0.5, 0, 1, -9)
                v723.Position = v729
                v729 = UDim2.fromOffset(18, 3)
                v723.Size = v729
                v730 = up55.Accent
                v723.BackgroundColor3 = v730
                v723.BorderSizePixel = 0
                v723.ZIndex = 17
                v723.Parent = v719
                capturedValues1.value27(v723, 2)
            else
                v719 = Instance.new("TextLabel")
                v719.Name = "CardLogoText"
                v721 = UDim2.fromScale(1, 1)
                v719.Size = v721
                v719.BackgroundTransparency = 1
                v712 = "Text"
                v723 = up55.LogoText
                v720 = v723
                if not (v723) then
                    v720 = up55.Title
                end
                v719[v712] = v720
                v720 = up55.Accent
                v719.TextColor3 = v720
                v720 = Enum.Font.GothamBold
                v719.Font = v720
                v719.TextSize = 28
                v719.ZIndex = 15
                v719.Parent = v718
            end
        end
        v719 = Instance.new("Frame")
        v719.Name = "DetailBox"
        v719.Position = UDim2.fromOffset(14, ((up55.Popular and 170) or 142))
        v719.Size = UDim2.new(1, -28, 0, 92)
        v719.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
        v719.BorderSizePixel = 0
        v719.ZIndex = 13
        v719.Parent = v710
        capturedValues1.value27(v719, 4)
        v720 = Instance.new("TextLabel")
        v720.Name = "CardDetail"
        v720.Position = UDim2.fromOffset(12, 8)
        v720.Size = UDim2.new(1, -24, 1, -16)
        v720.BackgroundTransparency = 1
        v720.Text = up55.Detail
        v720.TextColor3 = Color3.fromRGB(213, 213, 222)
        v720.Font = Enum.Font.Gotham
        v720.TextSize = 15
        v720.TextWrapped = true
        v720.TextXAlignment = Enum.TextXAlignment.Center
        v720.TextYAlignment = Enum.TextYAlignment.Center
        v720.ZIndex = 15
        v720.Parent = v719
        v721 = Instance.new("TextButton")
        local up56 = v721
        up56.Name = "CopyLink"
        up56.AnchorPoint = Vector2.new(0.5, 1)
        up56.Position = UDim2.new(0.5, 0, 1, -14)
        up56.Size = UDim2.new(1, -28, 0, 46)
        up56.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        up56.BorderSizePixel = 0
        up56.Text = "COPY LINK"
        up56.TextColor3 = up55.Accent
        up56.Font = Enum.Font.GothamBold
        up56.TextSize = 14
        up56.AutoButtonColor = false
        up56.ZIndex = 15
        up56.Parent = v710
        capturedValues1.value27(up56, 4)
        v721 = capturedValues1.value28(up56, up55.Accent, 1.5, 0)
        local up57 = v721
        v721 = Instance.new("Frame")
        v721.Position = UDim2.new(0, 0, 0, 7)
        v721.Size = UDim2.new(0, 4, 1, -14)
        v721.BackgroundColor3 = up55.Accent
        v721.BorderSizePixel = 0
        v721.ZIndex = 16
        v721.Parent = up56
        capturedValues1.value27(v721, 2)
        v712 = up56.MouseEnter
        local v724 = function()
            local v615
            local v608 = capturedValues1.value17
            local v609 = up56
            local v610 = TweenInfo.new(.12)
            local v616 = v608.Create
            local v611 = up55.Accent
            local v617 = Color3.fromRGB(12, 12, 16)
            v616 = v616(v608, v609, v610, {["BackgroundColor3"] = v611, ["TextColor3"] = v617})
            v616:Play()
            v608 = capturedValues1.value17
            v609 = up57
            v610 = TweenInfo.new(.12)
            v611 = capturedValues1.value23
            v615, v616 = {["Color"] = v611, ["Thickness"] = 2}, v608.Create
            v616 = v616(v608, v609, v610, v615)
            v616:Play()
            return
        end
        v712:Connect(v724)
        v712 = up56.MouseLeave
        v724 = function()
            local v622 = capturedValues1.value17
            local v623 = up56
            local v624 = TweenInfo.new(.12)
            local v626 = Color3
            local v633 = v622.Create
            v626 = v626.fromRGB (18, 18, 24)
            local v627 = up55.Accent
            v633 = v633(v622, v623, v624, {["BackgroundColor3"] = v626, ["TextColor3"] = v627})
            v633:Play()
            v622 = capturedValues1.value17
            v623 = up57
            v624 = TweenInfo.new(.12)
            local v625 = up55.Accent
            v622:Create(v623, v624, {["Color"] = v625, ["Thickness"] = 1.5}):Play()
            return
        end
        v712:Connect(v724)
        up56.Activated:Connect(function()
            local v637, v638, v643
            local v644 = capturedValues1.value32(up55.Link)
            if v644 then
                v637 = up56
                v637.Text = "COPIED!"
                v637 = up56
                v643 = up55.Accent
                v637.BackgroundColor3 = v643
                v637 = up56
                v638 = Color3.fromRGB(12, 12, 16)
                v637.TextColor3 = v638
                capturedValues1.value35("Link Copied!", (up55.Title .. " link copied to your clipboard."))
            else
                v637 = up56
                v637.Text = "COPY ERROR"
            end
            task.delay(1.2, function()
                local v124, v129
                local v122 = up56
                local v123 = v122
                if v122 then
                    v123 = up56.Parent
                end
                if v123 then
                    v129 = up56
                    v129.Text = "COPY LINK"
                    v129 = up56
                    v124 = Color3.fromRGB(18, 18, 24)
                    v129.BackgroundColor3 = v124
                    v129 = up56
                    v122 = up55.Accent
                    v129.TextColor3 = v122
                end
                return
            end)

            return
        end)
        table.insert(up53, {["Frame"] = v710, ["Title"] = v717, ["LogoBox"] = v718, ["DetailBox"] = v719, ["PopularBadge"] = v715})

        return v710
    end
    v580 = v550
    local v589 = capturedValues1.value4
    local v592 = Color3.fromRGB(164, 63, 255)
    v580({["Name"] = "LifetimeCard", ["Title"] = "LIFETIME", ["Detail"] = "Lifetime key\nCrypto payment\nPermanent access", ["Link"] = v589, ["Accent"] = v592, ["Logo"] = capturedValues1.value5, ["LogoText"] = "LIFE", ["Popular"] = false})
    local v590 = capturedValues1.value6
    local v593 = Color3.fromRGB(255, 190, 28)
    v580({["Name"] = "PremiumCard", ["Title"] = "PREMIUM", ["Detail"] = "Multiple key durations\n1-day key from $0.99", ["Link"] = v590, ["Accent"] = v593, ["Logo"] = capturedValues1.value7, ["LogoText"] = "VIP", ["Popular"] = true})
    local v591 = capturedValues1.value8
    local v594 = Color3.fromRGB(95, 226, 234)
    v580({["Name"] = "AdsCard", ["Title"] = "ADS", ["Detail"] = "Free key with ads\n3 checkpoints", ["Link"] = v591, ["Accent"] = v594, ["Logo"] = capturedValues1.value9, ["LogoKind"] = "ADS", ["Popular"] = false})
    v550 = function()
        local v737, v738, v739, v740, v742, v743, v744, v745, v746, v747, v748, v749, v750, v751, v752, v753
        local v754, v755, v756, v757, v758, v759
        local v760, v764, v765, v767
        v738, v739 = capturedValues1.value31(), "math"
        v740, v739 = "math", math.max(210, (v738.X - 12))
        v740 = (math.max(250, (v738.Y - 12)))
        local v741 = (v739 >= 760) and (v740 >= 460)
        local v736 = up33
        v736.Scale = 1
        if v741 then
            v747, v748 = 19218474705653, 18725767815695
            v742 = (math.min(900, v739))
            v737 = math
            v747, v748 = "\233\225\026\200", 34956648841109
            v737 = v737.min(500, v740)
            v736 = up31
            v743 = v737
            v745 = UDim2.fromOffset(v742, v743)
            v736.Size = v745
            v736 = up41
            v736.Visible = true
            v736 = up42
            v736.Visible = true
            v736 = up43
            v745 = Vector2
            v747, v748 = 0, 18262371606840
            v745 = v745.new (0.5, v747)
            v736.AnchorPoint = v745
            v736 = up43
            v745 = UDim2
            v749, v751 = "\148\174M\201\158\192\190\25129", 10
            v744 = v745.new
            v747, v750 = 0, 34941965156239
            v745 = v744(0.5, v747, 0, v751)
            v736.Position = v745
            v736 = up43
            v744 = UDim2.fromOffset
            v747, v748 = 62, 16671795207763
            v745 = v744(270, v747)
            v747, v750 = "f\181\028\026b\232,", 17644250587160
            v736.Size = v745
            v736 = up44
            v744, v748 = true, 18542773526970
            v736.Visible = v744
            v736 = up44
            v745 = UDim2.fromOffset(22, 7)
            v748, v750 = 3838157571835, 4361787918319
            v736.Position = v745
            v736 = up44
            v749, v747 = "Ox\236\t\018!\191i\145\132", "V\218\233\234"
            v745 = UDim2
            v747, v750 = 48, 9989441638955
            v745 = v745.fromOffset (48, v747)
            v736.Size = v745
            v747, v749 = "1L\217\205\004G\019W", "4\173Y\224\221\248Rw\005S"
            v736 = up45
            v744 = UDim2.fromOffset
            v750, v747, v749 = 734083793237, 4, "z9\234\141\220\206\142\188\197\145"
            v745 = v744(80, v747)
            v736.Position = v745
            v736 = up45
            v745 = UDim2.fromOffset(176, 30)
            v736.Size = v745
            v736 = up45
            v736.TextSize = 24
            v736 = up45
            v745 = Enum.TextXAlignment
            v749, v750 = "kI-\146", 21944539998186
            v744 = v745.Left
            v747, v748, v749 = "\231\241\226\175\253S;", 21230641063582, "\166\203\128\225w\147\152\242\215."
            v736.TextXAlignment = v744
            v736 = up46
            v747, v748 = "*\020\169nA\243 \226", 12352877680248
            v736.Visible = true
            v736 = up46
            v744 = UDim2.fromOffset
            v749, v747 = "\162\199\208&mi\202\14967", 33
            v745 = v744(81, v747)
            v736.Position = v745
            v736 = up46
            v745 = UDim2.fromOffset(180, 21)
            v736.Size = v745
            v736 = up46
            v736.TextSize = 11
            v736 = up47
            v747, v748 = "A\219?\165", 26834373636303
            v744 = UDim2.fromOffset
            v750, v747 = 28915997717657, 48
            v745 = v744(168, v747)
            v736.Size = v745
            v736 = up47
            v748, v747 = 1679763751694, "\190\181\166{E\021e+"
            v744 = UDim2.new
            v751, v747 = 16, -18
            v745 = v744(1, v747, 0, v751)
            v736.Position = v745
            v747, v750 = "\219\162D\159e\030?\160\228uT", 16895301951163
            v736 = up49
            v749, v748 = "\133W\143", 12531334977227
            v745 = Vector2
            v750, v747, v748 = 11586513802515, 0.5, 5027452029221
            v745 = v745.new (0, v747)
            v736.AnchorPoint = v745
            v736 = up49
            v744 = UDim2.new
            v747, v751, v748 = 11, 0, 0.5
            v745 = v744(0, v747, v748, v751)
            v736.Position = v745
            v736 = up49
            v745 = UDim2.fromOffset(30, 30)
            v736.Size = v745
            v748, v749 = 1818509607758, "*l\005\r\199!t\0209\246"
            v736 = up50
            v748, v744 = 34915266609026, true
            v736.Visible = v744
            v736 = up51
            v745 = UDim2.fromOffset(18, 80)
            v736.Position = v745
            v736 = up51
            v750, v747 = 17375145090970, "\155\157\021\196"
            v744 = UDim2.new
            v748, v747 = 0, -36
            v745 = v744(1, v747, v748, 1)
            v736.Size = v745
            v736 = up52
            v750, v748, v747 = 24723071069432, 11929993385395, "o\231\143v\172\238@\151"
            v745 = UDim2.fromOffset(6, 88)
            v736.Position = v745
            v736 = up52
            v744 = UDim2.new
            v751, v747, v749 = -96, -12, "[j$\191\174m\015\132m\146"
            v745 = v744(1, v747, 1, v751)
            v736.Size = v745
            v736 = up52
            v747, v748 = "^\154lf\206\153\015\246\219s", 26491552837680
            v744 = UDim2.fromOffset
            v748, v750 = 3604388660878, 5039250999594
            v745 = v744(0, 0)
            v736.CanvasSize = v745
            v736 = up52
            v745 = Vector2.new(0, 0)
            v736.CanvasPosition = v745
            v736 = up52
            v748, v747 = 4207492761511, "\231\022%\249\155\000\216*\215?Y\199\207\201\127_\172\001"
            v736.ScrollBarThickness = 0
            v744, v745 = 24, "math"
            v736 = math.clamp
            v746 = math.floor((v742 * .024))
            v745, v747 = 12, 22
            v737 = v736(v746, v745, v747)
            v747, v745 = 2, v737
            v737 = (v742 - (v744 * v747))
            v750, v747 = "\129\226\019\181\238", 2
            v746 = (v737 - (v745 * v747))
            v737 = math.floor((v746 / 3))
            v748, v752, v747 = "math", "DG\200", v737
            v737 = math.max(326, (v743 - 150))
            v736, v748 = 24, v737
            v751, v737 = v736, "ipairs"
            v736 = ipairs
            for v750, v753 in v736(up53) do
                v756 = (v744 + ((v750 - 1) * (v747 + v745)))
                v736 = v753.Frame
                v757 = UDim2.fromOffset(v756, v751)
                v736.Position = v757
                v736 = v753.Frame
                v757 = UDim2.fromOffset(v747, v748)
                v736.Size = v757
                v736 = v753.Title
                v755 = (((v747 < 240) and 19) or 23)
                v736.TextSize = v755
                if v753["PopularBadge"] then
                    v754 = v753.PopularBadge
                    v758 = UDim2.new(0.5, 0, 0, 12)
                    v754.Position = v758
                    v754 = v753.PopularBadge
                    v758 = UDim2.fromOffset((math.min (176, (v747 - 24))), 28)
                    v754.Size = v758
                    v754 = v753.Title
                    v758 = UDim2.fromOffset(14, 48)
                    v754.Position = v758
                    v754 = v753.LogoBox
                    v758 = UDim2.fromOffset(14, 86)
                    v754.Position = v758
                    v754 = v753.DetailBox
                    v758 = UDim2.fromOffset(14, 170)
                    v754.Position = v758
                else
                    v754 = v753.Title
                    v758 = UDim2.fromOffset(14, 18)
                    v754.Position = v758
                    v754 = v753.LogoBox
                    v758 = UDim2.fromOffset(14, 58)
                    v754.Position = v758
                    v754 = v753.DetailBox
                    v758 = UDim2.fromOffset(14, 142)
                    v754.Position = v758
                end
            end
        else
            v743 = math.min(420, v739)
            v744 = math.min(620, v740)
            v742 = (v743 < 320)
            v745 = up31
            v748 = UDim2.fromOffset(v743, v744)
            v745.Size = v748
            v745 = up41
            v745.Visible = false
            v745 = up42
            v745.Visible = false
            v745 = up39
            v748 = UDim2.fromOffset(10, 14)
            v745.Position = v748
            v745 = up39
            v748 = UDim2.fromOffset(38, 38)
            v745.Size = v748
            v745 = up39
            v745.TextSize = 21
            v745 = up47
            v748 = UDim2.fromOffset(42, 38)
            v745.Size = v748
            v745 = up47
            v748 = UDim2.new(1, -10, 0, 14)
            v745.Position = v748
            v745 = up49
            v748 = Vector2.new(0.5, 0.5)
            v745.AnchorPoint = v748
            v745 = up49
            v748 = UDim2.fromScale(0.5, 0.5)
            v745.Position = v748
            v745 = up49
            v748 = UDim2.fromOffset(25, 25)
            v745.Size = v748
            v745 = up50
            v745.Visible = false
            v746 = math.max(104, (v743 - 128))
            v745 = up43
            v751 = Vector2.new(0.5, 0)
            v745.AnchorPoint = v751
            v745 = up43
            v751 = UDim2.new(0.5, 0, 0, 7)
            v745.Position = v751
            v745 = up43
            v751 = UDim2.fromOffset(v746, 58)
            v745.Size = v751
            if v742 then
                v745 = up44
                v745.Visible = false
                v745 = up45
                v751 = UDim2.fromOffset(0, 7)
                v745.Position = v751
                v745 = up45
                v751 = UDim2.new(1, 0, 0, 28)
                v745.Size = v751
                v745 = up45
                v745.TextSize = 18
                v745 = up45
                v748 = Enum.TextXAlignment.Center
                v745.TextXAlignment = v748
                v745 = up46
                v745.Visible = false
            else
                v745 = up44
                v745.Visible = true
                v745 = up44
                v751 = UDim2.fromOffset(4, 9)
                v745.Position = v751
                v745 = up44
                v751 = UDim2.fromOffset(40, 40)
                v745.Size = v751
                v745 = up45
                v751 = UDim2.fromOffset(50, 5)
                v745.Position = v751
                v745 = up45
                v751 = UDim2.new(1, -52, 0, 27)
                v745.Size = v751
                v745 = up45
                v745.TextSize = (((v743 < 360) and 18) or 20)
                v745 = up45
                v748 = Enum.TextXAlignment .Left
                v745.TextXAlignment = v748
                v745 = up46
                v745.Visible = (v743 >= 350)
                v745 = up46
                v751 = UDim2.fromOffset(51, 31)
                v745.Position = v751
                v745 = up46
                v751 = UDim2.new(1, -54, 0, 19)
                v745.Size = v751
                v745 = up46
                v745.TextSize = 9
            end
            v745 = up51
            v751 = UDim2
            v756, v753 = 9414189617439, "\142\217\230m<^\232A\027\018"
            v751 = v751.fromOffset(10, 70)
            v745.Position = v751
            v745 = up51
            v753, v756 = "0W\218", 18740835295766
            v748 = UDim2.new
            v756, v765, v749 = 34053830573553, 1, 1
            v751 = v748(v749, -20, 0, v765)
            v745.Size = v751
            v745 = up52
            v751 = UDim2.fromOffset(4, 76)
            v745.Position = v751
            v745 = up52
            v751 = UDim2.new(1, -8, 1, -82)
            v745.Size = v751
            v745 = up52
            v753, v756 = "\229.\007", 23867370646378
            v751 = Vector2.new(0, 0)
            v745.CanvasPosition = v751
            v745 = up52
            v745.ScrollBarThickness = ((v742 and 3) or 4)
            v751, v747, v749 = 12, v736, 8
            v747, v748 = 14, (v742 and v749)
            v749, v745 = (v742 and 284), (v748 or v751)
            v748 = (v749 or 310)
            v751 = ((v743 - (v745 * 2)) - 8)
            v749 = 10
            v750 = (((10 + (v748 * (#up53))) + (v747 * ((#up53) - 1))) + 14)
            v752 = up52
            v756 = UDim2.fromOffset(0, v750)
            v752.CanvasSize = v756
            v752 = ipairs
            v754 = up53
            for v756, v754 in v752(v754) do
                v755 = (v749 + ((v756 - 1) * (v748 + v747)))
                v757 = v754.Frame
                v760 = UDim2.fromOffset(v745, v755)
                v757.Position = v760
                v757 = v754.Frame
                v760 = UDim2.fromOffset(v751, v748)
                v757.Size = v760
                v757 = v754.Title
                v757.TextSize = ((v742 and 18) or 21)
                if v754["PopularBadge"] then
                    v757 = v754.PopularBadge
                    v760 = UDim2.new(0.5, 0, 0, 9)
                    v757.Position = v760
                    v757 = v754.PopularBadge
                    v760 = UDim2.fromOffset((math.min (176, (v751 - 20))), 26)
                    v757.Size = v760
                    v757 = v754.Title
                    v760 = UDim2.fromOffset(12, 40)
                    v757.Position = v760
                    v757 = v754.LogoBox
                    v760 = UDim2.fromOffset(12, 70)
                    v757.Position = v760
                    v757 = v754.LogoBox
                    v759 = UDim2.new
                    v767 = (v742 and 58)
                    v760 = v759(1, -24, 0, (v767 or 66))
                    v757.Size = v760
                    v757 = v754.DetailBox
                    v760 = UDim2.fromOffset(12, ((v742 and 136) or 145))
                    v757.Position = v760
                else
                    v757 = v754.Title
                    v760 = UDim2.fromOffset(12, 11)
                    v757.Position = v760
                    v757 = v754.LogoBox
                    v760 = UDim2.fromOffset(12, 41)
                    v757.Position = v760
                    v757 = v754.LogoBox
                    v759 = UDim2.new
                    v767 = (v742 and 58)
                    v760 = v759(1, -24, 0, (v767 or 66))
                    v757.Size = v760
                    v757 = v754.DetailBox
                    v760 = UDim2.fromOffset(12, ((v742 and 107) or 116))
                    v757.Position = v760
                end
                v757 = v754.DetailBox
                v759 = UDim2.new
                v764 = ((v742 and 76) or 84)
                v760 = v759(1, -24, 0, v764)
                v757.Size = v760
            end
        end
        return
    end
    local up54 = v550
    up54()
    v584 = capturedValues1.value20.CurrentCamera
    if v584 then
        v584:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if (capturedValues1.value37 == up30) then
                up54()
            end
            return
        end)
    end
    up31.BackgroundTransparency = 1
    v553.Transparency = 1
    local v587 = up33.Scale
    up33.Scale = math.max(0.5, (v587 * .94))
    v550 = capturedValues1.value17
    v589 = up33
    v591 = TweenInfo.new(.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    v550:Create(v589, v591, {["Scale"] = v587}):Play()
    v550 = capturedValues1.value17
    v589 = up31
    v591 = TweenInfo.new(.18)
    v550:Create(v589, v591, {["BackgroundTransparency"] = 0}):Play()
    v550 = capturedValues1.value17
    v590 = TweenInfo
    local v588 = v550.Create
    v590 = v590.new(.22)
    v588 = v588(v550, v553, v590, {["Transparency"] = 0})
    v588:Play()
    return
end
capturedValues1.value39 = v955
v955 = v946.Main
v956 = v955.AddInput
v962 = capturedValues1.value13
local v970 = function(arg42_1)
    capturedValues1.value13 = arg42_1
    return
end
v956(v955, "KeyInput", {["Title"] = "Access Key:", ["Default"] = v962, ["Placeholder"] = "Paste your Luarmor key here...", ["Numeric"] = false, ["Finished"] = false, ["Callback"] = v970})
v955 = v946.Main
local v964 = function()
    capturedValues1.value39()
    return
end
spilledValues1.value6, spilledValues1.value7 = v955.AddButton, {["Title"] = "1. Get Key", ["Description"] = "Lifetime, Premium, or Free Key with Ads", ["Callback"] = v964}
spilledValues1.value6(v955, spilledValues1.value7)
v955 = v946.Main
spilledValues1.value6 = v955.AddButton
v964 = function()
    up117(capturedValues1.value13)
    return
end
spilledValues1.value6(v955, {["Title"] = "2. Check Key", ["Description"] = "Click here after pasting your key above", ["Callback"] = v964})
v952:SelectTab(1)
spilledValues1.value6 = capturedValues1.value13
if (spilledValues1.value6 ~= "") then
    task.spawn(function()
        up117(capturedValues1.value13)
        return
    end)
else
    capturedValues1.value35("Welcome!", ("Please get a key to use " .. v894))
end
return
