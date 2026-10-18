local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer

local IsFarming = false
local FarmingThread = nil
local TimerThread = nil
local CoinsCollected = 0
local StartTime = os.time()

local function GetParts()
    local Char = Player.Character
    if Char then
        local Root = Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char:FindFirstChild("Humanoid")

        if Root and Hum then
            return Root, Hum
        end
    end

    return nil, nil
end

local function GetMap()
    while true do
        for _, Obj in ipairs(workspace:GetChildren()) do
            if Obj:GetAttribute("MapID")
                and Obj:FindFirstChild("CoinContainer") then
                return Obj
            end
        end

        task.wait()
    end
end

local function GetNearest(Root)
    if not Root then
        return nil
    end

    local Map = GetMap()
    local Closest, Dist = nil, math.huge

    for _, Coin in ipairs(Map.CoinContainer:GetChildren()) do
        local Visual = Coin:FindFirstChild("CoinVisual")

        if Visual and not Visual:GetAttribute("Collected") then
            local D = (Root.Position - Coin.Position).Magnitude

            if D < Dist then
                Closest = Coin
                Dist = D
            end
        end
    end

    return Closest
end

local function MoveTo(Root, Hum, Target)
    if not Root or not Hum then
        return
    end

    Hum:ChangeState(11)

    local D = (Root.Position - Target.Position).Magnitude

    local Tween = TweenService:Create(
        Root,
        TweenInfo.new(D / 25, Enum.EasingStyle.Linear),
        {
            CFrame = Target.CFrame
        }
    )

    Tween:Play()
    Tween.Completed:Wait()
end

local function StartFarming()
    if FarmingThread then
        return
    end

    CoinsCollected = 0
    StartTime = os.time()

    TimerThread = task.spawn(function()
        while IsFarming do
            local Elapsed = os.time() - StartTime
            task.wait(1)
        end
    end)

    FarmingThread = task.spawn(function()
        while IsFarming do
            local Success, Err = pcall(function()
                while IsFarming do
                    local Root, Hum = GetParts()

                    if not Root
                        or not Hum
                        or not Player:GetAttribute("Alive") then

                        task.wait(0.5)
                        continue
                    end

                    local Target = GetNearest(Root)

                    if Target then
                        MoveTo(Root, Hum, Target)

                        local Visual = Target:FindFirstChild("CoinVisual")
                        local CollectedByUs = false

                        if Visual and not Visual:GetAttribute("Collected") then
                            while Visual
                                and not Visual:GetAttribute("Collected")
                                and Visual.Parent
                                and IsFarming do

                                if not Player:GetAttribute("Alive")
                                    or not GetParts() then
                                    break
                                end

                                local Next = GetNearest(Root)

                                if Next and Next ~= Target then
                                    break
                                end

                                task.wait()
                            end

                            if not Visual
                                or not Visual.Parent
                                or Visual:GetAttribute("Collected") then

                                CollectedByUs = true
                            end
                        end

                        if CollectedByUs then
                            CoinsCollected = CoinsCollected + 1
                        end

                        local Elapsed = os.time() - StartTime

                        if Elapsed > 0 then
                            local Cph = math.floor(
                                (CoinsCollected / Elapsed) * 3600
                            )
                        end
                    else
                        task.wait(0.5)
                    end
                end
            end)

            if not IsFarming then
                break
            end

            if Err then
                warn("Farming error: " .. tostring(Err))
                task.wait(1)
            end
        end
    end)
end

local function StopFarming()
    IsFarming = false

    if FarmingThread then
        FarmingThread = nil
    end

    if TimerThread then
        TimerThread = nil
    end
end

--==================================================
-- HALLOWEEN MM2 GUI
--==================================================

local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HalloweenCoinFarm"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Main frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 235, 0, 82)
Main.Position = UDim2.new(0.5, -117, 0, 10)
Main.BackgroundColor3 = Color3.fromRGB(18, 13, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 98, 0)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

-- Orange top line
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 3)
TopLine.Position = UDim2.new(0, 0, 0, 0)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 98, 0)
TopLine.BorderSizePixel = 0
TopLine.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -55, 0, 30)
Title.Position = UDim2.new(0, 12, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "👻  MM2 COIN FARM"
Title.TextColor3 = Color3.fromRGB(255, 120, 20)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Small subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -55, 0, 18)
Subtitle.Position = UDim2.new(0, 13, 0, 29)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "🕸️ Halloween Murder Mystery 🔪"
Subtitle.TextColor3 = Color3.fromRGB(150, 135, 160)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

-- Toggle
local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Size = UDim2.new(0, 195, 0, 27)
Toggle.Position = UDim2.new(0, 12, 0, 48)
Toggle.BackgroundColor3 = Color3.fromRGB(45, 35, 52)
Toggle.BorderSizePixel = 0
Toggle.Text = "🎃  Farming: OFF"
Toggle.TextColor3 = Color3.fromRGB(220, 210, 225)
Toggle.TextSize = 12
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = false
Toggle.Parent = Main

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 7)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(85, 65, 95)
ToggleStroke.Thickness = 1
ToggleStroke.Parent = Toggle

-- Expand button
local ExpandButton = Instance.new("TextButton")
ExpandButton.Name = "ExpandButton"
ExpandButton.Size = UDim2.new(0, 32, 0, 32)
ExpandButton.Position = UDim2.new(1, -38, 0, 6)
ExpandButton.BackgroundColor3 = Color3.fromRGB(35, 25, 42)
ExpandButton.BorderSizePixel = 0
ExpandButton.Text = "−"
ExpandButton.TextColor3 = Color3.fromRGB(255, 120, 20)
ExpandButton.TextSize = 20
ExpandButton.Font = Enum.Font.GothamBold
ExpandButton.AutoButtonColor = false
ExpandButton.Parent = Main

local ExpandCorner = Instance.new("UICorner")
ExpandCorner.CornerRadius = UDim.new(0, 7)
ExpandCorner.Parent = ExpandButton

--==================================================
-- TOGGLE FARMING
--==================================================

Toggle.MouseButton1Click:Connect(function()
    IsFarming = not IsFarming

    if IsFarming then
        Toggle.Text = "🎃  Farming: ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(105, 48, 12)
        ToggleStroke.Color = Color3.fromRGB(255, 98, 0)

        StartFarming()
    else
        Toggle.Text = "🎃  Farming: OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(45, 35, 52)
        ToggleStroke.Color = Color3.fromRGB(85, 65, 95)

        StopFarming()
    end
end)

--==================================================
-- EXPAND / COLLAPSE
--==================================================

local Expanded = true

ExpandButton.MouseButton1Click:Connect(function()
    Expanded = not Expanded

    if Expanded then
        Main.Size = UDim2.new(0, 235, 0, 82)

        Title.Visible = true
        Subtitle.Visible = true
        Toggle.Visible = true

        ExpandButton.Text = "−"
    else
        Main.Size = UDim2.new(0, 45, 0, 38)

        Title.Visible = false
        Subtitle.Visible = false
        Toggle.Visible = false

        ExpandButton.Text = "+"
    end
end)

--==================================================
-- DRAGGING
--==================================================

local Dragging = false
local DragStart
local StartPosition

Main.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        if Input.Target == Toggle
            or Input.Target == ExpandButton then
            return
        end

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging
        and (
            Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch
        ) then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

-- Start OFF
IsFarming = false