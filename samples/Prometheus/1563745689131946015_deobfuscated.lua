-- This file was generated at discord.gg/syncrypt

local unpackValues = unpack or table.unpack
local v2274, v2278
local v2280, v2282, v2289, v2290, v2293, v2296, v2298
local v2337
local v2358, v2360, v2361
local v2384
local v2259 = (not ((function()
    local v1192, v1195, v1197, v1198, v1199, v1200, v1201, v1202
    local up16
    local v1193 = function()
        local v2016 = identifyexecutor or getexecutorname
        if v2016 then
            up16 = v2016()
        end
        return
    end
    up16 = nil
    pcall(v1193)
    local v1194 = ((type(up16)) == "string") and (string.find((string.lower (up16)), "wave", 1, true))
    if v1194 then
        print("Not supported executor.")
        v1192 = false
        return v1192
    else
        v1194 = ((rawget(_G, "Wave")) ~= nil) or ((rawget(_G, "wave")) ~= nil)
        if v1194 then
            print("Not supported executor.")
            v1192 = false
            return v1192
        else
            local up17 = false
            v1195 = function()
                local v2055 = ((typeof(game)) ~= "Instance") or ((typeof(workspace)) ~= "Instance")
                if v2055 then
                    up17 = true
                end
                return
            end
            pcall(v1195)
            if iscclosure then
                v1192 = ipairs
                v1198 = pcall
                v1199 = error
                v1200 = setmetatable
                v1201 = rawget
                for v1197, v1199 in v1192({v1198, v1199, v1200, v1201}) do
                    v1200, v1201 = pcall(iscclosure, v1199)
                    v1202 = v1200 and (v1201 == false)
                    if v1202 then
                        up17 = true
                    else
                        continue
                    end
                    break
                end
            end
            if up17 then
                print("Hello, sadly but your shit tamper detected")

                return false
            else
                return true
            end
        end
    end
end)()))
if v2259 then
    return
else
    local capturedValues1 = {}
    v2259 = game:GetService("Players")
    capturedValues1.value1 = v2259
    v2259 = game:GetService("UserInputService")
    capturedValues1.value2 = v2259
    v2259 = game:GetService("TweenService")
    capturedValues1.value3 = v2259
    v2259 = game:GetService("RunService")
    capturedValues1.value4 = v2259
    v2259 = game:GetService("VirtualInputManager")
    capturedValues1.value5 = v2259
    v2259 = game:GetService("HttpService")
    capturedValues1.value6 = v2259
    v2259 = game:GetService("Teams")
    capturedValues1.value7 = v2259
    v2259 = workspace
    capturedValues1.value8 = v2259
    v2259 = capturedValues1.value1.LocalPlayer
    capturedValues1.value9 = v2259
    v2259 = capturedValues1.value8.CurrentCamera
    capturedValues1.value10 = v2259
    v2259 = gethui and (gethui()) or (game:GetService("CoreGui"))
    capturedValues1.value11 = v2259
    v2274 = capturedValues1.value9:WaitForChild("PlayerGui")
    capturedValues1.value12 = v2274
    v2280 = Color3.fromRGB(24, 24, 24)
    v2278 = Color3.fromRGB(32, 32, 32)
    v2282 = Color3.fromRGB(48, 48, 48)
    v2290 = Color3.fromRGB(38, 38, 38)
    v2293 = Color3.fromRGB(52, 52, 52)
    v2296 = Color3.fromRGB(217, 119, 87)
    v2289 = Color3.fromRGB(240, 240, 240)
    v2298 = Color3.fromRGB(150, 150, 150)
    v2259 = Color3.fromRGB(60, 60, 60)
    v2274 = Color3.fromRGB(255, 255, 255)
    v2274 = {["Background"] = v2280, ["Secondary"] = v2278, ["Tertiary"] = v2282, ["Element"] = v2290, ["ElementHover"] = v2293, ["Accent"] = v2296, ["Text"] = v2289, ["TextDark"] = v2298, ["Stroke"] = v2259, ["White"] = v2274}
    capturedValues1.value13 = v2274
    v2274 = Color3.fromRGB(255, 55, 55)
    v2280 = Color3.fromRGB(60, 255, 120)
    v2278 = Color3.fromRGB(255, 215, 40)
    v2290 = Color3.fromRGB(255, 150, 40)
    v2282 = Color3.fromRGB(255, 45, 45)
    v2259 = Color3.fromRGB(255, 255, 255)
    v2298 = Color3.fromRGB(0, 255, 80)
    v2289 = Color3.fromRGB(20, 40, 150)
    capturedValues1.value14 = {["Killer"] = v2274, ["Survivor"] = v2280, ["Generator"] = v2278, ["Pallet"] = v2290, ["Hook"] = v2282, ["Window"] = v2259, ["Gate"] = v2298, ["Tesla"] = v2289}
    v2280 = Color3.fromRGB(50, 255, 110)
    capturedValues1.value15 = v2280
    v2278 = capturedValues1.value10.FieldOfView
    capturedValues1.value16 = {["FOV"] = v2278, ["AimFov"] = 120, ["AimSmooth"] = 0.25, ["AimPart"] = "Head", ["AimTeam"] = "All", ["WalkSpeed"] = 16, ["FlySpeed"] = 60}
    capturedValues1.value17 = 120
    v2282 = Enum.KeyCode.Space
    capturedValues1.value18 = {["Key"] = v2282, ["ZoneMin"] = 107, ["ZoneMax"] = 117}
    v2280 = {["Radar"] = false, ["AutoPerfect"] = false, ["KillTarget"] = false, ["KillAll"] = false, ["Aimbot"] = false, ["AimCircle"] = false, ["AimHolding"] = false, ["Noclip"] = false, ["Fly"] = false, ["GodMode"] = false, ["WalkSpeedOn"] = false, ["Xray"] = false, ["WatermarkOn"] = false, ["ESP"] = {["Players"] = false, ["Generator"] = false, ["Pallet"] = false, ["Hook"] = false, ["Window"] = false, ["Gate"] = false, ["Tesla"] = false}}
    v2278 = function(arg137_1)
        local v1484, v1485, v1486, v1487
        local v1483 = arg137_1.Team
        if v1483 then
            v1484 = (string.lower(v1483.Name))
            v1486 = string.find(v1484, "kill")
            if v1486 then
                v1487 = capturedValues1.value14.Killer
                return v1487
            else
                v1486 = string.find(v1484, "surv")
                if v1486 then
                    v1487 = capturedValues1.value14.Survivor
                    return v1487
                else
                    if v1483["TeamColor"] then
                        v1485 = v1483.TeamColor.Color
                        v1486 = (v1485.R > .6) and (v1485.G < .4)
                        if v1486 then
                            v1487 = capturedValues1.value14.Killer
                            return v1487
                        end
                    end
                end
            end
        end
        return capturedValues1.value14.Survivor
    end
    capturedValues1.value19 = v2280
    v2290 = {}
    v2280 = function()
        local v1497 = capturedValues1.value11:FindFirstChild("ClaudewareGUI")
        if v1497 then
            capturedValues1.value11.ClaudewareGUI:Destroy()
        end
        v1497 = capturedValues1.value11:FindFirstChild("ClaudewareESP")
        if v1497 then
            capturedValues1.value11.ClaudewareESP:Destroy()
        end
        v1497 = capturedValues1.value11:FindFirstChild("ClaudewareWM")
        if v1497 then
            capturedValues1.value11.ClaudewareWM:Destroy()
        end
        return
    end
    capturedValues1.value20 = {["toggles"] = v2290, ["sliders"] = {}, ["colors"] = {}}
    capturedValues1.value21 = {}
    capturedValues1.value22 = false
    v2259 = Enum.UserInputType.MouseButton2
    v2289 = function(arg139_1, arg139_2, arg139_3)
        local v1500 = capturedValues1.value3
        local v1506 = TweenInfo.new
        local v1505 = Enum.EasingStyle.Quart
        local v1502 = Enum.EasingDirection.Out
        local v1501 = v1506(arg139_2, v1505, v1502)
        local v1511 = v1500:Create(arg139_1, v1501, arg139_3)
        v1511:Play()
        return v1511
    end
    v2298 = function(arg140_1, arg140_2)
        local v1516 = (Instance.new("UICorner"))
        v1516.CornerRadius = UDim.new(0, (arg140_2 or 6))
        v1516.Parent = arg140_1
        return v1516
    end
    v2290 = function()
        local v1524 = capturedValues1.value9.Character
        local v1521 = v1524 and (v1524:FindFirstChild("HumanoidRootPart")) or v1524.PrimaryPart
        local v1522 = v1521 and v1521.Position
        return (v1522 or nil)
    end
    capturedValues1.value23 = {["kind"] = "mouse", ["input"] = v2259}
    v2259 = function(arg142_1)
        local v1536 = string.format
        local v1535 = "#%02X%02X%02X"
        local v1533 = math.floor(((arg142_1.R * 255) + 0.5))
        local v1534 = math.floor(((arg142_1.G * 255) + 0.5))
        local v1532 = math.floor
        local v1538 = ((arg142_1.B * 255) + 0.5)
        return v1536(v1535, v1533, v1534, v1532(v1538))
    end
    v2282 = function(arg143_1)
        local v1546, v1548, v1549, v1550
        local v1547 = string.gsub
        local v1545 = arg143_1
        if not (arg143_1) then
            v1545 = ""
        end
        v1545 = (v1547(v1545, "#", ""))
        if ((#v1545) == 6) then
            v1547 = (tonumber((string.sub(v1545, 1, 2)), 16))
            v1548 = (tonumber((string.sub(v1545, 3, 4)), 16))
            v1549 = (tonumber((string.sub (v1545, 5, 6)), 16))
            v1546 = v1547 and (v1548 and v1549)
            if v1546 then
                v1550 = Color3.fromRGB
                return v1550(v1547, v1548, v1549)
            end
        end
        return nil
    end
    capturedValues1.value24 = false
    capturedValues1.value25 = nil
    v2274 = function(arg144_1)
        return arg144_1.Character
    end
    capturedValues1.value26 = v2289
    v2289 = function(arg145_1)
        local v1561 = arg145_1
        return v1561 and (v1561:FindFirstChild("HumanoidRootPart")) or (v1561:FindFirstChild("Torso"))
    end
    capturedValues1.value27 = v2298
    v2298 = function(arg146_1, arg146_2, arg146_3, arg146_4)
        local v1569 = arg146_3
        local v1570 = arg146_1
        local v1572 = Instance
        local v1574 = arg146_4
        local v1571 = (v1572.new("UIStroke"))
        v1572 = arg146_2
        if not (arg146_2) then
            v1572 = capturedValues1.value13.Stroke
        end
        v1571.Color = v1572
        v1571.Thickness = (v1569 or 1)
        v1571.Transparency = (v1574 or 0)
        v1571.Parent = v1570
        return v1571
    end
    v2293 = function(arg147_1)
        local v1582 = arg147_1
        return v1582 and (v1582:FindFirstChildOfClass("Humanoid"))
    end
    capturedValues1.value28 = v2298
    v2298 = function(arg148_1, arg148_2)
        local v1593 = (Instance.new("UIPadding"))
        v1593.PaddingTop = UDim.new(0, arg148_2)
        v1593.PaddingBottom = UDim.new(0, arg148_2)
        v1593.PaddingLeft = UDim.new(0, arg148_2)
        v1593.PaddingRight = UDim.new(0, arg148_2)
        v1593.Parent = arg148_1
        return v1593
    end
    capturedValues1.value29 = v2259
    v2259 = function()
        local v1601 = capturedValues1.value9.Team
        return (v1601 ~= nil) and ((string.find((string.lower(v1601.Name)), "kill")) ~= nil)
    end
    capturedValues1.value30 = v2282
    capturedValues1.value31 = v2274
    capturedValues1.value32 = v2293
    capturedValues1.value33 = v2289
    capturedValues1.value34 = v2290
    capturedValues1.value35 = v2278
    capturedValues1.value36 = v2259
    v2259 = pcall
    v2259(v2280)
    v2280 = Instance.new("ScreenGui")
    capturedValues1.value37 = v2280
    v2280 = capturedValues1.value37
    v2280.Name = "ClaudewareGUI"
    v2280 = capturedValues1.value37
    v2280.ResetOnSpawn = false
    v2280 = capturedValues1.value37
    v2274 = Enum.ZIndexBehavior.Sibling
    v2280.ZIndexBehavior = v2274
    v2280 = capturedValues1.value37
    v2280.Parent = capturedValues1.value11
    v2274 = Instance.new("Frame")
    capturedValues1.value38 = v2274
    v2274 = capturedValues1.value38
    v2278 = Vector2.new(1, 1)
    v2274.AnchorPoint = v2278
    v2274 = capturedValues1.value38
    v2278 = UDim2.new(1, -16, 1, -16)
    v2274.Position = v2278
    v2274 = capturedValues1.value38
    v2278 = UDim2.new(0, 260, 0, 400)
    v2274.Size = v2278
    v2274 = capturedValues1.value38
    v2274.BackgroundTransparency = 1
    v2274 = capturedValues1.value38
    v2274.Parent = capturedValues1.value37
    v2274 = Instance.new("UIListLayout")
    v2278 = UDim.new(0, 8)
    v2274.Padding = v2278
    v2280 = Enum.VerticalAlignment.Bottom
    v2274.VerticalAlignment = v2280
    v2280 = Enum.SortOrder.LayoutOrder
    v2274.SortOrder = v2280
    v2274.Parent = capturedValues1.value38
    v2280 = function(arg150_1, arg150_2, arg150_3)
        local v1610 = (arg150_3 or 3)
        local v1611 = Instance.new("Frame")
        local up32 = v1611
        up32.Size = UDim2.new(1, 0, 0, 50)
        up32.BackgroundColor3 = capturedValues1.value13.Secondary
        up32.BackgroundTransparency = 1
        up32.ClipsDescendants = true
        up32.Parent = capturedValues1.value38
        capturedValues1.value27(up32, 6)
        local v1615 = capturedValues1.value28(up32, capturedValues1.value13.Stroke, 1, 1)
        local up33 = v1615
        local v1612 = Instance.new("Frame")
        local up34 = v1612
        up34.Size = UDim2.new(0, 3, 1, -10)
        up34.Position = UDim2.new(0, 4, 0, 5)
        up34.BackgroundColor3 = capturedValues1.value13.Accent
        up34.BorderSizePixel = 0
        up34.BackgroundTransparency = 1
        up34.Parent = up32
        capturedValues1.value27(up34, 2)
        local v1613 = Instance.new("TextLabel")
        local up35 = v1613
        up35.Size = UDim2.new(1, -16, 0, 18)
        up35.Position = UDim2.new(0, 14, 0, 8)
        up35.BackgroundTransparency = 1
        up35.Text = arg150_1
        up35.Font = Enum.Font.GothamBold
        up35.TextSize = 13
        up35.TextColor3 = capturedValues1.value13.Text
        up35.TextTransparency = 1
        up35.TextXAlignment = Enum.TextXAlignment.Left
        up35.Parent = up32
        local v1614 = Instance.new("TextLabel")
        local up36 = v1614
        up36.Size = UDim2.new(1, -16, 0, 14)
        up36.Position = UDim2.new(0, 14, 0, 27)
        up36.BackgroundTransparency = 1
        up36.Text = arg150_2
        up36.Font = Enum.Font.Gotham
        up36.TextSize = 11
        up36.TextColor3 = capturedValues1.value13.TextDark
        up36.TextTransparency = 1
        up36.TextXAlignment = Enum.TextXAlignment.Left
        up36.Parent = up32
        capturedValues1.value26(up32, .3, {["BackgroundTransparency"] = 0})
        capturedValues1.value26(up33, .3, {["Transparency"] = 0})
        capturedValues1.value26(up34, .3, {["BackgroundTransparency"] = 0})
        capturedValues1.value26(up35, .3, {["TextTransparency"] = 0})
        capturedValues1.value26(up36, .3, {["TextTransparency"] = .2})
        task.delay(v1610, function()
            capturedValues1.value26(up32, .3, {["BackgroundTransparency"] = 1})
            capturedValues1.value26(up33, .3, {["Transparency"] = 1})
            capturedValues1.value26(up34, .3, {["BackgroundTransparency"] = 1})
            capturedValues1.value26(up35, .3, {["TextTransparency"] = 1})
            capturedValues1.value26(up36, .3, {["TextTransparency"] = 1})
            task.wait(.35)
            local v2172 = function()
                up32:Destroy()
                return
            end
            pcall(v2172)

            return
        end)

        return
    end
    capturedValues1.value39 = v2280
    v2278 = Instance.new("Frame")
    capturedValues1.value40 = v2278
    v2278 = capturedValues1.value40
    v2278.Name = "Main"
    v2278 = capturedValues1.value40
    v2280 = UDim2.new(0, 570, 0, 400)
    v2278.Size = v2280
    v2278 = capturedValues1.value40
    v2280 = UDim2.new(0.5, -240, 0.5, -200)
    v2278.Position = v2280
    v2278 = capturedValues1.value40
    v2274 = capturedValues1.value13.Background
    v2278.BackgroundColor3 = v2274
    v2278 = capturedValues1.value40
    v2278.BorderSizePixel = 0
    v2278 = capturedValues1.value40
    v2278.Active = true
    v2278 = capturedValues1.value40
    v2278.Parent = capturedValues1.value37
    capturedValues1.value27(capturedValues1.value40, 10)
    capturedValues1.value28(capturedValues1.value40, capturedValues1.value13.Stroke, 1, 0)
    v2278 = Instance.new("ImageLabel")
    v2278.Name = "Shadow"
    v2280 = Vector2.new(0.5, 0.5)
    v2278.AnchorPoint = v2280
    v2280 = UDim2.new(0.5, 0, 0.5, 0)
    v2278.Position = v2280
    v2280 = UDim2.new(1, 46, 1, 46)
    v2278.Size = v2280
    v2278.BackgroundTransparency = 1
    v2278.Image = "rbxassetid://6014261993"
    v2280 = Color3.fromRGB(0, 0, 0)
    v2278.ImageColor3 = v2280
    v2278.ImageTransparency = 0.5
    v2274 = Enum.ScaleType.Slice
    v2278.ScaleType = v2274
    v2280 = Rect.new(49, 49, 450, 450)
    v2278.SliceCenter = v2280
    v2278.ZIndex = 0
    v2278.Parent = capturedValues1.value40
    v2274 = Instance.new("Frame")
    v2290 = UDim2.new(1, 0, 0, 44)
    v2274.Size = v2290
    v2280 = capturedValues1.value13.Secondary
    v2274.BackgroundColor3 = v2280
    v2274.BorderSizePixel = 0
    v2274.Parent = capturedValues1.value40
    capturedValues1.value27(v2274, 10)
    v2280 = Instance.new("Frame")
    v2278 = UDim2.new(1, 0, 0, 12)
    v2280.Size = v2278
    v2278 = UDim2.new(0, 0, 1, -12)
    v2280.Position = v2278
    v2290 = capturedValues1.value13.Secondary
    v2280.BackgroundColor3 = v2290
    v2280.BorderSizePixel = 0
    v2280.Parent = v2274
    v2290 = Instance.new("Frame")
    v2280 = UDim2.new(1, 0, 0, 1)
    v2290.Size = v2280
    v2280 = UDim2.new(0, 0, 1, -1)
    v2290.Position = v2280
    v2278 = capturedValues1.value13.Accent
    v2290.BackgroundColor3 = v2278
    v2290.BackgroundTransparency = .65
    v2290.BorderSizePixel = 0
    v2290.ZIndex = 6
    v2290.Parent = v2274
    v2278 = Instance.new("Frame")
    v2290 = Vector2.new(0.5, 0.5)
    v2278.AnchorPoint = v2290
    v2290 = UDim2.new(0.5, 0, 0.5, 0)
    v2278.Position = v2290
    v2290 = UDim2.new(0, 0, 0, 24)
    v2278.Size = v2290
    v2280 = Enum.AutomaticSize.X
    v2278.AutomaticSize = v2280
    v2278.BackgroundTransparency = 1
    v2278.Parent = v2274
    v2280 = Instance.new("UIListLayout")
    v2290 = Enum.FillDirection.Horizontal
    v2280.FillDirection = v2290
    v2290 = Enum.VerticalAlignment.Center
    v2280.VerticalAlignment = v2290
    v2290 = Enum.SortOrder.LayoutOrder
    v2280.SortOrder = v2290
    v2290 = UDim.new(0, 6)
    v2280.Padding = v2290
    v2280.Parent = v2278
    v2290 = Instance.new("ImageLabel")
    v2280 = UDim2.new(0, 22, 0, 22)
    v2290.Size = v2280
    v2290.BackgroundTransparency = 1
    v2290.Image = "rbxassetid://115798729575437"
    v2290.LayoutOrder = 1
    v2290.Parent = v2278
    v2290 = Instance.new("TextLabel")
    v2280 = Enum.AutomaticSize.X
    v2290.AutomaticSize = v2280
    v2282 = UDim2.new(0, 0, 1, 0)
    v2290.Size = v2282
    v2290.BackgroundTransparency = 1
    v2290.RichText = true
    v2290.Text = "<font color=\"#ffffff\">Claude</font><font color=\"#d97757\">ware</font>"
    v2280 = Enum.Font.GothamBold
    v2290.Font = v2280
    v2290.TextSize = 16
    v2280 = capturedValues1.value13.White
    v2290.TextColor3 = v2280
    v2290.LayoutOrder = 2
    v2290.Parent = v2278
    v2280 = Instance.new("TextLabel")
    v2278 = UDim2.new(0, 58, 0, 20)
    v2280.Size = v2278
    v2278 = UDim2.new(1, -70, 0.5, -10)
    v2280.Position = v2278
    v2282 = capturedValues1.value13.Element
    v2280.BackgroundColor3 = v2282
    v2280.Text = "[BETA]"
    v2282 = Enum.Font.GothamBold
    v2280.Font = v2282
    v2280.TextSize = 11
    v2282 = capturedValues1.value13.Accent
    v2280.TextColor3 = v2282
    v2280.Parent = v2274
    capturedValues1.value27(v2280, 6)
    capturedValues1.value28(v2280, capturedValues1.value13.Stroke, 1, 0)
    capturedValues1.value41 = false
    capturedValues1.value42 = nil
    capturedValues1.value43 = nil
    v2280 = function(arg151_1)
        local v1629, v1630
        local up37 = arg151_1
        local v1634 = (up37.UserInputType == Enum.UserInputType.MouseButton1) or (up37.UserInputType == Enum.UserInputType.Touch)
        if v1634 then
            capturedValues1.value41 = true
            capturedValues1.value42 = up37.Position
            capturedValues1.value43 = capturedValues1.value40.Position
            v1630 = up37.Changed
            v1629 = function()
                local v756 = up37.UserInputState
                local v755 = Enum.UserInputState
                if (v756 == v755["End"]) then
                    capturedValues1.value41 = false
                end
                return
            end
            v1630:Connect(v1629)
        end
        return
    end
    v2274.InputBegan :Connect(v2280)
    v2278 = capturedValues1.value2.InputChanged
    v2280 = function(arg152_1)
        local v1648, v1650
        local v1637 = capturedValues1.value41
        local v1638 = v1637
        local v1639 = arg152_1
        if v1637 then
            v1638 = (v1639.UserInputType == Enum.UserInputType.MouseMovement) or (v1639.UserInputType == Enum.UserInputType.Touch)
        end
        if v1638 then
            v1637 = (v1639.Position - capturedValues1.value42)
            v1650 = capturedValues1.value40
            v1648 = UDim2.new(capturedValues1.value43.X.Scale, (capturedValues1.value43.X.Offset + v1637.X), capturedValues1.value43.Y.Scale, (capturedValues1.value43.Y .Offset + v1637.Y))
            v1650.Position = v1648
        end
        return
    end
    v2278:Connect(v2280)
    v2282 = Instance.new("TextButton")
    capturedValues1.value44 = v2282
    v2282 = capturedValues1.value44
    v2282.Name = "Discord"
    v2282 = capturedValues1.value44
    v2280 = UDim2.new(0, 96, 0, 26)
    v2282.Size = v2280
    v2282 = capturedValues1.value44
    v2280 = UDim2.new(0, 10, 0.5, -13)
    v2282.Position = v2280
    v2282 = capturedValues1.value44
    v2280 = Color3.fromRGB(88, 101, 242)
    v2282.BackgroundColor3 = v2280
    v2282 = capturedValues1.value44
    v2282.AutoButtonColor = false
    v2282 = capturedValues1.value44
    v2282.Text = ""
    v2282 = capturedValues1.value44
    v2282.ZIndex = 6
    v2282 = capturedValues1.value44
    v2282.Parent = v2274
    capturedValues1.value27(capturedValues1.value44, 8)
    capturedValues1.value28(capturedValues1.value44, (Color3.fromRGB(88, 101, 242)), 1, .35)
    v2278 = Instance.new("ImageLabel")
    v2280 = UDim2.new(0, 16, 0, 16)
    v2278.Size = v2280
    v2280 = UDim2.new(0, 9, 0.5, -8)
    v2278.Position = v2280
    v2278.BackgroundTransparency = 1
    v2278.Image = "rbxassetid://18505728201"
    v2274 = capturedValues1.value13.White
    v2278.ImageColor3 = v2274
    v2278.ZIndex = 7
    v2278.Parent = capturedValues1.value44
    v2274 = Instance.new("TextLabel")
    v2280 = UDim2.new(1, -32, 1, 0)
    v2274.Size = v2280
    v2280 = UDim2.new(0, 30, 0, 0)
    v2274.Position = v2280
    v2274.BackgroundTransparency = 1
    v2274.Text = "Discord"
    v2280 = Enum.Font.GothamBold
    v2274.Font = v2280
    v2274.TextSize = 12
    v2280 = capturedValues1.value13.White
    v2274.TextColor3 = v2280
    v2280 = Enum.TextXAlignment.Left
    v2274.TextXAlignment = v2280
    v2274.ZIndex = 7
    v2274.Parent = capturedValues1.value44
    v2282 = function()
        local v1656
        local v1654 = setclipboard
        local v1655 = v1654
        if not (v1654) then
            v1656 = toclipboard
            v1654 = v1656
            if not (v1656) then
                v1654 = set_clipboard or Clipboard and Clipboard.set
            end
            v1655 = v1654
        end
        v1654 = v1655
        if v1654 then
            pcall(v1654, "https://discord.gg/S23AjGzfNv")
        end
        capturedValues1.value39("Claudeware", "Discord link copied to clipboard", 3)

        return
    end
    capturedValues1.value44.MouseButton1Click:Connect(v2282)
    capturedValues1.value44.MouseEnter:Connect(function()
        local v1668 = capturedValues1.value26
        local v1669 = capturedValues1.value44
        local v1671 = Color3.fromRGB(71, 82, 196)
        v1668(v1669, .15, {["BackgroundColor3"] = v1671})

        return
    end)
    v2280 = capturedValues1.value44.MouseLeave
    v2274 = function()
        local v1679 = capturedValues1.value26
        local v1680 = capturedValues1.value44
        local v1682 = Color3.fromRGB(88, 101, 242)
        v1679(v1680, .15, {["BackgroundColor3"] = v1682})

        return
    end
    v2280:Connect(v2274)
    v2280 = Instance.new("Frame")
    v2280.Name = "SearchBar"
    v2278 = UDim2.new(1, -20, 0, 30)
    v2280.Size = v2278
    v2278 = UDim2.new(0, 10, 0, 50)
    v2280.Position = v2278
    v2274 = capturedValues1.value13.Secondary
    v2280.BackgroundColor3 = v2274
    v2280.BorderSizePixel = 0
    v2280.Parent = capturedValues1.value40
    capturedValues1.value27(v2280, 8)
    capturedValues1.value28(v2280, capturedValues1.value13.Stroke, 1, 0)
    v2274 = Instance.new("Frame")
    v2274.Name = "Glass"
    v2278 = UDim2.new(0, 11, 0, 11)
    v2274.Size = v2278
    v2278 = UDim2.new(0, 12, 0.5, -6)
    v2274.Position = v2278
    v2274.BackgroundTransparency = 1
    v2274.BorderSizePixel = 0
    v2274.Parent = v2280
    v2278 = Instance.new("Frame")
    v2290 = UDim2.new(0, 11, 0, 11)
    v2278.Size = v2290
    v2278.BackgroundTransparency = 1
    v2278.BorderSizePixel = 0
    v2278.Parent = v2274
    capturedValues1.value27(v2278, 6)
    capturedValues1.value28(v2278, capturedValues1.value13.TextDark, 1.5, 0)
    v2278 = Instance.new("Frame")
    v2290 = UDim2.new(0, 5, 0, 2)
    v2278.Size = v2290
    v2290 = Vector2.new(0.5, 0.5)
    v2278.AnchorPoint = v2290
    v2290 = UDim2.new(1, 0, 1, 0)
    v2278.Position = v2290
    v2290 = capturedValues1.value13.TextDark
    v2278.BackgroundColor3 = v2290
    v2278.BorderSizePixel = 0
    v2278.Rotation = 45
    v2278.Parent = v2274
    capturedValues1.value27(v2278, 1)
    v2290 = Instance.new("TextBox")
    capturedValues1.value45 = v2290
    v2290 = capturedValues1.value45
    v2290.Name = "Input"
    v2290 = capturedValues1.value45
    v2274 = UDim2.new(1, -40, 1, 0)
    v2290.Size = v2274
    v2290 = capturedValues1.value45
    v2274 = UDim2.new(0, 32, 0, 0)
    v2290.Position = v2274
    v2290 = capturedValues1.value45
    v2290.BackgroundTransparency = 1
    v2290 = capturedValues1.value45
    v2290.Text = ""
    v2290 = capturedValues1.value45
    v2290.PlaceholderText = "Search"
    v2290 = capturedValues1.value45
    v2274 = capturedValues1.value13.TextDark
    v2290.PlaceholderColor3 = v2274
    v2290 = capturedValues1.value45
    v2274 = Enum.Font.GothamMedium
    v2290.Font = v2274
    v2290 = capturedValues1.value45
    v2290.TextSize = 13
    v2290 = capturedValues1.value45
    v2274 = capturedValues1.value13.Text
    v2290.TextColor3 = v2274
    v2290 = capturedValues1.value45
    v2274 = Enum.TextXAlignment.Left
    v2290.TextXAlignment = v2274
    v2290 = capturedValues1.value45
    v2290.ClearTextOnFocus = false
    v2290 = capturedValues1.value45
    v2290.ClipsDescendants = true
    v2290 = capturedValues1.value45
    v2290.Parent = v2280
    v2290 = Instance.new("Frame")
    v2274 = UDim2.new(0, 120, 1, -96)
    v2290.Size = v2274
    v2274 = UDim2.new(0, 10, 0, 88)
    v2290.Position = v2274
    v2274 = capturedValues1.value13.Secondary
    v2290.BackgroundColor3 = v2274
    v2290.BorderSizePixel = 0
    v2290.Parent = capturedValues1.value40
    capturedValues1.value27(v2290, 8)
    capturedValues1.value28(v2290, capturedValues1.value13.Stroke, 1, 0)
    v2274 = Instance.new("ScrollingFrame")
    capturedValues1.value46 = v2274
    v2274 = capturedValues1.value46
    v2280 = UDim2.new(1, 0, 1, 0)
    v2274.Size = v2280
    v2274 = capturedValues1.value46
    v2274.BackgroundTransparency = 1
    v2274 = capturedValues1.value46
    v2274.BorderSizePixel = 0
    v2274 = capturedValues1.value46
    v2274.ScrollBarThickness = 0
    v2274 = capturedValues1.value46
    v2280 = UDim2.new(0, 0, 0, 0)
    v2274.CanvasSize = v2280
    v2274 = capturedValues1.value46
    v2278 = Enum.AutomaticSize.Y
    v2274.AutomaticCanvasSize = v2278
    v2274 = capturedValues1.value46
    v2274.Parent = v2290
    v2274 = Instance.new("UIListLayout")
    v2280 = UDim.new(0, 4)
    v2274.Padding = v2280
    v2278 = Enum.SortOrder .LayoutOrder
    v2274.SortOrder = v2278
    capturedValues1.value47 = nil
    v2274.Parent = capturedValues1.value46
    v2298(capturedValues1.value46, 8)
    v2280 = {}
    v2278 = {}
    v2274 = {}
    v2298 = function(arg156_1, arg156_2, arg156_3)
        local up38 = arg156_3
        local v1690 = Instance.new("TextButton")
        local up39 = v1690
        up39.Size = UDim2.new(1, 0, 0, 38)
        up39.BackgroundColor3 = capturedValues1.value13.Element
        up39.AutoButtonColor = false
        up39.Text = arg156_2
        up39.Font = Enum.Font.GothamBold
        up39.TextSize = 13
        up39.TextColor3 = capturedValues1.value13.Accent
        up39.Parent = arg156_1
        capturedValues1.value27(up39, 6)
        capturedValues1.value28(up39, capturedValues1.value13.Stroke, 1, 0)
        local v1695 = up39.MouseButton1Click
        local v1691 = function()
            up38()
            return
        end
        v1695:Connect(v1691)
        v1695 = up39.MouseEnter
        v1691 = function()
            local v1461 = capturedValues1.value26
            local v1462 = up39
            local v1463 = capturedValues1.value13.ElementHover
            v1461(v1462, .15, {["BackgroundColor3"] = v1463})

            return
        end
        v1695:Connect(v1691)
        v1695 = up39.MouseLeave
        v1691 = function()
            local v1472 = capturedValues1.value26
            local v1473 = up39
            local v1474 = capturedValues1.value13.Element
            v1472(v1473, .15, {["BackgroundColor3"] = v1474})

            return
        end
        v1695:Connect(v1691)
        table.insert(capturedValues1.value47, {["inst"] = up39, ["name"] = arg156_2, ["page"] = arg156_1})

        return up39
    end
    v2290 = function(arg157_1, arg157_2, arg157_3)
        local v1706 = (Instance.new("TextLabel"))
        v1706.Size = UDim2.new(1, 0, 0, 22)
        v1706.BackgroundTransparency = 1
        v1706.Text = arg157_3
        v1706.Font = Enum.Font.GothamMedium
        v1706.TextSize = 12
        v1706.TextColor3 = capturedValues1.value13.TextDark
        v1706.TextXAlignment = Enum.TextXAlignment.Left
        v1706.Parent = arg157_1
        table.insert(capturedValues1.value47, {["inst"] = v1706, ["name"] = arg157_2, ["page"] = arg157_1})

        return v1706
    end
    capturedValues1.value48 = v2274
    capturedValues1.value49 = v2278
    v2274 = function(arg158_1, arg158_2, arg158_3, arg158_4)
        local v1724, v1725
        local v1713 = arg158_2
        local v1717 = arg158_1
        local up40 = arg158_3
        local v1718 = Instance.new("TextButton")
        local up41 = v1718
        up41.Size = UDim2.new(1, 0, 0, 42)
        up41.BackgroundColor3 = capturedValues1.value13.Element
        up41.AutoButtonColor = false
        up41.Text = ""
        up41.Parent = v1717
        capturedValues1.value27(up41, 6)
        capturedValues1.value28(up41, capturedValues1.value13.Stroke, 1, 0)
        local v1719 = (Instance.new("TextLabel"))
        v1719.Size = UDim2.new(1, -70, 1, 0)
        v1719.Position = UDim2.new(0, 12, 0, 0)
        v1719.BackgroundTransparency = 1
        v1719.Text = v1713
        v1719.Font = Enum.Font.GothamMedium
        v1719.TextSize = 13
        v1719.TextColor3 = capturedValues1.value13.Text
        v1719.TextXAlignment = Enum.TextXAlignment.Left
        v1719.Parent = up41
        v1718 = Instance.new("Frame")
        local up42 = v1718
        up42.Size = UDim2.new(0, 36, 0, 20)
        up42.Position = UDim2.new(1, -46, 0.5, -10)
        up42.BackgroundColor3 = capturedValues1.value13.Tertiary
        up42.BorderSizePixel = 0
        up42.Parent = up41
        capturedValues1.value27(up42, 10)
        v1718 = Instance.new("Frame")
        local up43 = v1718
        up43.Size = UDim2.new(0, 16, 0, 16)
        up43.Position = UDim2.new(0, 2, 0.5, -8)
        up43.BackgroundColor3 = capturedValues1.value13.White
        up43.BorderSizePixel = 0
        up43.Parent = up42
        capturedValues1.value27(up43, 8)
        local v1714 = (arg158_4 and true)
        local up44 = (v1714 or false)
        local up45 = function()
            local v1204, v1205, v1206, v1207
            if up44 then
                v1204 = capturedValues1.value26
                v1205 = up42
                v1206 = capturedValues1.value13.Accent
                v1204(v1205, .2, {["BackgroundColor3"] = v1206})
                v1204 = capturedValues1.value26
                v1205 = up43
                v1207 = UDim2.new(1, -18, 0.5, -8)
                v1204(v1205, .2, {["Position"] = v1207})
            else
                v1204 = capturedValues1.value26
                v1205 = up42
                v1206 = capturedValues1.value13.Tertiary
                v1204(v1205, .2, {["BackgroundColor3"] = v1206})
                v1204 = capturedValues1.value26
                v1205 = up43
                v1207 = UDim2.new(0, 2, 0.5, -8)
                v1204(v1205, .2, {["Position"] = v1207})
            end
            return
        end
        if up44 then
            v1718 = up42
            v1724 = capturedValues1.value13.Accent
            v1718.BackgroundColor3 = v1724
            v1718 = up43
            v1725 = UDim2.new(1, -18, 0.5, -8)
            v1718.Position = v1725
        end
        v1718 = up41.MouseButton1Click
        v1724 = function()
            up44 = (not up44)
            up45()
            up40(up44)
            return
        end
        v1718:Connect(v1724)
        up41.MouseEnter:Connect(function()
            local v445 = capturedValues1.value26
            local v446 = up41
            local v447 = capturedValues1.value13.ElementHover
            v445(v446, .15, {["BackgroundColor3"] = v447})

            return
        end)
        v1718 = up41.MouseLeave
        v1724 = function()
            local v456 = capturedValues1.value26
            local v457 = up41
            local v458 = capturedValues1.value13.Element
            v456(v457, .15, {["BackgroundColor3"] = v458})

            return
        end
        v1718:Connect(v1724)
        v1718 = capturedValues1.value20.toggles
        v1725 = function()
            return up44
        end
        local v1727 = function(arg25_1)
            up44 = ((arg25_1 and true) or false)
            up45()
            up40(up44)
            return
        end
        v1718[v1713] = {["get"] = v1725, ["set"] = v1727}
        table.insert(capturedValues1.value47, {["inst"] = up41, ["name"] = v1713, ["page"] = v1717})

        return up41
    end
    capturedValues1.value50 = v2280
    capturedValues1.value51 = nil
    v2280 = function(arg159_1)
        local v1733, v1738, v1739, v1740, v1741, v1742, v1744, v1751
        local v1734 = arg159_1
        capturedValues1.value51 = v1734
        v1733, v1738, v1739 = pairs(capturedValues1.value48)
        while true do
            v1739, v1740 = v1733(v1738, v1739)
            if not v1739 then
                break
            end
            v1741 = (v1739 == v1734)
            v1740.Visible = v1741
        end
        local v1736 = pairs
        for v1739, v1740 in v1736(capturedValues1.value49) do
            v1741 = capturedValues1.value50[v1739]
            if (v1739 == v1734) then
                v1736 = capturedValues1.value26
                v1744 = capturedValues1.value13.Accent
                v1751 = {["BackgroundColor3"] = v1744}
                v1736(v1740, .15, v1751)
                if v1741 then
                    v1742 = capturedValues1.value13.White
                    v1741.TextColor3 = v1742
                end
            else
                v1736 = capturedValues1.value26
                v1744 = capturedValues1.value13.Element
                v1751 = {["BackgroundColor3"] = v1744}
                v1736(v1740, .15, v1751)
                if v1741 then
                    v1742 = capturedValues1.value13.Text
                    v1741.TextColor3 = v1742
                end
            end
        end
        return
    end
    v2278 = function(arg160_1, arg160_2, arg160_3, arg160_4, arg160_5, arg160_6)
        local up47 = arg160_3
        local up48 = arg160_4
        local up46 = arg160_6
        local v1756 = (Instance.new("Frame"))
        v1756.Size = UDim2.new(1, 0, 0, 50)
        v1756.BackgroundColor3 = capturedValues1.value13.Element
        v1756.BorderSizePixel = 0
        v1756.Parent = arg160_1
        capturedValues1.value27(v1756, 6)
        capturedValues1.value28(v1756, capturedValues1.value13.Stroke, 1, 0)
        local v1753 = (Instance.new("TextLabel"))
        v1753.Size = UDim2.new(1, -60, 0, 16)
        v1753.Position = UDim2.new(0, 12, 0, 6)
        v1753.BackgroundTransparency = 1
        v1753.Text = arg160_2
        v1753.Font = Enum.Font.GothamMedium
        v1753.TextSize = 13
        v1753.TextColor3 = capturedValues1.value13.Text
        v1753.TextXAlignment = Enum.TextXAlignment.Left
        v1753.Parent = v1756
        local v1752 = Instance.new("TextLabel")
        local up49 = v1752
        up49.Size = UDim2.new(0, 44, 0, 16)
        up49.Position = UDim2.new(1, -52, 0, 6)
        up49.BackgroundTransparency = 1
        up49.Text = tostring(arg160_5)
        up49.Font = Enum.Font.GothamBold
        up49.TextSize = 12
        up49.TextColor3 = capturedValues1.value13.Accent
        up49.TextXAlignment = Enum.TextXAlignment.Right
        up49.Parent = v1756
        v1752 = Instance.new("Frame")
        local up50 = v1752
        up50.Size = UDim2.new(1, -24, 0, 6)
        up50.Position = UDim2.new(0, 12, 0, 32)
        up50.BackgroundColor3 = capturedValues1.value13.Tertiary
        up50.BorderSizePixel = 0
        up50.Parent = v1756
        capturedValues1.value27(up50, 3)
        v1752 = Instance.new("Frame")
        local up51 = v1752
        up51.Size = UDim2.new(((arg160_5 - up47) / (up48 - up47)), 0, 1, 0)
        up51.BackgroundColor3 = capturedValues1.value13.Accent
        up51.BorderSizePixel = 0
        up51.Parent = up50
        capturedValues1.value27(up51, 3)
        v1752 = Instance.new("Frame")
        local up52 = v1752
        up52.Size = UDim2.new(0, 12, 0, 12)
        up52.Position = UDim2.new(((arg160_5 - up47) / (up48 - up47)), -6, 0.5, -6)
        up52.BackgroundColor3 = capturedValues1.value13.White
        up52.BorderSizePixel = 0
        up52.Parent = up50
        capturedValues1.value27(up52, 6)
        capturedValues1.value28(up52, capturedValues1.value13.Accent, 1.5, 0)
        local up53 = arg160_5
        local up54 = function(arg193_1, arg193_2)
            local v2117 = (math.clamp((math.floor(arg193_1)), up47, up48))
            local v2122 = ((v2117 - up47) / (up48 - up47))
            up51.Size = UDim2.new(v2122, 0, 1, 0)
            up52.Position = UDim2.new(v2122, -6, 0.5, -6)
            up49.Text = tostring(v2117)
            up53 = v2117
            if (arg193_2 ~= false) then
                up46(v2117)
            end
            return
        end
        local up55 = false
        local v1757 = up50.InputBegan
        local v1763 = function(arg194_1)
            local v2137
            local v2130 = arg194_1
            local v2138 = (v2130.UserInputType == Enum.UserInputType.MouseButton1) or (v2130.UserInputType == Enum.UserInputType.Touch)
            if v2138 then
                up55 = true
                v2137 = math.clamp(((v2130.Position.X - up50.AbsolutePosition.X) / up50.AbsoluteSize.X), 0, 1)
                up54((up47 + ((up48 - up47) * v2137)))
            end
            return
        end
        v1757:Connect(v1763)
        capturedValues1.value2.InputEnded:Connect(function(arg195_1)
            local v2142 = arg195_1
            local v2152 = (v2142.UserInputType == Enum.UserInputType.MouseButton1) or (v2142.UserInputType == Enum.UserInputType.Touch)
            if v2152 then
                up55 = false
            end
            return
        end)
        v1757 = capturedValues1.value2.InputChanged
        v1763 = function(arg196_1)
            local v2155
            local v2154 = arg196_1
            local v2156 = up55 and (v2154.UserInputType == Enum.UserInputType.MouseMovement) or (v2154.UserInputType == Enum.UserInputType.Touch)
            if v2156 then
                v2155 = (math.clamp(((v2154.Position.X - up50.AbsolutePosition.X) / up50.AbsoluteSize.X), 0, 1))
                up54((up47 + ((up48 - up47) * v2155)))
            end
            return
        end
        v1757:Connect(v1763)
        v1757 = capturedValues1.value20.sliders
        local v1764 = function()
            return up53
        end
        local v1766 = function(arg198_1)
            up54(arg198_1, true)
            return
        end
        v1757[arg160_2] = {["get"] = v1764, ["set"] = v1766}
        table.insert(capturedValues1.value47, {["inst"] = v1756, ["name"] = arg160_2, ["page"] = arg160_1})

        return v1756
    end
    v2282 = function(arg161_1, arg161_2, arg161_3, arg161_4)
        local v1782, v1783, v1784
        local v1802, v1804, v1806, v1809, v1810, v1811
        local v1773 = arg161_1
        local up58 = arg161_3
        local up56 = arg161_4
        local v1774 = arg161_2
        local up57 = 42
        local up59 = 176
        local v1776 = Instance.new("Frame")
        local up60 = v1776
        up60.Size = UDim2.new(1, 0, 0, up57)
        up60.BackgroundColor3 = capturedValues1.value13.Element
        up60.BorderSizePixel = 0
        up60.ClipsDescendants = true
        up60.Parent = v1773
        capturedValues1.value27(up60, 6)
        capturedValues1.value28(up60, capturedValues1.value13.Stroke, 1, 0)
        local v1778 = (Instance.new("TextLabel"))
        v1778.Size = UDim2.new(1, -110, 0, 42)
        v1778.Position = UDim2.new(0, 12, 0, 0)
        v1778.BackgroundTransparency = 1
        v1778.Text = v1774
        v1778.Font = Enum.Font.GothamMedium
        v1778.TextSize = 13
        v1778.TextColor3 = capturedValues1.value13.Text
        v1778.TextXAlignment = Enum.TextXAlignment.Left
        v1778.Parent = up60
        v1776 = Instance.new("TextButton")
        local up61 = v1776
        up61.Size = UDim2.new(0, 24, 0, 24)
        up61.Text = ""
        up61.AutoButtonColor = false
        up61.BackgroundColor3 = capturedValues1.value14[up58]
        up61.Parent = up60
        capturedValues1.value27(up61, 5)
        capturedValues1.value28(up61, capturedValues1.value13.Stroke, 1, 0)
        local v1771
        local up62 = v1771
        local up63
        local up64 = false
        if up56 then
            v1771 = up61
            v1782 = UDim2.new(1, -80, 0, 9)
            v1771.Position = v1782
            up62 = (Instance.new("Frame"))
            v1771 = up62
            v1783 = UDim2.new(0, 36, 0, 20)
            v1771.Size = v1783
            v1771 = up62
            v1783 = UDim2.new(1, -46, 0, 11)
            v1771.Position = v1783
            v1771 = up62
            v1782 = capturedValues1.value13.Tertiary
            v1771.BackgroundColor3 = v1782
            v1771 = up62
            v1771.BorderSizePixel = 0
            v1771 = up62
            v1771.Parent = up60
            capturedValues1.value27(up62, 10)
            up63 = (Instance.new("Frame"))
            v1771 = up63
            v1784 = UDim2.new(0, 16, 0, 16)
            v1771.Size = v1784
            v1771 = up63
            v1784 = UDim2.new(0, 2, 0.5, -8)
            v1771.Position = v1784
            v1771 = up63
            v1783 = capturedValues1.value13.White
            v1771.BackgroundColor3 = v1783
            v1771 = up63
            v1771.BorderSizePixel = 0
            v1771 = up63
            v1771.Parent = up62
            capturedValues1.value27(up63, 8)
        else
            v1771 = up61
            v1784 = UDim2.new(1, -36, 0, 9)
            v1771.Position = v1784
        end
        v1782 = Instance.new("Frame")
        local up65 = v1782
        up65.Size = UDim2.new(1, -24, 0, 124)
        up65.Position = UDim2.new(0, 12, 0, 44)
        up65.BackgroundTransparency = 1
        up65.Visible = false
        up65.Parent = up60
        v1782 = Instance.new("Frame")
        local up66 = v1782
        up66.Size = UDim2.new(1, -24, 0, 84)
        up66.Position = UDim2.new(0, 0, 0, 0)
        up66.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        up66.BorderSizePixel = 0
        up66.ClipsDescendants = true
        up66.Active = true
        up66.Parent = up65
        capturedValues1.value27(up66, 5)
        capturedValues1.value28(up66, capturedValues1.value13.Stroke, 1, 0)
        v1782 = Instance.new("Frame")
        v1782.Size = UDim2.new(1, 0, 1, 0)
        v1782.BackgroundColor3 = capturedValues1.value13.White
        v1782.BorderSizePixel = 0
        v1782.Parent = up66
        local v1785 = Instance.new("UIGradient")
        v1785.Color = ColorSequence.new(capturedValues1.value13.White)
        local v1786 = NumberSequence.new
        local v1792 = NumberSequenceKeypoint.new(0, 0)
        v1785.Transparency = v1786({v1792, NumberSequenceKeypoint.new(1, 1)})
        v1785.Parent = v1782
        v1786 = Instance.new("Frame")
        v1786.Size = UDim2.new(1, 0, 1, 0)
        v1786.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        v1786.BorderSizePixel = 0
        v1786.Parent = up66
        local v1787 = Instance.new("UIGradient")
        v1787.Rotation = 90
        v1787.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
        local v1788 = NumberSequence.new
        local v1795 = NumberSequenceKeypoint.new(0, 1)
        v1787.Transparency = v1788({v1795, NumberSequenceKeypoint.new(1, 0)})
        v1787.Parent = v1786
        v1788 = Instance.new("Frame")
        local up67 = v1788
        up67.Size = UDim2.new(0, 10, 0, 10)
        up67.AnchorPoint = Vector2.new(0.5, 0.5)
        up67.BackgroundColor3 = capturedValues1.value13.White
        up67.BorderSizePixel = 0
        up67.ZIndex = 5
        up67.Parent = up66
        capturedValues1.value27(up67, 5)
        capturedValues1.value28(up67, (Color3.fromRGB(0, 0, 0)), 1, 0)
        v1788 = Instance.new("Frame")
        local up68 = v1788
        up68.Size = UDim2.new(0, 16, 0, 84)
        up68.Position = UDim2.new(1, -16, 0, 0)
        up68.BackgroundColor3 = capturedValues1.value13.White
        up68.BorderSizePixel = 0
        up68.ClipsDescendants = true
        up68.Active = true
        up68.Parent = up65
        capturedValues1.value27(up68, 5)
        capturedValues1.value28(up68, capturedValues1.value13.Stroke, 1, 0)
        v1788 = Instance.new("UIGradient")
        v1788.Rotation = 90
        local v1789 = ColorSequence.new
        local v1790 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0))
        local v1793 = ColorSequenceKeypoint.new(.17, Color3.fromRGB(255, 255, 0))
        local v1797 = ColorSequenceKeypoint.new(.33, Color3.fromRGB(0, 255, 0))
        local v1798 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255))
        local v1799 = ColorSequenceKeypoint.new(.67, Color3.fromRGB(0, 0, 255))
        local v1800 = ColorSequenceKeypoint.new(.83, Color3.fromRGB(255, 0, 255))
        local v1794 = ColorSequenceKeypoint.new
        local v1803 = Color3.fromRGB
        v1788.Color = v1789({v1790, v1793, v1797, v1798, v1799, v1800, v1794(1, v1803(255, 0, 0))})
        v1788.Parent = up68
        v1789 = Instance.new("Frame")
        local up69 = v1789
        up69.Size = UDim2.new(1, 0, 0, 3)
        up69.AnchorPoint = Vector2.new(0, 0.5)
        up69.BackgroundColor3 = capturedValues1.value13.White
        up69.BorderSizePixel = 0
        up69.ZIndex = 5
        up69.Parent = up68
        capturedValues1.value28(up69, (Color3.fromRGB(0, 0, 0)), 1, 0)
        v1789 = Instance.new("TextBox")
        local up70 = v1789
        up70.Size = UDim2.new(1, 0, 0, 24)
        up70.Position = UDim2.new(0, 0, 0, 92)
        up70.BackgroundColor3 = capturedValues1.value13.Secondary
        up70.BorderSizePixel = 0
        up70.Text = "#FFFFFF"
        up70.PlaceholderText = "#RRGGBB"
        up70.PlaceholderColor3 = capturedValues1.value13.TextDark
        up70.Font = Enum.Font.GothamMedium
        up70.TextSize = 12
        up70.TextColor3 = capturedValues1.value13.Text
        up70.ClearTextOnFocus = false
        up70.Parent = up65
        capturedValues1.value27(up70, 5)
        capturedValues1.value28(up70, capturedValues1.value13.Stroke, 1, 0)
        v1809, v1810, v1811 = Color3.toHSV(capturedValues1.value14[up58])
        local up71 = v1809
        local up72 = v1810
        local up73 = v1811
        v1771 = function(arg12_1)
            local v343 = Color3.fromHSV(up71, up72, up73)
            local v347 = up61
            local v342 = v343
            v347.BackgroundColor3 = v342
            up66.BackgroundColor3 = Color3.fromHSV(up71, 1, 1)
            up67.Position = UDim2.new(up72, 0, (1 - up73), 0)
            v347 = up69
            local v345 = UDim2.new(0, 0, up71, 0)
            v347.Position = v345
            if arg12_1 then
                v347 = up70
                v345 = capturedValues1.value29(v342)
                v347.Text = v345
            end
            capturedValues1.value14[up58] = v342
            return
        end
        local up74 = v1771
        up74(true)
        local up75 = false
        local up76 = false
        up66.InputBegan:Connect(function(arg13_1)
            local v352 = arg13_1
            local v362 = (v352.UserInputType == Enum.UserInputType.MouseButton1) or (v352.UserInputType == Enum.UserInputType.Touch)
            if v362 then
                up75 = true
                math.clamp(((v352.Position.X - up66.AbsolutePosition.X) / up66.AbsoluteSize.X), 0, 1)
                v362 = (1 - (math.clamp(((v352.Position.Y - up66.AbsolutePosition .Y) / up66.AbsoluteSize.Y), 0, 1)))
                up74(true)
            end
            return
        end)
        up68.InputBegan:Connect(function(arg14_1)
            local v371 = arg14_1
            local v379 = (v371.UserInputType == Enum.UserInputType.MouseButton1) or (v371.UserInputType == Enum.UserInputType.Touch)
            if v379 then
                up76 = true
                math.clamp(((v371.Position.Y - up68.AbsolutePosition .Y) / up68.AbsoluteSize.Y), 0, 1)
                up74(true)
            end
            return
        end)
        v1771 = capturedValues1.value2.InputEnded
        v1800 = function(arg15_1)
            local v383 = arg15_1
            local v393 = (v383.UserInputType == Enum.UserInputType.MouseButton1) or (v383.UserInputType == Enum.UserInputType.Touch)
            if v393 then
                up75 = false
                up76 = false
            end
            return
        end
        v1771:Connect(v1800)
        capturedValues1.value2.InputChanged:Connect(function(arg16_1)
            local v406
            local v395 = arg16_1
            local v405 = (v395.UserInputType == Enum.UserInputType.MouseMovement) or (v395.UserInputType == Enum.UserInputType.Touch)
            if v405 then
                if up75 then
                    math.clamp(((v395.Position.X - up66.AbsolutePosition.X) / up66.AbsoluteSize.X), 0, 1)
                    v406 = (1 - (math.clamp(((v395.Position.Y - up66.AbsolutePosition .Y) / up66.AbsoluteSize.Y), 0, 1)))
                    up74(true)
                end
                if up76 then
                    math.clamp(((v395.Position.Y - up68.AbsolutePosition .Y) / up68.AbsoluteSize.Y), 0, 1)
                    up74(true)
                end
            end
            return
        end)
        up70.FocusLost:Connect(function()
            local v412, v416, v418
            local v417 = (capturedValues1.value30(up70.Text))
            if v417 then
                v418, v412, v416 = Color3.toHSV(v417)
            end
            up74(true)

            return
        end)
        local up77 = false
        v1771 = up61.MouseButton1Click
        local v1801 = function()
            up77 = (not up77)
            up65.Visible = up77
            local v419 = capturedValues1.value26
            local v423 = up60
            local v430 = UDim2.new(1, 0, 0, up77 and up59 or up57)
            v419(v423, .22, {["Size"] = v430})

            return
        end
        v1771:Connect(v1801)
        if up56 then
            local up78 = function()
                local v809, v810, v811, v812
                if up64 then
                    v809 = capturedValues1.value26
                    v810 = up62
                    v811 = capturedValues1.value13.Accent
                    v809(v810, .2, {["BackgroundColor3"] = v811})
                    v809 = capturedValues1.value26
                    v810 = up63
                    v812 = UDim2.new(1, -18, 0.5, -8)
                    v809(v810, .2, {["Position"] = v812})
                else
                    v809 = capturedValues1.value26
                    v810 = up62
                    v811 = capturedValues1.value13.Tertiary
                    v809(v810, .2, {["BackgroundColor3"] = v811})
                    v809 = capturedValues1.value26
                    v810 = up63
                    v812 = UDim2.new(0, 2, 0.5, -8)
                    v809(v810, .2, {["Position"] = v812})
                end
                return
            end
            v1801 = Instance.new("TextButton")
            v1803 = UDim2.new(0, 46, 0, 42)
            v1801.Size = v1803
            v1803 = UDim2.new(1, -46, 0, 0)
            v1801.Position = v1803
            v1801.BackgroundTransparency = 1
            v1801.Text = ""
            v1801.Parent = up60
            v1771 = v1801.MouseButton1Click
            v1803 = function()
                up64 = (not up64)
                up78()
                up56(up64)
                return
            end
            v1771:Connect(v1803)
            v1771 = capturedValues1.value20.toggles
            v1804 = function()
                return up64
            end
            v1806 = function(arg61_1)
                up64 = ((arg61_1 and true) or false)
                up78()
                up56(up64)
                return
            end
            v1802 = {["get"] = v1804, ["set"] = v1806}
            v1771[v1774] = v1802
        end
        v1771 = capturedValues1.value20.colors
        v1800 = up58
        v1803 = function()
            local v1949 = capturedValues1.value14[up58]

            return capturedValues1.value29(v1949)
        end
        local v1805 = function(arg175_1)
            local v1951, v1953, v1956
            local v1952 = (capturedValues1.value30(arg175_1))
            if v1952 then
                v1951, v1956, v1953 = Color3.toHSV(v1952)
                up74(true)
            end
            return
        end
        v1771[v1800] = {["get"] = v1803, ["set"] = v1805}
        table.insert(capturedValues1.value47, {["inst"] = up60, ["name"] = v1774, ["page"] = v1773})

        return up60
    end
    capturedValues1.value47 = {}
    capturedValues1.value52 = v2280
    v2280 = function(arg162_1)
        local up79 = arg162_1
        local v1813 = Instance.new("TextButton")
        local up80 = v1813
        up80.Name = up79
        local v1818 = up80
        local v1815 = UDim2.new(1, 0, 0, 34)
        v1818.Size = v1815
        up80.BackgroundColor3 = capturedValues1.value13.Element
        up80.AutoButtonColor = false
        up80.Text = ""
        up80.Parent = capturedValues1.value46
        capturedValues1.value27(up80, 6)
        local v1814 = (Instance.new("TextLabel"))
        v1815 = UDim2.new(1, -20, 1, 0)
        v1814.Size = v1815
        v1815 = UDim2.new(0, 12, 0, 0)
        v1814.Position = v1815
        v1814.BackgroundTransparency = 1
        v1814.Text = up79
        v1814.Font = Enum.Font.GothamMedium
        v1814.TextSize = 13
        v1814.TextColor3 = capturedValues1.value13.Text
        v1814.TextXAlignment = Enum.TextXAlignment.Left
        v1814.Parent = up80
        capturedValues1.value50[up79] = v1814
        v1815 = (Instance.new("ScrollingFrame"))
        v1815.Name = (up79 .. "Page")
        v1815.Size = UDim2.new(1, -150, 1, -96)
        v1815.Position = UDim2.new(0, 140, 0, 88)
        v1815.BackgroundTransparency = 1
        v1815.BorderSizePixel = 0
        v1815.ScrollBarThickness = 4
        v1815.ScrollBarImageColor3 = capturedValues1.value13.Stroke
        v1815.CanvasSize = UDim2.new(0, 0, 0, 0)
        v1815.AutomaticCanvasSize = Enum.AutomaticSize.Y
        v1815.Visible = false
        v1815.Parent = capturedValues1.value40
        local v1816 = (Instance.new("UIListLayout"))
        v1816.Padding = UDim.new(0, 8)
        v1816.SortOrder = Enum.SortOrder.LayoutOrder
        v1816.Parent = v1815
        capturedValues1.value48[up79] = v1815
        capturedValues1.value49[up79] = up80
        up80.MouseButton1Click:Connect(function()
            capturedValues1.value52(up79)
            return
        end)
        v1818 = up80.MouseEnter
        local v1819 = function()
            local v275, v276, v277
            if (capturedValues1.value51 ~= up79) then
                v275 = capturedValues1.value26
                v276 = up80
                v277 = capturedValues1.value13.ElementHover
                v275(v276, .12, {["BackgroundColor3"] = v277})
            end
            return
        end
        v1818:Connect(v1819)
        v1818 = up80.MouseLeave
        v1819 = function()
            local v286, v287, v288
            if (capturedValues1.value51 ~= up79) then
                v286 = capturedValues1.value26
                v287 = up80
                v288 = capturedValues1.value13.Element
                v286(v287, .12, {["BackgroundColor3"] = v288})
            end
            return
        end
        v1818:Connect(v1819)

        return v1815
    end
    v2289 = Instance.new("Folder")
    capturedValues1.value53 = v2289
    v2289 = capturedValues1.value53
    v2289.Name = "ClaudewareESP"
    v2289 = capturedValues1.value53
    v2289.Parent = capturedValues1.value11
    capturedValues1.value54 = false
    pcall(function()
        Drawing.new("Text"):Remove()
        capturedValues1.value54 = true
        return
    end)
    v2358 = capturedValues1.value14.Generator
    v2337 = {["color"] = v2358, ["generator"] = true, ["key"] = "Generator"}
    v2293 = capturedValues1.value14.Pallet
    v2358 = {["color"] = v2293, ["key"] = "Pallet"}
    v2296 = capturedValues1.value14.Hook
    v2293 = {["color"] = v2296, ["key"] = "Hook"}
    v2289 = capturedValues1.value14.Window
    v2296 = {["color"] = v2289, ["key"] = "Window"}
    v2289 = capturedValues1.value14.Gate
    v2289 = {["Generator"] = v2337, ["Palletwrong"] = v2358, ["Hook"] = v2293, ["Window"] = v2296, ["Gate"] = {["color"] = v2289, ["key"] = "Gate"}}
    v2337 = {}
    v2358 = function(arg164_1, arg164_2)
        local v1835 = (Instance.new("Highlight"))
        v1835.FillColor = arg164_1
        v1835.OutlineColor = arg164_1
        v1835.FillTransparency = (arg164_2 or .7)
        v1835.OutlineTransparency = 0
        v1835.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        v1835.Enabled = false
        v1835.Parent = capturedValues1.value53
        return v1835
    end
    capturedValues1.value55 = v2289
    capturedValues1.value56 = {}
    capturedValues1.value57 = v2337
    capturedValues1.value58 = v2358
    v2296 = capturedValues1.value58(capturedValues1.value14.Tesla, .55)
    v2289 = function(arg165_1)
        local v1843
        local v1841 = capturedValues1.value57
        local v1842 = arg165_1
        local v1844 = v1841[v1842]
        if (not v1844) then
            return
        else
            if v1844["hl"] then
                v1844.hl:Destroy()
            end
            if v1844["drawing"] then
                v1844.drawing:Remove()
            end
            v1843 = capturedValues1.value57
            v1843[v1842] = nil
            return
        end
    end
    v2293 = function()
        local v1851 = {}
        v1851.hl = capturedValues1.value58(capturedValues1.value14.Survivor, 0.75)
        local v1849 = v1851.hl
        v1849.OutlineTransparency = .05
        local v1850 = (Instance.new("BillboardGui"))
        v1850.Name = "Tag"
        v1850.Size = UDim2.new(0, 150, 0, 20)
        v1850.StudsOffset = Vector3.new(0, 3, 0)
        v1850.AlwaysOnTop = true
        v1850.LightInfluence = 0
        v1850.Enabled = false
        v1850.Parent = capturedValues1.value53
        v1851.bb = v1850
        local v1852 = (Instance.new("TextLabel"))
        v1852.Size = UDim2.new(1, 0, 1, 0)
        v1852.BackgroundTransparency = 1
        v1852.Font = Enum.Font.GothamBold
        v1852.TextSize = 14
        v1852.TextColor3 = Color3.fromRGB(255, 255, 255)
        v1852.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        v1852.TextStrokeTransparency = .4
        v1852.Text = ""
        v1852.Parent = v1850
        v1851.txt = v1852
        return v1851
    end
    capturedValues1.value59 = v2296
    v2358 = function(arg167_1, arg167_2)
        local v1861, v1862, v1865, v1866, v1867, v1868
        local v1859 = arg167_1
        local v1860 = arg167_2
        if capturedValues1.value57[v1859] then
            return
        else
            v1866 = (capturedValues1.value58(v1860.color, .68))
            v1866.Adornee = v1859
            v1862 = v1860.key
            v1868 = v1860.generator
            v1865 = {["hl"] = v1866, ["key"] = v1862, ["isGen"] = (v1868 == true)}
            v1867 = v1860.generator and capturedValues1.value54
            if v1867 then
                v1862 = (Drawing.new("Text"))
                v1862.Size = 15
                v1862.Center = true
                v1862.Outline = true
                v1862.Font = 2
                v1867 = capturedValues1.value14.Generator
                v1862.Color = v1867
                v1862.Visible = false
                v1865.drawing = v1862
            end
            v1861 = capturedValues1.value57
            v1861[v1859] = v1865
            return
        end
    end
    v2337 = function(arg168_1)
        local v1875
        local v1873 = arg168_1
        local v1876 = capturedValues1.value56[v1873]
        if (not v1876) then
            return
        else
            if v1876["hl"] then
                v1876.hl:Destroy()
            end
            if v1876["bb"] then
                v1876.bb:Destroy()
            end
            v1875 = capturedValues1.value56
            v1875[v1873] = nil
            return
        end
    end
    capturedValues1.value60 = v2293
    capturedValues1.value61 = nil
    v2296 = function()
        local v1880, v1881, v1883, v1884, v1885, v1887, v1888
        v1880, v1884, v1885 = ipairs(capturedValues1.value1:GetPlayers())
        local v1882 = v1880
        while true do
            v1885, v1883 = v1882(v1884, v1885)
            if not v1885 then
                break
            end
            v1888 = (v1883 ~= capturedValues1.value9) and (not capturedValues1.value56[v1883])
            if v1888 then
                v1881 = capturedValues1.value56
                v1887 = capturedValues1.value60()
                v1881[v1883] = v1887
            end
        end
        v1881 = pairs
        local v1890 = capturedValues1.value56
        for v1882 in v1881(v1890) do
            v1890 = v1882
            if (not v1890["Parent"]) then
                capturedValues1.value61(v1890)
            end
        end
        return
    end
    capturedValues1.value61 = v2337
    capturedValues1.value62 = v2296
    capturedValues1.value63 = v2358
    v2296 = function(arg170_1)
        local v1898, v1903
        for v1895, v1897 in ipairs(arg170_1:GetDescendants()) do
            v1898 = capturedValues1.value55[v1897.Name ]
            v1903 = v1898 and (not capturedValues1.value57[v1897]) and (v1897:IsA("Model")) or (v1897:IsA("BasePart"))
            if v1903 then
                capturedValues1.value63(v1897, v1898)
            end
        end
        return
    end
    capturedValues1.value64 = v2289
    capturedValues1.value65 = v2296
    v2296 = function()
        local v1909, v1911, v1912, v1913, v1914, v1915, v1916, v1917, v1918, v1919, v1920, v1921, v1922, v1923, v1924, v1925
        local v1927, v1928
        local v1935
        if capturedValues1.value22 then
            return
        else
            v1911 = (capturedValues1.value34())
            v1909 = pairs
            for v1914, v1915 in v1909(capturedValues1.value56) do
                v1916 = v1914
                v1909 = v1916.Character
                v1920 = v1909
                v1917 = v1920 and (v1920:FindFirstChildOfClass("Humanoid"))
                v1918 = v1920 and (v1920:FindFirstChild("HumanoidRootPart")) or v1920.PrimaryPart
                v1919 = v1920 and (v1920:FindFirstChild("Head"))
                v1922 = capturedValues1.value19.ESP.Players
                v1921 = v1922
                if v1922 then
                    v1922 = v1920
                    if v1920 then
                        v1922 = v1917 and v1918 and v1919 and (v1917.Health > 0)
                    end
                    v1921 = v1922
                end
                if v1921 then
                    v1922 = v1915.hl
                    if (v1922["Adornee"] ~= v1920) then
                        v1909 = v1915.hl
                        v1909.Adornee = v1920
                    end
                    v1922 = v1915.bb
                    if (v1922["Adornee"] ~= v1919) then
                        v1909 = v1915.bb
                        v1909.Adornee = v1919
                    end
                    v1909 = v1915.hl
                    v1909.Enabled = true
                    v1909 = v1915.bb
                    v1909.Enabled = true
                    v1921 = capturedValues1.value35(v1916)
                    v1909 = v1915.hl
                    v1909.FillColor = v1921
                    v1909 = v1915.hl
                    v1909.OutlineColor = v1921
                    v1922 = (v1911 and (math.floor((v1918.Position - v1911).Magnitude)) or 0)
                    v1923 = v1915.txt
                    v1925 = (v1916.DisplayName .. (" | " .. (v1922 .. "m")))
                    v1923.Text = v1925
                else
                    v1921 = v1915.hl
                    v1921.Enabled = false
                    v1921 = v1915.bb
                    v1921.Enabled = false
                end
            end
            v1914, v1912, v1916 = pairs(capturedValues1.value57)
            while true do
                v1916, v1915 = v1914(v1912, v1916)
                if not v1916 then
                    break
                end
                local up81 = v1916
                v1920 = capturedValues1.value19.ESP[v1915.key] and (up81.Parent ~= nil)
                v1917 = v1915.hl
                v1917.Enabled = ((v1920 and true) or false)
                if v1915["isGen"] then
                    v1917 = ((tonumber(up81:GetAttribute("RepairProgress"))) or 0)
                    v1918 = ((tonumber(up81:GetAttribute("PlayersRepairingCount"))) or 0)
                    v1919 = (v1917 >= 100)
                    v1921 = v1919 and capturedValues1.value15 or capturedValues1.value14.Generator
                    v1922 = v1915.hl
                    v1922.FillColor = v1921
                    v1922 = v1915.hl
                    v1922.OutlineColor = v1921
                    if v1915["drawing"] then
                        if v1920 then
                            v1925 = function()
                                return up81:GetPivot().Position
                            end
                            v1923, v1924 = pcall(v1925)
                            v1922 = (v1923 and v1924)
                            if v1922 then
                                v1922 = capturedValues1.value10
                                v1935 = Vector3.new (0, 4, 0)
                                v1928 = v1922.WorldToViewportPoint
                                v1927 = (v1924 + v1935)
                                v1928 = {v1928(v1922, v1927)}
                                v1925 = v1928[1]
                                if v1928[2] then
                                    v1922 = v1915.drawing
                                    v1922.Visible = true
                                    v1922 = v1915.drawing
                                    v1935 = Vector2.new(v1925.X, v1925.Y)
                                    v1922.Position = v1935
                                    v1922 = v1915.drawing
                                    v1922.Color = v1921
                                    v1922 = v1915.drawing
                                    v1928 = v1919 and "Done" or (string.format("Generator %d%% [%dP]", (math.floor(v1917)), v1918))
                                    v1922.Text = v1928
                                else
                                    v1922 = v1915.drawing
                                    v1922.Visible = false
                                end
                            else
                                v1922 = v1915.drawing
                                v1922.Visible = false
                            end
                        else
                            v1922 = v1915.drawing
                            v1922.Visible = false
                        end
                    end
                else
                    v1917 = v1915.hl
                    v1919 = capturedValues1.value14[v1915.key]
                    v1917.FillColor = v1919
                    v1917 = v1915.hl
                    v1919 = capturedValues1.value14[v1915.key]
                    v1917.OutlineColor = v1919
                end
            end
            v1914 = capturedValues1.value19.ESP
            if v1914["Tesla"] then
                v1914 = capturedValues1.value8:FindFirstChild("Map")
                v1913 = v1914 and (v1914:FindFirstChild("Tesla"))
                v1912 = v1913 and (v1913:FindFirstChild("Model"))
                if v1912 then
                    v1920 = capturedValues1.value59
                    if (v1920["Adornee"] ~= v1912) then
                        v1916 = capturedValues1.value59
                        v1916.Adornee = v1912
                    end
                    v1916 = capturedValues1.value59
                    v1920 = capturedValues1.value14.Tesla
                    v1916.FillColor = v1920
                    v1916 = capturedValues1.value59
                    v1920 = capturedValues1.value14.Tesla
                    v1916.OutlineColor = v1920
                    v1916 = capturedValues1.value59
                    v1916.Enabled = true
                else
                    v1916 = capturedValues1.value59
                    v1916.Enabled = false
                end
            else
                v1913 = capturedValues1.value59
                v1913.Enabled = false
            end
            return
        end
    end
    v2289 = (capturedValues1.value8:FindFirstChild("Map")) or (capturedValues1.value8:WaitForChild("Map", 10))
    capturedValues1.value62()
    if v2289 then
        capturedValues1.value65(v2289)
    end
    v2360 = capturedValues1.value21
    v2361 = ((#capturedValues1.value21) + 1)
    v2337 = capturedValues1.value1.PlayerAdded
    v2293 = function(arg188_1)
        local v2079, v2081
        local v2078 = arg188_1
        if (v2078 ~= capturedValues1.value9) then
            v2079 = capturedValues1.value56
            v2081 = capturedValues1.value60()
            v2079[v2078] = v2081
        end
        return
    end
    v2358 = v2337:Connect(v2293)
    v2360[v2361] = v2358
    v2360 = capturedValues1.value21
    v2361 = ((#capturedValues1.value21) + 1)
    v2337 = capturedValues1.value1.PlayerRemoving
    v2293 = function(arg189_1)
        capturedValues1.value61(arg189_1)
        return
    end
    v2358 = v2337:Connect(v2293)
    v2360[v2361] = v2358
    if v2289 then
        v2360 = capturedValues1.value21
        v2361 = ((#capturedValues1.value21) + 1)
        v2358 = "DescendantAdded"
        v2293 = function(arg208_1)
            local v2240 = capturedValues1.value55
            local v2241 = arg208_1
            local v2246 = v2240[v2241.Name]
            v2240 = v2246 and (v2241:IsA("Model")) or (v2241:IsA("BasePart"))
            if v2240 then
                capturedValues1.value63(v2241, v2246)
            end
            return
        end
        v2358 = v2289[v2358]:Connect(v2293)
        v2360[v2361] = v2358
        v2360 = capturedValues1.value21
        v2361 = ((#capturedValues1.value21) + 1)
        v2337 = v2289.DescendantRemoving
        v2293 = function(arg209_1)
            local v2251 = arg209_1
            if capturedValues1.value57[v2251] then
                capturedValues1.value64(v2251)
            end
            return
        end
        v2358 = v2337:Connect(v2293)
        v2360[v2361] = v2358
    end
    task.spawn(function()
        local v269
        while true do
            if not (not capturedValues1.value22) then
                break
            end
            task.wait(3)
            if not (capturedValues1.value22) then
                capturedValues1.value62()
                v269 = (capturedValues1.value8:FindFirstChild("Map"))
                if v269 then
                    capturedValues1.value65(v269)
                end
                continue
            end
            break
        end
        return
    end)
    v2360 = capturedValues1.value21
    v2361 = ((#capturedValues1.value21) + 1)
    v2358 = capturedValues1.value4.RenderStepped:Connect(v2296)
    v2360[v2361] = v2358
    capturedValues1.value66 = nil
    if capturedValues1.value54 then
        v2337 = function()
            capturedValues1.value66 = (Drawing.new("Circle"))
            capturedValues1.value66.Thickness = 1.5
            capturedValues1.value66.NumSides = 64
            capturedValues1.value66.Radius = capturedValues1.value16.AimFov
            capturedValues1.value66.Filled = false
            capturedValues1.value66.Color = capturedValues1.value13.Accent
            capturedValues1.value66.Transparency = .9
            capturedValues1.value66.Visible = false
            return
        end
        pcall(v2337)
    end
    capturedValues1.value67 = nil
    v2337 = function()
        local v496, v497, v500, v501, v506, v507, v508
        local v493 = capturedValues1.value16.AimFov
        local v489
        local v488 = ipairs
        local v492 = capturedValues1.value1
        local v495 = v492.GetPlayers
        for v491, v495 in v488(v495(v492)) do
            if not ((v495 == capturedValues1.value9))then
                v501 = capturedValues1.value16.AimTeam
                if (v501 ~= "All") then
                    v501 = v495.Team
                    v496 = (not v501) or (v501.Name ~= capturedValues1.value16.AimTeam)
                    if v496 then
                        continue
                    end
                end
                v506 = (capturedValues1.value31(v495))
                v501 = v506 and (capturedValues1.value67(v506))
                v488 = capturedValues1.value32
                v507 = v501
                v508 = (v488(v506))
                v501 = v507 and v508 and (v508.Health > 0)
                if v501 then
                    v488 = capturedValues1.value10
                    v500 = v507.Position
                    v501, v496 = v488:WorldToViewportPoint(v500)
                    if v496 then
                        v500 = Vector2.new((capturedValues1.value10.ViewportSize.X / 2), (capturedValues1.value10.ViewportSize.Y / 2))
                        v497 = ((Vector2.new(v501.X, v501.Y )) - v500).Magnitude
                        if (v497 < v493) then
                            v493 = v497
                            v489 = v507
                        end
                    end
                end
            end
        end
        return v489
    end
    capturedValues1.value67 = function(arg31_1)
        local v512, v518, v520
        local v511 = arg31_1
        if (not v511) then
            v512 = nil
            return v512
        else
            v518 = capturedValues1.value16.AimPart
            v520 = (v511:FindFirstChild(v518)) or (v511:FindFirstChild("Head")) or (capturedValues1.value33(v511))
            return v520
        end
    end
    capturedValues1.value68 = v2337
    v2337 = capturedValues1.value21
    v2358 = ((#capturedValues1.value21) + 1)
    v2289 = capturedValues1.value4.RenderStepped:Connect(function()
        local v521, v522, v523, v524, v525, v526, v527
        if capturedValues1.value22 then
            return
        else
            v521 = capturedValues1.value10
            v522 = capturedValues1.value16.FOV
            v521.FieldOfView = v522
            if capturedValues1.value66 then
                v525 = capturedValues1.value19
                if v525.AimCircle then
                    v521 = capturedValues1.value66
                    v521.Visible = true
                    v521 = capturedValues1.value66
                    v522 = capturedValues1.value16.AimFov
                    v521.Radius = v522
                    v521 = capturedValues1.value66
                    v523 = Vector2.new((capturedValues1.value10.ViewportSize.X / 2), (capturedValues1.value10.ViewportSize.Y / 2))
                    v521.Position = v523
                else
                    v521 = capturedValues1.value66
                    v521.Visible = false
                end
            end
            v525 = capturedValues1.value19.Aimbot and capturedValues1.value19.AimHolding
            if v525 then
                v522 = (capturedValues1.value68())
                if v522 then
                    v523 = (CFrame.new(capturedValues1.value10.CFrame .Position, v522.Position ))
                    v524 = capturedValues1.value16
                    if (v524.AimSmooth > 0) then
                        v521 = capturedValues1.value10
                        v524 = capturedValues1.value10.CFrame
                        v527 = (1 - capturedValues1.value16.AimSmooth)
                        v526 = v524:Lerp(v523, v527)
                        v521.CFrame = v526
                    else
                        v521 = capturedValues1.value10
                        v521.CFrame = v523
                    end
                end
            end
            return
        end
    end)
    v2337[v2358] = v2289
    v2358 = function()
        local v541, v545
        local v536 = ipairs
        local v537 = capturedValues1.value12
        local v538 = v537.GetChildren
        for v540, v538 in v536(v538(v537)) do
            v541 = string.find(v538.Name, "SkillCheckPromptGui", 1, true)
            if v541 then
                v541 = (v538:FindFirstChild("Check"))
                v545 = v541 and v541.Visible
                if v545 then
                    return v541
                end
            end
        end
        return nil
    end
    v2293 = function()
        capturedValues1.value5:SendKeyEvent(true, capturedValues1.value18.Key, false, game)
        task.wait(.01)
        local v548 = capturedValues1.value5
        local v555 = capturedValues1.value18.Key
        v548:SendKeyEvent(false, v555, false, game)

        return
    end
    capturedValues1.value69 = v2358
    capturedValues1.value70 = v2293
    capturedValues1.value71 = false
    v2293 = capturedValues1.value21
    v2289 = ((#capturedValues1.value21) + 1)
    v2337 = capturedValues1.value4.Heartbeat
    v2296 = function()
        local v557, v558, v559, v560, v564
        if capturedValues1.value22 then
            return
        else
            v557 = capturedValues1.value19
            if (not v557["AutoPerfect"]) then
                capturedValues1.value71 = false
                return
            else
                v557 = capturedValues1.value69()
                if (not v557) then
                    capturedValues1.value71 = false
                    return
                else
                    v564 = v557:FindFirstChild("Line")
                    v558 = v557:FindFirstChild("Goal")
                    v560 = (v564 and v558)
                    if (not v560) then
                        return
                    else
                        v559 = ((v564.Rotation - v558.Rotation) % 360)
                        v560 = (v559 >= capturedValues1.value18.ZoneMin) and (v559 <= capturedValues1.value18.ZoneMax)
                        if v560 then
                            if (not capturedValues1.value71) then
                                capturedValues1.value70()
                            end
                        end
                        return
                    end
                end
            end
        end
    end
    v2296 = v2337:Connect(v2296)
    v2293[v2289] = v2296
    capturedValues1.value72 = nil
    v2296 = function(arg36_1)
        local v572 = arg36_1
        local v574 = (capturedValues1.value33(capturedValues1.value31(capturedValues1.value9)))
        local v576 = (v574 and v572)
        if v576 then
            v576 = (v572.CFrame * (CFrame.new(0, 0, 2.5)))
            v574.CFrame = v576
        end
        return
    end
    capturedValues1.value73 = false
    v2289 = function()
        local v593
        local v590 = capturedValues1.value10.ViewportSize
        local v591 = (v590.X / 2)
        local v586 = v590.Y
        local v587 = 2
        local v584 = (v586 / 2)
        local v583 = 1
        v586 = v591
        local v588 = v584
        for v589 = 1, v587, v583 do
            v591 = capturedValues1.value5
            v593 = game
            v591:SendMouseButtonEvent(v586, v588, 0, true, v593, 0)
            task.wait(.03)
            v591 = capturedValues1.value5
            v593 = game
            v591:SendMouseButtonEvent(v586, v588, 0, false, v593, 0)
            task.wait(.05)
        end
        return
    end
    capturedValues1.value74 = false
    capturedValues1.value75 = v2296
    capturedValues1.value76 = v2289
    v2289 = function()
        if capturedValues1.value74 then
            return
        else
            task.spawn(function()
                local v2084, v2088, v2089, v2090
                while true do
                    v2090 = capturedValues1.value19.KillTarget and (not capturedValues1.value22)
                    if v2090 then
                        v2090 = (capturedValues1.value36()) and capturedValues1.value72 and capturedValues1.value72.Parent
                        if v2090 then
                            v2089 = (capturedValues1.value31(capturedValues1.value72))
                            v2084 = v2089 and (capturedValues1.value33(v2089))
                            v2088 = (capturedValues1.value32(v2089))
                            v2090 = v2084 and v2088 and (v2088.Health > 0)
                            if v2090 then
                                capturedValues1.value75(v2084)
                                capturedValues1.value76()
                            end
                        end
                        task.wait(3)
                    else
                        break
                    end
                end
                return
            end)
            return
        end
    end
    local up185 = function()
        if capturedValues1.value73 then
            return
        else
            task.spawn(function()
                local v790, v792, v793, v794, v796, v797, v798, v799, v800
                while true do
                    v796 = capturedValues1.value19.KillAll and (not capturedValues1.value22)
                    if v796 then
                        v796 = capturedValues1.value36()
                        if v796 then
                            v797 = ipairs
                            v794 = capturedValues1.value1
                            v792 = v794.GetPlayers
                            for v790, v792 in v797(v792(v794)) do
                                if (v792 ~= capturedValues1.value9) then
                                    v793 = capturedValues1.value31(v792)
                                    v798 = v793 and (capturedValues1.value33(v793))
                                    v799 = capturedValues1.value32(v793)
                                    v800 = v798 and v799 and (v799.Health > 0)
                                    if v800 then
                                        capturedValues1.value75(v798)
                                        capturedValues1.value76()
                                        task.wait(.15)
                                    end
                                end
                            end
                        end
                        task.wait(3)
                    else
                        break
                    end
                end
                return
            end)
            return
        end
    end
    capturedValues1.value77 = v2289
    capturedValues1.value78 = nil
    capturedValues1.value79 = {}
    v2296 = Instance.new("Frame")
    capturedValues1.value80 = v2296
    v2296 = capturedValues1.value80
    v2296.Name = "TargetPicker"
    v2296 = capturedValues1.value80
    v2293 = UDim2.new(0, 300, 0, 320)
    v2296.Size = v2293
    v2296 = capturedValues1.value80
    v2293 = UDim2.new(0.5, -150, 0.5, -160)
    v2296.Position = v2293
    v2296 = capturedValues1.value80
    v2289 = capturedValues1.value13.Background
    v2296.BackgroundColor3 = v2289
    v2296 = capturedValues1.value80
    v2296.BorderSizePixel = 0
    v2296 = capturedValues1.value80
    v2296.Active = true
    v2296 = capturedValues1.value80
    v2296.Visible = false
    v2296 = capturedValues1.value80
    v2296.ZIndex = 20
    v2296 = capturedValues1.value80
    v2296.Parent = capturedValues1.value37
    capturedValues1.value27(capturedValues1.value80, 12)
    capturedValues1.value28(capturedValues1.value80, capturedValues1.value13.Accent, 1.5, 0)
    capturedValues1.value81 = false
    capturedValues1.value82 = nil
    capturedValues1.value83 = nil
    v2289 = capturedValues1.value80.InputBegan
    v2296 = function(arg40_1)
        local v615, v616
        local up1 = arg40_1
        local v620 = (up1.UserInputType == Enum.UserInputType.MouseButton1) or (up1.UserInputType == Enum.UserInputType.Touch)
        if v620 then
            capturedValues1.value81 = true
            capturedValues1.value82 = up1.Position
            capturedValues1.value83 = capturedValues1.value80.Position
            v616 = up1.Changed
            v615 = function()
                local v258 = up1.UserInputState
                local v257 = Enum.UserInputState
                if (v258 == v257["End"]) then
                    capturedValues1.value81 = false
                end
                return
            end
            v616:Connect(v615)
        end
        return
    end
    v2289:Connect(v2296)
    v2289 = capturedValues1.value2.InputChanged
    v2296 = function(arg41_1)
        local v624, v634, v636
        local v623 = arg41_1
        local v625 = capturedValues1.value81 and (v623.UserInputType == Enum.UserInputType.MouseMovement) or (v623.UserInputType == Enum.UserInputType.Touch)
        if v625 then
            v624 = (v623.Position - capturedValues1.value82)
            v636 = capturedValues1.value80
            v634 = UDim2.new(capturedValues1.value83.X.Scale, (capturedValues1.value83.X.Offset + v624.X), capturedValues1.value83.Y.Scale, (capturedValues1.value83.Y .Offset + v624.Y))
            v636.Position = v634
        end
        return
    end
    v2289:Connect(v2296)
    v2296 = Instance.new("TextLabel")
    v2293 = UDim2.new(1, -50, 0, 32)
    v2296.Size = v2293
    v2293 = UDim2.new(0, 14, 0, 8)
    v2296.Position = v2293
    v2296.BackgroundTransparency = 1
    v2296.Text = "Choose Target"
    v2289 = Enum.Font.GothamBold
    v2296.Font = v2289
    v2296.TextSize = 15
    v2289 = capturedValues1.value13.Text
    v2296.TextColor3 = v2289
    v2289 = Enum.TextXAlignment.Left
    v2296.TextXAlignment = v2289
    v2296.ZIndex = 21
    v2296.Parent = capturedValues1.value80
    v2289 = Instance.new("TextButton")
    v2293 = UDim2.new(0, 26, 0, 26)
    v2289.Size = v2293
    v2293 = UDim2.new(1, -34, 0, 10)
    v2289.Position = v2293
    v2293 = capturedValues1.value13.Element
    v2289.BackgroundColor3 = v2293
    v2289.Text = "X"
    v2293 = Enum.Font.GothamBold
    v2289.Font = v2293
    v2289.TextSize = 13
    v2293 = capturedValues1.value13.Accent
    v2289.TextColor3 = v2293
    v2289.ZIndex = 21
    v2289.Parent = capturedValues1.value80
    capturedValues1.value27(v2289, 6)
    capturedValues1.value28(v2289, capturedValues1.value13.Stroke, 1, 0)
    v2289.MouseButton1Click:Connect(function()
        capturedValues1.value80.Visible = false
        return
    end)
    v2293 = Instance.new("ScrollingFrame")
    capturedValues1.value84 = v2293
    v2293 = capturedValues1.value84
    v2289 = UDim2.new(1, -20, 1, -50)
    v2293.Size = v2289
    v2293 = capturedValues1.value84
    v2289 = UDim2.new(0, 10, 0, 44)
    v2293.Position = v2289
    v2293 = capturedValues1.value84
    v2293.BackgroundTransparency = 1
    v2293 = capturedValues1.value84
    v2293.BorderSizePixel = 0
    v2293 = capturedValues1.value84
    v2293.ScrollBarThickness = 4
    v2293 = capturedValues1.value84
    v2296 = capturedValues1.value13.Stroke
    v2293.ScrollBarImageColor3 = v2296
    v2293 = capturedValues1.value84
    v2289 = UDim2.new(0, 0, 0, 0)
    v2293.CanvasSize = v2289
    v2293 = capturedValues1.value84
    v2296 = Enum.AutomaticSize.Y
    v2293.AutomaticCanvasSize = v2296
    v2293 = capturedValues1.value84
    v2293.ZIndex = 21
    v2293 = capturedValues1.value84
    v2293.Parent = capturedValues1.value80
    v2293 = Instance.new("UIListLayout")
    v2289 = UDim.new(0, 6)
    v2293.Padding = v2289
    v2296 = Enum.SortOrder.LayoutOrder
    v2293.SortOrder = v2296
    v2293.Parent = capturedValues1.value84
    v2296 = function(arg43_1)
        local up2 = arg43_1
        local v645 = Instance.new("TextButton")
        local up3 = v645
        up3.Size = UDim2.new(1, 0, 0, 56)
        up3.BackgroundColor3 = capturedValues1.value13.Secondary
        up3.AutoButtonColor = false
        up3.Text = ""
        up3.ZIndex = 21
        up3.Parent = capturedValues1.value84
        capturedValues1.value27(up3, 8)
        capturedValues1.value28(up3, capturedValues1.value13.Accent, 1.2, .15)
        v645 = Instance.new("ImageLabel")
        local up4 = v645
        up4.Size = UDim2.new(0, 40, 0, 40)
        up4.Position = UDim2.new(0, 8, 0.5, -20)
        up4.BackgroundColor3 = capturedValues1.value13.Element
        up4.BorderSizePixel = 0
        up4.ZIndex = 22
        up4.Parent = up3
        capturedValues1.value27(up4, 8)
        task.spawn(function()
            local v298, v299, v300
            local v297 = function()
                local v2039 = capturedValues1.value1
                local v2045 = up2.UserId
                local v2040 = Enum.ThumbnailType.HeadShot
                local v2044 = Enum.ThumbnailSize.Size48x48
                return v2039:GetUserThumbnailAsync(v2045, v2040, v2044)
            end
            v298, v300 = pcall(v297)
            v298 = v298 and v300 and up4.Parent
            if v298 then
                v299 = up4
                v299.Image = v300
            end
            return
        end)
        local v647 = (Instance.new("TextLabel"))
        v647.Size = UDim2.new(1, -60, 0, 20)
        v647.Position = UDim2.new(0, 56, 0, 8)
        v647.BackgroundTransparency = 1
        local v648 = up2.Name
        local v654 = up2.DisplayName
        v647.Text = (v648 .. (" (" .. (v654 .. ")")))
        v647.Font = Enum.Font.GothamBold
        v647.TextSize = 13
        v647.TextColor3 = capturedValues1.value13.Text
        v647.TextXAlignment = Enum.TextXAlignment.Left
        v647.ZIndex = 22
        v647.Parent = up3
        v648 = (Instance.new("TextLabel"))
        v648.Size = UDim2.new(0, 120, 0, 16)
        v648.Position = UDim2.new(0, 56, 0, 30)
        v648.BackgroundTransparency = 1
        v648.Text = "HP: -"
        v648.Font = Enum.Font.GothamMedium
        v648.TextSize = 12
        v648.TextColor3 = capturedValues1.value13.TextDark
        v648.TextXAlignment = Enum.TextXAlignment.Left
        v648.ZIndex = 22
        v648.Parent = up3
        local v651 = (Instance.new("TextLabel"))
        v651.Size = UDim2.new(0, 90, 0, 16)
        v651.Position = UDim2.new(1, -98, 0, 30)
        v651.BackgroundTransparency = 1
        v651.Text = "-m"
        v651.Font = Enum.Font.GothamMedium
        v651.TextSize = 12
        v651.TextColor3 = capturedValues1.value13.Accent
        v651.TextXAlignment = Enum.TextXAlignment.Right
        v651.ZIndex = 22
        v651.Parent = up3
        local v650 = up3.MouseButton1Click
        local v652 = function()
            local v310, v311
            if capturedValues1.value78 then
                v310 = capturedValues1.value78
                v311 = ("Target: " .. up2.Name)
                v310.Text = v311
            end
            capturedValues1.value80.Visible = false
            return
        end
        v650:Connect(v652)
        v650 = up3.MouseEnter
        v652 = function()
            local v320 = capturedValues1.value26
            local v321 = up3
            local v322 = capturedValues1.value13.Element
            v320(v321, .12, {["BackgroundColor3"] = v322})

            return
        end
        v650:Connect(v652)
        v650 = up3.MouseLeave
        v652 = function()
            local v331 = capturedValues1.value26
            local v332 = up3
            local v333 = capturedValues1.value13.Secondary
            v331(v332, .12, {["BackgroundColor3"] = v333})

            return
        end
        v650:Connect(v652)
        v650 = capturedValues1.value79
        v645 = ((#capturedValues1.value79) + 1)
        v650[v645] = {["player"] = up2, ["hp"] = v648, ["dist"] = v651}

        return
    end
    capturedValues1.value85 = nil
    v2289 = function()
        local v661, v664, v665, v666
        v661, v664, v665 = ipairs(capturedValues1.value79)
        local v663 = v661
        while true do
            v665, v666 = v663(v664, v665)
            if not v665 then
                break
            end
            local up5 = v666
            pcall(function()
                up5.hp.Parent.Parent:Destroy()
                return
            end)
        end
        table.clear(capturedValues1.value79)
        for v663, v666 in ipairs(capturedValues1.value1:GetPlayers()) do
            if (v666 ~= capturedValues1.value9) then
                capturedValues1.value85(v666)
            end
        end
        capturedValues1.value80.Visible = true
        return
    end
    capturedValues1.value85 = v2296
    capturedValues1.value86 = v2289
    v2289 = task.spawn
    v2289(function()
        local v670, v672, v674, v675, v676, v677, v678, v680, v681, v682
        while true do
            if not (not capturedValues1.value22) then
                break
            end
            v670 = capturedValues1.value80
            if v670.Visible then
                v675 = (capturedValues1.value34())
                v674 = ipairs
                for v672, v676 in v674(capturedValues1.value79) do
                    v682 = capturedValues1.value31(v676.player)
                    v681 = capturedValues1.value32(v682)
                    v680 = v682 and (capturedValues1.value33(v682))
                    if v681 then
                        v674 = v676.hp
                        v678 = ("HP: " .. (math.floor(v681.Health)))
                        v674.Text = v678
                    end
                    v677 = (v680 and v675)
                    if v677 then
                        v674 = v676.dist
                        v678 = ((math.floor((v680.Position - v675).Magnitude)) .. "m")
                        v674.Text = v678
                    end
                end
            end
            task.wait(0.5)
        end
        return
    end)
    capturedValues1.value87 = {}
    capturedValues1.value88 = nil
    capturedValues1.value89 = {}
    v2293 = Instance.new("Frame")
    capturedValues1.value90 = v2293
    v2293 = capturedValues1.value90
    v2293.Name = "Radar"
    v2293 = capturedValues1.value90
    v2337 = UDim2.new(0, 210, 0, 240)
    v2293.Size = v2337
    v2293 = capturedValues1.value90
    v2337 = UDim2.new(1, -230, 0, 70)
    v2293.Position = v2337
    v2293 = capturedValues1.value90
    v2289 = capturedValues1.value13.Background
    v2293.BackgroundColor3 = v2289
    v2293 = capturedValues1.value90
    v2293.BorderSizePixel = 0
    v2293 = capturedValues1.value90
    v2293.Active = true
    v2293 = capturedValues1.value90
    v2293.Visible = false
    v2293 = capturedValues1.value90
    v2293.Parent = capturedValues1.value37
    capturedValues1.value27(capturedValues1.value90, 12)
    capturedValues1.value28(capturedValues1.value90, capturedValues1.value13.Stroke, 1, .3)
    capturedValues1.value91 = false
    capturedValues1.value92 = nil
    capturedValues1.value93 = nil
    v2289 = capturedValues1.value90.InputBegan
    v2293 = function(arg46_1)
        local up6 = arg46_1
        local v701 = (up6.UserInputType == Enum.UserInputType.MouseButton1) or (up6.UserInputType == Enum.UserInputType.Touch)
        if v701 then
            capturedValues1.value91 = true
            capturedValues1.value92 = up6.Position
            capturedValues1.value93 = capturedValues1.value90.Position
            up6.Changed:Connect(function()
                local v2113 = up6.UserInputState
                local v2112 = Enum.UserInputState
                if (v2113 == v2112.End ) then
                    capturedValues1.value91 = false
                end
                return
            end)
        end
        return
    end
    v2289:Connect(v2293)
    v2289 = capturedValues1.value2.InputChanged
    v2293 = function(arg47_1)
        local v705, v715, v717
        local v704 = arg47_1
        local v706 = capturedValues1.value91 and (v704.UserInputType == Enum.UserInputType.MouseMovement) or (v704.UserInputType == Enum.UserInputType.Touch)
        if v706 then
            v705 = (v704.Position - capturedValues1.value92)
            v717 = capturedValues1.value90
            v715 = UDim2.new(capturedValues1.value93.X.Scale, (capturedValues1.value93.X.Offset + v705.X), capturedValues1.value93.Y.Scale, (capturedValues1.value93.Y .Offset + v705.Y))
            v717.Position = v715
        end
        return
    end
    v2289:Connect(v2293)
    v2296 = Instance.new("Frame")
    v2337 = UDim2.new(1, -20, 0, 24)
    v2296.Size = v2337
    v2337 = UDim2.new(0, 10, 0, 8)
    v2296.Position = v2337
    v2296.BackgroundTransparency = 1
    v2296.Parent = capturedValues1.value90
    v2289 = Instance.new("UIListLayout")
    v2337 = Enum.FillDirection.Horizontal
    v2289.FillDirection = v2337
    v2337 = Enum.HorizontalAlignment.Center
    v2289.HorizontalAlignment = v2337
    v2337 = Enum.VerticalAlignment.Center
    v2289.VerticalAlignment = v2337
    v2337 = Enum.SortOrder.LayoutOrder
    v2289.SortOrder = v2337
    v2337 = UDim.new(0, 6)
    v2289.Padding = v2337
    v2289.Parent = v2296
    v2337 = Instance.new("ImageLabel")
    v2293 = UDim2.new(0, 18, 0, 18)
    v2337.Size = v2293
    v2337.BackgroundTransparency = 1
    v2337.Image = "rbxassetid://115798729575437"
    v2337.LayoutOrder = 1
    v2337.Parent = v2296
    v2337 = Instance.new("TextLabel")
    v2293 = Enum.AutomaticSize.X
    v2337.AutomaticSize = v2293
    v2384 = UDim2.new(0, 0, 1, 0)
    v2337.Size = v2384
    v2337.BackgroundTransparency = 1
    v2337.RichText = true
    v2337.Text = "<font color=\"#ffffff\">Claude</font><font color=\"#d97757\">ware</font>"
    v2293 = Enum.Font.GothamBold
    v2337.Font = v2293
    v2337.TextSize = 15
    v2337.LayoutOrder = 2
    v2293 = capturedValues1.value13.White
    v2337.TextColor3 = v2293
    v2384 = Color3.fromRGB(0, 0, 0)
    v2337.TextStrokeColor3 = v2384
    v2337.TextStrokeTransparency = 0
    v2337.Parent = v2296
    v2293 = Instance.new("Frame")
    capturedValues1.value94 = v2293
    v2293 = capturedValues1.value94
    v2293.Name = "Map"
    v2293 = capturedValues1.value94
    v2289 = UDim2.new(1, -20, 1, -44)
    v2293.Size = v2289
    v2293 = capturedValues1.value94
    v2289 = UDim2.new(0, 10, 0, 36)
    v2293.Position = v2289
    v2293 = capturedValues1.value94
    v2289 = Color3.fromRGB(0, 0, 0)
    v2293.BackgroundColor3 = v2289
    v2293 = capturedValues1.value94
    v2293.BackgroundTransparency = .35
    v2293 = capturedValues1.value94
    v2293.BorderSizePixel = 0
    v2293 = capturedValues1.value94
    v2293.ClipsDescendants = true
    v2293 = capturedValues1.value94
    v2293.Parent = capturedValues1.value90
    capturedValues1.value27(capturedValues1.value94, 8)
    capturedValues1.value28(capturedValues1.value94, capturedValues1.value13.Stroke , 1, .4)
    v2293 = 3
    v2289 = 1
    for v2384 = 1, v2293, v2289 do
        v2337 = Instance.new("Frame")
        v2293 = UDim2.new(0, 1, 1, 0)
        v2337.Size = v2293
        v2293 = UDim2.new((v2384 / 4), 0, 0, 0)
        v2337.Position = v2293
        v2289 = capturedValues1.value13.White
        v2337.BackgroundColor3 = v2289
        v2337.BackgroundTransparency = .85
        v2337.BorderSizePixel = 0
        v2337.Parent = capturedValues1.value94
        v2289 = Instance.new("Frame")
        v2296 = UDim2.new(1, 0, 0, 1)
        v2289.Size = v2296
        v2296 = UDim2.new(0, 0, (v2384 / 4), 0)
        v2289.Position = v2296
        v2293 = capturedValues1.value13.White
        v2289.BackgroundColor3 = v2293
        v2289.BackgroundTransparency = .85
        v2289.BorderSizePixel = 0
        v2293 = capturedValues1.value94
        v2289.Parent = v2293
    end
    v2384 = Instance.new("ImageLabel")
    capturedValues1.value95 = v2384
    v2384 = capturedValues1.value95
    v2293 = UDim2.new(0, 20, 0, 20)
    v2384.Size = v2293
    v2384 = capturedValues1.value95
    v2293 = Vector2.new(0.5, 0.5)
    v2384.AnchorPoint = v2293
    v2384 = capturedValues1.value95
    v2293 = UDim2.new(0.5, 0, 0.5, 0)
    v2384.Position = v2293
    v2384 = capturedValues1.value95
    v2289 = capturedValues1.value13.Accent
    v2384.BackgroundColor3 = v2289
    v2384 = capturedValues1.value95
    v2384.BorderSizePixel = 0
    v2384 = capturedValues1.value95
    v2384.ZIndex = 7
    v2384 = capturedValues1.value95
    v2384.Parent = capturedValues1.value94
    capturedValues1.value27(capturedValues1.value95, 10)
    capturedValues1.value28(capturedValues1.value95, capturedValues1.value13.White, 1.5, 0)
    task.spawn(function()
        local v830, v831, v832
        local v829 = function()
            local v2216 = capturedValues1.value1
            local v2222 = capturedValues1.value9.UserId
            local v2217 = Enum.ThumbnailType.HeadShot
            local v2221 = Enum.ThumbnailSize.Size48x48
            return v2216:GetUserThumbnailAsync(v2222, v2217, v2221)
        end
        v830, v832 = pcall(v829)
        v830 = v830 and v832 and capturedValues1.value95.Parent
        if v830 then
            v831 = capturedValues1.value95
            v831.Image = v832
        end
        return
    end)
    v2293 = function(arg63_1)
        local v845 = (Instance.new("Frame"))
        v845.Size = UDim2.new(0, 14, 0, 14)
        v845.AnchorPoint = Vector2.new(0.5, 0.5)
        v845.BackgroundTransparency = 1
        v845.ZIndex = 5
        v845.Visible = false
        v845.Parent = capturedValues1.value94
        local v842 = (Instance.new("Frame"))
        v842.Size = UDim2.new(1, 0, 1, 0)
        v842.BackgroundColor3 = capturedValues1.value14.Survivor
        v842.BorderSizePixel = 0
        v842.ZIndex = 5
        v842.Parent = v845
        capturedValues1.value27(v842, 7)
        capturedValues1.value28(v842, (Color3.fromRGB(0, 0, 0)), 1, .2)
        local v843 = (Instance.new("TextLabel"))
        v843.Size = UDim2.new(0, 50, 0, 12)
        v843.AnchorPoint = Vector2.new(0.5, 1)
        v843.Position = UDim2.new(0.5, 0, 0, -3)
        v843.BackgroundTransparency = 1
        v843.Text = "[0m]"
        v843.Font = Enum.Font.GothamMedium
        v843.TextSize = 10
        v843.TextColor3 = capturedValues1.value13.White
        v843.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        v843.TextStrokeTransparency = .4
        v843.ZIndex = 6
        v843.Parent = v845
        capturedValues1.value87[arg63_1] = {["holder"] = v845, ["dot"] = v842, ["dist"] = v843}

        return capturedValues1.value87[arg63_1]
    end
    capturedValues1.value96 = v2293
    v2289 = function()
        local v854, v856, v857, v858, v859
        if capturedValues1.value88 then
            capturedValues1.value88:Disconnect()
        end
        v854, v856, v857 = ipairs(capturedValues1.value89)
        while true do
            v857, v858 = v854(v856, v857)
            if not v857 then
                break
            end
            local up7 = v858
            pcall(function()
                up7:Disconnect()
                return
            end)
        end
        table.clear(capturedValues1.value89)
        local v852 = pairs
        for v857, v858 in v852(capturedValues1.value87) do
            local up8 = v858
            v859 = function()
                up8.holder:Destroy()
                return
            end
            v852 = pcall
            v858 = nil
            v852(v859)
        end
        table.clear(capturedValues1.value87)
        capturedValues1.value90.Visible = false
        return
    end
    capturedValues1.value97 = nil
    v2293 = function()
        capturedValues1.value97()
        capturedValues1.value90.Visible = true
        local v861 = capturedValues1.value89
        local v862 = ((#capturedValues1.value89) + 1)
        local v863 = capturedValues1.value1.PlayerRemoving
        local v865 = function(arg176_1)
            local v1960
            local v1957 = arg176_1
            local v1959 = capturedValues1.value87[v1957]
            local up82 = v1959
            if up82 then
                v1960 = function()
                    up82.holder:Destroy()
                    return
                end
                pcall(v1960)                    v1959 = capturedValues1.value87
                v1959[v1957] = nil
            end
            return
        end
        v861[v862] = v863:Connect(v865)
        v861 = capturedValues1.value4.RenderStepped
        v862 = v861.Connect
        v863 = function()
            local v1963, v1964, v1965, v1966, v1968, v1969, v1970, v1971, v1972, v1973, v1974, v1975, v1976, v1977, v1978, v1979
            local v1980, v1981, v1982, v1983, v1984, v1985
            local v1986, v1987, v1989
            local v1962 = capturedValues1.value19
            if (not v1962["Radar"]) then
                return
            else
                v1966 = capturedValues1.value33
                v1963 = capturedValues1.value9
                v1962 = (v1966(capturedValues1.value31(v1963)))
                if (not v1962) then
                    return
                else
                    v1970 = (capturedValues1.value94.AbsoluteSize.X / 2)
                    if (v1970 <= 0) then
                        return
                    else
                        v1963 = (v1970 / capturedValues1.value17)
                        v1964 = capturedValues1.value10.CFrame.LookVector
                        v1965 = (math.atan2((-v1964.X), (-v1964.Z)))
                        v1968 = ((CFrame.new(v1962.Position)) * (CFrame.Angles(0, v1965, 0)))
                        v1969 = {}
                        v1966 = ipairs
                        v1971 = capturedValues1.value1
                        v1975 = v1971.GetPlayers
                        for v1972, v1975 in v1966(v1975(v1971)) do
                            if (v1975 ~= capturedValues1.value9) then
                                v1976 = capturedValues1.value31(v1975)
                                v1977 = v1976 and (capturedValues1.value33(v1976))
                                v1966 = capturedValues1.value32
                                v1979 = v1977
                                v1978 = v1966(v1976)
                                if v1977 then
                                    v1979 = v1978 and (v1978.Health > 0)
                                end
                                if v1979 then
                                    v1969[v1975] = true
                                    v1979 = capturedValues1.value87[v1975] or (capturedValues1.value96(v1975))
                                    v1980 = (v1968:PointToObjectSpace(v1977.Position ))
                                    v1987 = (v1980.X * v1963)
                                    v1986 = (v1980.Z * v1963)
                                    v1985 = math.sqrt(((v1987 * v1987) + (v1986 * v1986)))
                                    v1984 = (v1970 - 8)
                                    v1981 = (v1985 > v1984) and (v1985 > 0)
                                    if v1981 then
                                        v1966 = ((v1987 / v1985) * v1984)
                                        v1981 = ((v1986 / v1985) * v1984)
                                        v1987 = v1966
                                        v1986 = v1981
                                    end
                                    v1982 = v1979.holder
                                    v1989 = UDim2.new(0.5, v1987, 0.5, v1986)
                                    v1982.Position = v1989
                                    v1982 = v1979.holder
                                    v1982.Visible = true
                                    v1982 = v1979.dot
                                    v1989 = capturedValues1.value35(v1975)
                                    v1982.BackgroundColor3 = v1989
                                    v1983 = math.floor((v1977.Position - v1962.Position).Magnitude)
                                    v1982 = v1979.dist
                                    v1989 = ("[" .. (v1983 .. "m]"))
                                    v1982.Text = v1989
                                end
                            end
                        end
                        v1973 = pairs
                        v1975 = capturedValues1.value87
                        for v1974, v1975 in v1973(v1975) do
                            if (not v1969[v1974]) then
                                v1976 = v1975.holder
                                v1976.Visible = false
                            end
                        end
                        return
                    end
                end
            end
        end
        v862(v861, v863)

        return
    end
    capturedValues1.value97 = v2289
    capturedValues1.value98 = v2293
    v2293 = Instance.new("ScreenGui")
    capturedValues1.value99 = v2293
    v2293 = capturedValues1.value99
    v2293.Name = "ClaudewareWM"
    v2293 = capturedValues1.value99
    v2293.ResetOnSpawn = false
    v2293 = capturedValues1.value99
    v2293.IgnoreGuiInset = true
    v2293 = capturedValues1.value99
    v2293.DisplayOrder = 1000
    v2293 = capturedValues1.value99
    v2289 = Enum.ZIndexBehavior.Sibling
    v2293.ZIndexBehavior = v2289
    v2293 = capturedValues1.value99
    v2293.Parent = capturedValues1.value11
    v2337 = Instance.new("Frame")
    capturedValues1.value100 = v2337
    v2337 = capturedValues1.value100
    v2337.Name = "Watermark"
    v2337 = capturedValues1.value100
    v2296 = Vector2.new(0.5, 0)
    v2337.AnchorPoint = v2296
    v2337 = capturedValues1.value100
    v2296 = UDim2.new(0.5, 0, 0, 4)
    v2337.Position = v2296
    v2337 = capturedValues1.value100
    v2296 = UDim2.new(0, 0, 0, 38)
    v2337.Size = v2296
    v2337 = capturedValues1.value100
    v2293 = Enum.AutomaticSize.X
    v2337.AutomaticSize = v2293
    v2337 = capturedValues1.value100
    v2296 = Color3.fromRGB(24, 24, 24)
    v2337.BackgroundColor3 = v2296
    v2337 = capturedValues1.value100
    v2337.BorderSizePixel = 0
    v2337 = capturedValues1.value100
    v2337.Active = true
    v2337 = capturedValues1.value100
    v2337.Parent = capturedValues1.value99
    v2337 = capturedValues1.value100
    v2337.Visible = false
    capturedValues1.value27(capturedValues1.value100, 8)
    capturedValues1.value28(capturedValues1.value100, (Color3.fromRGB(60, 60, 60)), 1, 0)
    v2289 = Instance.new("UIPadding")
    v2296 = UDim.new(0, 20)
    v2289.PaddingLeft = v2296
    v2296 = UDim.new(0, 24)
    v2289.PaddingRight = v2296
    v2289.Parent = capturedValues1.value100
    v2293 = Instance.new("UIListLayout")
    v2296 = Enum.FillDirection.Horizontal
    v2293.FillDirection = v2296
    v2296 = Enum.VerticalAlignment.Center
    v2293.VerticalAlignment = v2296
    v2296 = Enum.SortOrder.LayoutOrder
    v2293.SortOrder = v2296
    v2289 = UDim.new(0, 12)
    v2293.Padding = v2289
    v2293.Parent = capturedValues1.value100
    v2296 = Instance.new("ImageLabel")
    v2293 = UDim2.new(0, 24, 0, 24)
    v2296.Size = v2293
    v2296.BackgroundTransparency = 1
    v2296.Image = "rbxassetid://115798729575437"
    v2296.LayoutOrder = 1
    v2296.Parent = capturedValues1.value100
    v2289 = Instance.new("TextLabel")
    v2293 = Enum.AutomaticSize.X
    v2289.AutomaticSize = v2293
    v2293 = UDim2.new(0, 0, 1, 0)
    v2289.Size = v2293
    v2289.BackgroundTransparency = 1
    v2289.RichText = true
    v2289.Text = "<font color=\"#ffffff\">Claude</font><font color=\"#d97757\">ware</font>"
    v2293 = Enum.Font.GothamBold
    v2289.Font = v2293
    v2289.TextSize = 18
    v2289.LayoutOrder = 2
    v2289.Parent = capturedValues1.value100
    v2293 = Instance.new("Frame")
    v2289 = UDim2.new(0, 1, 0, 20)
    v2293.Size = v2289
    v2289 = Color3.fromRGB(70, 70, 70)
    v2293.BackgroundColor3 = v2289
    v2293.BorderSizePixel = 0
    v2293.LayoutOrder = 3
    v2293.Parent = capturedValues1.value100
    v2293 = Instance.new("TextLabel")
    v2289 = Enum.AutomaticSize.X
    v2293.AutomaticSize = v2289
    v2289 = UDim2.new(0, 0, 1, 0)
    v2293.Size = v2289
    v2293.BackgroundTransparency = 1
    v2293.Text = "Violence District"
    v2289 = Enum.Font.GothamMedium
    v2293.Font = v2289
    v2293.TextSize = 14
    v2289 = Color3.fromRGB(200, 200, 200)
    v2293.TextColor3 = v2289
    v2293.LayoutOrder = 4
    v2293.Parent = capturedValues1.value100
    v2289 = Instance.new("Frame")
    v2293 = UDim2.new(0, 1, 0, 20)
    v2289.Size = v2293
    v2293 = Color3.fromRGB(70, 70, 70)
    v2289.BackgroundColor3 = v2293
    v2289.BorderSizePixel = 0
    v2289.LayoutOrder = 5
    v2289.Parent = capturedValues1.value100
    v2289 = Instance.new("TextLabel")
    capturedValues1.value101 = v2289
    v2289 = capturedValues1.value101
    v2293 = Enum.AutomaticSize.X
    v2289.AutomaticSize = v2293
    v2289 = capturedValues1.value101
    v2293 = UDim2.new(0, 0, 1, 0)
    v2289.Size = v2293
    v2289 = capturedValues1.value101
    v2289.BackgroundTransparency = 1
    v2289 = capturedValues1.value101
    v2289.Text = "00:00:00"
    v2289 = capturedValues1.value101
    v2293 = Enum.Font.GothamMedium
    v2289.Font = v2293
    v2289 = capturedValues1.value101
    v2289.TextSize = 14
    v2289 = capturedValues1.value101
    v2293 = Color3.fromRGB(180, 180, 180)
    v2289.TextColor3 = v2293
    v2289 = capturedValues1.value101
    v2289.LayoutOrder = 6
    v2289 = capturedValues1.value101
    v2289.Parent = capturedValues1.value100
    capturedValues1.value102 = false
    capturedValues1.value103 = nil
    capturedValues1.value104 = nil
    v2293 = capturedValues1.value100.InputBegan
    v2289 = function(arg66_1)
        local up9 = arg66_1
        local v878 = (up9.UserInputType == Enum.UserInputType.MouseButton1) or (up9.UserInputType == Enum.UserInputType.Touch)
        if v878 then
            capturedValues1.value102 = true
            capturedValues1.value103 = up9.Position
            capturedValues1.value104 = capturedValues1.value100.Position
            up9.Changed:Connect(function()
                local v786 = up9.UserInputState
                local v785 = Enum.UserInputState
                if (v786 == v785.End ) then
                    capturedValues1.value102 = false
                end
                return
            end)
        end
        return
    end
    v2293:Connect(v2289)
    capturedValues1.value2.InputChanged:Connect(function(arg67_1)
        local v891, v893
        local v880 = capturedValues1.value102
        local v881 = v880
        local v882 = arg67_1
        if v880 then
            v881 = (v882.UserInputType == Enum.UserInputType.MouseMovement) or (v882.UserInputType == Enum.UserInputType.Touch)
        end
        if v881 then
            v880 = (v882.Position - capturedValues1.value103)
            v893 = capturedValues1.value100
            v891 = UDim2.new(capturedValues1.value104.X.Scale, (capturedValues1.value104.X.Offset + v880.X), capturedValues1.value104.Y.Scale, (capturedValues1.value104.Y .Offset + v880.Y))
            v893.Position = v891
        end
        return
    end)
    v2293 = task
    v2289 = v2293.spawn
    v2293 = function()
        local v897, v899
        while true do
            if not (not capturedValues1.value22) then
                break
            end
            v897 = capturedValues1.value101
            v899 = os.date("%H:%M:%S")
            v897.Text = v899
            task.wait(1)
        end
        return
    end
    v2289(v2293)
    capturedValues1.value105 = nil
    local up216 = function()
        local v906, v908, v910, v911, v912
        if capturedValues1.value22 then
            return
        else
            pcall(capturedValues1.value97)
            v906, v908, v910 = ipairs(capturedValues1.value21)
            while true do
                v910, v911 = v906(v908, v910)
                if not v910 then
                    break
                end
                local up10 = v911
                v912 = function()
                    up10:Disconnect()
                    return
                end
                pcall(v912)
            end
            table.clear(capturedValues1.value21)
            if capturedValues1.value105 then
                v908 = function()
                    capturedValues1.value105:Disconnect()
                    return
                end
                pcall(v908)
            end
            for v910 in pairs(capturedValues1.value56) do
                capturedValues1.value61(v910)
            end
            for v910 in pairs(capturedValues1.value57) do
                capturedValues1.value64(v910)
            end
            if capturedValues1.value66 then
                pcall(function()
                    capturedValues1.value66:Remove()
                    return
                end)
            end
            task.delay(.1, function()
                pcall(function()
                    capturedValues1.value37:Destroy()
                    return
                end)
                local v1945 = function()
                    capturedValues1.value53:Destroy()
                    return
                end
                pcall(v1945)
                v1945 = function()
                    capturedValues1.value99:Destroy()
                    return
                end
                pcall(v1945)

                return
            end)
            capturedValues1.value39("Claudeware", "Unloaded", 3)

            return
        end
    end
    capturedValues1.value106 = {}
    capturedValues1.value107 = nil
    v2296 = function(arg70_1)
        local v914, v915, v916, v917, v918, v919, v920, v921, v922, v923, v924, v926, v927
        if arg70_1 then
            v916 = {}
            v915 = ipairs
            v917 = capturedValues1.value1
            v918 = v917.GetPlayers
            v914, v919, v920 = v915(v918(v917))
            v917 = v914
            while true do
                v920, v918 = v917(v919, v920)
                if not v920 then
                    break
                end
                if v918["Character"] then
                    v915 = ((#v916) + 1)
                    v924 = v918.Character
                    v916[v915] = v924
                end
            end
            v915 = ipairs
            v926 = capturedValues1.value8
            v924 = v926.GetDescendants
            for v917, v918 in v915(v924(v926)) do
                v924 = (v918:IsA("BasePart")) and (v918.Transparency < 0.5)
                if v924 then
                    v924 = false
                    v921, v922, v923 = ipairs(v916)
                    while true do
                        v923, v927 = v921(v922, v923)
                        if not v923 then
                            break
                        end
                        v915 = v918:IsDescendantOf(v927)
                        if v915 then
                            v924 = true
                        else
                            continue
                        end
                        break
                    end
                    if (not v924) then
                        if (capturedValues1.value106[v918] == nil) then
                            v921 = capturedValues1.value106
                            v922 = v918.Transparency
                            v921[v918] = v922
                        end
                        v918.Transparency = 0.5
                    end
                end
            end
        else
            v916 = pairs
            v926 = capturedValues1.value106
            for v917, v926 in v916(v926) do
                v916 = v917
                local up11 = v916
                local up12 = v926
                v918 = up11 and up11.Parent
                if v918 then
                    v921 = function()
                        up11.Transparency = up12
                        return
                    end
                    pcall(v921)
                end
                v926 = nil
            end
            table.clear(capturedValues1.value106)
        end
        return
    end
    capturedValues1.value108 = nil
    capturedValues1.value109 = nil
    capturedValues1.value110 = nil
    v2289 = function()
        local v929, v936
        if capturedValues1.value110 then
            v929 = function()
                capturedValues1.value110:Disconnect()
                return
            end
            pcall(v929)                capturedValues1.value110 = nil
        end
        if capturedValues1.value108 then
            pcall(function()
                capturedValues1.value108:Destroy()
                return
            end)
            capturedValues1.value108 = nil
        end
        if capturedValues1.value109 then
            pcall(function()
                capturedValues1.value109:Destroy()
                return
            end)
            capturedValues1.value109 = nil
        end
        local v933 = capturedValues1.value32(capturedValues1.value31(capturedValues1.value9))
        local up13 = v933
        if up13 then
            v936 = function()
                up13.PlatformStand = false
                return
            end
            pcall(v936)
        end
        return
    end
    capturedValues1.value111 = v2289
    v2289 = function()
        local v937, v943, v944, v945
        local v938 = (capturedValues1.value31(capturedValues1.value9))
        local v940 = v938 and (capturedValues1.value33(v938))
        local v941 = v938 and (capturedValues1.value32(v938))
        local v939 = (v940 and v941)
        if (not v939) then
            return
        else
            capturedValues1.value111()
            v941.PlatformStand = true
            capturedValues1.value108 = (Instance.new("BodyVelocity"))
            v937 = capturedValues1.value108
            v944 = Vector3.new(9000000000, 9000000000, 9000000000)
            v937.MaxForce = v944
            v937 = capturedValues1.value108
            v943 = Vector3.zero
            v937.Velocity = v943
            v937 = capturedValues1.value108
            v937.P = 1250
            v937 = capturedValues1.value108
            v937.Parent = v940
            capturedValues1.value109 = (Instance.new("BodyGyro"))
            v937 = capturedValues1.value109
            v945 = Vector3.new(9000000000, 9000000000, 9000000000)
            v937.MaxTorque = v945
            v937 = capturedValues1.value109
            v937.P = 90000
            v937 = capturedValues1.value109
            v944 = capturedValues1.value8.CurrentCamera.CFrame
            v937.CFrame = v944
            v937 = capturedValues1.value109
            v937.Parent = v940
            v937 = capturedValues1.value4.RenderStepped
            v944 = function()
                local v1997, v1998, v1999, v2000, v2001, v2002, v2003, v2004, v2005, v2006, v2007, v2008, v2009, v2010
                local v1996 = capturedValues1.value19
                if (not v1996["Fly"]) then
                    return
                else
                    v1996 = (capturedValues1.value31(capturedValues1.value9))
                    v2002 = v1996 and (capturedValues1.value33(v1996))
                    v2001 = v2002 and capturedValues1.value108 and (capturedValues1.value108.Parent == v2002)
                    if (not v2001) then
                        return
                    else
                        v1997 = capturedValues1.value8.CurrentCamera.CFrame
                        v1998 = Vector3.zero
                        v2000 = capturedValues1.value2
                        v2003 = Enum.KeyCode
                        v2001 = v2000:IsKeyDown(v2003.W)
                        if v2001 then
                            v1998 = (v1998 + v1997.LookVector)
                        end
                        v2001 = capturedValues1.value2
                        v2004 = Enum
                        v1999 = v2001:IsKeyDown(v2004.KeyCode .S)
                        if v1999 then
                            v1998 = (v1998 - v1997.LookVector)
                        end
                        v1999 = capturedValues1.value2
                        v2004 = Enum.KeyCode
                        v2003 = v1999:IsKeyDown(v2004.A)
                        if v2003 then
                            v1998 = (v1998 - v1997.RightVector)
                        end
                        v2003 = capturedValues1.value2
                        v2004 = Enum.KeyCode.D
                        v2009 = v2003:IsKeyDown(v2004)
                        if v2009 then
                            v1998 = (v1998 + v1997.RightVector)
                        end
                        v2009 = capturedValues1.value2
                        v2005 = Enum.KeyCode
                        v2004 = v2009:IsKeyDown(v2005.Space)
                        if v2004 then
                            v1998 = (v1998 + (Vector3.new(0, 1, 0)))
                        end
                        v2005 = capturedValues1.value2
                        v2010 = Enum.KeyCode
                        v2006 = v2005:IsKeyDown(v2010.LeftShift)
                        v2004 = v2006
                        if not (v2006) then
                            v2005 = capturedValues1.value2
                            v2007 = Enum.KeyCode.LeftControl
                            v2004 = (v2005:IsKeyDown(v2007))
                        end
                        if v2004 then
                            v1998 = (v1998 + (Vector3.new(0, -1, 0)))
                        end
                        v2008 = capturedValues1.value109
                        v2008.CFrame = v1997
                        if (v1998["Magnitude"] > 0) then
                            v2008 = capturedValues1.value108
                            v2006 = (v1998.Unit * capturedValues1.value16.FlySpeed)
                            v2008.Velocity = v2006
                        else
                            v2008 = capturedValues1.value108
                            v2006 = Vector3.zero
                            v2008.Velocity = v2006
                        end
                        return
                    end
                end
            end
            v937:Connect(v944)

            return
        end
    end
    capturedValues1.value112 = v2289
    capturedValues1.value113 = v2296
    v2296 = capturedValues1.value21
    v2289 = ((#capturedValues1.value21) + 1)
    v2293 = capturedValues1.value4.Stepped
    v2337 = function()
        local v953, v956, v958, v964
        local v951 = capturedValues1.value19
        if v951["Noclip"] then
            v956 = (capturedValues1.value31(capturedValues1.value9))
            if v956 then
                for v953, v958 in ipairs(v956:GetDescendants()) do
                    v964 = (v958:IsA("BasePart")) and v958.CanCollide
                    if v964 then
                        v958.CanCollide = false
                    end
                end
            end
        end
        return
    end
    v2293 = v2293:Connect(v2337)
    v2296[v2289] = v2293
    v2296 = capturedValues1.value21
    v2289 = ((#capturedValues1.value21) + 1)
    v2293 = capturedValues1.value4.Heartbeat
    v2337 = function()
        local v969
        local v966 = (capturedValues1.value31(capturedValues1.value9))
        local v967 = v966 and (capturedValues1.value32(v966))
        local up14 = v967
        if (not up14) then
            return
        else
            v967 = capturedValues1.value19
            if v967["WalkSpeedOn"] then
                pcall(function()
                    up14.WalkSpeed = capturedValues1.value16.WalkSpeed
                    return
                end)
            end
            v967 = capturedValues1.value19
            if v967["GodMode"] then
                v969 = function()
                    up14.Health = up14.MaxHealth
                    return
                end
                pcall(v969)
            end
            return
        end
    end
    v2293 = v2293:Connect(v2337)
    v2296[v2289] = v2293
    v2296 = capturedValues1.value21
    v2289 = ((#capturedValues1.value21) + 1)
    v2293 = capturedValues1.value9.CharacterAdded:Connect(function()
        task.wait(.6)
        local v973 = capturedValues1.value19
        if v973.Fly then
            capturedValues1.value112()
        end
        return
    end)
    v2296[v2289] = v2293
    v2296 = v2280("Visuals")
    v2278(v2296, "Camera FOV", 40, 120, (math.floor(capturedValues1.value16.FOV)), function(arg76_1)
        capturedValues1.value16.FOV = arg76_1
        return
    end)
    v2274(v2296, "Radar", function(arg77_1)
        capturedValues1.value19.Radar = arg77_1
        if arg77_1 then
            capturedValues1.value98()
        else
            capturedValues1.value97()
        end
        return
    end)
    v2274(v2296, "Player ESP", function(arg78_1)
        local v994 = capturedValues1.value19.ESP
        v994.Players = arg78_1
        return
    end)
    v2282(v2296, "Killer Color", "Killer", nil)
    v2282(v2296, "Survivor Color", "Survivor", nil)
    v2282(v2296, "Generator ESP", "Generator", function(arg79_1)
        local v1000 = capturedValues1.value19.ESP
        v1000.Generator = arg79_1
        return
    end)
    v2282(v2296, "Pallet ESP", "Pallet", function(arg80_1)
        local v1006 = capturedValues1.value19.ESP
        v1006.Pallet = arg80_1
        return
    end)
    v2282(v2296, "Hook ESP", "Hook", function(arg81_1)
        local v1012 = capturedValues1.value19.ESP
        v1012.Hook = arg81_1
        return
    end)
    v2282(v2296, "Window ESP", "Window", function(arg82_1)
        local v1018 = capturedValues1.value19.ESP
        v1018.Window = arg82_1
        return
    end)
    v2282(v2296, "Gate ESP", "Gate", function(arg83_1)
        local v1024 = capturedValues1.value19.ESP
        v1024.Gate = arg83_1
        return
    end)
    v2282(v2296, "Tesla ESP", "Tesla", function(arg84_1)
        local v1030 = capturedValues1.value19.ESP
        v1030.Tesla = arg84_1
        return
    end)
    v2274(v2296, "XRAY", function(arg85_1)
        capturedValues1.value19.Xray = arg85_1
        capturedValues1.value113(arg85_1)
        return
    end, false)
    v2289 = v2280("Aim")
    v2274(v2289, "Aimbot", function(arg86_1)
        capturedValues1.value19.Aimbot = arg86_1
        return
    end)
    v2274(v2289, "Aim Circle", function(arg87_1)
        capturedValues1.value19.AimCircle = arg87_1
        return
    end)
    v2293 = Instance.new("Frame")
    v2282 = UDim2.new(1, 0, 0, 42)
    v2293.Size = v2282
    v2337 = capturedValues1.value13.Element
    v2293.BackgroundColor3 = v2337
    v2293.BorderSizePixel = 0
    v2293.Parent = v2289
    capturedValues1.value27(v2293, 6)
    capturedValues1.value28(v2293, capturedValues1.value13.Stroke, 1, 0)
    v2337 = Instance.new("TextLabel")
    v2282 = UDim2.new(1, -150, 1, 0)
    v2337.Size = v2282
    v2282 = UDim2.new(0, 12, 0, 0)
    v2337.Position = v2282
    v2337.BackgroundTransparency = 1
    v2337.Text = "Aim Key"
    v2282 = Enum.Font.GothamMedium
    v2337.Font = v2282
    v2337.TextSize = 13
    v2282 = capturedValues1.value13.Text
    v2337.TextColor3 = v2282
    v2282 = Enum.TextXAlignment.Left
    v2337.TextXAlignment = v2282
    v2337.Parent = v2293
    v2282 = Instance.new("TextButton")
    capturedValues1.value114 = v2282
    v2282 = capturedValues1.value114
    v2296 = UDim2.new(0, 130, 0, 28)
    v2282.Size = v2296
    v2282 = capturedValues1.value114
    v2296 = UDim2.new(1, -140, 0.5, -14)
    v2282.Position = v2296
    v2282 = capturedValues1.value114
    v2296 = capturedValues1.value13.Tertiary
    v2282.BackgroundColor3 = v2296
    v2282 = capturedValues1.value114
    v2282.AutoButtonColor = false
    v2282 = capturedValues1.value114
    v2296 = Enum.Font.GothamBold
    v2282.Font = v2296
    v2282 = capturedValues1.value114
    v2282.TextSize = 12
    v2282 = capturedValues1.value114
    v2296 = capturedValues1.value13.Accent
    v2282.TextColor3 = v2296
    v2282 = capturedValues1.value114
    v2282.Text = "Set Keybind"
    v2282 = capturedValues1.value114
    v2282.Parent = v2293
    capturedValues1.value27(capturedValues1.value114, 6)
    capturedValues1.value28(capturedValues1.value114, capturedValues1.value13.Stroke, 1, 0)
    local up132 = function()
        local v1054 = (capturedValues1.value23.kind == "key") and capturedValues1.value23.code.Name or capturedValues1.value23.input.Name
        local v1056 = capturedValues1.value114
        local v1055 = capturedValues1.value24 and "Press any key..." or ("Set: " .. v1054)
        v1056.Text = v1055
        return
    end
    up132()
    capturedValues1.value114.MouseButton1Click:Connect(function()
        capturedValues1.value24 = true
        up132()
        return
    end)
    table.insert(capturedValues1.value47, {["inst"] = v2293, ["name"] = "Aim Key", ["page"] = v2289})
    v2296 = Instance.new("Frame")
    capturedValues1.value115 = v2296
    v2296 = capturedValues1.value115
    v2282 = UDim2.new(1, 0, 0, 42)
    v2296.Size = v2282
    v2296 = capturedValues1.value115
    v2293 = capturedValues1.value13.Element
    v2296.BackgroundColor3 = v2293
    v2296 = capturedValues1.value115
    v2296.BorderSizePixel = 0
    v2296 = capturedValues1.value115
    v2296.ClipsDescendants = true
    v2296 = capturedValues1.value115
    v2296.Parent = v2289
    capturedValues1.value27(capturedValues1.value115, 6)
    capturedValues1.value28(capturedValues1.value115, capturedValues1.value13.Stroke, 1, 0)
    v2296 = Instance.new("Frame")
    v2282 = UDim2.new(1, 0, 0, 42)
    v2296.Size = v2282
    v2296.BackgroundTransparency = 1
    v2296.Parent = capturedValues1.value115
    v2293 = Instance.new("TextLabel")
    v2282 = UDim2.new(1, -150, 1, 0)
    v2293.Size = v2282
    v2282 = UDim2.new(0, 12, 0, 0)
    v2293.Position = v2282
    v2293.BackgroundTransparency = 1
    v2293.Text = "Team Target"
    v2282 = Enum.Font.GothamMedium
    v2293.Font = v2282
    v2293.TextSize = 13
    v2282 = capturedValues1.value13.Text
    v2293.TextColor3 = v2282
    v2282 = Enum.TextXAlignment.Left
    v2293.TextXAlignment = v2282
    v2293.Parent = v2296
    v2282 = Instance.new("TextButton")
    capturedValues1.value116 = v2282
    v2282 = capturedValues1.value116
    v2293 = UDim2.new(0, 130, 0, 28)
    v2282.Size = v2293
    v2282 = capturedValues1.value116
    v2293 = UDim2.new(1, -140, 0.5, -14)
    v2282.Position = v2293
    v2282 = capturedValues1.value116
    v2293 = capturedValues1.value13.Tertiary
    v2282.BackgroundColor3 = v2293
    v2282 = capturedValues1.value116
    v2282.AutoButtonColor = false
    v2282 = capturedValues1.value116
    v2293 = Enum.Font.GothamBold
    v2282.Font = v2293
    v2282 = capturedValues1.value116
    v2282.TextSize = 12
    v2282 = capturedValues1.value116
    v2293 = capturedValues1.value13.Accent
    v2282.TextColor3 = v2293
    v2282 = capturedValues1.value116
    v2282.Text = "All"
    v2282 = capturedValues1.value116
    v2282.Parent = v2296
    capturedValues1.value27(capturedValues1.value116, 6)
    capturedValues1.value28(capturedValues1.value116, capturedValues1.value13.Stroke, 1, 0)
    v2282 = Instance.new("TextLabel")
    capturedValues1.value117 = v2282
    v2282 = capturedValues1.value117
    v2296 = UDim2.new(0, 16, 1, 0)
    v2282.Size = v2296
    v2282 = capturedValues1.value117
    v2296 = UDim2.new(1, -18, 0, 0)
    v2282.Position = v2296
    v2282 = capturedValues1.value117
    v2282.BackgroundTransparency = 1
    v2282 = capturedValues1.value117
    v2282.Text = "v"
    v2282 = capturedValues1.value117
    v2293 = Enum.Font.GothamBold
    v2282.Font = v2293
    v2282 = capturedValues1.value117
    v2282.TextSize = 11
    v2282 = capturedValues1.value117
    v2293 = capturedValues1.value13.Accent
    v2282.TextColor3 = v2293
    v2282 = capturedValues1.value117
    v2282.Parent = capturedValues1.value116
    v2293 = Instance.new("Frame")
    capturedValues1.value118 = v2293
    v2293 = capturedValues1.value118
    v2282 = UDim2.new(1, -16, 0, 0)
    v2293.Size = v2282
    v2293 = capturedValues1.value118
    v2282 = UDim2.new(0, 8, 0, 44)
    v2293.Position = v2282
    v2293 = capturedValues1.value118
    v2293.BackgroundTransparency = 1
    v2293 = capturedValues1.value118
    v2293.Parent = capturedValues1.value115
    v2293 = Instance.new("UIListLayout")
    v2282 = UDim.new(0, 4)
    v2293.Padding = v2282
    v2296 = Enum.SortOrder.LayoutOrder
    v2293.SortOrder = v2296
    v2296 = capturedValues1.value118
    capturedValues1.value119 = nil
    v2293.Parent = v2296
    capturedValues1.value120 = false
    v2282 = function()
        local v1065, v1067, v1068, v1069, v1071, v1072
        local v1061 = ipairs
        local v1062 = capturedValues1.value118
        local v1063 = v1062.GetChildren
        for v1065, v1063 in v1061(v1063(v1062)) do
            v1061 = v1063:IsA("TextButton")
            if v1061 then
                v1063:Destroy()
            end
        end
        local v1064 = {"All"}
        local v1070 = function()
            return capturedValues1.value7:GetChildren()
        end
        v1065, v1062 = pcall(v1070)
        v1070 = (v1065 and v1062)
        if v1070 then
            v1061 = ipairs
            for v1069, v1067 in v1061(v1062) do
                v1061 = v1067:IsA("Team")
                if v1061 then
                    v1061 = ((#v1064) + 1)
                    v1068 = v1067.Name
                    v1064[v1061] = v1068
                end
            end
        end
        v1061 = ipairs
        for v1069, v1067 in v1061(v1064) do
            local up15 = v1067
            v1068 = Instance.new("TextButton")
            v1072 = UDim2.new(1, 0, 0, 26)
            v1068.Size = v1072
            v1071 = (up15 == capturedValues1.value16.AimTeam) and capturedValues1.value13.Accent or capturedValues1.value13.Secondary
            v1068.BackgroundColor3 = v1071
            v1068.AutoButtonColor = false
            v1068.Text = ("  " .. up15)
            v1071 = Enum.Font.GothamMedium
            v1068.Font = v1071
            v1068.TextSize = 12
            v1071 = capturedValues1.value13.Text
            v1068.TextColor3 = v1071
            v1071 = Enum.TextXAlignment.Left
            v1068.TextXAlignment = v1071
            v1068.Parent = capturedValues1.value118
            capturedValues1.value27(v1068, 5)
            v1061 = v1068.MouseButton1Click
            v1072 = function()
                capturedValues1.value16.AimTeam = up15
                capturedValues1.value25()
                capturedValues1.value119()
                return
            end
            v1067 = nil
            v1061:Connect(v1072)
        end
        return (#v1064)
    end
    v2293 = function()
        capturedValues1.value120 = false
        capturedValues1.value117.Text = "v"
        local v1084 = capturedValues1.value26
        local v1085 = capturedValues1.value115
        local v1091 = UDim2.new(1, 0, 0, 42)
        v1084(v1085, .18, {["Size"] = v1091})

        return
    end
    capturedValues1.value25 = function()
        capturedValues1.value116.Text = capturedValues1.value16.AimTeam
        return
    end
    capturedValues1.value119 = v2293
    capturedValues1.value121 = v2282
    v2282 = capturedValues1.value116.MouseButton1Click
    v2293 = function()
        local v1105, v1106, v1107, v1113
        if capturedValues1.value120 then
            capturedValues1.value119()
        else
            v1106 = (capturedValues1.value121())
            v1105 = capturedValues1.value117
            v1105.Text = "^"
            v1105 = capturedValues1.value26
            v1107 = capturedValues1.value115
            v1113 = UDim2.new(1, 0, 0, (48 + (v1106 * 30)))
            v1105(v1107, .18, {["Size"] = v1113})
        end
        return
    end
    v2282:Connect(v2293)
    v2282 = table.insert
    v2293 = capturedValues1.value47
    v2296 = capturedValues1.value115
    v2282(v2293, {["inst"] = v2296, ["name"] = "Team Target", ["page"] = v2289})
    v2278(v2289, "Aim FOV", 30, 400, capturedValues1.value16.AimFov, function(arg94_1)
        capturedValues1.value16.AimFov = arg94_1
        return
    end)
    v2278(v2289, "Aim Smooth", 0, 95, (math.floor((capturedValues1.value16.AimSmooth * 100))), function(arg95_1)
        capturedValues1.value16.AimSmooth = (arg95_1 / 100)

        return
    end)
    v2274((v2280("Skillcheck")), "Auto Perfect", function(arg96_1)
        capturedValues1.value19.AutoPerfect = arg96_1
        return
    end)
    v2282 = v2280("Rage")
    capturedValues1.value78 = (v2290(v2282, "Target", "Target: none"))
    v2274(v2282, "Kill Target", function(arg97_1)
        local v1135
        capturedValues1.value19.KillTarget = arg97_1
        if arg97_1 then
            v1135 = capturedValues1.value36()
            if (not v1135) then
                capturedValues1.value39("Claudeware", "You are not killer buddy", 3)
            end
            capturedValues1.value77()
        end
        return
    end)
    v2298(v2282, "Choose Target", function()
        capturedValues1.value86()
        return
    end)
    v2274(v2282, "Kill All", function(arg99_1)
        local v1144
        capturedValues1.value19.KillAll = arg99_1
        if arg99_1 then
            v1144 = capturedValues1.value36()
            if (not v1144) then
                capturedValues1.value39("Claudeware", "You are not killer buddy", 3)
            end
            up185()
        end
        return
    end)
    capturedValues1.value122 = "Claudeware"
    v2298 = (writefile ~= nil)
    v2290 = v2298
    if v2298 then
        v2290 = (readfile ~= nil) and (listfiles ~= nil) and (isfolder ~= nil) and (makefolder ~= nil)
    end
    capturedValues1.value123 = v2290
    if capturedValues1.value123 then
        v2298 = function()
            local v1941 = isfolder(capturedValues1.value122)
            if (not v1941) then
                makefolder(capturedValues1.value122)
            end
            return
        end
        pcall(v2298)
    end
    local up232 = function()
        local v1216, v1217
        local v1215 = {}
        local v1218 = {}
        local v1220 = {}
        local v1222 = capturedValues1.value16.AimPart
        local v1223 = "aimTeam"
        local v1224 = capturedValues1.value16.AimTeam
        v1215 = {["toggles"] = v1215, ["sliders"] = v1218, ["colors"] = v1220, ["aimPart"] = v1222, [v1223] = v1224}
        local v1230 = pairs
        v1220 = capturedValues1.value20
        local v1221 = "toggles"
        for v1218, v1221 in v1230(v1220[v1221]) do
            v1230 = v1215.toggles
            v1223 = v1221.get()
            v1230[v1218] = v1223
        end
        v1217, v1218, v1216 = pairs(capturedValues1.value20.sliders)
        while true do
            v1216, v1221 = v1217(v1218, v1216)
            if not v1216 then
                break
            end
            v1230 = v1215.sliders
            v1223 = v1221.get()
            v1230[v1216] = v1223
        end
        v1230 = pairs
        v1221 = capturedValues1.value20
        for v1216, v1221 in v1230(v1221.colors) do
            v1230 = v1215.colors
            v1223 = v1221.get()
            v1230[v1216] = v1223
        end
        v1216 = capturedValues1.value23.kind
        v1221 = (capturedValues1.value23.kind == "key") and capturedValues1.value23.code.Name or capturedValues1.value23.input.Name
        v1215.aimKey = {["kind"] = v1216, ["name"] = v1221}

        return v1215
    end
    v2298 = function(arg108_1)
        local v1233, v1234, v1236, v1237, v1238, v1240, v1242
        local up18 = arg108_1
        local v1235 = type(up18)
        if (v1235 ~= "table") then
            return
        else
            v1233 = up18
            if v1233["sliders"] then
                v1238 = pairs
                v1237 = up18
                for v1234, v1242 in v1238(v1237.sliders) do
                    v1237 = v1234
                    local up19 = v1237
                    local up20 = v1242
                    v1240 = capturedValues1.value20
                    if v1240.sliders [up19] then
                        pcall(function()
                            capturedValues1.value20.sliders[up19].set(up20)
                            return
                        end)
                    end
                    v1242 = nil
                end
            end
            v1235 = up18
            if v1235["colors"] then
                v1238 = pairs
                v1242 = up18
                v1237 = v1242.colors
                for v1236, v1242 in v1238(v1237) do
                    v1237 = v1236
                    local up21 = v1237
                    local up22 = v1242
                    v1240 = capturedValues1.value20
                    if v1240["colors"][up21] then
                        v1240 = function()
                            capturedValues1.value20.colors[up21].set(up22)
                            return
                        end
                        pcall(v1240)
                    end
                    v1242 = nil
                end
            end
            v1235 = up18
            if v1235["toggles"] then
                v1238 = pairs
                v1242 = up18
                v1237 = v1242.toggles
                for v1236, v1242 in v1238(v1237) do
                    v1237 = v1236
                    local up23 = v1237
                    local up24 = v1242
                    v1240 = capturedValues1.value20
                    if v1240["toggles"][up23] then
                        v1240 = function()
                            capturedValues1.value20.toggles[up23].set(up24)
                            return
                        end
                        pcall(v1240)
                    end
                    v1242 = nil
                end
            end
            v1235 = up18
            if v1235["aimPart"] then
                v1238 = capturedValues1.value16
                v1234 = up18.aimPart
                v1238.AimPart = v1234
            end
            v1235 = up18
            if v1235["aimTeam"] then
                v1238 = capturedValues1.value16
                v1234 = up18.aimTeam
                v1238.AimTeam = v1234
                if capturedValues1.value25 then
                    capturedValues1.value25()
                end
            end
            v1235 = up18
            if v1235["aimKey"] then
                v1234 = function()
                    local v2227, v2230
                    local v2232 = up18.aimKey.kind
                    if (v2232 == "key") then
                        v2230 = Enum.KeyCode[up18.aimKey.name]
                        capturedValues1.value23 = {["kind"] = "key", ["code"] = v2230}
                    else
                        v2227 = Enum.UserInputType[up18.aimKey.name]
                        capturedValues1.value23 = {["kind"] = "mouse", ["input"] = v2227}
                    end
                    if up132 then
                        up132()
                    end
                    return
                end
                pcall(v1234)
            end
            return
        end
    end
    capturedValues1.value124 = v2298
    v2290 = function(arg109_1)
        local v1246, v1250, v1252
        local up25 = arg109_1
        if (not capturedValues1.value123) then
            capturedValues1.value39("Config", "No filesystem access", 3)
            v1246 = false
            return v1246
        else
            v1252 = (up25 == nil) or (up25 == "")
            if v1252 then
                capturedValues1.value39("Config", "Enter a name", 3)
                v1246 = false
                return v1246
            else
                v1250 = function()
                    local v1442 = writefile
                    local v1452 = (capturedValues1.value122 .. ("/" .. (up25 .. ".json")))
                    local v1443 = capturedValues1.value6
                    local v1444 = {up232()}
                    v1442(v1452, v1443:JSONEncode(unpackValues(v1444)))

                    return
                end
                v1250 = (pcall(v1250))
                if v1250 then
                    capturedValues1.value39("Config", ("Saved: " .. up25), 3)
                else
                    capturedValues1.value39("Config", "Save failed", 3)
                end
                return v1250
            end
        end
    end
    v2298 = function(arg110_1, arg110_2)
        local v1256, v1261, v1262
        local v1255 = arg110_2
        local v1257 = (not capturedValues1.value123)
        local v1258 = arg110_1
        if v1257 then
            return
        else
            v1256, v1261 = pcall(readfile, v1258)
            v1257 = (not v1256)
            local up26 = v1261
            if v1257 then
                capturedValues1.value39("Config", "Read failed", 3)

                return
            else
                v1262 = function()
                    return capturedValues1.value6:JSONDecode(up26)
                end
                v1256, v1261 = pcall(v1262)
                if (not v1256) then
                    capturedValues1.value39("Config", "Bad config", 3)

                    return
                else
                    capturedValues1.value124(v1261)
                    capturedValues1.value39("Config", ("Loaded: " .. v1255 or "config"), 3)

                    return
                end
            end
        end
    end
    capturedValues1.value125 = v2290
    capturedValues1.value126 = v2298
    v2298 = v2280("Player")
    v2274(v2298, "Noclip", function(arg111_1)
        capturedValues1.value19.Noclip = arg111_1
        return
    end, false)
    v2274(v2298, "Fly", function(arg112_1)
        capturedValues1.value19.Fly = arg112_1
        if arg112_1 then
            capturedValues1.value112()
        else
            capturedValues1.value111()
        end
        return
    end, false)
    v2274(v2298, "God Mode", function(arg113_1)
        local v1286
        capturedValues1.value19.GodMode = arg113_1
        local v1282 = capturedValues1.value32
        local v1284 = {capturedValues1.value31(capturedValues1.value9)}
        local up27 = (v1282(unpackValues(v1284)))
        if arg113_1 then
            if up27 then
                capturedValues1.value107 = up27.Health
            end
        else
            v1286 = up27 and capturedValues1.value107
            if v1286 then
                pcall(function()
                    up27.Health = math.clamp(capturedValues1.value107, 0, up27.MaxHealth)

                    return
                end)
            end
            capturedValues1.value107 = nil
        end
        return
    end, false)
    v2278(v2298, "Walkspeed", 16, 200, 16, function(arg114_1)
        capturedValues1.value16.WalkSpeed = arg114_1
        capturedValues1.value19.WalkSpeedOn = true
        return
    end)
    v2298 = v2280("Config")
    v2278 = Instance.new("Frame")
    v2282 = UDim2.new(1, 0, 0, 38)
    v2278.Size = v2282
    v2289 = capturedValues1.value13.Element
    v2278.BackgroundColor3 = v2289
    v2278.BorderSizePixel = 0
    v2278.Parent = v2298
    capturedValues1.value27(v2278, 8)
    capturedValues1.value28(v2278, capturedValues1.value13.Stroke, 1, 0)
    v2289 = Instance.new("TextBox")
    capturedValues1.value127 = v2289
    v2289 = capturedValues1.value127
    v2290 = UDim2.new(1, -92, 1, -8)
    v2289.Size = v2290
    v2289 = capturedValues1.value127
    v2290 = UDim2.new(0, 6, 0, 4)
    v2289.Position = v2290
    v2289 = capturedValues1.value127
    v2282 = capturedValues1.value13.Secondary
    v2289.BackgroundColor3 = v2282
    v2289 = capturedValues1.value127
    v2289.Text = ""
    v2289 = capturedValues1.value127
    v2289.PlaceholderText = "Config name"
    v2289 = capturedValues1.value127
    v2282 = capturedValues1.value13.TextDark
    v2289.PlaceholderColor3 = v2282
    v2289 = capturedValues1.value127
    v2282 = Enum.Font.GothamMedium
    v2289.Font = v2282
    v2289 = capturedValues1.value127
    v2289.TextSize = 13
    v2289 = capturedValues1.value127
    v2282 = capturedValues1.value13.Text
    v2289.TextColor3 = v2282
    v2289 = capturedValues1.value127
    v2282 = Enum.TextXAlignment.Left
    v2289.TextXAlignment = v2282
    v2289 = capturedValues1.value127
    v2289.ClearTextOnFocus = false
    v2289 = capturedValues1.value127
    v2289.Parent = v2278
    capturedValues1.value27(capturedValues1.value127, 6)
    capturedValues1.value28(capturedValues1.value127, capturedValues1.value13.Stroke, 1, 0)
    v2282 = Instance.new("UIPadding")
    v2290 = UDim.new(0, 8)
    v2282.PaddingLeft = v2290
    v2282.Parent = capturedValues1.value127
    v2282 = Instance.new("TextButton")
    v2289 = UDim2.new(0, 76, 1, -8)
    v2282.Size = v2289
    v2289 = UDim2.new(1, -82, 0, 4)
    v2282.Position = v2289
    v2290 = capturedValues1.value13.Accent
    v2282.BackgroundColor3 = v2290
    v2282.AutoButtonColor = false
    v2282.Text = "Save"
    v2290 = Enum.Font.GothamBold
    v2282.Font = v2290
    v2282.TextSize = 13
    v2290 = capturedValues1.value13.White
    v2282.TextColor3 = v2290
    v2282.Parent = v2278
    capturedValues1.value27(v2282, 6)
    v2290 = Instance.new("Frame")
    v2289 = UDim2.new(1, 0, 0, 150)
    v2290.Size = v2289
    v2289 = capturedValues1.value13.Secondary
    v2290.BackgroundColor3 = v2289
    v2290.BorderSizePixel = 0
    v2290.Parent = v2298
    capturedValues1.value27(v2290, 8)
    capturedValues1.value28(v2290, capturedValues1.value13.Stroke, 1, 0)
    v2289 = Instance.new("ScrollingFrame")
    capturedValues1.value128 = v2289
    v2289 = capturedValues1.value128
    v2293 = UDim2.new(1, -12, 1, -12)
    v2289.Size = v2293
    v2289 = capturedValues1.value128
    v2293 = UDim2.new(0, 6, 0, 6)
    v2289.Position = v2293
    v2289 = capturedValues1.value128
    v2289.BackgroundTransparency = 1
    v2289 = capturedValues1.value128
    v2289.BorderSizePixel = 0
    v2289 = capturedValues1.value128
    v2289.ScrollBarThickness = 4
    v2289 = capturedValues1.value128
    v2293 = capturedValues1.value13.Stroke
    v2289.ScrollBarImageColor3 = v2293
    v2289 = capturedValues1.value128
    v2293 = UDim2.new(0, 0, 0, 0)
    v2289.CanvasSize = v2293
    v2289 = capturedValues1.value128
    v2293 = Enum.AutomaticSize.Y
    v2289.AutomaticCanvasSize = v2293
    v2289 = capturedValues1.value128
    v2289.Parent = v2290
    v2289 = Instance.new("UIListLayout")
    v2293 = UDim.new(0, 4)
    v2289.Padding = v2293
    v2293 = Enum.SortOrder.LayoutOrder
    v2289.SortOrder = v2293
    v2289.Parent = capturedValues1.value128
    capturedValues1.value129 = nil
    capturedValues1.value130 = nil
    capturedValues1.value131 = nil
    v2289 = function()
        local v1294, v1297, v1298, v1299, v1300, v1301, v1303, v1304, v1305, v1306, v1307, v1309, v1310, v1311
        v1294, v1298, v1299 = ipairs(capturedValues1.value128:GetChildren())
        local v1296 = v1294
        while true do
            v1299, v1297 = v1296(v1298, v1299)
            if not v1299 then
                break
            end
            v1305 = (v1297:IsA("TextButton")) or (v1297:IsA("TextLabel"))
            if v1305 then
                v1297:Destroy()
            end
        end
        capturedValues1.value129 = nil
        capturedValues1.value130 = nil
        capturedValues1.value131 = nil
        if (not capturedValues1.value123) then
            v1306 = Instance.new("TextLabel")
            v1305 = UDim2.new(1, 0, 0, 30)
            v1306.Size = v1305
            v1306.BackgroundTransparency = 1
            v1306.Text = "No filesystem access"
            v1297 = Enum.Font .Gotham
            v1306.Font = v1297
            v1306.TextSize = 12
            v1297 = capturedValues1.value13.TextDark
            v1306.TextColor3 = v1297
            v1297 = capturedValues1.value128
            v1306.Parent = v1297
            return
        else
            v1296 = pcall
            v1305 = listfiles
            v1304 = capturedValues1.value122
            v1303 = {v1296(v1305, v1304)}
            v1297 = v1303[2]
            if (not v1303[1]) then
                return
            else
                for v1303, v1300 in ipairs(v1297) do
                    local up28 = v1300
                    v1307 = string.sub(up28, -5)
                    if (v1307 == ".json") then
                        v1301 = (string.match(up28, "[^/\\]+$")) or up28
                        v1307 = string.gsub(v1301, "%.json$", "")
                        local up29 = v1307
                        v1311 = Instance.new("TextButton")
                        local up30 = v1311
                        v1311 = up30
                        v1310 = UDim2.new(1, 0, 0, 28)
                        v1311.Size = v1310
                        v1311 = up30
                        v1309 = capturedValues1.value13.Element
                        v1311.BackgroundColor3 = v1309
                        v1311 = up30
                        v1311.AutoButtonColor = false
                        v1311 = up30
                        v1311.Text = ("  " .. up29)
                        v1311 = up30
                        v1309 = Enum.Font.GothamMedium
                        v1311.Font = v1309
                        v1311 = up30
                        v1311.TextSize = 12
                        v1311 = up30
                        v1309 = capturedValues1.value13.Text
                        v1311.TextColor3 = v1309
                        v1311 = up30
                        v1309 = Enum.TextXAlignment.Left
                        v1311.TextXAlignment = v1309
                        v1311 = up30
                        v1311.Parent = capturedValues1.value128
                        capturedValues1.value27(up30, 5)
                        v1311 = up30.MouseButton1Click
                        v1309 = function()
                            local v2097, v2098
                            if capturedValues1.value131 then
                                v2097 = capturedValues1.value131
                                v2098 = capturedValues1.value13.Element
                                v2097.BackgroundColor3 = v2098
                            end
                            capturedValues1.value131 = up30
                            capturedValues1.value129 = up28
                            capturedValues1.value130 = up29
                            up30.BackgroundColor3 = capturedValues1.value13.Accent
                            return
                        end
                        v1311:Connect(v1309)
                    end
                    v1300 = nil
                end
                return
            end
        end
    end
    capturedValues1.value132 = v2289
    v2293 = Instance.new("Frame")
    capturedValues1.value133 = v2293
    v2293 = capturedValues1.value133
    v2289 = UDim2.new(1, 0, 0, 34)
    v2293.Size = v2289
    v2293 = capturedValues1.value133
    v2293.BackgroundTransparency = 1
    v2293 = capturedValues1.value133
    v2293.Parent = v2298
    v2293 = Instance.new("UIListLayout")
    v2289 = Enum.FillDirection.Horizontal
    v2293.FillDirection = v2289
    v2289 = UDim.new(0, 6)
    v2293.Padding = v2289
    v2289 = Enum.SortOrder.LayoutOrder
    v2293.SortOrder = v2289
    v2293.Parent = capturedValues1.value133
    v2293 = function(arg116_1, arg116_2)
        local v1317 = Instance.new("TextButton")
        local up31 = v1317
        up31.Size = UDim2.new(.3333, -4, 1, 0)
        up31.BackgroundColor3 = capturedValues1.value13.Element
        up31.AutoButtonColor = false
        up31.Text = arg116_1
        up31.Font = Enum.Font.GothamBold
        up31.TextSize = 13
        up31.TextColor3 = capturedValues1.value13.Accent
        up31.Parent = capturedValues1.value133
        capturedValues1.value27(up31, 6)
        capturedValues1.value28(up31, capturedValues1.value13.Stroke, 1, 0)
        up31.MouseButton1Click:Connect(arg116_2)
        local v1322 = up31.MouseEnter
        local v1318 = function()
            local v729 = capturedValues1.value26
            local v730 = up31
            local v731 = capturedValues1.value13.ElementHover
            v729(v730, .15, {["BackgroundColor3"] = v731})

            return
        end
        v1322:Connect(v1318)
        up31.MouseLeave:Connect(function()
            local v740 = capturedValues1.value26
            local v741 = up31
            local v742 = capturedValues1.value13.Element
            v740(v741, .15, {["BackgroundColor3"] = v742})

            return
        end)

        return up31
    end
    v2293("Load", function()
        if capturedValues1.value129 then
            capturedValues1.value126(capturedValues1.value129, capturedValues1.value130)
        else
            capturedValues1.value39("Config", "Select a config", 3)
        end
        return
    end)
    v2293("Refresh", function()
        capturedValues1.value132()
        return
    end)
    v2293("Rewrite", function()
        local v1337
        if capturedValues1.value130 then
            v1337 = capturedValues1.value130
            capturedValues1.value125(v1337)
            capturedValues1.value132()
        else
            capturedValues1.value39("Config", "Select a config", 3)
        end
        return
    end)
    v2293 = function()
        local v1343
        local v1350 = capturedValues1.value125(capturedValues1.value127.Text)
        if v1350 then
            v1343 = capturedValues1.value127
            v1343.Text = ""
            capturedValues1.value132()
        end
        return
    end
    v2282.MouseButton1Click :Connect(v2293)
    table.insert(capturedValues1.value47, {["inst"] = v2278, ["name"] = "Save Config", ["page"] = v2298})
    table.insert(capturedValues1.value47, {["inst"] = v2290, ["name"] = "Configs", ["page"] = v2298})
    v2289 = table.insert
    v2293 = capturedValues1.value47
    v2278 = capturedValues1.value133
    v2289(v2293, {["inst"] = v2278, ["name"] = "Load Refresh Rewrite", ["page"] = v2298})
    capturedValues1.value132()
    v2289 = v2280("Settings")
    v2274(v2289, "Watermark", function(arg121_1)
        local v1351 = capturedValues1.value19
        local v1352 = arg121_1
        v1351.WatermarkOn = v1352
        if capturedValues1.value100 then
            v1351 = capturedValues1.value100
            v1351.Visible = v1352
        end
        return
    end, false)
    v2293 = Instance.new("TextButton")
    capturedValues1.value134 = v2293
    v2293 = capturedValues1.value134
    v2278 = UDim2.new(1, 0, 0, 40)
    v2293.Size = v2278
    v2293 = capturedValues1.value134
    v2274 = capturedValues1.value13.Accent
    v2293.BackgroundColor3 = v2274
    v2293 = capturedValues1.value134
    v2293.BackgroundTransparency = .15
    v2293 = capturedValues1.value134
    v2293.AutoButtonColor = false
    v2293 = capturedValues1.value134
    v2293.Text = "Unload"
    v2293 = capturedValues1.value134
    v2274 = Enum.Font.GothamBold
    v2293.Font = v2274
    v2293 = capturedValues1.value134
    v2293.TextSize = 14
    v2293 = capturedValues1.value134
    v2274 = capturedValues1.value13.White
    v2293.TextColor3 = v2274
    v2293 = capturedValues1.value134
    v2293.Parent = v2289
    capturedValues1.value27(capturedValues1.value134, 10)
    capturedValues1.value28(capturedValues1.value134, capturedValues1.value13.Accent, 1, .2)
    v2293 = capturedValues1.value134.MouseButton1Click
    v2274 = function()
        up216()
        return
    end
    v2293:Connect(v2274)
    v2293 = capturedValues1.value134.MouseEnter
    v2274 = function()
        capturedValues1.value26(capturedValues1.value134, .15, {["BackgroundTransparency"] = 0})

        return
    end
    v2293:Connect(v2274)
    capturedValues1.value134.MouseLeave:Connect(function()
        capturedValues1.value26(capturedValues1.value134, .15, {["BackgroundTransparency"] = .15})

        return
    end)
    v2293 = table.insert
    v2274 = capturedValues1.value47
    v2280 = capturedValues1.value134
    v2293(v2274, {["inst"] = v2280, ["name"] = "Unload", ["page"] = v2289})
    v2274 = function(arg125_1)
        local v1377, v1378, v1379, v1381, v1382, v1384, v1385, v1386, v1387, v1388, v1389, v1390, v1391
        local v1380 = string.lower
        local v1375 = arg125_1
        if not (arg125_1) then
            v1375 = ""
        end
        local v1383 = (v1380(v1375))
        v1375 = {}
        v1377, v1378, v1379 = pairs(capturedValues1.value49)
        while true do
            v1379 = v1377(v1378, v1379)
            if not v1379 then
                break
            end
            v1381 = v1379
            v1388 = (v1383 ~= "")
            v1382 = v1388
            if v1388 then
                v1387 = string.find
                v1386 = string.lower(v1381)
                v1382 = ((v1387(v1386, v1383, 1, true)) ~= nil)
            end
            v1375[v1381] = v1382
        end
        for v1379, v1382 in ipairs(capturedValues1.value47) do
            v1388 = (v1383 == "") or ((string.find((string.lower(v1382.name)), v1383, 1, true)) ~= nil)
            v1387 = false
            for v1386, v1390 in pairs(capturedValues1.value48) do
                v1389 = v1386
                v1391 = (v1390 == v1382.page) and v1375[v1389]
                if v1391 then
                    v1387 = true
                else
                    continue
                end
                break
            end
            v1384 = v1382.inst
            v1386 = (v1388 or v1387)
            v1384.Visible = v1386
        end
        v1378, v1379, v1381 = pairs(capturedValues1.value49)
        while true do
            v1381, v1382 = v1378(v1379, v1381)
            if not v1381 then
                break
            end
            v1377 = v1381
            v1388 = capturedValues1.value48[v1377]
            v1387 = false
            for v1389, v1390 in ipairs(capturedValues1.value47) do
                v1391 = (v1390.page == v1388) and v1390.inst.Visible
                if v1391 then
                    v1387 = true
                else
                    continue
                end
                break
            end
            v1385 = (v1383 == "") or (v1375[v1377] or v1387)
            v1382.Visible = v1385
        end
        v1379 = (v1383 ~= "")
        v1377 = v1379
        if v1379 then
            v1377 = capturedValues1.value51 and capturedValues1.value49[capturedValues1.value51] and (not capturedValues1.value49[capturedValues1.value51].Visible)
        end
        if v1377 then
            for v1381, v1382 in pairs(capturedValues1.value49) do
                v1377 = v1381
                if v1382["Visible"] then
                    capturedValues1.value52(v1377)
                else
                    continue
                end
                break
            end
        end
        return
    end
    capturedValues1.value135 = v2274
    v2274 = capturedValues1.value45:GetPropertyChangedSignal("Text")
    v2278 = function()
        capturedValues1.value135(capturedValues1.value45.Text)

        return
    end
    v2274:Connect(v2278)
    local up246 = function(arg127_1)
        local v1418
        local v1407 = capturedValues1.value23
        local v1408 = arg127_1
        local v1413 = v1407.kind
        if (v1413 == "key") then
            v1413 = (v1408.UserInputType == Enum.UserInputType.Keyboard) and (v1408.KeyCode == capturedValues1.value23.code)
            return v1413
        else
            v1418 = (v1408.UserInputType == capturedValues1.value23.input)

            return v1418
        end
    end
    capturedValues1.value136 = true
    v2274 = capturedValues1.value2.InputBegan
    v2280 = function(arg128_1, arg128_2)
        local v1423, v1424, v1425, v1427, v1430, v1431
        local v1419 = capturedValues1.value24
        local v1420 = arg128_2
        local v1421 = arg128_1
        if v1419 then
            v1431 = (v1421.UserInputType == Enum.UserInputType.Keyboard) and (v1421.KeyCode ~= Enum.KeyCode.Unknown)
            if v1431 then
                v1425 = v1421.KeyCode
                up132()
                return
            else
                v1430 = (v1421.UserInputType == Enum.UserInputType.MouseButton1) or (v1421.UserInputType == Enum.UserInputType.MouseButton2) or (v1421.UserInputType == Enum.UserInputType.MouseButton3)
                if v1430 then
                    v1423 = v1421.UserInputType
                    up132()
                    return
                end
            end
        end
        local v1422 = up246(v1421)
        if v1422 then
            v1425 = capturedValues1.value19
            v1425.AimHolding = true
        end
        if v1420 then
            return
        else
            v1422 = v1421.KeyCode
            v1424 = Enum.KeyCode
            if (v1422 == v1424["RightShift"]) then
                capturedValues1.value136 = (not capturedValues1.value136)
                v1422 = capturedValues1.value40
                v1424 = capturedValues1.value136
                v1422.Visible = v1424
            else
                v1423 = v1421.KeyCode
                v1427 = Enum.KeyCode
                if (v1423 == v1427["End"]) then
                    up216()
                end
            end
            return
        end
    end
    capturedValues1.value105 = (v2274:Connect(v2280))
    v2274 = capturedValues1.value2.InputEnded
    v2280 = function(arg129_1)
        local v1436
        local v1437 = up246(arg129_1)
        if v1437 then
            v1436 = capturedValues1.value19
            v1436.AimHolding = false
        end
        return
    end
    v2274:Connect(v2280)
    capturedValues1.value52("Visuals")
    v2274 = capturedValues1.value40
    v2274.BackgroundTransparency = 1
    v2274 = capturedValues1.value40
    v2280 = UDim2.new (0, v2259, 0, 0)
    v2274.Size = v2280
    v2274 = capturedValues1.value26
    v2280 = capturedValues1.value40
    v2259 = UDim2.new(0, v2259, 0, 400)
    v2274(v2280, .35, {["BackgroundTransparency"] = 0, ["Size"] = v2259})
    capturedValues1.value39("Claudeware", "Loaded | RightShift menu | End unload", 4)

    return
end
