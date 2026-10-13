-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
repeat
    task.wait()
    t1.value1 = game:IsLoaded()
until t1.value1
t1.value2 = 12834712622936
t1.value3 = 4828406859976
t2.value1 = "rbxassetid://126937210066343"
t2.value2 = "rbxassetid://0"
t2.value3 = "rbxassetid://111092517538982"
t2.value4 = "https://s0ftkillz.sellhub.cx/product/Key/"
t2.value5 = "rbxassetid://113639632389270"
t2.value6 = "https://s0ftkillz.dillydally586.workers.dev/"
t2.value7 = "rbxassetid://120926108125796"
t2.value8 = "https://stfly.vip/HubKeys1"
t2.value9 = "rbxassetid://89792003818413"
t2.value10 = "https://discord.gg/D2ZAvkx63j"
t2.value11 = "rbxassetid://126946140959629"
t2.value12 = "Games Hub_Key.txt"
t2.value13 = ""
t2.value14 = "Games Hub_Welcome_V1335.txt"
pcall(function()
    if isfile(t2.value12) then
        t2.value13 = readfile(t2.value12)
    end
end)

function t2.value15(p1)
    local v24 = not p1

    if not v24 then
        v24 = p1 == ""
    end

    if v24 then
        return
    end

    pcall(function()
        writefile(t2.value12, p1)
    end)
end
function t2.value16(p2)
    local v26 = type(p2) == "string"

    if v26 then
        v26 = p2 ~= "" and p2 ~= "rbxassetid://0"
    end

    return v26
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

    if not p6 then
        p6 = t2.value22
    end

    UIStroke.Color = p6
    UIStroke.Thickness = p7 or 1
    UIStroke.Transparency = p8 or 0
    UIStroke.Parent = p5

    return UIStroke
end
function t2.value29(p9)
    local ok, result = pcall(function()
        return Instance.new("UIShadow")
    end)
    local v34 = result

    if ok then
        ok = v34
    end

    if ok then
        local ok2 = pcall(function()
            v34.Name = "CyberUIShadow"
            v34.BlurRadius = UDim.new(0, 20)
            v34.Color = t2.value22
            v34.Transparency = 0.48
            v34.Offset = UDim2.new(0, 0, 0, 9)
            v34.Spread = UDim2.new(0, 9, 0, 9)
            v34.ZIndex = 0
            v34.Parent = p9
        end)

        if ok2 then
            ok2 = p9 == v34.Parent
        end

        if ok2 then
            return v34
        end

        pcall(function()
            v34:Destroy()
        end)
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "CyberShadowFallback"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.new(1, 42, 1, 42)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://1316045217"
    ImageLabel.ImageColor3 = t2.value22
    ImageLabel.ImageTransparency = 0.62
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.ZIndex = math.max(0, p9.ZIndex - 1)
    ImageLabel.Parent = p9

    return ImageLabel
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
            local v137 = Frame

            if v137 then
                v137 = Frame.Parent
            end

            if not v137 then
                break
            end

            local value17 = t2.value17
            local v139 = Frame
            local new = TweenInfo.new
            local Sine = Enum.EasingStyle.Sine
            local EasingDirection = Enum.EasingDirection
            local Create = value17.Create
            local v144 = new(1.55, Sine, EasingDirection.InOut)
            local uDim2 = UDim2.new(0.7, 0, 0, 0)
            local value22 = t2.value22
            local v147 = Create(value17, v139, v144, {
				Position = uDim2,
				BackgroundColor3 = value22
			})

            v147:Play()
            v147.Completed:Wait()

            if not Frame.Parent then
                return
            end

            local value17_2 = t2.value17
            local v149 = Frame
            local tweenInfo = TweenInfo.new(1.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local new2 = UDim2.new
            local Create2 = value17_2.Create
            local v153 = new2(0, 0, 0, 0)
            local value23 = t2.value23
            local v155 = Create2(value17_2, v149, tweenInfo, {
				Position = v153,
				BackgroundColor3 = value23
			})

            v155:Play()
            v155.Completed:Wait()
        end
    end)

    return Frame
end
function t2.value31()
    local CurrentCamera = t2.value20.CurrentCamera

    if CurrentCamera then
        return CurrentCamera.ViewportSize
    end

    return Vector2.new(1920, 1080)
end
function t2.value32(p12)
    return pcall(function()
        if setclipboard then
            setclipboard(p12)

            return
        end

        if toclipboard then
            toclipboard(p12)

            return
        end

        error("Clipboard unsupported")
    end)
end;
(function()
    local u50 = false
    pcall(function()
        u50 = isfile(t2.value14)
    end)
    if u50 then
        return
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "S0ftKillz_FirstWelcome"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 1000000000
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    if not pcall(function()
        ScreenGui.Parent = t2.value18
    end) then
        ScreenGui.Parent = t2.value21:WaitForChild("PlayerGui")
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "TransparentBackdrop"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = ScreenGui
    local Frame2 = Instance.new("Frame")
    Frame2.Name = "CyberWelcome"
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Position = UDim2.fromScale(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(660, 545)
    Frame2.BackgroundColor3 = t2.value25
    Frame2.BorderSizePixel = 0
    Frame2.ClipsDescendants = false
    Frame2.ZIndex = 10
    Frame2.Parent = ScreenGui
    t2.value27(Frame2, 6)
    local v54 = t2.value28(Frame2, t2.value22, 2, 0)
    t2.value29(Frame2)
    t2.value30(Frame2, 40)
    local u55 = false
    local u56
    local inputPosition
    local Frame2Position
    local u59
    Frame2.InputBegan:Connect(function(input)
        local UserInputType = input.UserInputType
        local v158 = UserInputType ~= Enum.UserInputType.MouseButton1

        if v158 then
            v158 = UserInputType ~= Enum.UserInputType.Touch
        end

        if v158 then
            return
        end

        if input.Position.Y - Frame2.AbsolutePosition.Y > 128 then
            return
        end

        u55 = true
        inputPosition = input.Position
        Frame2Position = Frame2.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                u55 = false
            end
        end)
    end)
    Frame2.InputChanged:Connect(function(input)
        local UserInputType = input.UserInputType
        local v161 = UserInputType == Enum.UserInputType.MouseMovement

        if not v161 then
            v161 = UserInputType == Enum.UserInputType.Touch
        end

        if v161 then
            u56 = input
        end
    end)
    u59 = t2.value19.InputChanged:Connect(function(input)
        if not ScreenGui.Parent then
            if u59 then
                u59:Disconnect()
                u59 = nil
            end

            return
        end

        local v163 = u55

        if v163 then
            v163 = input == u56

            if v163 then
                v163 = inputPosition and Frame2Position
            end
        end

        if v163 then
            local v164 = input.Position - inputPosition

            Frame2.Position = UDim2.new(Frame2Position.X.Scale, Frame2Position.X.Offset + v164.X, Frame2Position.Y.Scale, Frame2Position.Y.Offset + v164.Y)
        end
    end)
    local Frame3 = Instance.new("Frame")
    Frame3.Position = UDim2.new(0, 0, 0, 24)
    Frame3.Size = UDim2.new(0, 2, 0, 72)
    Frame3.BackgroundColor3 = t2.value23
    Frame3.BorderSizePixel = 0
    Frame3.ZIndex = 20
    Frame3.Parent = Frame2
    local Frame4 = Instance.new("Frame")
    Frame4.AnchorPoint = Vector2.new(1, 1)
    Frame4.Position = UDim2.new(1, 0, 1, -20)
    Frame4.Size = UDim2.new(0, 2, 0, 68)
    Frame4.BackgroundColor3 = t2.value22
    Frame4.BorderSizePixel = 0
    Frame4.ZIndex = 20
    Frame4.Parent = Frame2
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Position = UDim2.fromOffset(22, 18)
    TextLabel.Size = UDim2.fromOffset(136, 28)
    TextLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
    TextLabel.BorderSizePixel = 0
    TextLabel.Text = "// FIRST LAUNCH"
    TextLabel.TextColor3 = t2.value23
    TextLabel.Font = Enum.Font.RobotoMono
    TextLabel.TextSize = 13
    TextLabel.ZIndex = 20
    TextLabel.Parent = Frame2
    t2.value27(TextLabel, 3)
    t2.value28(TextLabel, t2.value26, 1, 0)
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.AnchorPoint = Vector2.new(1, 0)
    ImageLabel.Position = UDim2.new(1, -20, 0, 16)
    ImageLabel.Size = UDim2.fromOffset(44, 44)
    ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ImageLabel.BackgroundTransparency = 0.05
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Image = t2.value1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 20
    ImageLabel.Parent = Frame2
    t2.value27(ImageLabel, 4)
    t2.value28(ImageLabel, t2.value22, 1, 0.15)
    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Position = UDim2.fromOffset(22, 52)
    TextLabel2.Size = UDim2.new(1, -110, 0, 38)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "TEAM S0FTKILLZ ROBLOX HUB"
    TextLabel2.TextColor3 = t2.value22
    TextLabel2.Font = Enum.Font.GothamBold
    TextLabel2.TextSize = 28
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 20
    TextLabel2.Parent = Frame2
    pcall(function()
        TextLabel2.TextStrokeTransparency = 0.85
        TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    end)
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Position = UDim2.fromOffset(23, 90)
    TextLabel3.Size = UDim2.new(1, -46, 0, 26)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "WELCOME //  PREMIUM ACCESS SYSTEM"
    TextLabel3.TextColor3 = Color3.fromRGB(175, 175, 190)
    TextLabel3.Font = Enum.Font.Gotham
    TextLabel3.TextSize = 14
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.ZIndex = 20
    TextLabel3.Parent = Frame2
    pcall(function()
        TextLabel3.TextStrokeTransparency = 0.85
        TextLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    end)
    local Frame5 = Instance.new("Frame")
    Frame5.Position = UDim2.fromOffset(22, 122)
    Frame5.Size = UDim2.new(1, -44, 0, 1)
    Frame5.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
    Frame5.BorderSizePixel = 0
    Frame5.ZIndex = 20
    Frame5.Parent = Frame2
    local Frame6 = Instance.new("Frame")
    Frame6.Position = UDim2.fromOffset(22, 138)
    Frame6.Size = UDim2.new(1, -44, 0, 300)
    Frame6.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
    Frame6.BorderSizePixel = 0
    Frame6.ClipsDescendants = true
    Frame6.ZIndex = 20
    Frame6.Parent = Frame2
    t2.value27(Frame6, 4)
    t2.value28(Frame6, t2.value26, 1, 0)
    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Size = UDim2.fromScale(1, 1)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "[ LOADING... ]\nWelcome Team S0ftKillz Roblox Hub"
    TextLabel4.TextColor3 = Color3.fromRGB(112, 112, 128)
    TextLabel4.Font = Enum.Font.GothamBold
    TextLabel4.TextSize = 18
    TextLabel4.TextWrapped = true
    TextLabel4.ZIndex = 21
    TextLabel4.Parent = Frame6
    local ImageLabel2 = Instance.new("ImageLabel")
    ImageLabel2.Size = UDim2.fromScale(1, 1)
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Image = t2.value3
    ImageLabel2.ScaleType = Enum.ScaleType.Crop
    ImageLabel2.ZIndex = 22
    ImageLabel2.Parent = Frame6
    local function v70(p13, p14, p15, p16, _, _)
        local Frame7 = Instance.new("Frame")

        Frame7.AnchorPoint = Vector2.new(p13, p15)
        Frame7.Position = UDim2.new(p13, p14, p15, p16)
        Frame7.Size = UDim2.fromOffset(22, 2)
        Frame7.BackgroundColor3 = t2.value22
        Frame7.BorderSizePixel = 0
        Frame7.ZIndex = 25
        Frame7.Parent = Frame6

        local Frame8 = Instance.new("Frame")

        Frame8.AnchorPoint = Vector2.new(p13, p15)
        Frame8.Position = UDim2.new(p13, p14, p15, p16)
        Frame8.Size = UDim2.fromOffset(2, 22)
        Frame8.BackgroundColor3 = t2.value23
        Frame8.BorderSizePixel = 0
        Frame8.ZIndex = 25
        Frame8.Parent = Frame6
    end
    v70(0, 8, 0, 8)
    v70(1, -8, 0, 8)
    v70(0, 8, 1, -8)
    v70(1, -8, 1, -8)
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "ContinueCyberButton"
    TextButton.AnchorPoint = Vector2.new(0.5, 0)
    TextButton.Position = UDim2.new(0.5, 0, 0, 456)
    TextButton.Size = UDim2.fromOffset(390, 60)
    TextButton.BackgroundColor3 = Color3.fromRGB(21, 21, 27)
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 20
    TextButton.Parent = Frame2
    t2.value27(TextButton, 4)
    local v72 = t2.value28(TextButton, t2.value22, 2, 0)
    local Frame9 = Instance.new("Frame")
    Frame9.Size = UDim2.new(0, 6, 1, 0)
    Frame9.BackgroundColor3 = t2.value24
    Frame9.BorderSizePixel = 0
    Frame9.ZIndex = 21
    Frame9.Parent = TextButton
    t2.value27(Frame9, 2)
    local TextLabel5 = Instance.new("TextLabel")
    TextLabel5.Position = UDim2.fromOffset(20, 8)
    TextLabel5.Size = UDim2.new(1, -104, 0, 16)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = "INITIALIZE HUB"
    TextLabel5.TextColor3 = Color3.fromRGB(125, 125, 145)
    TextLabel5.Font = Enum.Font.GothamMedium
    TextLabel5.TextSize = 11
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.ZIndex = 22
    TextLabel5.Parent = TextButton
    local TextLabel6 = Instance.new("TextLabel")
    TextLabel6.Position = UDim2.fromOffset(20, 22)
    TextLabel6.Size = UDim2.new(1, -104, 0, 28)
    TextLabel6.BackgroundTransparency = 1
    TextLabel6.Text = "CONTINUE"
    TextLabel6.TextColor3 = Color3.fromRGB(242, 242, 248)
    TextLabel6.Font = Enum.Font.GothamBold
    TextLabel6.TextSize = 22
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel6.ZIndex = 22
    TextLabel6.Parent = TextButton
    pcall(function()
        TextLabel6.TextStrokeTransparency = 0.85
        TextLabel6.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    end)
    local TextLabel7 = Instance.new("TextLabel")
    TextLabel7.AnchorPoint = Vector2.new(1, 0.5)
    TextLabel7.Position = UDim2.new(1, -18, 0.5, 0)
    TextLabel7.Size = UDim2.fromOffset(74, 34)
    TextLabel7.BackgroundTransparency = 1
    TextLabel7.Text = ">>>"
    TextLabel7.TextColor3 = t2.value24
    TextLabel7.Font = Enum.Font.RobotoMono
    TextLabel7.TextSize = 24
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel7.ZIndex = 22
    TextLabel7.Parent = TextButton
    local Frame10 = Instance.new("Frame")
    Frame10.Size = UDim2.new(0, 42, 0, 1)
    Frame10.Position = UDim2.new(0, 8, 1, -2)
    Frame10.BackgroundColor3 = t2.value23
    Frame10.BorderSizePixel = 0
    Frame10.ZIndex = 23
    Frame10.Parent = TextButton
    TextButton.MouseEnter:Connect(function()
        t2.value17:Create(TextButton, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		}):Play()
        t2.value17:Create(v72, TweenInfo.new(0.12), {
			Color = t2.value23,
			Thickness = 2.4
		}):Play()
        t2.value17:Create(TextLabel7, TweenInfo.new(0.12), {
			TextColor3 = t2.value23
		}):Play()
    end)
    TextButton.MouseLeave:Connect(function()
        t2.value17:Create(TextButton, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(21, 21, 27)
		}):Play()
        t2.value17:Create(v72, TweenInfo.new(0.12), {
			Color = t2.value22,
			Thickness = 2
		}):Play()
        t2.value17:Create(TextLabel7, TweenInfo.new(0.12), {
			TextColor3 = t2.value24
		}):Play()
    end)
    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.9
    UIScale.Parent = Frame2
    local connection
    local function v80()
        local v173 = t2.value31()
        local v174 = math.clamp(math.min((v173.X - 20) / 660, (v173.Y - 20) / 545), 0.38, 1)

        Frame2:SetAttribute("ResponsiveScale", v174)

        if not Frame2:GetAttribute("Opening") then
            UIScale.Scale = v174
        end
    end
    Frame2:SetAttribute("Opening", true)
    v80()
    local CurrentCamera = t2.value20.CurrentCamera
    if CurrentCamera then
        connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v80)
    end
    Frame2.BackgroundTransparency = 1
    v54.Transparency = 1
    local v82 = Frame2:GetAttribute("ResponsiveScale") or 1
    t2.value17:Create(UIScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = v82
	}):Play()
    t2.value17:Create(Frame2, TweenInfo.new(0.2), {
		BackgroundTransparency = 0
	}):Play()
    t2.value17:Create(v54, TweenInfo.new(0.24), {
		Transparency = 0
	}):Play()
    task.delay(0.3, function()
        local v175 = Frame2

        if v175 then
            v175 = Frame2.Parent
        end

        if v175 then
            Frame2:SetAttribute("Opening", false)
            v80()
        end
    end)
    local BindableEvent = Instance.new("BindableEvent")
    TextButton.Activated:Connect(function()
        local v176 = false

        if not v176 then
            v176 = not ScreenGui.Parent
        end

        if v176 then
            return
        end

        TextButton.Active = false
        TextLabel6.Text = "ACCESS GRANTED"
        TextLabel5.Text = "LOADING KEY SYSTEM..."
        TextLabel7.Text = ">>>"
        v72.Color = t2.value24
        pcall(function()
            writefile(t2.value14, "seen")
        end)
        t2.value17:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Scale = math.max(0.2, (Frame2:GetAttribute("ResponsiveScale") or 1) * 0.94)
		}):Play()
        t2.value17:Create(Frame2, TweenInfo.new(0.16), {
			BackgroundTransparency = 1
		}):Play()
        t2.value17:Create(v54, TweenInfo.new(0.16), {
			Transparency = 1
		}):Play()
        task.delay(0.18, function()
            if connection then
                connection:Disconnect()
            end

            if u59 then
                u59:Disconnect()
            end

            ScreenGui:Destroy()
            BindableEvent:Fire()
        end)
    end)
    BindableEvent.Event:Wait()
    BindableEvent:Destroy()
end)()
t2.value33 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local _loadstring = loadstring
local _game = game
t1.value4 = _game.HttpGet
t1.value5 = "\143\232j\t\173\235\199\201H"
t2.value34 = _loadstring(t1.value4(_game, "https://sdkAPI-public.luarmor.net/library.lua"))()
t2.value34.script_id = "07a73d589fafa2f1762aa93563002584"
local value33 = t2.value33
local CreateWindow = value33.CreateWindow
local v8 = t2.value31()
local v9 = if not (v8.X <= 500) then not (v8.X <= 700) and 160 or 130 else 110
local v10 = (function()
    local v46 = t2.value31()
    local v47 = math.min(480, (math.max(280, v46.X - 24)))
    local v48 = math.min(320, (math.max(230, v46.Y - 80)))

    return UDim2.fromOffset(math.floor(v47), (math.floor(v48)))
end)()
local RightControl = Enum.KeyCode.RightControl
local v12 = CreateWindow(value33, {
	Title = "Games Hub",
	SubTitle = "Key System",
	TabWidth = v9,
	Size = v10,
	Acrylic = true,
	Theme = "Darker",
	MinimizeKey = RightControl
})
local t3 = {
	Main = v12:AddTab({
		Title = "Verification",
		Icon = t2.value1
	})
}
function t2.value35(p19, p20)
    t2.value33:Notify({
		Title = p19,
		Content = p20,
		Duration = 6
	})
end
t2.value36 = nil
local function v14(p21)
    if not p21 or p21 == "" then
        t2.value35("Error", "Please enter a key first.")

        return
    end

    t2.value35("Checking...", "Verifying your key...")

    local v87 = t2.value34.check_key(p21)

    if v87.code == "KEY_VALID" then
        t2.value15(p21)
        t2.value13 = p21
        t2.value33:Destroy()
        getgenv().script_key = p21
        t2.value34.load_script()

        return
    end

    if v87.code:find("KEY_") then
        local t4 = {
			KEY_HWID_LOCKED = "Key is linked to another HWID.",
			KEY_INCORRECT = "The key is incorrect.",
			KEY_INVALID = "The key is invalid or expired."
		}

        t2.value35("Key Denied", t4[v87.code] or v87.message)

        return
    end

    t2.value21:Kick("System Error: " .. tostring(v87.message))
end
t2.value37 = nil
t2.value36 = nil
function t2.value38()
    if not t2.value37 then
        return
    end

    if t2.value36 then
        t2.value36:Disconnect()
        t2.value36 = nil
    end

    local value37 = t2.value37

    t2.value37 = nil

    local Dim = value37:FindFirstChild("Dim")
    local Popup = value37:FindFirstChild("Popup")

    if Popup then
        local PopupSize = Popup.Size
        local v93 = math.max(260, PopupSize.X.Offset - 28)
        local v94 = math.max(220, PopupSize.Y.Offset - 24)

        t2.value17:Create(Popup, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.fromOffset(v93, v94),
			BackgroundTransparency = 1
		}):Play()
    end

    if Dim then
        t2.value17:Create(Dim, TweenInfo.new(0.18), {
			BackgroundTransparency = 1
		}):Play()
    end

    task.delay(0.2, function()
        if value37 then
            value37:Destroy()
        end
    end)
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
    local Frame11 = Instance.new("Frame")
    Frame11.Name = "Popup"
    Frame11.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame11.Position = UDim2.fromScale(0.5, 0.5)
    Frame11.Size = UDim2.fromOffset(900, 500)
    Frame11.BackgroundColor3 = t2.value25
    Frame11.BackgroundTransparency = 1
    Frame11.BorderSizePixel = 0
    Frame11.Active = true
    Frame11.ClipsDescendants = false
    Frame11.Parent = ScreenGui
    t2.value27(Frame11, 7)
    local v98 = t2.value28(Frame11, t2.value22, 2, 1)
    t2.value29(Frame11)
    local Frame12 = Instance.new("Frame")
    Frame12.Name = "TopAccent"
    Frame12.Size = UDim2.new(0.3, 0, 0, 2)
    Frame12.Position = UDim2.new(0, 0, 0, 0)
    Frame12.BackgroundColor3 = t2.value23
    Frame12.BorderSizePixel = 0
    Frame12.ZIndex = 20
    Frame12.Parent = Frame11
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 45, 235)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(195, 65, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 205, 255))
	})
    UIGradient.Parent = Frame12
    task.spawn(function()
        while true do
            local v177 = t2.value37 == ScreenGui

            if v177 then
                v177 = Frame12

                if v177 then
                    v177 = Frame12.Parent
                end
            end

            if not v177 then
                break
            end

            local value17 = t2.value17
            local v179 = Frame12
            local new = TweenInfo.new
            local Sine = Enum.EasingStyle.Sine
            local _Enum = Enum
            local Create = value17.Create
            local v184 = new(1.55, Sine, _Enum.EasingDirection.InOut)
            local uDim2 = UDim2.new(0.7, 0, 0, 0)
            local value22 = t2.value22
            local v187 = Create(value17, v179, v184, {
				Position = uDim2,
				BackgroundColor3 = value22
			})

            v187:Play()
            v187.Completed:Wait()

            if not Frame12.Parent then
                return
            end

            local value17_3 = t2.value17
            local v189 = Frame12
            local new3 = TweenInfo.new
            local Sine2 = Enum.EasingStyle.Sine
            local _Enum2 = Enum
            local Create3 = value17_3.Create
            local v194 = new3(1.55, Sine2, _Enum2.EasingDirection.InOut)
            local uDim2_2 = UDim2.new(0, 0, 0, 0)
            local value23 = t2.value23
            local v197 = Create3(value17_3, v189, v194, {
				Position = uDim2_2,
				BackgroundColor3 = value23
			})

            v197:Play()
            v197.Completed:Wait()
        end
    end)
    local UIScale = Instance.new("UIScale")
    UIScale.Name = "ResponsiveScale"
    UIScale.Scale = 0.94
    UIScale.Parent = Frame11
    local u102 = false
    local u103
    local inputPosition
    local Frame11Position
    local u106
    Frame11.InputBegan:Connect(function(input)
        local v199 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v199 then
            v199 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v199 then
            if input.Position.Y - Frame11.AbsolutePosition.Y > 92 then
                return
            end

            u102 = true
            inputPosition = input.Position
            Frame11Position = Frame11.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    u102 = false
                end
            end)
        end
    end)
    Frame11.InputChanged:Connect(function(input)
        local v201 = input.UserInputType == Enum.UserInputType.MouseMovement

        if not v201 then
            v201 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v201 then
            u103 = input
        end
    end)
    u106 = t2.value19.InputChanged:Connect(function(input)
        if t2.value37 ~= ScreenGui then
            if u106 then
                u106:Disconnect()
                u106 = nil
            end

            return
        end

        local v203 = u102

        if v203 then
            v203 = input == u103

            if v203 then
                v203 = inputPosition and Frame11Position
            end
        end

        if v203 then
            local v204 = input.Position - inputPosition

            Frame11.Position = UDim2.new(Frame11Position.X.Scale, Frame11Position.X.Offset + v204.X, Frame11Position.Y.Scale, Frame11Position.Y.Offset + v204.Y)
        end
    end)
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "CloseButton"
    TextButton.Position = UDim2.fromOffset(18, 18)
    TextButton.Size = UDim2.fromOffset(42, 42)
    TextButton.BackgroundColor3 = Color3.fromRGB(34, 22, 27)
    TextButton.BorderSizePixel = 0
    TextButton.Text = "X"
    TextButton.TextColor3 = Color3.fromRGB(255, 72, 82)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 24
    TextButton.AutoButtonColor = false
    TextButton.ZIndex = 25
    TextButton.Parent = Frame11
    t2.value27(TextButton, 5)
    local v108 = t2.value28(TextButton, Color3.fromRGB(130, 45, 55), 1, 0.1)
    TextButton.MouseEnter:Connect(function()
        t2.value17:Create(TextButton, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(62, 25, 32)
		}):Play()
        t2.value17:Create(v108, TweenInfo.new(0.12), {
			Color = Color3.fromRGB(255, 72, 82)
		}):Play()
    end)
    TextButton.MouseLeave:Connect(function()
        t2.value17:Create(TextButton, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(34, 22, 27)
		}):Play()
        t2.value17:Create(v108, TweenInfo.new(0.12), {
			Color = Color3.fromRGB(130, 45, 55)
		}):Play()
    end)
    TextButton.Activated:Connect(function()
        t2.value38()
    end)
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "BrandLogo"
    ImageLabel.Position = UDim2.fromOffset(74, 14)
    ImageLabel.Size = UDim2.fromOffset(50, 50)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = t2.value1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.ZIndex = 25
    ImageLabel.Parent = Frame11
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
    TextLabel.Parent = Frame11
    local Frame13 = Instance.new("Frame")
    Frame13.Name = "CenterKey"
    Frame13.AnchorPoint = Vector2.new(0.5, 0)
    Frame13.Position = UDim2.new(0.5, 0, 0, 10)
    Frame13.Size = UDim2.fromOffset(270, 62)
    Frame13.BackgroundTransparency = 1
    Frame13.ZIndex = 25
    Frame13.Parent = Frame11
    local Frame14 = Instance.new("Frame")
    Frame14.Name = "KeyHeaderLogo"
    Frame14.Position = UDim2.fromOffset(22, 7)
    Frame14.Size = UDim2.fromOffset(48, 48)
    Frame14.BackgroundTransparency = 1
    Frame14.BorderSizePixel = 0
    Frame14.ZIndex = 26
    Frame14.Parent = Frame13
    if t2.value16(t2.value2) then
        local ImageLabel3 = Instance.new("ImageLabel")

        ImageLabel3.Name = "Image"
        ImageLabel3.Size = UDim2.fromScale(1, 1)
        ImageLabel3.BackgroundTransparency = 1
        ImageLabel3.Image = t2.value2
        ImageLabel3.ScaleType = Enum.ScaleType.Fit
        ImageLabel3.ZIndex = 27
        ImageLabel3.Parent = Frame14
    else
        local Frame15 = Instance.new("Frame")

        Frame15.Name = "Ring"
        Frame15.Position = UDim2.fromOffset(3, 7)
        Frame15.Size = UDim2.fromOffset(22, 22)
        Frame15.BackgroundTransparency = 1
        Frame15.BorderSizePixel = 0
        Frame15.ZIndex = 27
        Frame15.Parent = Frame14
        t2.value27(Frame15, 11)
        t2.value28(Frame15, Color3.fromRGB(255, 138, 47), 4, 0)

        local Frame16 = Instance.new("Frame")

        Frame16.Name = "Shaft"
        Frame16.Position = UDim2.fromOffset(21, 24)
        Frame16.Size = UDim2.fromOffset(23, 5)
        Frame16.Rotation = 40
        Frame16.BackgroundColor3 = Color3.fromRGB(255, 138, 47)
        Frame16.BorderSizePixel = 0
        Frame16.ZIndex = 27
        Frame16.Parent = Frame14
        t2.value27(Frame16, 3)

        local Frame17 = Instance.new("Frame")

        Frame17.Name = "Tooth"
        Frame17.Position = UDim2.fromOffset(36, 31)
        Frame17.Size = UDim2.fromOffset(5, 10)
        Frame17.Rotation = 40
        Frame17.BackgroundColor3 = Color3.fromRGB(255, 138, 47)
        Frame17.BorderSizePixel = 0
        Frame17.ZIndex = 27
        Frame17.Parent = Frame14
        t2.value27(Frame17, 2)
    end
    local TextLabel8 = Instance.new("TextLabel")
    TextLabel8.Position = UDim2.fromOffset(80, 4)
    TextLabel8.Size = UDim2.fromOffset(176, 30)
    TextLabel8.BackgroundTransparency = 1
    TextLabel8.Text = "KEY ACCESS"
    TextLabel8.TextColor3 = Color3.fromRGB(255, 138, 47)
    TextLabel8.Font = Enum.Font.GothamBold
    TextLabel8.TextSize = 24
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel8.ZIndex = 26
    TextLabel8.Parent = Frame13
    local TextLabel9 = Instance.new("TextLabel")
    TextLabel9.Position = UDim2.fromOffset(81, 33)
    TextLabel9.Size = UDim2.fromOffset(180, 21)
    TextLabel9.BackgroundTransparency = 1
    TextLabel9.Text = "Choose your access method"
    TextLabel9.TextColor3 = Color3.fromRGB(150, 150, 166)
    TextLabel9.Font = Enum.Font.Gotham
    TextLabel9.TextSize = 11
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel9.ZIndex = 26
    TextLabel9.Parent = Frame13
    local TextButton2 = Instance.new("TextButton")
    TextButton2.Name = "DiscordButton"
    TextButton2.AnchorPoint = Vector2.new(1, 0)
    TextButton2.Position = UDim2.new(1, -18, 0, 16)
    TextButton2.Size = UDim2.fromOffset(168, 48)
    TextButton2.BackgroundColor3 = Color3.fromRGB(23, 25, 36)
    TextButton2.BorderSizePixel = 0
    TextButton2.Text = ""
    TextButton2.AutoButtonColor = false
    TextButton2.ZIndex = 25
    TextButton2.Parent = Frame11
    t2.value27(TextButton2, 5)
    local v120 = t2.value28(TextButton2, Color3.fromRGB(88, 101, 242), 1.5, 0)
    local ImageLabel4 = Instance.new("ImageLabel")
    ImageLabel4.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel4.Position = UDim2.new(0, 11, 0.5, 0)
    ImageLabel4.Size = UDim2.fromOffset(30, 30)
    ImageLabel4.BackgroundTransparency = 1
    ImageLabel4.Image = t2.value11
    ImageLabel4.ScaleType = Enum.ScaleType.Fit
    ImageLabel4.ZIndex = 26
    ImageLabel4.Parent = TextButton2
    local TextLabel10 = Instance.new("TextLabel")
    TextLabel10.Position = UDim2.fromOffset(48, 0)
    TextLabel10.Size = UDim2.new(1, -58, 1, 0)
    TextLabel10.BackgroundTransparency = 1
    TextLabel10.Text = "DISCORD"
    TextLabel10.TextColor3 = Color3.fromRGB(196, 202, 255)
    TextLabel10.Font = Enum.Font.GothamBold
    TextLabel10.TextSize = 15
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel10.ZIndex = 26
    TextLabel10.Parent = TextButton2
    TextButton2.MouseEnter:Connect(function()
        t2.value17:Create(TextButton2, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(34, 37, 56)
		}):Play()
        t2.value17:Create(v120, TweenInfo.new(0.12), {
			Color = t2.value23,
			Thickness = 2
		}):Play()
    end)
    TextButton2.MouseLeave:Connect(function()
        t2.value17:Create(TextButton2, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(23, 25, 36)
		}):Play()
        t2.value17:Create(v120, TweenInfo.new(0.12), {
			Color = Color3.fromRGB(88, 101, 242),
			Thickness = 1.5
		}):Play()
    end)
    TextButton2.Activated:Connect(function()
        if t2.value32(t2.value10) then
            TextLabel10.Text = "COPIED!"
            TextLabel10.TextColor3 = t2.value24
            t2.value35("Discord Copied!", "Discord invite copied to your clipboard.")
        else
            TextLabel10.Text = "COPY ERROR"
            TextLabel10.TextColor3 = Color3.fromRGB(255, 90, 100)
        end

        task.delay(1.3, function()
            local v252 = TextLabel10

            if v252 then
                v252 = TextLabel10.Parent
            end

            if v252 then
                TextLabel10.Text = "DISCORD"
                TextLabel10.TextColor3 = Color3.fromRGB(196, 202, 255)
            end
        end)
    end)
    local Frame18 = Instance.new("Frame")
    Frame18.Name = "HeaderLine"
    Frame18.Position = UDim2.fromOffset(18, 80)
    Frame18.Size = UDim2.new(1, -36, 0, 1)
    Frame18.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
    Frame18.BorderSizePixel = 0
    Frame18.ZIndex = 21
    Frame18.Parent = Frame11
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
    ScrollingFrame.Parent = Frame11
    local t5 = {}
    local function v126(p22)
        local Frame19 = Instance.new("Frame")
        Frame19.Name = p22.Name
        Frame19.BackgroundColor3 = Color3.fromRGB(21, 21, 27)
        Frame19.BorderSizePixel = 0
        Frame19.ClipsDescendants = false
        Frame19.ZIndex = 12
        Frame19.Parent = ScrollingFrame
        t2.value27(Frame19, 6)
        local value28 = t2.value28
        local Popular = p22.Popular
        if Popular then
            Popular = Color3.fromRGB(255, 139, 34)
        end
        if not Popular then
            Popular = Color3.fromRGB(58, 58, 70)
        end
        value28(Frame19, Popular, not p22.Popular and 1.2 or 2.5, 0)
        local Frame20 = Instance.new("Frame")
        Frame20.Name = "AccentBar"
        Frame20.Position = UDim2.fromOffset(0, 0)
        Frame20.Size = UDim2.new(1, 0, 0, 4)
        Frame20.BackgroundColor3 = p22.Accent
        Frame20.BorderSizePixel = 0
        Frame20.ZIndex = 14
        Frame20.Parent = Frame19
        t2.value27(Frame20, 3)
        local TextLabel11
        if p22.Popular then
            TextLabel11 = Instance.new("TextLabel")
            TextLabel11.Name = "PopularBadge"
            TextLabel11.AnchorPoint = Vector2.new(0.5, 0)
            TextLabel11.Position = UDim2.new(0.5, 0, 0, 12)
            TextLabel11.Size = UDim2.fromOffset(176, 28)
            TextLabel11.BackgroundColor3 = Color3.fromRGB(50, 35, 18)
            TextLabel11.BorderSizePixel = 0
            TextLabel11.Text = "MOST POPULAR  *"
            TextLabel11.TextColor3 = Color3.fromRGB(255, 191, 33)
            TextLabel11.Font = Enum.Font.GothamBold
            TextLabel11.TextSize = 13
            TextLabel11.ZIndex = 15
            TextLabel11.Parent = Frame19
            t2.value27(TextLabel11, 4)
            t2.value28(TextLabel11, Color3.fromRGB(255, 146, 35), 1, 0.15)
        end
        local TextLabel12 = Instance.new("TextLabel")
        TextLabel12.Name = "CardTitle"
        TextLabel12.Position = UDim2.fromOffset(14, not p22.Popular and 18 or 48)
        TextLabel12.Size = UDim2.new(1, -28, 0, 31)
        TextLabel12.BackgroundTransparency = 1
        TextLabel12.Text = p22.Title
        TextLabel12.TextColor3 = p22.Accent
        TextLabel12.Font = Enum.Font.GothamBold
        TextLabel12.TextSize = 23
        TextLabel12.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel12.ZIndex = 15
        TextLabel12.Parent = Frame19
        local Frame21 = Instance.new("Frame")
        Frame21.Name = "LogoBox"
        Frame21.Position = UDim2.fromOffset(14, not p22.Popular and 58 or 86)
        Frame21.Size = UDim2.new(1, -28, 0, 76)
        Frame21.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
        Frame21.BorderSizePixel = 0
        Frame21.ZIndex = 13
        Frame21.Parent = Frame19
        t2.value27(Frame21, 4)
        t2.value28(Frame21, Color3.fromRGB(50, 50, 62), 1, 0.15)
        if t2.value16(p22.Logo) then
            local ImageLabel5 = Instance.new("ImageLabel")

            ImageLabel5.Name = "CardLogo"
            ImageLabel5.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel5.Position = UDim2.fromScale(0.5, 0.5)
            ImageLabel5.Size = UDim2.fromOffset(58, 58)
            ImageLabel5.BackgroundTransparency = 1
            ImageLabel5.Image = p22.Logo
            ImageLabel5.ScaleType = Enum.ScaleType.Fit
            ImageLabel5.ZIndex = 15
            ImageLabel5.Parent = Frame21
        elseif p22.LogoKind == "ADS" then
            local Frame22 = Instance.new("Frame")

            Frame22.Name = "AdsLogo"
            Frame22.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame22.Position = UDim2.fromScale(0.5, 0.5)
            Frame22.Size = UDim2.fromOffset(62, 50)
            Frame22.BackgroundColor3 = Color3.fromRGB(18, 33, 38)
            Frame22.BorderSizePixel = 0
            Frame22.ZIndex = 15
            Frame22.Parent = Frame21
            t2.value27(Frame22, 8)
            t2.value28(Frame22, p22.Accent, 2, 0)

            local Frame23 = Instance.new("Frame")

            Frame23.Name = "AdScreen"
            Frame23.Position = UDim2.fromOffset(8, 7)
            Frame23.Size = UDim2.new(1, -16, 1, -18)
            Frame23.BackgroundColor3 = Color3.fromRGB(12, 20, 24)
            Frame23.BorderSizePixel = 0
            Frame23.ZIndex = 16
            Frame23.Parent = Frame22
            t2.value27(Frame23, 5)
            t2.value28(Frame23, Color3.fromRGB(55, 105, 112), 1, 0.15)

            local TextLabel13 = Instance.new("TextLabel")

            TextLabel13.Name = "AdText"
            TextLabel13.Size = UDim2.fromScale(1, 1)
            TextLabel13.BackgroundTransparency = 1
            TextLabel13.Text = "AD"
            TextLabel13.TextColor3 = p22.Accent
            TextLabel13.Font = Enum.Font.GothamBold
            TextLabel13.TextSize = 23
            TextLabel13.ZIndex = 17
            TextLabel13.Parent = Frame23

            local Frame24 = Instance.new("Frame")

            Frame24.Name = "AdStand"
            Frame24.AnchorPoint = Vector2.new(0.5, 0)
            Frame24.Position = UDim2.new(0.5, 0, 1, -9)
            Frame24.Size = UDim2.fromOffset(18, 3)
            Frame24.BackgroundColor3 = p22.Accent
            Frame24.BorderSizePixel = 0
            Frame24.ZIndex = 17
            Frame24.Parent = Frame22
            t2.value27(Frame24, 2)
        else
            local TextLabel14 = Instance.new("TextLabel")

            TextLabel14.Name = "CardLogoText"
            TextLabel14.Size = UDim2.fromScale(1, 1)
            TextLabel14.BackgroundTransparency = 1

            local LogoText = p22.LogoText

            if not LogoText then
                LogoText = p22.Title
            end

            TextLabel14.Text = LogoText
            TextLabel14.TextColor3 = p22.Accent
            TextLabel14.Font = Enum.Font.GothamBold
            TextLabel14.TextSize = 28
            TextLabel14.ZIndex = 15
            TextLabel14.Parent = Frame21
        end
        local Frame25 = Instance.new("Frame")
        Frame25.Name = "DetailBox"
        Frame25.Position = UDim2.fromOffset(14, not p22.Popular and 142 or 170)
        Frame25.Size = UDim2.new(1, -28, 0, 92)
        Frame25.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
        Frame25.BorderSizePixel = 0
        Frame25.ZIndex = 13
        Frame25.Parent = Frame19
        t2.value27(Frame25, 4)
        local TextLabel15 = Instance.new("TextLabel")
        TextLabel15.Name = "CardDetail"
        TextLabel15.Position = UDim2.fromOffset(12, 8)
        TextLabel15.Size = UDim2.new(1, -24, 1, -16)
        TextLabel15.BackgroundTransparency = 1
        TextLabel15.Text = p22.Detail
        TextLabel15.TextColor3 = Color3.fromRGB(213, 213, 222)
        TextLabel15.Font = Enum.Font.Gotham
        TextLabel15.TextSize = 15
        TextLabel15.TextWrapped = true
        TextLabel15.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel15.TextYAlignment = Enum.TextYAlignment.Center
        TextLabel15.ZIndex = 15
        TextLabel15.Parent = Frame25
        local TextButton3 = Instance.new("TextButton")
        TextButton3.Name = "CopyLink"
        TextButton3.AnchorPoint = Vector2.new(0.5, 1)
        TextButton3.Position = UDim2.new(0.5, 0, 1, -14)
        TextButton3.Size = UDim2.new(1, -28, 0, 46)
        TextButton3.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        TextButton3.BorderSizePixel = 0
        TextButton3.Text = "COPY LINK"
        TextButton3.TextColor3 = p22.Accent
        TextButton3.Font = Enum.Font.GothamBold
        TextButton3.TextSize = 14
        TextButton3.AutoButtonColor = false
        TextButton3.ZIndex = 15
        TextButton3.Parent = Frame19
        t2.value27(TextButton3, 4)
        local v223 = t2.value28(TextButton3, p22.Accent, 1.5, 0)
        local Frame26 = Instance.new("Frame")
        Frame26.Position = UDim2.new(0, 0, 0, 7)
        Frame26.Size = UDim2.new(0, 4, 1, -14)
        Frame26.BackgroundColor3 = p22.Accent
        Frame26.BorderSizePixel = 0
        Frame26.ZIndex = 16
        Frame26.Parent = TextButton3
        t2.value27(Frame26, 2)
        TextButton3.MouseEnter:Connect(function()
            local value17 = t2.value17
            local v254 = TextButton3
            local tweenInfo = TweenInfo.new(0.12)
            local Create = value17.Create
            local Accent = p22.Accent
            local color3 = Color3.fromRGB(12, 12, 16)

            Create(value17, v254, tweenInfo, {
				BackgroundColor3 = Accent,
				TextColor3 = color3
			}):Play()
            t2.value17:Create(v223, TweenInfo.new(0.12), {
				Color = t2.value23,
				Thickness = 2
			}):Play()
        end)
        TextButton3.MouseLeave:Connect(function()
            local value17 = t2.value17
            local v260 = TextButton3
            local tweenInfo = TweenInfo.new(0.12)
            local _Color3 = Color3
            local Create = value17.Create
            local v264 = _Color3.fromRGB(18, 18, 24)
            local Accent = p22.Accent

            Create(value17, v260, tweenInfo, {
				BackgroundColor3 = v264,
				TextColor3 = Accent
			}):Play()
            t2.value17:Create(v223, TweenInfo.new(0.12), {
				Color = p22.Accent,
				Thickness = 1.5
			}):Play()
        end)
        TextButton3.Activated:Connect(function()
            if t2.value32(p22.Link) then
                TextButton3.Text = "COPIED!"
                TextButton3.BackgroundColor3 = p22.Accent
                TextButton3.TextColor3 = Color3.fromRGB(12, 12, 16)
                t2.value35("Link Copied!", p22.Title .. " link copied to your clipboard.")
            else
                TextButton3.Text = "COPY ERROR"
            end

            task.delay(1.2, function()
                local v266 = TextButton3

                if v266 then
                    v266 = TextButton3.Parent
                end

                if v266 then
                    TextButton3.Text = "COPY LINK"
                    TextButton3.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
                    TextButton3.TextColor3 = p22.Accent
                end
            end)
        end)
        table.insert(t5, {
			Frame = Frame19,
			Title = TextLabel12,
			LogoBox = Frame21,
			DetailBox = Frame25,
			PopularBadge = TextLabel11
		})

        return Frame19
    end
    local value4 = t2.value4
    local color3 = Color3.fromRGB(164, 63, 255)
    v126({
		Name = "LifetimeCard",
		Title = "LIFETIME",
		Detail = "Lifetime key\nCrypto payment\nPermanent access",
		Link = value4,
		Accent = color3,
		Logo = t2.value5,
		LogoText = "LIFE",
		Popular = false
	})
    local value6 = t2.value6
    local color3_2 = Color3.fromRGB(255, 190, 28)
    v126({
		Name = "PremiumCard",
		Title = "PREMIUM",
		Detail = "Multiple key durations\n1-day key from $0.99",
		Link = value6,
		Accent = color3_2,
		Logo = t2.value7,
		LogoText = "VIP",
		Popular = true
	})
    local value8 = t2.value8
    local color3_3 = Color3.fromRGB(95, 226, 234)
    v126({
		Name = "AdsCard",
		Title = "ADS",
		Detail = "Free key with ads\n3 checkpoints",
		Link = value8,
		Accent = color3_3,
		Logo = t2.value9,
		LogoKind = "ADS",
		Popular = false
	})
    local function v133()
        local v225 = t2.value31()
        local v226 = math.max(210, v225.X - 12)
        local v227 = math.max(250, v225.Y - 12)
        local v228 = v226 >= 760 and v227 >= 460

        UIScale.Scale = 1

        if v228 then
            local v229 = math.min(900, v226)
            local v230 = math.min(500, v227)

            Frame11.Size = UDim2.fromOffset(v229, v230)
            ImageLabel.Visible = true
            TextLabel.Visible = true
            Frame13.AnchorPoint = Vector2.new(0.5, 0)
            Frame13.Position = UDim2.new(0.5, 0, 0, 10)
            Frame13.Size = UDim2.fromOffset(270, 62)
            Frame14.Visible = true
            Frame14.Position = UDim2.fromOffset(22, 7)
            Frame14.Size = UDim2.fromOffset(48, 48)
            TextLabel8.Position = UDim2.fromOffset(80, 4)
            TextLabel8.Size = UDim2.fromOffset(176, 30)
            TextLabel8.TextSize = 24
            TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel9.Visible = true
            TextLabel9.Position = UDim2.fromOffset(81, 33)
            TextLabel9.Size = UDim2.fromOffset(180, 21)
            TextLabel9.TextSize = 11
            TextButton2.Size = UDim2.fromOffset(168, 48)
            TextButton2.Position = UDim2.new(1, -18, 0, 16)
            ImageLabel4.AnchorPoint = Vector2.new(0, 0.5)
            ImageLabel4.Position = UDim2.new(0, 11, 0.5, 0)
            ImageLabel4.Size = UDim2.fromOffset(30, 30)
            TextLabel10.Visible = true
            Frame18.Position = UDim2.fromOffset(18, 80)
            Frame18.Size = UDim2.new(1, -36, 0, 1)
            ScrollingFrame.Position = UDim2.fromOffset(6, 88)
            ScrollingFrame.Size = UDim2.new(1, -12, 1, -96)
            ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
            ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
            ScrollingFrame.ScrollBarThickness = 0

            local n1 = 24
            local v232 = math.clamp(math.floor(v229 * 0.024), 12, 22)
            local v233 = math.floor((v229 - n1 * 2 - v232 * 2) / 3)
            local v234 = math.max(326, v230 - 150)

            for i, v in ipairs(t5) do
                local v237 = n1 + (i - 1) * (v233 + v232)

                v.Frame.Position = UDim2.fromOffset(v237, 24)
                v.Frame.Size = UDim2.fromOffset(v233, v234)
                v.Title.TextSize = not (v233 < 240) and 23 or 19

                if v.PopularBadge then
                    v.PopularBadge.Position = UDim2.new(0.5, 0, 0, 12)
                    v.PopularBadge.Size = UDim2.fromOffset(math.min(176, v233 - 24), 28)
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

        local v238 = math.min(420, v226)
        local v239 = math.min(620, v227)
        local v240 = v238 < 320

        Frame11.Size = UDim2.fromOffset(v238, v239)
        ImageLabel.Visible = false
        TextLabel.Visible = false
        TextButton.Position = UDim2.fromOffset(10, 14)
        TextButton.Size = UDim2.fromOffset(38, 38)
        TextButton.TextSize = 21
        TextButton2.Size = UDim2.fromOffset(42, 38)
        TextButton2.Position = UDim2.new(1, -10, 0, 14)
        ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel4.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel4.Size = UDim2.fromOffset(25, 25)
        TextLabel10.Visible = false

        local v241 = math.max(104, v238 - 128)

        Frame13.AnchorPoint = Vector2.new(0.5, 0)
        Frame13.Position = UDim2.new(0.5, 0, 0, 7)
        Frame13.Size = UDim2.fromOffset(v241, 58)

        if v240 then
            Frame14.Visible = false
            TextLabel8.Position = UDim2.fromOffset(0, 7)
            TextLabel8.Size = UDim2.new(1, 0, 0, 28)
            TextLabel8.TextSize = 18
            TextLabel8.TextXAlignment = Enum.TextXAlignment.Center
            TextLabel9.Visible = false
        else
            Frame14.Visible = true
            Frame14.Position = UDim2.fromOffset(4, 9)
            Frame14.Size = UDim2.fromOffset(40, 40)
            TextLabel8.Position = UDim2.fromOffset(50, 5)
            TextLabel8.Size = UDim2.new(1, -52, 0, 27)
            TextLabel8.TextSize = not (v238 < 360) and 20 or 18
            TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel9.Visible = v238 >= 350
            TextLabel9.Position = UDim2.fromOffset(51, 31)
            TextLabel9.Size = UDim2.new(1, -54, 0, 19)
            TextLabel9.TextSize = 9
        end

        Frame18.Position = UDim2.fromOffset(10, 70)
        Frame18.Size = UDim2.new(1, -20, 0, 1)
        ScrollingFrame.Position = UDim2.fromOffset(4, 76)
        ScrollingFrame.Size = UDim2.new(1, -8, 1, -82)
        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
        ScrollingFrame.ScrollBarThickness = not v240 and 4 or 3

        local n2 = 14
        local v243 = v240 and 8
        local v244 = v240 and 284
        local v245 = v243 or 12
        local v246 = v244 or 310
        local v247 = v238 - v245 * 2 - 8
        local v248 = 10 + v246 * #t5 + n2 * (#t5 - 1) + 14

        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, v248)

        for i, v in ipairs(t5) do
            local v251 = 10 + (i - 1) * (v246 + n2)

            v.Frame.Position = UDim2.fromOffset(v245, v251)
            v.Frame.Size = UDim2.fromOffset(v247, v246)
            v.Title.TextSize = not v240 and 21 or 18

            if v.PopularBadge then
                v.PopularBadge.Position = UDim2.new(0.5, 0, 0, 9)
                v.PopularBadge.Size = UDim2.fromOffset(math.min(176, v247 - 20), 26)
                v.Title.Position = UDim2.fromOffset(12, 40)
                v.LogoBox.Position = UDim2.fromOffset(12, 70)
                v.LogoBox.Size = UDim2.new(1, -24, 0, v240 and 58 or 66)
                v.DetailBox.Position = UDim2.fromOffset(12, not v240 and 145 or 136)
            else
                v.Title.Position = UDim2.fromOffset(12, 11)
                v.LogoBox.Position = UDim2.fromOffset(12, 41)
                v.LogoBox.Size = UDim2.new(1, -24, 0, v240 and 58 or 66)
                v.DetailBox.Position = UDim2.fromOffset(12, not v240 and 116 or 107)
            end

            v.DetailBox.Size = UDim2.new(1, -24, 0, not v240 and 84 or 76)
        end
    end
    v133()
    local CurrentCamera = t2.value20.CurrentCamera
    if CurrentCamera then
        CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if t2.value37 == ScreenGui then
                v133()
            end
        end)
    end
    Frame11.BackgroundTransparency = 1
    v98.Transparency = 1
    local UIScaleScale = UIScale.Scale
    UIScale.Scale = math.max(0.5, UIScaleScale * 0.94)
    t2.value17:Create(UIScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = UIScaleScale
	}):Play()
    t2.value17:Create(Frame11, TweenInfo.new(0.18), {
		BackgroundTransparency = 0
	}):Play()
    t2.value17:Create(v98, TweenInfo.new(0.22), {
		Transparency = 0
	}):Play()
end
local Main = t3.Main
local AddInput = Main.AddInput
local value13 = t2.value13
AddInput(Main, "KeyInput", {
	Title = "Access Key:",
	Default = value13,
	Placeholder = "Paste your Luarmor key here...",
	Numeric = false,
	Finished = false,
	Callback = function(p23)
    t2.value13 = p23
end
})
local Main2 = t3.Main
local AddButton = Main2.AddButton
local t6 = {
	Title = "1. Get Key",
	Description = "Lifetime, Premium, or Free Key with Ads",
	Callback = function()
    t2.value39()
end
}
t1.value6 = AddButton
t1.value7 = t6
t1.value6(Main2, t1.value7)

local Main3 = t3.Main
t1.value6 = Main3.AddButton
t1.value6(Main3, {
	Title = "2. Check Key",
	Description = "Click here after pasting your key above",
	Callback = function()
    v14(t2.value13)
end
})
v12:SelectTab(1)
t1.value6 = t2.value13
if t1.value6 ~= "" then
    task.spawn(function()
        v14(t2.value13)
    end)

    return
end
t2.value35("Welcome!", "Please get a key to use Games Hub")
