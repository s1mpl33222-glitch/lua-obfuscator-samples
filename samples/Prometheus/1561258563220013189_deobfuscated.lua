-- This file was generated at discord.gg/syncrypt

local t1 = {}
repeat
    task.wait()
    t1.value1 = game:IsLoaded()
until t1.value1
t1.value2 = 12834712622936
t1.value3 = 4828406859976
local t2 = {
	value1 = "rbxassetid://126937210066343",
	value2 = "rbxassetid://0",
	value3 = "rbxassetid://111092517538982",
	value4 = "https://s0ftkillz.sellhub.cx/product/Key/",
	value5 = "rbxassetid://113639632389270",
	value6 = "https://s0ftkillz.dillydally586.workers.dev/",
	value7 = "rbxassetid://120926108125796",
	value8 = "https://stfly.vip/HubKeys1",
	value9 = "rbxassetid://89792003818413",
	value10 = "https://discord.gg/D2ZAvkx63j",
	value11 = "rbxassetid://126946140959629",
	value12 = "Games Hub_Key.txt",
	value13 = "",
	value14 = "Games Hub_Welcome_V1335.txt"
}
pcall(function()
    if not isfile(t2.value12) then
        return
    end

    t2.value13 = readfile(t2.value12)
end)

function t2.value15(p1)
    if not p1 or p1 == "" then
        return
    end
end
function t2.value16(p2)
    local v3 = type(p2) == "string"

    if not v3 then
        return v3
    end

    if p2 == "" then
        v3 = false
    else
        v3 = p2 ~= "rbxassetid://0"
    end

    return v3
end
local Players = game:GetService("Players")

t2.value17 = game:GetService("TweenService")
t2.value18 = game:GetService("CoreGui")
t2.value19 = game:GetService("UserInputService")
t2.value20 = game:GetService("Workspace")
t2.value21 = Players.LocalPlayer
t2.value22 = Color3.fromRGB(183, 85, 255)
t2.value23 = Color3.fromRGB(55, 215, 255)
t2.value24 = Color3.fromRGB(85, 255, 135)
t2.value25 = Color3.fromRGB(15, 15, 18)
Color3.fromRGB(22, 22, 27)
t2.value26 = Color3.fromRGB(58, 58, 68)

function t2.value27(p3, p4)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, p4 or 5)
    UICorner.Parent = p3

    return UICorner
end
function t2.value28(p5, p6, p7, p8)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p6 or t2.value22
    UIStroke.Thickness = p7 or 1
    UIStroke.Transparency = p8 or 0
    UIStroke.Parent = p5

    return UIStroke
end
function t2.value29(p9)
    local ok, result = pcall(function()
        return Instance.new("UIShadow")
    end)

    if ok then
        ok = result
    end

    if not ok then
        ok = Instance.new("ImageLabel")
        ok.Name = "CyberShadowFallback"
        ok.AnchorPoint = Vector2.new(0.5, 0.5)
        ok.Position = UDim2.fromScale(0.5, 0.5)
        ok.Size = UDim2.new(1, 42, 1, 42)
        ok.BackgroundTransparency = 1
        ok.Image = "rbxassetid://1316045217"
        ok.ImageColor3 = t2.value22
        ok.ImageTransparency = 0.62
        ok.ScaleType = Enum.ScaleType.Stretch
        result = p9.ZIndex - 1
        ok.ZIndex = math.max(0, result)
        ok.Parent = p9

        return ok
    end

    ok = pcall(function()
        result.Name = "CyberUIShadow"
        result.BlurRadius = UDim.new(0, 20)
        result.Color = t2.value22
        result.Transparency = 0.48
        result.Offset = UDim2.new(0, 0, 0, 9)
        result.Spread = UDim2.new(0, 9, 0, 9)
        result.ZIndex = 0
        result.Parent = p9
    end)

    if ok then
        ok = result.Parent == p9
    end

    if ok then
        return result
    end

    pcall(function()
        result:Destroy()
    end)
    ok = Instance.new("ImageLabel")
    ok.Name = "CyberShadowFallback"
    ok.AnchorPoint = Vector2.new(0.5, 0.5)
    ok.Position = UDim2.fromScale(0.5, 0.5)
    ok.Size = UDim2.new(1, 42, 1, 42)
    ok.BackgroundTransparency = 1
    ok.Image = "rbxassetid://1316045217"
    ok.ImageColor3 = t2.value22
    ok.ImageTransparency = 0.62
    ok.ScaleType = Enum.ScaleType.Stretch
    result = p9.ZIndex - 1
    ok.ZIndex = math.max(0, result)
    ok.Parent = p9

    return ok
end
function t2.value30(p10, p11)
    local Frame = Instance.new("Frame")

    Frame.Name = "CyberScanLine"
    Frame.Size = UDim2.new(0.3, 0, 0, 2)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundColor3 = t2.value23
    Frame.BorderSizePixel = 0
    Frame.ZIndex = p11 or 30
    Frame.Parent = p10

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.22, 0.28),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.78, 0.28),
		NumberSequenceKeypoint.new(1, 1)
	})
    UIGradient.Parent = Frame
    task.spawn(function()
        while true do
            local Parent = Frame

            if Parent then
                Parent = Frame.Parent
            end

            if not Parent then
                return
            end

            Parent = t2.value17

            local v12 = Frame
            local tweenInfoNew = TweenInfo.new
            local Sine = Enum.EasingStyle.Sine
            local EasingDirection = Enum.EasingDirection

            Parent = Parent:Create(v12, tweenInfoNew(1.55, Sine, EasingDirection.InOut), {
				["Position"] = UDim2.new(0.7, 0, 0, 0),
				["BackgroundColor3"] = t2.value22
			})
            Parent:Play()
            Parent.Completed:Wait()

            if not Frame.Parent then
                return
            end

            Parent = t2.value17
            v12 = Frame
            tweenInfoNew = TweenInfo.new(1.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            Sine = UDim2.new
            Parent = Parent:Create(v12, tweenInfoNew, {
				["Position"] = Sine(0, 0, 0, 0),
				["BackgroundColor3"] = t2.value23
			})
            Parent:Play()
            Parent.Completed:Wait()
        end
    end)

    return Frame
end
function t2.value31()
    local CurrentCamera = t2.value20.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    else
        return Vector2.new(1920, 1080)
    end
end
function t2.value32(p12)
    return pcall(function()
        if setclipboard then
            setclipboard(p12)

            return
        else
            if toclipboard then
                toclipboard(p12)

                return
            else
                error("Clipboard unsupported")

                return
            end

            return
        end
    end)
end
(function()
    local u17
    local function v18()
        u17 = isfile(t2.value14)
    end
    u17 = false
    pcall(v18)
    if u17 then
        return
    end
end)()
t2.value33 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
Players = loadstring
local game_ = game
t1.value4 = game_.HttpGet
t1.value5 = "\143\232j\t\173\235\199\201H"
t2.value34 = Players(t1.value4(game_, "https://sdkAPI-public.luarmor.net/library.lua"))()
t2.value34.script_id = "07a73d589fafa2f1762aa93563002584"
Players = t2.value33
game_ = Players.CreateWindow
local v20 = t2.value31()
Players = game_(Players, {
	["Title"] = "Games Hub",
	["SubTitle"] = "Key System",
	["TabWidth"] = v20.X <= 500 and 110 or (v20.X <= 700 and 130 or 160),
	["Size"] = (function()
    local v21 = t2.value31()
    local v22 = v21.X - 24

    v22 = math.max(280, v22)
    v22 = math.min(480, v22)
    v21 = v21.Y - 80
    v21 = math.max(230, v21)
    v21 = math.min(320, v21)

    return UDim2.fromOffset(math.floor(v22), (math.floor(v21)))
end)(),
	["Acrylic"] = true,
	["Theme"] = "Darker",
	["MinimizeKey"] = Enum.KeyCode.RightControl
})
game_ = {
	["Main"] = Players:AddTab({
		["Title"] = "Verification",
		["Icon"] = t2.value1
	})
}
function t2.value35(p13, p14)
    t2.value33:Notify({
		["Title"] = p13,
		["Content"] = p14,
		["Duration"] = 6
	})
end
t2.value36 = nil
v20 = function(p15)
    if not p15 or p15 == "" then
        t2.value35("Error", "Please enter a key first.")

        return
    else
        t2.value35("Checking...", "Verifying your key...")

        local message = t2.value34.check_key(p15)

        if message.code == "KEY_VALID" then
            t2.value15(p15)
            t2.value13 = p15
            t2.value33:Destroy()
            getgenv().script_key = p15
            t2.value34.load_script()

            return
        else
            if message.code:find("KEY_") then
                t2.value35("Key Denied", ({
					["KEY_HWID_LOCKED"] = "Key is linked to another HWID.",
					["KEY_INCORRECT"] = "The key is incorrect.",
					["KEY_INVALID"] = "The key is invalid or expired."
				})[message.code] or message.message)

                return
            else
                local value21 = t2.value21

                message = message.message
                value21:Kick("System Error: " .. tostring(message))

                return
            end

            return
        end

        return
    end
end
t2.value37 = nil
t2.value36 = nil
function t2.value38()
    if not t2.value37 then
        return
    end
end
function t2.value39()
    if t2.value37 then
        t2.value38()
        task.wait(0.22)
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "S0ftKillz_KeyPopup"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999999999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    if not pcall(function()
        ScreenGui.Parent = t2.value18
    end) then
        ScreenGui.Parent = t2.value21:WaitForChild("PlayerGui")
    end
    t2.value37 = ScreenGui
    local Frame = Instance.new("Frame")
    Frame.Name = "Dim"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = ScreenGui
    Frame = Instance.new("Frame")
    Frame.Name = "Popup"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(900, 500)
    Frame.BackgroundColor3 = t2.value25
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.ClipsDescendants = false
    Frame.Parent = ScreenGui
    t2.value27(Frame, 7)
    local v27 = t2.value28(Frame, t2.value22, 2, 1)
    t2.value29(Frame)
    local Frame2 = Instance.new("Frame")
    Frame2.Name = "TopAccent"
    Frame2.Size = UDim2.new(0.3, 0, 0, 2)
    Frame2.Position = UDim2.new(0, 0, 0, 0)
    Frame2.BackgroundColor3 = t2.value23
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 20
    Frame2.Parent = Frame
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 45, 235)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(195, 65, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 205, 255)) })
    UIGradient.Parent = Frame2
    task.spawn(function()
        local n1 = 16767352

        while true do
            n1 = t2.value37 == ScreenGui
            if n1 then
                n1 = Frame2

                if n1 then
                    n1 = Frame2.Parent
                end
            end
            if not n1 then
                return
            end
            n1 = t2.value17
            local v31 = Frame2
            local tweenInfoNew = TweenInfo.new
            local Sine = Enum.EasingStyle.Sine
            n1 = n1:Create(v31, tweenInfoNew(1.55, Sine, Enum.EasingDirection.InOut), {
				["Position"] = UDim2.new(0.7, 0, 0, 0),
				["BackgroundColor3"] = t2.value22
			})
            n1:Play()
            n1.Completed:Wait()
            if not Frame2.Parent then
                return
            end
            n1 = t2.value17
            v31 = Frame2
            tweenInfoNew = TweenInfo.new
            Sine = Enum.EasingStyle.Sine
            n1 = n1:Create(v31, tweenInfoNew(1.55, Sine, Enum.EasingDirection.InOut), {
				["Position"] = UDim2.new(0, 0, 0, 0),
				["BackgroundColor3"] = t2.value23
			})
            n1:Play()
            n1 = n1.Completed
            n1:Wait()
        end
    end)
    Frame2 = Instance.new("UIScale")
    Frame2.Name = "ResponsiveScale"
    Frame2.Scale = 0.94
    Frame2.Parent = Frame
    local u35 = false
    local u36
    local Position
    local Position2
    local u39
    Frame.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        if input.Position.Y - Frame.AbsolutePosition.Y > 92 then
            return
        end

        u35 = true
        Position = input.Position
        Position2 = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            u35 = false
        end)
    end)
    UIGradient = Frame.InputChanged
    local function v40(p16)
        if not (p16.UserInputType == Enum.UserInputType.MouseMovement or p16.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u36 = p16
    end
    UIGradient:Connect(v40)
    UIGradient = t2.value19.InputChanged
    v40 = function(p17)
        if t2.value37 ~= ScreenGui then
            if not u39 then
                return
            end

            u39:Disconnect()
            u39 = nil

            return
        else
            local v41 = u35

            if v41 then
                v41 = p17 == u36

                if v41 then
                    v41 = Position

                    if v41 then
                        v41 = Position2
                    end
                end
            end

            if not v41 then
                return
            end

            v41 = p17.Position - Position
            Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v41.X, Position2.Y.Scale, Position2.Y.Offset + v41.Y)

            return
        end
    end
    u39 = UIGradient:Connect(v40)
    UIGradient = Instance.new("TextButton")
    UIGradient.Name = "CloseButton"
    UIGradient.Position = UDim2.fromOffset(18, 18)
    UIGradient.Size = UDim2.fromOffset(42, 42)
    UIGradient.BackgroundColor3 = Color3.fromRGB(34, 22, 27)
    UIGradient.BorderSizePixel = 0
    UIGradient.Text = "X"
    UIGradient.TextColor3 = Color3.fromRGB(255, 72, 82)
    UIGradient.Font = Enum.Font.GothamBold
    UIGradient.TextSize = 24
    UIGradient.AutoButtonColor = false
    UIGradient.ZIndex = 25
    UIGradient.Parent = Frame
    t2.value27(UIGradient, 5)
    v40 = t2.value28(UIGradient, Color3.fromRGB(130, 45, 55), 1, 0.1)
    UIGradient.MouseEnter:Connect(function()
        local value17 = t2.value17
        local v43 = UIGradient
        local tweenInfo = TweenInfo.new(0.12)
        local Color3_ = Color3

        value17.Create(value17, v43, tweenInfo, {
			["BackgroundColor3"] = Color3_.fromRGB(62, 25, 32)
		}):Play()
        value17 = t2.value17
        v43 = v40
        tweenInfo = TweenInfo.new(0.12)
        Color3_ = Color3
        value17.Create(value17, v43, tweenInfo, {
			["Color"] = Color3_.fromRGB(255, 72, 82)
		}):Play()
    end)
    UIGradient.MouseLeave:Connect(function()
        local value17 = t2.value17
        local v47 = UIGradient
        local tweenInfo = TweenInfo.new(0.12)
        local Color3_ = Color3

        value17.Create(value17, v47, tweenInfo, {
			["BackgroundColor3"] = Color3_.fromRGB(34, 22, 27)
		}):Play()
        value17 = t2.value17
        v47 = v40
        tweenInfo = TweenInfo.new(0.12)
        Color3_ = {
			["Color"] = Color3.fromRGB(130, 45, 55)
		}
        value17.Create(value17, v47, tweenInfo, Color3_):Play()
    end)
    UIGradient.Activated:Connect(function()
        t2.value38()
    end)
    v40 = Instance.new("ImageLabel")
    v40.Name = "BrandLogo"
    v40.Position = UDim2.fromOffset(74, 14)
    v40.Size = UDim2.fromOffset(50, 50)
    v40.BackgroundTransparency = 1
    v40.Image = t2.value1
    v40.ScaleType = Enum.ScaleType.Fit
    v40.ZIndex = 25
    v40.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "BrandText"
    TextLabel.Position = UDim2.fromOffset(132, 16)
    TextLabel.Size = UDim2.fromOffset(190, 46)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "S0FTKILLZ"
    TextLabel.TextColor3 = Color3.fromRGB(242, 170, 213)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 20
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 25
    TextLabel.Parent = Frame
    local Frame3 = Instance.new("Frame")
    Frame3.Name = "CenterKey"
    Frame3.AnchorPoint = Vector2.new(0.5, 0)
    Frame3.Position = UDim2.new(0.5, 0, 0, 10)
    Frame3.Size = UDim2.fromOffset(270, 62)
    Frame3.BackgroundTransparency = 1
    Frame3.ZIndex = 25
    Frame3.Parent = Frame
    local Frame4 = Instance.new("Frame")
    Frame4.Name = "KeyHeaderLogo"
    Frame4.Position = UDim2.fromOffset(22, 7)
    Frame4.Size = UDim2.fromOffset(48, 48)
    Frame4.BackgroundTransparency = 1
    Frame4.BorderSizePixel = 0
    Frame4.ZIndex = 26
    Frame4.Parent = Frame3
    if t2.value16(t2.value2) then
        v_u_71 = Instance.new("ImageLabel")
        v_u_71.Name = "Image"
        v_u_71.Size = UDim2.fromScale(1, 1)
        v_u_71.BackgroundTransparency = 1
        v_u_71.Image = t2.value2
        v_u_71.ScaleType = Enum.ScaleType.Fit
        v_u_71.ZIndex = 27
        v_u_71.Parent = Frame4
    else
        v_u_71 = Instance.new("Frame")
        v_u_71.Name = "Ring"
        v_u_71.Position = UDim2.fromOffset(3, 7)
        v_u_71.Size = UDim2.fromOffset(22, 22)
        v_u_71.BackgroundTransparency = 1
        v_u_71.BorderSizePixel = 0
        v_u_71.ZIndex = 27
        v_u_71.Parent = Frame4
        t2.value27(v_u_71, 11)
        t2.value28(v_u_71, Color3.fromRGB(255, 138, 47), 4, 0)
        v_u_71 = Instance.new("Frame")
        v_u_71.Name = "Shaft"
        v_u_71.Position = UDim2.fromOffset(21, 24)
        v_u_71.Size = UDim2.fromOffset(23, 5)
        v_u_71.Rotation = 40
        v_u_71.BackgroundColor3 = Color3.fromRGB(255, 138, 47)
        v_u_71.BorderSizePixel = 0
        v_u_71.ZIndex = 27
        v_u_71.Parent = Frame4
        t2.value27(v_u_71, 3)
        v_u_71 = Instance.new("Frame")
        v_u_71.Name = "Tooth"
        v_u_71.Position = UDim2.fromOffset(36, 31)
        v_u_71.Size = UDim2.fromOffset(5, 10)
        v_u_71.Rotation = 40
        v_u_71.BackgroundColor3 = Color3.fromRGB(255, 138, 47)
        v_u_71.BorderSizePixel = 0
        v_u_71.ZIndex = 27
        v_u_71.Parent = Frame4
        t2.value27(v_u_71, 2)
    end
    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Position = UDim2.fromOffset(80, 4)
    TextLabel2.Size = UDim2.fromOffset(176, 30)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "KEY ACCESS"
    TextLabel2.TextColor3 = Color3.fromRGB(255, 138, 47)
    TextLabel2.Font = Enum.Font.GothamBold
    TextLabel2.TextSize = 24
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 26
    TextLabel2.Parent = Frame3
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Position = UDim2.fromOffset(81, 33)
    TextLabel3.Size = UDim2.fromOffset(180, 21)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "Choose your access method"
    TextLabel3.TextColor3 = Color3.fromRGB(150, 150, 166)
    TextLabel3.Font = Enum.Font.Gotham
    TextLabel3.TextSize = 11
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.ZIndex = 26
    TextLabel3.Parent = Frame3
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "DiscordButton"
    TextButton.AnchorPoint = Vector2.new(1, 0)
    TextButton.Position = UDim2.new(1, -18, 0, 16)
    TextButton.Size = UDim2.fromOffset(168, 48)
    TextButton.BackgroundColor3 = Color3.fromRGB(23, 25, 36)
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 25
    TextButton.Parent = Frame
    t2.value27(TextButton, 5)
    local Frame5 = t2.value28(TextButton, Color3.fromRGB(88, 101, 242), 1.5, 0)
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.Position = UDim2.new(0, 11, 0.5, 0)
    ImageLabel.Size = UDim2.fromOffset(30, 30)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t2.value11
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 26
    ImageLabel.Parent = TextButton
    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Position = UDim2.fromOffset(48, 0)
    TextLabel4.Size = UDim2.new(1, -58, 1, 0)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "DISCORD"
    TextLabel4.TextColor3 = Color3.fromRGB(196, 202, 255)
    TextLabel4.Font = Enum.Font.GothamBold
    TextLabel4.TextSize = 15
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.ZIndex = 26
    TextLabel4.Parent = TextButton
    TextButton.MouseEnter:Connect(function()
        local value17 = t2.value17
        local v60 = TextButton
        local tweenInfo = TweenInfo.new(0.12)
        local color3 = Color3.fromRGB

        value17.Create(value17, v60, tweenInfo, {
			["BackgroundColor3"] = color3(34, 37, 56)
		}):Play()
        t2.value17:Create(Frame5, TweenInfo.new(0.12), {
			["Color"] = t2.value23,
			["Thickness"] = 2
		}):Play()
    end)
    TextButton.MouseLeave:Connect(function()
        local value17 = t2.value17
        local v64 = TextButton
        local tweenInfoNew = TweenInfo.new

        value17.Create(value17, v64, tweenInfoNew(0.12), {
			["BackgroundColor3"] = Color3.fromRGB(23, 25, 36)
		}):Play()
        value17 = t2.value17
        v64 = Frame5
        tweenInfoNew = TweenInfo.new(0.12)
        value17.Create(value17, v64, tweenInfoNew, {
			["Color"] = Color3.fromRGB(88, 101, 242),
			["Thickness"] = 1.5
		}):Play()
    end)
    TextButton.Activated:Connect(function()
        if t2.value32(t2.value10) then
            TextLabel4.Text = "COPIED!"
            TextLabel4.TextColor3 = t2.value24
            t2.value35("Discord Copied!", "Discord invite copied to your clipboard.")
        else
            TextLabel4.Text = "COPY ERROR"
            TextLabel4.TextColor3 = Color3.fromRGB(255, 90, 100)
        end

        task.delay(1.3, function()
            local Parent = TextLabel4

            if Parent then
                Parent = TextLabel4.Parent
            end

            if not Parent then
                return
            end

            TextLabel4.Text = "DISCORD"
            TextLabel4.TextColor3 = Color3.fromRGB(196, 202, 255)
        end)
    end)
    Frame5 = Instance.new("Frame")
    Frame5.Name = "HeaderLine"
    Frame5.Position = UDim2.fromOffset(18, 80)
    Frame5.Size = UDim2.new(1, -36, 0, 1)
    Frame5.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
    Frame5.BorderSizePixel = 0
    Frame5.ZIndex = 21
    Frame5.Parent = Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "AccessMethods"
    ScrollingFrame.Position = UDim2.fromOffset(6, 88)
    ScrollingFrame.Size = UDim2.new(1, -12, 1, -96)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.ScrollBarImageColor3 = t2.value22
    ScrollingFrame.ScrollBarImageTransparency = 0.12
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    ScrollingFrame.Active = true
    ScrollingFrame.ZIndex = 10
    ScrollingFrame.Parent = Frame
    local t3 = {}
    local function createFrame(p18)
        local Frame6 = Instance.new("Frame")

        Frame6.Name = p18.Name
        Frame6.BackgroundColor3 = Color3.fromRGB(21, 21, 27)
        Frame6.BorderSizePixel = 0
        Frame6.ClipsDescendants = false
        Frame6.ZIndex = 12
        Frame6.Parent = ScrollingFrame
        t2.value27(Frame6, 6)

        local value28 = t2.value28
        local Popular = p18.Popular

        if Popular then
            Popular = Color3.fromRGB(255, 139, 34)
        end

        value28(Frame6, Popular or Color3.fromRGB(58, 58, 70), p18.Popular and 2.5 or 1.2, 0)
        value28 = Instance.new("Frame")
        value28.Name = "AccentBar"
        value28.Position = UDim2.fromOffset(0, 0)
        value28.Size = UDim2.new(1, 0, 0, 4)
        value28.BackgroundColor3 = p18.Accent
        value28.BorderSizePixel = 0
        value28.ZIndex = 14
        value28.Parent = Frame6
        t2.value27(value28, 3)

        if p18.Popular then
            value28 = Instance.new("TextLabel")
            value28.Name = "PopularBadge"
            value28.AnchorPoint = Vector2.new(0.5, 0)
            value28.Position = UDim2.new(0.5, 0, 0, 12)
            value28.Size = UDim2.fromOffset(176, 28)
            value28.BackgroundColor3 = Color3.fromRGB(50, 35, 18)
            value28.BorderSizePixel = 0
            value28.Text = "MOST POPULAR  *"
            value28.TextColor3 = Color3.fromRGB(255, 191, 33)
            value28.Font = Enum.Font.GothamBold
            value28.TextSize = 13
            value28.ZIndex = 15
            value28.Parent = Frame6
            t2.value27(value28, 4)
            t2.value28(value28, Color3.fromRGB(255, 146, 35), 1, 0.15)
        else
            value28 = nil
        end

        Popular = Instance.new("TextLabel")
        Popular.Name = "CardTitle"
        Popular.Position = UDim2.fromOffset(14, p18.Popular and 48 or 18)
        Popular.Size = UDim2.new(1, -28, 0, 31)
        Popular.BackgroundTransparency = 1
        Popular.Text = p18.Title
        Popular.TextColor3 = p18.Accent
        Popular.Font = Enum.Font.GothamBold
        Popular.TextSize = 23
        Popular.TextXAlignment = Enum.TextXAlignment.Center
        Popular.ZIndex = 15
        Popular.Parent = Frame6

        local Frame7 = Instance.new("Frame")

        Frame7.Name = "LogoBox"
        Frame7.Position = UDim2.fromOffset(14, p18.Popular and 86 or 58)
        Frame7.Size = UDim2.new(1, -28, 0, 76)
        Frame7.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
        Frame7.BorderSizePixel = 0
        Frame7.ZIndex = 13
        Frame7.Parent = Frame6
        t2.value27(Frame7, 4)
        t2.value28(Frame7, Color3.fromRGB(50, 50, 62), 1, 0.15)

        if t2.value16(p18.Logo) then
            v92 = Instance.new("ImageLabel")
            v92.Name = "CardLogo"
            v92.AnchorPoint = Vector2.new(0.5, 0.5)
            v92.Position = UDim2.fromScale(0.5, 0.5)
            v92.Size = UDim2.fromOffset(58, 58)
            v92.BackgroundTransparency = 1
            v92.Image = p18.Logo
            v92.ScaleType = Enum.ScaleType.Fit
            v92.ZIndex = 15
            v92.Parent = Frame7
        elseif p18.LogoKind == "ADS" then
            v92 = Instance.new("Frame")
            v92.Name = "AdsLogo"
            v92.AnchorPoint = Vector2.new(0.5, 0.5)
            v92.Position = UDim2.fromScale(0.5, 0.5)
            v92.Size = UDim2.fromOffset(62, 50)
            v92.BackgroundColor3 = Color3.fromRGB(18, 33, 38)
            v92.BorderSizePixel = 0
            v92.ZIndex = 15
            v92.Parent = Frame7
            t2.value27(v92, 8)
            t2.value28(v92, p18.Accent, 2, 0)
            v_u_93 = Instance.new("Frame")
            v_u_93.Name = "AdScreen"
            v_u_93.Position = UDim2.fromOffset(8, 7)
            v_u_93.Size = UDim2.new(1, -16, 1, -18)
            v_u_93.BackgroundColor3 = Color3.fromRGB(12, 20, 24)
            v_u_93.BorderSizePixel = 0
            v_u_93.ZIndex = 16
            v_u_93.Parent = v92
            t2.value27(v_u_93, 5)
            t2.value28(v_u_93, Color3.fromRGB(55, 105, 112), 1, 0.15)
            v_u_94 = Instance.new("TextLabel")
            v_u_94.Name = "AdText"
            v_u_94.Size = UDim2.fromScale(1, 1)
            v_u_94.BackgroundTransparency = 1
            v_u_94.Text = "AD"
            v_u_94.TextColor3 = p18.Accent
            v_u_94.Font = Enum.Font.GothamBold
            v_u_94.TextSize = 23
            v_u_94.ZIndex = 17
            v_u_94.Parent = v_u_93
            v_u_93 = Instance.new("Frame")
            v_u_93.Name = "AdStand"
            v_u_93.AnchorPoint = Vector2.new(0.5, 0)
            v_u_93.Position = UDim2.new(0.5, 0, 1, -9)
            v_u_93.Size = UDim2.fromOffset(18, 3)
            v_u_93.BackgroundColor3 = p18.Accent
            v_u_93.BorderSizePixel = 0
            v_u_93.ZIndex = 17
            v_u_93.Parent = v92
            t2.value27(v_u_93, 2)
        else
            v92 = Instance.new("TextLabel")
            v92.Name = "CardLogoText"
            v92.Size = UDim2.fromScale(1, 1)
            v92.BackgroundTransparency = 1
            v92.Text = p18.LogoText or p18.Title
            v92.TextColor3 = p18.Accent
            v92.Font = Enum.Font.GothamBold
            v92.TextSize = 28
            v92.ZIndex = 15
            v92.Parent = Frame7
        end

        local Frame8 = Instance.new("Frame")

        Frame8.Name = "DetailBox"
        Frame8.Position = UDim2.fromOffset(14, p18.Popular and 170 or 142)
        Frame8.Size = UDim2.new(1, -28, 0, 92)
        Frame8.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
        Frame8.BorderSizePixel = 0
        Frame8.ZIndex = 13
        Frame8.Parent = Frame6
        t2.value27(Frame8, 4)

        local TextLabel5 = Instance.new("TextLabel")

        TextLabel5.Name = "CardDetail"
        TextLabel5.Position = UDim2.fromOffset(12, 8)
        TextLabel5.Size = UDim2.new(1, -24, 1, -16)
        TextLabel5.BackgroundTransparency = 1
        TextLabel5.Text = p18.Detail
        TextLabel5.TextColor3 = Color3.fromRGB(213, 213, 222)
        TextLabel5.Font = Enum.Font.Gotham
        TextLabel5.TextSize = 15
        TextLabel5.TextWrapped = true
        TextLabel5.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel5.TextYAlignment = Enum.TextYAlignment.Center
        TextLabel5.ZIndex = 15
        TextLabel5.Parent = Frame8
        TextLabel5 = Instance.new("TextButton")
        TextLabel5.Name = "CopyLink"
        TextLabel5.AnchorPoint = Vector2.new(0.5, 1)
        TextLabel5.Position = UDim2.new(0.5, 0, 1, -14)
        TextLabel5.Size = UDim2.new(1, -28, 0, 46)
        TextLabel5.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        TextLabel5.BorderSizePixel = 0
        TextLabel5.Text = "COPY LINK"
        TextLabel5.TextColor3 = p18.Accent
        TextLabel5.Font = Enum.Font.GothamBold
        TextLabel5.TextSize = 14
        TextLabel5.AutoButtonColor = false
        TextLabel5.ZIndex = 15
        TextLabel5.Parent = Frame6
        t2.value27(TextLabel5, 4)

        local v76 = t2.value28(TextLabel5, p18.Accent, 1.5, 0)
        local Frame9 = Instance.new("Frame")

        Frame9.Position = UDim2.new(0, 0, 0, 7)
        Frame9.Size = UDim2.new(0, 4, 1, -14)
        Frame9.BackgroundColor3 = p18.Accent
        Frame9.BorderSizePixel = 0
        Frame9.ZIndex = 16
        Frame9.Parent = TextLabel5
        t2.value27(Frame9, 2)
        TextLabel5.MouseEnter:Connect(function()
            local value17 = t2.value17
            local v79 = TextLabel5
            local tweenInfo = TweenInfo.new(0.12)

            value17.Create(value17, v79, tweenInfo, {
				["BackgroundColor3"] = p18.Accent,
				["TextColor3"] = Color3.fromRGB(12, 12, 16)
			}):Play()
            value17 = t2.value17
            v79 = v76
            tweenInfo = TweenInfo.new(0.12)

            local t4 = {
				["Color"] = t2.value23,
				["Thickness"] = 2
			}

            value17.Create(value17, v79, tweenInfo, t4):Play()
        end)
        TextLabel5.MouseLeave:Connect(function()
            local value17 = t2.value17
            local v83 = TextLabel5
            local tweenInfo = TweenInfo.new(0.12)
            local Color3_ = Color3

            value17.Create(value17, v83, tweenInfo, {
				["BackgroundColor3"] = Color3_.fromRGB(18, 18, 24),
				["TextColor3"] = p18.Accent
			}):Play()
            t2.value17:Create(v76, TweenInfo.new(0.12), {
				["Color"] = p18.Accent,
				["Thickness"] = 1.5
			}):Play()
        end)
        TextLabel5.Activated:Connect(function()
            if t2.value32(p18.Link) then
                TextLabel5.Text = "COPIED!"
                TextLabel5.BackgroundColor3 = p18.Accent
                TextLabel5.TextColor3 = Color3.fromRGB(12, 12, 16)
                t2.value35("Link Copied!", p18.Title .. " link copied to your clipboard.")
            else
                TextLabel5.Text = "COPY ERROR"
            end

            task.delay(1.2, function()
                local Parent = TextLabel5

                if Parent then
                    Parent = TextLabel5.Parent
                end

                if not Parent then
                    return
                end

                TextLabel5.Text = "COPY LINK"
                TextLabel5.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
                TextLabel5.TextColor3 = p18.Accent
            end)
        end)
        TextLabel5 = t3
        table.insert(TextLabel5, {
			["Frame"] = Frame6,
			["Title"] = Popular,
			["LogoBox"] = Frame7,
			["DetailBox"] = Frame8,
			["PopularBadge"] = value28
		})

        return Frame6
    end
    createFrame({
		["Name"] = "LifetimeCard",
		["Title"] = "LIFETIME",
		["Detail"] = "Lifetime key\nCrypto payment\nPermanent access",
		["Link"] = t2.value4,
		["Accent"] = Color3.fromRGB(164, 63, 255),
		["Logo"] = t2.value5,
		["LogoText"] = "LIFE",
		["Popular"] = false
	})
    createFrame({
		["Name"] = "PremiumCard",
		["Title"] = "PREMIUM",
		["Detail"] = "Multiple key durations\n1-day key from $0.99",
		["Link"] = t2.value6,
		["Accent"] = Color3.fromRGB(255, 190, 28),
		["Logo"] = t2.value7,
		["LogoText"] = "VIP",
		["Popular"] = true
	})
    createFrame({
		["Name"] = "AdsCard",
		["Title"] = "ADS",
		["Detail"] = "Free key with ads\n3 checkpoints",
		["Link"] = t2.value8,
		["Accent"] = Color3.fromRGB(95, 226, 234),
		["Logo"] = t2.value9,
		["LogoKind"] = "ADS",
		["Popular"] = false
	})
    UIGradient = function()
        local v87 = t2.value31()
        local v88 = v87.X - 12

        v88 = math.max(210, v88)
        v87 = v87.Y - 12
        v87 = math.max(250, v87)

        local v89

        if v88 >= 760 then
            v89 = v87 >= 460
        else
            v89 = false
        end

        Frame2.Scale = 1

        if v89 then
            v88 = math.min(900, v88)
            v87 = math.min(500, v87)
            Frame.Size = UDim2.fromOffset(v88, v87)
            v40.Visible = true
            TextLabel.Visible = true
            Frame3.AnchorPoint = Vector2.new(0.5, 0)
            Frame3.Position = UDim2.new(0.5, 0, 0, 10)
            Frame3.Size = UDim2.fromOffset(270, 62)
            Frame4.Visible = true
            Frame4.Position = UDim2.fromOffset(22, 7)
            Frame4.Size = UDim2.fromOffset(48, 48)
            TextLabel2.Position = UDim2.fromOffset(80, 4)
            TextLabel2.Size = UDim2.fromOffset(176, 30)
            TextLabel2.TextSize = 24
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel3.Visible = true
            TextLabel3.Position = UDim2.fromOffset(81, 33)
            TextLabel3.Size = UDim2.fromOffset(180, 21)
            TextLabel3.TextSize = 11
            TextButton.Size = UDim2.fromOffset(168, 48)
            TextButton.Position = UDim2.new(1, -18, 0, 16)
            ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
            ImageLabel.Position = UDim2.new(0, 11, 0.5, 0)
            ImageLabel.Size = UDim2.fromOffset(30, 30)
            TextLabel4.Visible = true
            Frame5.Position = UDim2.fromOffset(18, 80)
            Frame5.Size = UDim2.new(1, -36, 0, 1)
            ScrollingFrame.Position = UDim2.fromOffset(6, 88)
            ScrollingFrame.Size = UDim2.new(1, -12, 1, -96)
            ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
            ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
            ScrollingFrame.ScrollBarThickness = 0
            v89 = 24

            local clamp = math.clamp
            local v91 = v88 * 0.024

            clamp = clamp(math.floor(v91), 12, 22)
            v88 = (v88 - v89 * 2 - clamp * 2) / 3
            v88 = math.floor(v88)
            v87 = v87 - 150
            v87 = math.max(326, v87)

            local n2 = 24

            for i, v in ipairs(t3) do
                local v95 = v89 + (i - 1) * (v88 + clamp)

                v.Frame.Position = UDim2.fromOffset(v95, n2)
                v.Frame.Size = UDim2.fromOffset(v88, v87)
                v.Title.TextSize = v88 < 240 and 19 or 23

                if v.PopularBadge then
                    v.PopularBadge.Position = UDim2.new(0.5, 0, 0, 12)
                    v95 = v.PopularBadge

                    local uDim2 = UDim2.fromOffset
                    local v97 = v88 - 24

                    v95.Size = uDim2(math.min(176, v97), 28)
                    v.Title.Position = UDim2.fromOffset(14, 48)
                    v.LogoBox.Position = UDim2.fromOffset(14, 86)
                    v.DetailBox.Position = UDim2.fromOffset(14, 170)
                else
                    v.Title.Position = UDim2.fromOffset(14, 18)
                    v.LogoBox.Position = UDim2.fromOffset(14, 58)
                    v.DetailBox.Position = UDim2.fromOffset(14, 142)
                end
            end

            return
        end
    end
    UIGradient()
    v40 = t2.value20.CurrentCamera
    if not v40 then
        Frame.BackgroundTransparency = 1
        v27.Transparency = 1
        ScreenGui = Frame2.Scale
        UIGradient = ScreenGui * 0.94
        Frame2.Scale = math.max(0.5, UIGradient)
        t2.value17:Create(Frame2, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			["Scale"] = ScreenGui
		}):Play()
        t2.value17:Create(Frame, TweenInfo.new(0.18), {
			["BackgroundTransparency"] = 0
		}):Play()
        ScreenGui = t2.value17
        Frame = TweenInfo
        ScreenGui.Create(ScreenGui, v27, Frame.new(0.22), {
			["Transparency"] = 0
		}):Play()

        return
    end
    v40:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if t2.value37 ~= ScreenGui then
            return
        end

        UIGradient()
    end)
    Frame.BackgroundTransparency = 1
    v27.Transparency = 1
    ScreenGui = Frame2.Scale
    UIGradient = ScreenGui * 0.94
    Frame2.Scale = math.max(0.5, UIGradient)
    t2.value17:Create(Frame2, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		["Scale"] = ScreenGui
	}):Play()
    t2.value17:Create(Frame, TweenInfo.new(0.18), {
		["BackgroundTransparency"] = 0
	}):Play()
    ScreenGui = t2.value17
    Frame = TweenInfo
    ScreenGui.Create(ScreenGui, v27, Frame.new(0.22), {
		["Transparency"] = 0
	}):Play()
end
local Main = game_.Main
Main:AddInput("KeyInput", {
	["Title"] = "Access Key:",
	["Default"] = t2.value13,
	["Placeholder"] = "Paste your Luarmor key here...",
	["Numeric"] = false,
	["Finished"] = false,
	["Callback"] = function(p19)
    t2.value13 = p19
end
})
Main = game_.Main
t1.value6 = Main.AddButton
t1.value7 = {
	["Title"] = "1. Get Key",
	["Description"] = "Lifetime, Premium, or Free Key with Ads",
	["Callback"] = function()
    t2.value39()
end
}
t1.value6(Main, t1.value7)
game_ = game_.Main
t1.value6 = game_.AddButton
t1.value6(game_, {
	["Title"] = "2. Check Key",
	["Description"] = "Click here after pasting your key above",
	["Callback"] = function()
    v20(t2.value13)
end
})
Players:SelectTab(1)
t1.value6 = t2.value13
if t1.value6 == "" then
    t2.value35("Welcome!", "Please get a key to use Games Hub")

    return
end
