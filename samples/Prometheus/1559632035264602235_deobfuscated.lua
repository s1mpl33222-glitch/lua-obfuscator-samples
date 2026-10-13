-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("UserInputService"),
	value2 = game:GetService("TweenService"),
	value3 = game:GetService("Players")
}
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

t1.value4 = t1.value3.LocalPlayer
t1.value5 = workspace.CurrentCamera
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FireHub_Custom_Updated"
ScreenGui.Parent = gethui and gethui() or CoreGui
ScreenGui.ResetOnSpawn = false
local color3 = Color3.fromRGB(10, 10, 12)
local color3_2 = Color3.fromRGB(18, 18, 20)
local color3_3 = Color3.fromRGB(255, 80, 0)
local color3_4 = Color3.fromRGB(255, 255, 255)
local color3_5 = Color3.fromRGB(140, 140, 150)
local color3_6 = Color3.fromRGB(40, 40, 45)
local color3_7 = Color3.fromRGB(255, 0, 0)
local color3_8 = Color3.fromRGB(255, 120, 0)

t1.value6 = {
	Main = color3,
	Panel = color3_2,
	Accent = color3_3,
	Text = color3_4,
	Dim = color3_5,
	Stroke = color3_6,
	Red = color3_7,
	Orange = color3_8
}
t1.value7 = {
	PCAimbot = false,
	MobileAimbot = false,
	Smoothness = 0.5,
	TargetPart = "Head",
	ESP_Box = false,
	ESP_Health = false,
	ESP_Line = false
}
t1.value8 = {}
local function v13(p1)
    local u33
    local inputPosition
    local p1Position
    p1.InputBegan:Connect(function(input)
        local v108 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v108 then
            v108 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v108 then
            u33 = true
            inputPosition = input.Position
            p1Position = p1.Position
        end
    end)
    p1.InputChanged:Connect(function(input)
        local v110 = input.UserInputType == Enum.UserInputType.MouseMovement

        if not v110 then
            v110 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v110 and u33 then
            local v111 = input.Position - inputPosition

            p1.Position = UDim2.new(p1Position.X.Scale, p1Position.X.Offset + v111.X, p1Position.Y.Scale, p1Position.Y.Offset + v111.Y)
        end
    end)
    p1.InputEnded:Connect(function(input)
        local v113 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v113 then
            v113 = input.UserInputType == Enum.UserInputType.Touch
        end

        if not v113 then
        end
    end)
end
t1.value9 = Instance.new("Frame", ScreenGui)
t1.value9.Name = "Window"
t1.value9.Size = UDim2.new(0, 300, 0, 360)
t1.value9.Position = UDim2.new(0.5, -150, 0.5, -180)
t1.value9.BackgroundColor3 = t1.value6.Main
t1.value9.ClipsDescendants = true
Instance.new("UICorner", t1.value9).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", t1.value9).Color = t1.value6.Stroke
local Frame = Instance.new("Frame", t1.value9)

Frame.Size = UDim2.new(1, 0, 0, 38)
Frame.BackgroundTransparency = 1
local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Text = "🔥 FIRE <font color='#FF5000'>HUB</font>"
TextLabel.RichText = true
TextLabel.Size = UDim2.new(1, -45, 1, 0)
TextLabel.Position = UDim2.new(0, 12, 0, 0)
TextLabel.TextColor3 = t1.value6.Text
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 15
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.BackgroundTransparency = 1
local TextButton = Instance.new("TextButton", Frame)

TextButton.Size = UDim2.new(0, 26, 0, 26)
TextButton.Position = UDim2.new(1, -34, 0.5, -13)
TextButton.BackgroundColor3 = t1.value6.Panel
TextButton.Text = "–"
TextButton.TextColor3 = t1.value6.Accent
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 16
TextButton.AutoButtonColor = false
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)

local Frame2 = Instance.new("Frame", t1.value9)

Frame2.Size = UDim2.new(1, -24, 0, 1)
Frame2.Position = UDim2.new(0, 12, 0, 38)
Frame2.BackgroundColor3 = t1.value6.Stroke
Frame2.BorderSizePixel = 0
local Frame3 = Instance.new("Frame", t1.value9)

Frame3.Size = UDim2.new(1, -24, 0, 36)
Frame3.Position = UDim2.new(0, 12, 0, 44)
Frame3.BackgroundColor3 = t1.value6.Panel
Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", Frame3).Color = t1.value6.Stroke
t1.value10 = Instance.new("ImageLabel", Frame3)
t1.value10.Size = UDim2.new(0, 26, 0, 26)
t1.value10.Position = UDim2.new(0, 6, 0.5, -13)
t1.value10.BackgroundTransparency = 1
pcall(function()
    t1.value10.Image = t1.value3:GetUserThumbnailAsync(t1.value4.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
Instance.new("UICorner", t1.value10).CornerRadius = UDim.new(1, 0)

local TextLabel2 = Instance.new("TextLabel", Frame3)

TextLabel2.Text = t1.value4.DisplayName
TextLabel2.Size = UDim2.new(1, -42, 0.55, 0)
TextLabel2.Position = UDim2.new(0, 38, 0, 4)
TextLabel2.TextColor3 = t1.value6.Text
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextSize = 12
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.BackgroundTransparency = 1
TextLabel2.ClipsDescendants = true
local TextLabel3 = Instance.new("TextLabel", Frame3)

TextLabel3.Text = "@" .. t1.value4.Name
TextLabel3.Size = UDim2.new(1, -42, 0.45, 0)
TextLabel3.Position = UDim2.new(0, 38, 0.55, 0)
TextLabel3.TextColor3 = t1.value6.Dim
TextLabel3.Font = Enum.Font.GothamMedium
TextLabel3.TextSize = 10
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.BackgroundTransparency = 1
t1.value11 = Instance.new("Frame", t1.value9)
t1.value11.Size = UDim2.new(1, -24, 0, 28)
t1.value11.Position = UDim2.new(0, 12, 0, 86)
t1.value11.BackgroundTransparency = 1
local UIListLayout = Instance.new("UIListLayout", t1.value11)

UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.Padding = UDim.new(0, 6)
t1.value12 = Instance.new("Frame", t1.value9)
t1.value12.Size = UDim2.new(1, -24, 1, -140)
t1.value12.Position = UDim2.new(0, 12, 0, 120)

local function v22(p2, p3)
    local TextLabel4 = Instance.new("TextLabel", p2)

    TextLabel4.Text = p3
    TextLabel4.Size = UDim2.new(1, 0, 0, 22)
    TextLabel4.TextColor3 = t1.value6.Dim
    TextLabel4.Font = Enum.Font.GothamMedium
    TextLabel4.TextSize = 10
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.RichText = true

    return TextLabel4
end
t1.value12.BackgroundTransparency = 1
local function v23(p4, p5, p6)
    local Frame4 = Instance.new("Frame", p4)

    Frame4.Size = UDim2.new(1, 0, 0, 38)
    Frame4.BackgroundColor3 = t1.value6.Panel
    Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 7)
    Instance.new("UIStroke", Frame4).Color = t1.value6.Stroke

    local TextLabel5 = Instance.new("TextLabel", Frame4)

    TextLabel5.Text = p5
    TextLabel5.Size = UDim2.new(1, -55, 1, 0)
    TextLabel5.Position = UDim2.new(0, 12, 0, 0)
    TextLabel5.TextColor3 = t1.value6.Text
    TextLabel5.Font = Enum.Font.GothamMedium
    TextLabel5.TextSize = 12
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.BackgroundTransparency = 1

    local TextButton2 = Instance.new("TextButton", Frame4)

    TextButton2.Size = UDim2.new(0, 32, 0, 16)
    TextButton2.Position = UDim2.new(1, -42, 0.5, -8)
    TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TextButton2.Text = ""
    TextButton2.AutoButtonColor = false
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

    local Frame5 = Instance.new("Frame", TextButton2)

    Frame5.Size = UDim2.new(0, 10, 0, 10)
    Frame5.Position = UDim2.new(0, 3, 0.5, -5)
    Frame5.BackgroundColor3 = t1.value6.Dim
    Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

    local u46 = false

    TextButton2.MouseButton1Click:Connect(function()
        u46 = not u46

        local value2 = t1.value2
        local v115 = TextButton2
        local tweenInfo = TweenInfo.new(0.2)
        local v117 = u46

        if v117 then
            v117 = t1.value6.Accent
        end

        if not v117 then
            v117 = Color3.fromRGB(40, 40, 45)
        end

        value2:Create(v115, tweenInfo, {
			BackgroundColor3 = v117
		}):Play()

        local value2_2 = t1.value2
        local v119 = Frame5
        local tweenInfo2 = TweenInfo.new(0.2)
        local v121 = u46

        if v121 then
            v121 = UDim2.new(1, -13, 0.5, -5)
        end

        if not v121 then
            v121 = UDim2.new(0, 3, 0.5, -5)
        end

        value2_2:Create(v119, tweenInfo2, {
			Position = v121
		}):Play()

        local value2_3 = t1.value2
        local v123 = Frame5
        local tweenInfo3 = TweenInfo.new(0.2)
        local v125 = u46

        if v125 then
            v125 = t1.value6.Text
        end

        if not v125 then
            v125 = t1.value6.Dim
        end

        value2_3:Create(v123, tweenInfo3, {
			BackgroundColor3 = v125
		}):Play()

        if p6 then
            p6(u46)
        end
    end)
end
t1.value13 = {}
t1.value14 = {}
local function v24(p7)
    local ScrollingFrame = Instance.new("ScrollingFrame", t1.value12)

    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.Visible = false
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 2
    ScrollingFrame.ScrollBarImageColor3 = t1.value6.Accent
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

    UIListLayout2.Padding = UDim.new(0, 6)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

    local TextButton3 = Instance.new("TextButton", t1.value11)

    TextButton3.Size = UDim2.new(0, 82, 1, 0)
    TextButton3.BackgroundColor3 = t1.value6.Panel
    TextButton3.Text = p7
    TextButton3.TextColor3 = t1.value6.Dim
    TextButton3.Font = Enum.Font.GothamBold
    TextButton3.TextSize = 11
    TextButton3.AutoButtonColor = false
    Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
    table.insert(t1.value13, ScrollingFrame)
    table.insert(t1.value14, TextButton3)
    TextButton3.MouseButton1Click:Connect(function()

        for v128, v129 in ipairs(t1.value13) do

            v129.Visible = false
        end
        for _, v in ipairs(t1.value14) do
            v.TextColor3 = t1.value6.Dim
            t1.value2:Create(v, TweenInfo.new(0.15), {
				BackgroundColor3 = t1.value6.Panel
			}):Play()
        end
        ScrollingFrame.Visible = true
        TextButton3.TextColor3 = t1.value6.Text
        t1.value2:Create(TextButton3, TweenInfo.new(0.15), {
			BackgroundColor3 = t1.value6.Accent
		}):Play()
    end)

    return ScrollingFrame
end
local v25 = v24("Main")
local v26 = v24("Visuals")
local v27 = v24("Settings")

t1.value13[1].Visible = true
t1.value14[1].TextColor3 = t1.value6.Text
t1.value14[1].BackgroundColor3 = t1.value6.Accent
v22(v25, "  🎯  AIM ASSIST")
v23(v25, "PC Aimbot (Hold RMB)", function(p8)
    t1.value7.PCAimbot = p8
end)
v23(v25, "Mobile Aimbot (Hold Screen)", function(p9)
    t1.value7.MobileAimbot = p9
end);
(function(p10, p11, p12, p13, p14, p15)
    local Frame6 = Instance.new("Frame", p10)

    Frame6.Size = UDim2.new(1, 0, 0, 38)
    Frame6.BackgroundColor3 = t1.value6.Panel
    Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 7)
    Instance.new("UIStroke", Frame6).Color = t1.value6.Stroke

    local TextLabel6 = Instance.new("TextLabel", Frame6)

    TextLabel6.Text = p11
    TextLabel6.Size = UDim2.new(0.5, 0, 1, 0)
    TextLabel6.Position = UDim2.new(0, 12, 0, 0)
    TextLabel6.TextColor3 = t1.value6.Text
    TextLabel6.Font = Enum.Font.GothamMedium
    TextLabel6.TextSize = 12
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel6.BackgroundTransparency = 1

    local TextLabel7 = Instance.new("TextLabel", Frame6)

    TextLabel7.Text = tostring(p14)
    TextLabel7.Size = UDim2.new(0, 40, 1, 0)
    TextLabel7.Position = UDim2.new(1, -50, 0, 0)
    TextLabel7.TextColor3 = t1.value6.Accent
    TextLabel7.Font = Enum.Font.GothamBold
    TextLabel7.TextSize = 12
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel7.BackgroundTransparency = 1

    local Frame7 = Instance.new("Frame", Frame6)

    Frame7.Size = UDim2.new(1, -24, 0, 4)
    Frame7.Position = UDim2.new(0, 12, 1, -12)
    Frame7.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Frame7.BorderSizePixel = 0
    Instance.new("UICorner", Frame7).CornerRadius = UDim.new(1, 0)

    local Frame8 = Instance.new("Frame", Frame7)

    Frame8.Size = UDim2.new((p14 - p12) / (p13 - p12), 0, 1, 0)
    Frame8.BackgroundColor3 = t1.value6.Accent
    Frame8.BorderSizePixel = 0
    Instance.new("UICorner", Frame8).CornerRadius = UDim.new(1, 0)

    local TextButton4 = Instance.new("TextButton", Frame7)

    TextButton4.Size = UDim2.new(1, 0, 0, 20)
    TextButton4.Position = UDim2.new(0, 0, 0.5, -10)
    TextButton4.BackgroundTransparency = 1
    TextButton4.Text = ""
    TextButton4.AutoButtonColor = false

    local u63 = false

    TextButton4.InputBegan:Connect(function(input)
        local v133 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v133 then
            v133 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v133 then
            u63 = true
        end
    end)
    t1.value1.InputEnded:Connect(function(input)
        local v135 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v135 then
            v135 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v135 then
            u63 = false
        end
    end)
    t1.value1.InputChanged:Connect(function(input)
        local v137 = u63

        if v137 then
            v137 = input.UserInputType == Enum.UserInputType.MouseMovement

            if not v137 then
                v137 = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if v137 then
            local v138 = math.clamp((input.Position.X - Frame7.AbsolutePosition.X) / Frame7.AbsoluteSize.X, 0, 1)
            local v139 = math.floor(p12 + (p13 - p12) * v138)

            Frame8.Size = UDim2.new(v138, 0, 1, 0)
            TextLabel7.Text = tostring(v139)

            if p15 then
                p15(v139 / 100)
            end
        end
    end)
end)(v25, "Smoothness", 1, 100, 50, function(p16)
    t1.value7.Smoothness = p16
end)
t1.value15 = Instance.new("TextButton", v25)
t1.value15.Size = UDim2.new(1, 0, 0, 30)
t1.value15.BackgroundColor3 = t1.value6.Panel
t1.value15.TextColor3 = t1.value6.Accent
t1.value15.Text = "Target: Head"
t1.value15.Font = Enum.Font.GothamBold
t1.value15.TextSize = 11
Instance.new("UICorner", t1.value15).CornerRadius = UDim.new(0, 6)
t1.value15.MouseButton1Click:Connect(function()
    t1.value7.TargetPart = t1.value7.TargetPart ~= "Head" and "Head" or "HumanoidRootPart"
    t1.value15.Text = not ("Target: " .. (t1.value7.TargetPart == "Head")) and "Body" or "Head"
end)
v22(v26, "  👁\239\184\143  ESP")
v23(v26, "ESP Boxes", function(p17)
    t1.value7.ESP_Box = p17
end)
v23(v26, "ESP Health", function(p18)
    t1.value7.ESP_Health = p18
end)
v23(v26, "ESP Lines", function(p19)
    t1.value7.ESP_Line = p19
end)
v22(v27, "  ⚙\239\184\143  OPTIONS")
v23(v27, "Anti AFK", function(_)
end)
v23(v27, "Notifications", function(_)
end)
t1.value16 = Instance.new("TextButton", ScreenGui)
t1.value16.Size = UDim2.new(0, 48, 0, 48)
t1.value16.Position = UDim2.new(0.05, 0, 0.1, 0)
t1.value16.BackgroundColor3 = t1.value6.Main
t1.value16.Visible = false
t1.value16.Text = "🔥"
t1.value16.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value16.TextSize = 26
t1.value16.Font = Enum.Font.GothamBold
t1.value16.AutoButtonColor = false
Instance.new("UICorner", t1.value16).CornerRadius = UDim.new(1, 0)

local UIStroke = Instance.new("UIStroke", t1.value16)

UIStroke.Color = t1.value6.Accent
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
v13(t1.value9)
v13(t1.value16)
TextButton.MouseButton1Click:Connect(function()
    t1.value9.Visible = false
    t1.value16.Visible = true
end)
t1.value16.MouseButton1Click:Connect(function()
    t1.value9.Visible = true
    t1.value16.Visible = false
end)

function t1.value17()
    local n1 = 1e999
    local v73
    for _, player in pairs(t1.value3:GetPlayers()) do
        local v76 = player ~= t1.value4

        if v76 then
            v76 = player.Character

            if v76 then
                v76 = player.Character:FindFirstChild(t1.value7.TargetPart)
            end
        end

        if v76 then
            local v78, t2Result = t1.value5:WorldToViewportPoint(player.Character[t1.value7.TargetPart].Position)
            if t2Result then
                local Magnitude = (Vector2.new(v78.X, v78.Y) - Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2)).Magnitude

                if Magnitude < n1 then
                    v73 = player
                    n1 = Magnitude
                end
            end
        end
    end

    return v73
end
local function v29(p22)
    if p22 == t1.value4 then
        return
    end

    local drawing = Drawing.new("Square")

    drawing.Thickness = 2
    drawing.Color = t1.value6.Accent
    drawing.Filled = false
    drawing.Visible = false

    local drawing2 = Drawing.new("Line")

    drawing2.Thickness = 1.5
    drawing2.Color = t1.value6.Orange
    drawing2.Visible = false

    local drawing3 = Drawing.new("Square")

    drawing3.Thickness = 1
    drawing3.Filled = true
    drawing3.Visible = false
    t1.value8[p22] = {
		Box = drawing,
		Tracer = drawing2,
		Health = drawing3
	}
end
t1.value18 = false
t1.value1.InputBegan:Connect(function(input)
    local v88 = input.UserInputType == Enum.UserInputType.MouseButton2

    if v88 then
        v88 = t1.value7.PCAimbot
    end

    if not v88 then
        v88 = input.UserInputType == Enum.UserInputType.Touch

        if v88 then
            v88 = t1.value7.MobileAimbot
        end
    end

    if v88 then
        t1.value18 = true
    end
end)
t1.value1.InputEnded:Connect(function(input)
    local v90 = input.UserInputType == Enum.UserInputType.MouseButton2

    if not v90 then
        v90 = input.UserInputType == Enum.UserInputType.Touch
    end

    if v90 then
        t1.value18 = false
    end
end)
RunService.RenderStepped:Connect(function()
    if t1.value18 then
        local v91 = t1.value17()

        if v91 then
            local cFrame = CFrame.new(t1.value5.CFrame.Position, v91.Character[t1.value7.TargetPart].Position)

            t1.value5.CFrame = t1.value5.CFrame:Lerp(cFrame, t1.value7.Smoothness)
        end
    end

    for _, player in pairs(t1.value3:GetPlayers()) do
        local v95 = player ~= t1.value4

        if v95 then
            v95 = player.Character

            if v95 then
                v95 = player.Character:FindFirstChild("HumanoidRootPart")

                if v95 then
                    v95 = player.Character:FindFirstChild("Humanoid")

                    if v95 then
                        v95 = player.Character.Humanoid.Health > 0
                    end
                end
            end
        end

        if v95 then
            local HumanoidRootPart = player.Character.HumanoidRootPart
            local Humanoid = player.Character.Humanoid
            local v98, v99 = t1.value5:WorldToViewportPoint(HumanoidRootPart.Position)

            if v99 and t1.value8[player] then
                local v100 = player.Character:FindFirstChild("Head") or HumanoidRootPart
                local v101 = t1.value5:WorldToViewportPoint(v100.Position + Vector3.new(0, 0.5, 0))
                local v102 = t1.value5:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                local v103 = math.abs(v101.Y - v102.Y)
                local v104 = v103 * 0.6

                if t1.value7.ESP_Box then
                    t1.value8[player].Box.Size = Vector2.new(v104, v103)
                    t1.value8[player].Box.Position = Vector2.new(v98.X - v104 / 2, v98.Y - v103 / 2)
                    t1.value8[player].Box.Visible = true
                else
                    t1.value8[player].Box.Visible = false
                end

                if t1.value7.ESP_Line then
                    t1.value8[player].Tracer.From = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y)
                    t1.value8[player].Tracer.To = Vector2.new(v98.X, v98.Y)
                    t1.value8[player].Tracer.Visible = true
                else
                    t1.value8[player].Tracer.Visible = false
                end

                if t1.value7.ESP_Health then
                    local v105 = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
                    local v106 = v103 * v105

                    t1.value8[player].Health.Size = Vector2.new(2, v106)
                    t1.value8[player].Health.Position = Vector2.new(v98.X - v104 / 2 - 5, v98.Y - v103 / 2 + (v103 - v106))
                    t1.value8[player].Health.Color = Color3.fromRGB(255 - v105 * 255, v105 * 255, 0)
                    t1.value8[player].Health.Visible = true
                else
                    t1.value8[player].Health.Visible = false
                end
            elseif t1.value8[player] then
                t1.value8[player].Box.Visible = false
                t1.value8[player].Tracer.Visible = false
                t1.value8[player].Health.Visible = false
            end
        elseif t1.value8[player] then
            t1.value8[player].Box.Visible = false
            t1.value8[player].Tracer.Visible = false
            t1.value8[player].Health.Visible = false
        end
    end
end)
t1.value3.PlayerAdded:Connect(v29)
t1.value3.PlayerRemoving:Connect(function(player)
    if t1.value8[player] then
        for _, v in pairs(t1.value8[player]) do
            v:Remove()
        end

        t1.value8[player] = nil
    end
end)

for _, player in pairs(t1.value3:GetPlayers()) do
    v29(player)
end
