-- This file was generated at discord.gg/syncrypt

local t1 = {}
getgenv().HyperConfig = {
	HorizontalPrediction = 0.135,
	VerticalPrediction = 0.11,
	FOV = 150,
	FOVVisible = true,
	FOVOffset = 10,
	SilentEnabled = true,
	TriggerEnabled = true,
	TracerEnabled = true,
	AutoTarget = false,
	WallCheck = true,
	KnockedCheck = true,
	SelectedPlayers = {},
	MenuScale = 1,
	TriggerDelay = 0.02
}
t1.value1 = game:GetService("Players")
t1.value2 = game:GetService("RunService")
t1.value3 = game:GetService("UserInputService")

local CoreGui = game:GetService("CoreGui")

t1.value4 = t1.value1.LocalPlayer
t1.value5 = workspace.CurrentCamera
t1.value6 = Drawing.new("Circle")
t1.value6.Color = Color3.fromRGB(174, 214, 241)
t1.value6.Thickness = 1
t1.value6.NumSides = 900
t1.value6.Filled = false
t1.value7 = Drawing.new("Line")
t1.value7.Color = Color3.fromRGB(174, 214, 241)
t1.value7.Thickness = 1
t1.value7.Transparency = 1
t1.value7.Visible = false
local function v3(p1)
    local UIGradient = Instance.new("UIGradient", p1)

    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(174, 214, 241)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(93, 173, 226)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(41, 128, 185))
	})
    task.spawn(function()
        local n1 = 0

        while true do
            n1 += 2
            UIGradient.Rotation = n1
            t1.value2.RenderStepped:Wait()
        end
    end)
end
local function v4(p2)
    local u15
    local u16
    local inputPosition
    local p2Position
    p2.InputBegan:Connect(function(input)
        local v78 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v78 then
            v78 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v78 then
            u15 = true
            inputPosition = input.Position
            p2Position = p2.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    u15 = false
                end
            end)
        end
    end)
    p2.InputChanged:Connect(function(input)
        local v80 = input.UserInputType == Enum.UserInputType.MouseMovement

        if not v80 then
            v80 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v80 then
            u16 = input
        end
    end)
    t1.value3.InputChanged:Connect(function(input)
        if input == u16 and u15 then
            local v82 = input.Position - inputPosition

            p2.Position = UDim2.new(p2Position.X.Scale, p2Position.X.Offset + v82.X, p2Position.Y.Scale, p2Position.Y.Offset + v82.Y)
        end
    end)
end
local ScreenGui = Instance.new("ScreenGui", CoreGui)

ScreenGui.Name = "Hyper_Silent_V32"
ScreenGui.ResetOnSpawn = false
local TextButton = Instance.new("TextButton", ScreenGui)

TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Position = UDim2.new(0.05, 0, 0.3, 0)
TextButton.BackgroundTransparency = 1
TextButton.Text = "HYPERSILENT"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 24
v4(TextButton)
v3(TextButton)
t1.value8 = Instance.new("Frame", ScreenGui)
t1.value8.Size = UDim2.new(0, 420, 0, 520)
t1.value8.Position = UDim2.new(0.05, 0, 0.3, 60)
t1.value8.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
t1.value8.Visible = true
Instance.new("UICorner", t1.value8)

local Frame = Instance.new("Frame", t1.value8)

Frame.Size = UDim2.new(1, 6, 1, 6)
Frame.Position = UDim2.new(0, -3, 0, -3)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.ZIndex = t1.value8.ZIndex - 1
Instance.new("UICorner", Frame)
v3(Frame)
v4(t1.value8)
TextButton.Activated:Connect(function()
    t1.value8.Visible = not t1.value8.Visible
end)

local Frame2 = Instance.new("Frame", t1.value8)

Frame2.Size = UDim2.new(0, 210, 1, 0)
Frame2.BackgroundTransparency = 1
local Frame3 = Instance.new("Frame", t1.value8)

Frame3.Size = UDim2.new(0, 190, 1, -20)
Frame3.Position = UDim2.new(0, 220, 0, 10)
Frame3.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", Frame3)
t1.value9 = Instance.new("UIScale", t1.value8)
t1.value10 = nil
local function v10(p3, p4, p5, p6, p7)
    t1.value10(p3, p4, p5)

    local TextBox = Instance.new("TextBox", p3)

    TextBox.Size = UDim2.new(1, -20, 0, 25)
    TextBox.Position = UDim2.new(0, 10, 0, p5 + 15)
    TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TextBox.Text = tostring(getgenv().HyperConfig[p6])
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.Font = Enum.Font.GothamBold
    TextBox.TextSize = 9
    Instance.new("UICorner", TextBox)
    TextBox.FocusLost:Connect(function()
        local num = tonumber(TextBox.Text)

        if num then
            getgenv().HyperConfig[p6] = num

            if p7 then
                t1.value9.Scale = num
            end
        end
    end)
end
function t1.value10(p8, p9, p10)
    local TextLabel = Instance.new("TextLabel", p8)

    TextLabel.Size = UDim2.new(1, -20, 0, 15)
    TextLabel.Position = UDim2.new(0, 10, 0, p10)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.fromRGB(174, 214, 241)
    TextLabel.Text = p9
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 9
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    return TextLabel
end
local function v11(p11, p12, p13, p14)
    local TextButton2 = Instance.new("TextButton", p11)

    TextButton2.Size = UDim2.new(1, -20, 0, 25)
    TextButton2.Position = UDim2.new(0, 10, 0, p13)
    TextButton2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TextButton2.TextColor3 = Color3.new(1, 1, 1)
    TextButton2.Font = Enum.Font.GothamBold
    TextButton2.TextSize = 9
    Instance.new("UICorner", TextButton2)
    TextButton2.MouseButton1Click:Connect(function()
        getgenv().HyperConfig[p14] = not getgenv().HyperConfig[p14]
        TextButton2.Text = p12 .. (not (": " .. getgenv().HyperConfig[p14]) and "OFF" or "ON")
    end)
    TextButton2.Text = p12 .. (not (": " .. getgenv().HyperConfig[p14]) and "OFF" or "ON")

    return TextButton2
end
v10(Frame2, "MENU SCALE:", 10, "MenuScale", true)
t1.value10(Frame2, "--- COMBAT ---", 55)
v11(Frame2, "SILENT ENABLED", 70, "SilentEnabled")
v11(Frame2, "TRIGGERBOT", 100, "TriggerEnabled")
v11(Frame2, "ONLY TARGET LIST", 130, "AutoTarget")
v11(Frame2, "WALL CHECK", 160, "WallCheck")
t1.value10(Frame2, "--- VISUALS ---", 200)
v11(Frame2, "SHOW FOV", 215, "FOVVisible")
v11(Frame2, "SHOW TRACERS", 245, "TracerEnabled")
v10(Frame2, "FOV RADIUS:", 275, "FOV")
v10(Frame2, "FOV Y-OFFSET:", 320, "FOVOffset")
t1.value10(Frame3, "--- PREDICTIONS ---", 10)
v10(Frame3, "Horizontal Pred:", 25, "HorizontalPrediction")
v10(Frame3, "Vertical Pred:", 70, "VerticalPrediction")
t1.value10(Frame3, "--- PLAYER LIST ---", 115)
t1.value11 = Instance.new("ScrollingFrame", Frame3)
t1.value11.Size = UDim2.new(1, -10, 1, -140)
t1.value11.Position = UDim2.new(0, 5, 0, 130)
t1.value11.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
t1.value11.ScrollBarThickness = 2
t1.value11.BorderSizePixel = 0
t1.value12 = nil
function t1.value12()

    for v36, v37 in pairs(t1.value11:GetChildren()) do

        if v37:IsA("TextButton") then
            v37:Destroy()
        end
    end
    for k, player in pairs(t1.value1:GetPlayers()) do
        local v40 = player

        if v40 ~= t1.value4 then
            local TextButton3 = Instance.new("TextButton", t1.value11)

            TextButton3.Size = UDim2.new(1, -8, 0, 25)
            TextButton3.Position = UDim2.new(0, 0, 0, (k - 1) * 28)

            local v42 = table.find(getgenv().HyperConfig.SelectedPlayers, v40)
            local v43 = v42

            if v42 then
                v43 = Color3.fromRGB(174, 214, 241)
            end

            if not v43 then
                v43 = Color3.fromRGB(25, 25, 25)
            end

            TextButton3.BackgroundColor3 = v43
            TextButton3.Text = v40.DisplayName

            if v42 then
                v42 = Color3.new(0, 0, 0)
            end

            if not v42 then
                v42 = Color3.new(1, 1, 1)
            end

            TextButton3.TextColor3 = v42
            TextButton3.Font = Enum.Font.GothamBold
            TextButton3.TextSize = 8
            Instance.new("UICorner", TextButton3)
            TextButton3.MouseButton1Click:Connect(function()
                local v84 = table.find(getgenv().HyperConfig.SelectedPlayers, v40)

                if v84 then
                    table.remove(getgenv().HyperConfig.SelectedPlayers, v84)
                else
                    table.insert(getgenv().HyperConfig.SelectedPlayers, v40)
                end

                t1.value12()
            end)
        end
    end
end
t1.value12()
t1.value1.PlayerAdded:Connect(t1.value12)
t1.value1.PlayerRemoving:Connect(t1.value12)
t1.value13 = nil
t1.value14 = nil
t1.value15 = {
	"Head",
	"UpperTorso",
	"LowerTorso",
	"Torso",
	"LeftUpperArm",
	"LeftLowerArm",
	"LeftHand",
	"RightUpperArm",
	"RightLowerArm",
	"RightHand",
	"LeftUpperLeg",
	"LeftLowerLeg",
	"LeftFoot",
	"RightUpperLeg",
	"RightLowerLeg",
	"RightFoot"
}
function t1.value16(p15)
    if not p15 or not p15.Character then
        return false
    end

    local Humanoid = p15.Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid or Humanoid.Health <= 0 then
        return false
    end

    if getgenv().HyperConfig.KnockedCheck then
        local BodyEffects = p15.Character:FindFirstChild("BodyEffects")

        if BodyEffects then
            BodyEffects = BodyEffects:FindFirstChild("K.O") or BodyEffects:FindFirstChild("KnockedOut")
        end

        if BodyEffects and BodyEffects.Value then
            return false
        end
    end

    local AutoTarget = getgenv().HyperConfig.AutoTarget

    if AutoTarget then
        AutoTarget = not table.find(getgenv().HyperConfig.SelectedPlayers, p15)
    end

    if AutoTarget then
        return false
    end

    return true
end
function t1.value17()
    local FOV = getgenv().HyperConfig.FOV
    local v49
    local v50
    local vector2 = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2 + getgenv().HyperConfig.FOVOffset)
    for _, player in pairs(t1.value1:GetPlayers()) do
        if player ~= t1.value4 and t1.value16(player) then
            for _, v in pairs(t1.value15) do
                local v2 = player.Character:FindFirstChild(v)

                if v2 then
                    local v58, t2Result = t1.value5:WorldToViewportPoint(v2.Position)
                    if t2Result then
                        local Magnitude = (Vector2.new(v58.X, v58.Y) - vector2).Magnitude

                        if Magnitude < FOV then
                            local v60 = not getgenv().HyperConfig.WallCheck

                            if not v60 then
                                v60 = #t1.value5:GetPartsObscuringTarget({ v2.Position }, {
									t1.value4.Character,
									player.Character
								}) == 0
                            end

                            if v60 then
                                v49 = v2
                                FOV = Magnitude
                                v50 = player
                            end
                        end
                    end
                end
            end
        end
    end
    t1.value14 = v49

    return v50
end
t1.value2.Heartbeat:Connect(function()
    t1.value6.Visible = getgenv().HyperConfig.FOVVisible
    t1.value6.Radius = getgenv().HyperConfig.FOV
    t1.value6.Position = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y / 2 + getgenv().HyperConfig.FOVOffset)
    t1.value13 = t1.value17()

    local value13 = t1.value13

    if value13 then
        value13 = t1.value14

        if value13 then
            value13 = getgenv().HyperConfig.TracerEnabled
        end
    end

    if value13 then
        local v63, t3Result = t1.value5:WorldToViewportPoint(t1.value14.Position)
        if t3Result then
            t1.value7.Visible = true
            t1.value7.From = Vector2.new(t1.value5.ViewportSize.X / 2, t1.value5.ViewportSize.Y)
            t1.value7.To = Vector2.new(v63.X, v63.Y)

            return
        end
        t1.value7.Visible = false

        return
    end

    t1.value7.Visible = false
end)
task.spawn(function()
    while true do
        task.wait(getgenv().HyperConfig.TriggerDelay)

        local TriggerEnabled = getgenv().HyperConfig.TriggerEnabled

        if TriggerEnabled then
            TriggerEnabled = t1.value13 and t1.value14
        end

        if TriggerEnabled then
            local Character = t1.value4.Character

            if Character then
                Character = t1.value4.Character:FindFirstChildOfClass("Tool")
            end

            if Character then
                local v66 = Character.Name:lower()
                local v67 = false

                for _, v in pairs({
					"katana",
					"knife",
					"fist",
					"combat",
					"bat",
					"scythe",
					"sword",
					"punch",
					"taser",
					"machete"
				}) do
                    if string.find(v66, v) then
                        v67 = true

                        break
                    end
                end

                if not v67 then
                    Character:Activate()
                end
            end
        end
    end
end)
t1.value18 = nil
t1.value18 = hookmetamethod(game, "__namecall", newcclosure(function(p16, ...)
    local v71 = getnamecallmethod()
    local t4 = { ... }
    local v73 = not checkcaller()

    if v73 then
        v73 = v71 == "FireServer"

        if v73 then
            v73 = getgenv().HyperConfig.SilentEnabled

            if v73 then
                v73 = t1.value13 and t1.value14
            end
        end
    end

    if v73 then
        local v74 = t4[1] == "UpdateMousePos"

        if not v74 then
            v74 = t4[1] == "MousePos"

            if not v74 then
                v74 = t4[1] == "MOUSE"

                if not v74 then
                    v74 = t4[1] == "ShootPos"
                end
            end
        end

        if v74 then
            local v75 = t1.value14.Position + t1.value14.Velocity * Vector3.new(getgenv().HyperConfig.HorizontalPrediction, getgenv().HyperConfig.VerticalPrediction, getgenv().HyperConfig.HorizontalPrediction)

            t4[2] = type(t4[2]) == "table" and {
				v75,
				v75
			} or v75

            return t1.value18(p16, unpack(t4))
        end
    end

    return t1.value18(p16, ...)
end))
