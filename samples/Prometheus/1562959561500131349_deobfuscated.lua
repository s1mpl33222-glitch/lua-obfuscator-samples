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

	pcall(function()
		writefile(t2.value12, p1)
	end)
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
		v19 = Instance.new("ImageLabel")
		v19.Name = "CyberShadowFallback"
		v19.AnchorPoint = Vector2.new(0.5, 0.5)
		v19.Position = UDim2.fromScale(0.5, 0.5)
		v19.Size = UDim2.new(1, 42, 1, 42)
		v19.BackgroundTransparency = 1
		v19.Image = "rbxassetid://1316045217"
		v19.ImageColor3 = t2.value22
		v19.ImageTransparency = 0.62
		v19.ScaleType = Enum.ScaleType.Stretch
		v20 = p9.ZIndex - 1
		v19.ZIndex = math.max(0, v20)
		v19.Parent = p9

		return v19
	end

	local ok2 = pcall(function()
		result.Name = "CyberUIShadow"
		result.BlurRadius = UDim.new(0, 20)
		result.Color = t2.value22
		result.Transparency = 0.48
		result.Offset = UDim2.new(0, 0, 0, 9)
		result.Spread = UDim2.new(0, 9, 0, 9)
		result.ZIndex = 0
		result.Parent = p9
	end)

	if ok2 then
		ok2 = result.Parent == p9
	end

	if ok2 then
		return result
	end

	pcall(function()
		result:Destroy()
	end)

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

	local v11 = p9.ZIndex - 1

	ImageLabel.ZIndex = math.max(0, v11)
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
			local Parent = Frame

			if Parent then
				Parent = Frame.Parent
			end

			if not Parent then
				return
			end

			local value17 = t2.value17
			local v16 = Frame
			local tweenInfoNew = TweenInfo.new
			local Sine = Enum.EasingStyle.Sine
			local EasingDirection = Enum.EasingDirection
			local v21 = value17.Create(value17, v16, tweenInfoNew(1.55, Sine, EasingDirection.InOut), {
				Position = UDim2.new(0.7, 0, 0, 0),
				BackgroundColor3 = t2.value22
			})

			v21:Play()
			v21.Completed:Wait()

			if not Frame.Parent then
				return
			end

			local value172 = t2.value17
			local v22 = Frame
			local tweenInfo = TweenInfo.new(1.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local uDim2New = UDim2.new
			local v25 = value172.Create(value172, v22, tweenInfo, {
				Position = uDim2New(0, 0, 0, 0),
				BackgroundColor3 = t2.value23
			})

			v25:Play()
			v25.Completed:Wait()
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
		elseif toclipboard then
			toclipboard(p12)

			return
		else
			error("Clipboard unsupported")

			return
		end
	end)
end

(function()
	local u27 = nil

	local function v28()
		u27 = isfile(t2.value14)
	end

	u27 = false
	pcall(v28)

	if u27 then
		return
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "S0ftKillz_FirstWelcome"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 1000000000
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local function v30()
		ScreenGui.Parent = t2.value18
	end

	if not pcall(v30) then
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

	local v33 = t2.value28(Frame2, t2.value22, 2, 0)

	t2.value29(Frame2)
	t2.value30(Frame2, 40)

	local u34 = false
	local u35 = nil
	local Position = nil
	local Position2 = nil
	local connection = nil

	Frame2.InputBegan:Connect(function(input)
		local UserInputType = input.UserInputType
		local v40 = UserInputType ~= Enum.UserInputType.MouseButton1

		if v40 then
			v40 = UserInputType ~= Enum.UserInputType.Touch
		end

		if v40 then
			return
		end

		if input.Position.Y - Frame2.AbsolutePosition.Y > 128 then
			return
		end

		u34 = true
		Position = input.Position
		Position2 = Frame2.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u34 = false
		end)
	end)
	Frame2.InputChanged:Connect(function(input)
		local UserInputType = input.UserInputType

		if not (UserInputType == Enum.UserInputType.MouseMovement or UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u35 = input
	end)
	connection = t2.value19.InputChanged:Connect(function(input)
		if ScreenGui.Parent then
			local v42 = u34

			if v42 then
				v42 = input == u35

				if v42 then
					v42 = Position

					if v42 then
						v42 = Position2
					end
				end
			end

			if not v42 then
				return
			end

			local v43 = input.Position - Position

			Frame2.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v43.X, Position2.Y.Scale, Position2.Y.Offset + v43.Y)
		else
			if not connection then
				return
			end

			connection:Disconnect()
			connection = nil
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

	local function v54(p13, p14, p15, p16, _, _)
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

	v54(0, 8, 0, 8)
	v54(1, -8, 0, 8)
	v54(0, 8, 1, -8)
	v54(1, -8, 1, -8)

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

	local v58 = t2.value28(TextButton, t2.value22, 2, 0)
	local Frame7 = Instance.new("Frame")

	Frame7.Size = UDim2.new(0, 6, 1, 0)
	Frame7.BackgroundColor3 = t2.value24
	Frame7.BorderSizePixel = 0
	Frame7.ZIndex = 21
	Frame7.Parent = TextButton
	t2.value27(Frame7, 2)

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

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, 42, 0, 1)
	Frame8.Position = UDim2.new(0, 8, 1, -2)
	Frame8.BackgroundColor3 = t2.value23
	Frame8.BorderSizePixel = 0
	Frame8.ZIndex = 23
	Frame8.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		local value17 = t2.value17
		local v65 = TextButton
		local tweenInfo = TweenInfo.new(0.12)
		local Color3_ = Color3

		value17.Create(value17, v65, tweenInfo, {
			BackgroundColor3 = Color3_.fromRGB(28, 28, 36)
		}):Play()

		local value172 = t2.value17
		local v69 = v58
		local TweenInfo_ = TweenInfo

		value172.Create(value172, v69, TweenInfo_.new(0.12), {
			Color = t2.value23,
			Thickness = 2.4
		}):Play()
		t2.value17:Create(TextLabel7, TweenInfo.new(0.12), {
			TextColor3 = t2.value23
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		local value17 = t2.value17
		local v72 = TextButton
		local tweenInfo = TweenInfo.new(0.12)
		local t3 = {
			BackgroundColor3 = Color3.fromRGB(21, 21, 27)
		}

		value17.Create(value17, v72, tweenInfo, t3):Play()
		t2.value17:Create(v58, TweenInfo.new(0.12), {
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

	local function v76()
		local v77 = t2.value31()
		local v78 = (v77.X - 20) / 660
		local v79 = (v77.Y - 20) / 545
		local v80 = math.min(v78, v79)
		local scale = math.clamp(v80, 0.38, 1)

		Frame2:SetAttribute("ResponsiveScale", scale)

		if Frame2:GetAttribute("Opening") then
			return
		end

		UIScale.Scale = scale
	end

	Frame2:SetAttribute("Opening", true)
	v76()

	local CurrentCamera = t2.value20.CurrentCamera
	local connection2

	if CurrentCamera then
		connection2 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v76)
	else
		connection2 = nil
	end

	Frame2.BackgroundTransparency = 1
	v33.Transparency = 1

	local t4 = {
		Scale = Frame2:GetAttribute("ResponsiveScale") or 1
	}

	t2.value17:Create(UIScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), t4):Play()
	t2.value17:Create(Frame2, TweenInfo.new(0.2), {
		BackgroundTransparency = 0
	}):Play()
	t2.value17:Create(v33, TweenInfo.new(0.24), {
		Transparency = 0
	}):Play()
	task.delay(0.3, function()
		local Parent = Frame2

		if Parent then
			Parent = Frame2.Parent
		end

		if not Parent then
			return
		end

		Frame2:SetAttribute("Opening", false)
		v76()
	end)

	local BindableEvent = Instance.new("BindableEvent")

	TextButton.Activated:Connect(function()
		if not ScreenGui.Parent then
			return
		end

		TextButton.Active = false
		TextLabel6.Text = "ACCESS GRANTED"
		TextLabel5.Text = "LOADING KEY SYSTEM..."
		TextLabel7.Text = ">>>"
		v58.Color = t2.value24
		pcall(function()
			writefile(t2.value14, "seen")
		end)

		local value17 = t2.value17
		local v88 = UIScale
		local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		local math_ = math

		value17.Create(value17, v88, tweenInfo, {
			Scale = math_.max(0.2, (Frame2:GetAttribute("ResponsiveScale") or 1) * 0.94)
		}):Play()
		t2.value17:Create(Frame2, TweenInfo.new(0.16), {
			BackgroundTransparency = 1
		}):Play()
		t2.value17:Create(v33, TweenInfo.new(0.16), {
			Transparency = 1
		}):Play()

		local function v91()
			if connection2 then
				connection2:Disconnect()
			end

			if not connection then
				ScreenGui:Destroy()
				BindableEvent:Fire()

				return
			end

			connection:Disconnect()
			ScreenGui:Destroy()
			BindableEvent:Fire()
		end

		task.delay(0.18, v91)
	end)
	BindableEvent.Event:Wait()
	BindableEvent:Destroy()
end)()
t2.value33 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local loadstring_ = loadstring
local game_ = game

t1.value4 = game_.HttpGet
t1.value5 = "\143\232j\t\173\235\199\201H"
t2.value34 = loadstring_(t1.value4(game_, "https://sdkAPI-public.luarmor.net/library.lua"))()
t2.value34.script_id = "07a73d589fafa2f1762aa93563002584"

local value33 = t2.value33
local CreateWindow = value33.CreateWindow
local v96 = t2.value31()
local v97 = CreateWindow(value33, {
	Title = "Games Hub",
	SubTitle = "Key System",
	TabWidth = v96.X <= 500 and 110 or (v96.X <= 700 and 130 or 160),
	Size = (function()
		local v98 = t2.value31()
		local v99 = v98.X - 24
		local v100 = math.max(280, v99)
		local v101 = math.min(480, v100)
		local v102 = v98.Y - 80
		local v103 = math.max(230, v102)
		local v104 = math.min(320, v103)

		return UDim2.fromOffset(math.floor(v101), (math.floor(v104)))
	end)(),
	Acrylic = true,
	Theme = "Darker",
	MinimizeKey = Enum.KeyCode.RightControl
})
local t5 = {
	Main = v97:AddTab({
		Title = "Verification",
		Icon = t2.value1
	})
}

function t2.value35(p17, p18)
	t2.value33:Notify({
		Title = p17,
		Content = p18,
		Duration = 6
	})
end

t2.value36 = nil

local function v106(p19)
	if not p19 or p19 == "" then
		t2.value35("Error", "Please enter a key first.")
	else
		t2.value35("Checking...", "Verifying your key...")

		local v107 = t2.value34.check_key(p19)

		if v107.code == "KEY_VALID" then
			t2.value15(p19)
			t2.value13 = p19
			t2.value33:Destroy()
			getgenv().script_key = p19
			t2.value34.load_script()

			return
		elseif v107.code:find("KEY_") then
			t2.value35("Key Denied", ({
				KEY_HWID_LOCKED = "Key is linked to another HWID.",
				KEY_INCORRECT = "The key is incorrect.",
				KEY_INVALID = "The key is invalid or expired."
			})[v107.code] or v107.message)

			return
		else
			local value21 = t2.value21
			local message = v107.message

			value21:Kick("System Error: " .. tostring(message))

			return
		end
	end
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
		local Size = Popup.Size
		local v114 = Size.X.Offset - 28
		local v115 = math.max(260, v114)
		local v116 = Size.Y.Offset - 24
		local v117 = math.max(220, v116)

		t2.value17:Create(Popup, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.fromOffset(v115, v117),
			BackgroundTransparency = 1
		}):Play()
	end

	if Dim then
		t2.value17:Create(Dim, TweenInfo.new(0.18), {
			BackgroundTransparency = 1
		}):Play()
	end

	task.delay(0.2, function()
		if not value37 then
			return
		end

		value37:Destroy()
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

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Popup"
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.Position = UDim2.fromScale(0.5, 0.5)
	Frame2.Size = UDim2.fromOffset(900, 500)
	Frame2.BackgroundColor3 = t2.value25
	Frame2.BackgroundTransparency = 1
	Frame2.BorderSizePixel = 0
	Frame2.Active = true
	Frame2.ClipsDescendants = false
	Frame2.Parent = ScreenGui
	t2.value27(Frame2, 7)

	local v121 = t2.value28(Frame2, t2.value22, 2, 1)

	t2.value29(Frame2)

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "TopAccent"
	Frame3.Size = UDim2.new(0.3, 0, 0, 2)
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3.BackgroundColor3 = t2.value23
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 20
	Frame3.Parent = Frame2

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 45, 235)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(195, 65, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 205, 255)) })
	UIGradient.Parent = Frame3
	task.spawn(function()
		local n1 = 16767352

		while true do
			local v125 = t2.value37 == ScreenGui

			if v125 then
				v125 = Frame3

				if v125 then
					v125 = Frame3.Parent
				end
			end

			if not v125 then
				return
			end

			local value17 = t2.value17
			local v127 = Frame3
			local tweenInfoNew = TweenInfo.new
			local Sine = Enum.EasingStyle.Sine
			local Enum_ = Enum
			local v131 = value17.Create(value17, v127, tweenInfoNew(1.55, Sine, Enum_.EasingDirection.InOut), {
				Position = UDim2.new(0.7, 0, 0, 0),
				BackgroundColor3 = t2.value22
			})

			v131:Play()
			v131.Completed:Wait()

			if not Frame3.Parent then
				return
			end

			local value172 = t2.value17
			local v133 = Frame3
			local tweenInfoNew2 = TweenInfo.new
			local Sine2 = Enum.EasingStyle.Sine
			local Enum_2 = Enum
			local v137 = value172.Create(value172, v133, tweenInfoNew2(1.55, Sine2, Enum_2.EasingDirection.InOut), {
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = t2.value23
			})

			v137:Play()
			n1 = v137.Completed
			n1:Wait()
		end
	end)

	local UIScale = Instance.new("UIScale")

	UIScale.Name = "ResponsiveScale"
	UIScale.Scale = 0.94
	UIScale.Parent = Frame2

	local u139 = false
	local u140 = nil
	local Position = nil
	local Position2 = nil
	local u143 = nil

	Frame2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		if input.Position.Y - Frame2.AbsolutePosition.Y > 92 then
			return
		end

		u139 = true
		Position = input.Position
		Position2 = Frame2.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u139 = false
		end)
	end)

	local InputChanged = Frame2.InputChanged

	local function v145(p20)
		if not (p20.UserInputType == Enum.UserInputType.MouseMovement or p20.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u140 = p20
	end

	InputChanged.Connect(InputChanged, v145)

	local InputChanged2 = t2.value19.InputChanged

	local function v147(p21)
		if t2.value37 ~= ScreenGui then
			if not u143 then
				return
			end

			u143:Disconnect()
			u143 = nil
		else
			local v148 = u139

			if v148 then
				v148 = p21 == u140

				if v148 then
					v148 = Position

					if v148 then
						v148 = Position2
					end
				end
			end

			if not v148 then
				return
			end

			local v149 = p21.Position - Position

			Frame2.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v149.X, Position2.Y.Scale, Position2.Y.Offset + v149.Y)
		end
	end

	u143 = InputChanged2.Connect(InputChanged2, v147)

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
	TextButton.Parent = Frame2
	t2.value27(TextButton, 5)

	local v151 = t2.value28(TextButton, Color3.fromRGB(130, 45, 55), 1, 0.1)

	TextButton.MouseEnter:Connect(function()
		local value17 = t2.value17
		local v153 = TextButton
		local tweenInfo = TweenInfo.new(0.12)
		local Color3_ = Color3

		value17.Create(value17, v153, tweenInfo, {
			BackgroundColor3 = Color3_.fromRGB(62, 25, 32)
		}):Play()

		local value172 = t2.value17
		local v157 = v151
		local tweenInfo2 = TweenInfo.new(0.12)
		local Color3_2 = Color3

		value172.Create(value172, v157, tweenInfo2, {
			Color = Color3_2.fromRGB(255, 72, 82)
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		local value17 = t2.value17
		local v161 = TextButton
		local tweenInfo = TweenInfo.new(0.12)
		local Color3_ = Color3

		value17.Create(value17, v161, tweenInfo, {
			BackgroundColor3 = Color3_.fromRGB(34, 22, 27)
		}):Play()

		local value172 = t2.value17
		local v165 = v151
		local tweenInfo2 = TweenInfo.new(0.12)
		local t6 = {
			Color = Color3.fromRGB(130, 45, 55)
		}

		value172.Create(value172, v165, tweenInfo2, t6):Play()
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
	ImageLabel.Parent = Frame2

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
	TextLabel.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "CenterKey"
	Frame4.AnchorPoint = Vector2.new(0.5, 0)
	Frame4.Position = UDim2.new(0.5, 0, 0, 10)
	Frame4.Size = UDim2.fromOffset(270, 62)
	Frame4.BackgroundTransparency = 1
	Frame4.ZIndex = 25
	Frame4.Parent = Frame2

	local Frame5 = Instance.new("Frame")

	Frame5.Name = "KeyHeaderLogo"
	Frame5.Position = UDim2.fromOffset(22, 7)
	Frame5.Size = UDim2.fromOffset(48, 48)
	Frame5.BackgroundTransparency = 1
	Frame5.BorderSizePixel = 0
	Frame5.ZIndex = 26
	Frame5.Parent = Frame4

	if t2.value16(t2.value2) then
		local ImageLabel2 = Instance.new("ImageLabel")

		ImageLabel2.Name = "Image"
		ImageLabel2.Size = UDim2.fromScale(1, 1)
		ImageLabel2.BackgroundTransparency = 1
		ImageLabel2.Image = t2.value2
		ImageLabel2.ScaleType = Enum.ScaleType.Fit
		ImageLabel2.ZIndex = 27
		ImageLabel2.Parent = Frame5
	else
		local Frame6 = Instance.new("Frame")

		Frame6.Name = "Ring"
		Frame6.Position = UDim2.fromOffset(3, 7)
		Frame6.Size = UDim2.fromOffset(22, 22)
		Frame6.BackgroundTransparency = 1
		Frame6.BorderSizePixel = 0
		Frame6.ZIndex = 27
		Frame6.Parent = Frame5
		t2.value27(Frame6, 11)
		t2.value28(Frame6, Color3.fromRGB(255, 138, 47), 4, 0)

		local Frame7 = Instance.new("Frame")

		Frame7.Name = "Shaft"
		Frame7.Position = UDim2.fromOffset(21, 24)
		Frame7.Size = UDim2.fromOffset(23, 5)
		Frame7.Rotation = 40
		Frame7.BackgroundColor3 = Color3.fromRGB(255, 138, 47)
		Frame7.BorderSizePixel = 0
		Frame7.ZIndex = 27
		Frame7.Parent = Frame5
		t2.value27(Frame7, 3)

		local Frame8 = Instance.new("Frame")

		Frame8.Name = "Tooth"
		Frame8.Position = UDim2.fromOffset(36, 31)
		Frame8.Size = UDim2.fromOffset(5, 10)
		Frame8.Rotation = 40
		Frame8.BackgroundColor3 = Color3.fromRGB(255, 138, 47)
		Frame8.BorderSizePixel = 0
		Frame8.ZIndex = 27
		Frame8.Parent = Frame5
		t2.value27(Frame8, 2)
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
	TextLabel2.Parent = Frame4

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
	TextLabel3.Parent = Frame4

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
	TextButton2.Parent = Frame2
	t2.value27(TextButton2, 5)

	local v179 = t2.value28(TextButton2, Color3.fromRGB(88, 101, 242), 1.5, 0)
	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
	ImageLabel2.Position = UDim2.new(0, 11, 0.5, 0)
	ImageLabel2.Size = UDim2.fromOffset(30, 30)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = t2.value11
	ImageLabel2.ScaleType = Enum.ScaleType.Fit
	ImageLabel2.ZIndex = 26
	ImageLabel2.Parent = TextButton2

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
	TextLabel4.Parent = TextButton2
	TextButton2.MouseEnter:Connect(function()
		local value17 = t2.value17
		local v183 = TextButton2
		local tweenInfo = TweenInfo.new(0.12)
		local color3 = Color3.fromRGB

		value17.Create(value17, v183, tweenInfo, {
			BackgroundColor3 = color3(34, 37, 56)
		}):Play()
		t2.value17:Create(v179, TweenInfo.new(0.12), {
			Color = t2.value23,
			Thickness = 2
		}):Play()
	end)
	TextButton2.MouseLeave:Connect(function()
		local value17 = t2.value17
		local v187 = TextButton2
		local tweenInfoNew = TweenInfo.new

		value17.Create(value17, v187, tweenInfoNew(0.12), {
			BackgroundColor3 = Color3.fromRGB(23, 25, 36)
		}):Play()

		local value172 = t2.value17
		local v190 = v179
		local tweenInfo = TweenInfo.new(0.12)

		value172.Create(value172, v190, tweenInfo, {
			Color = Color3.fromRGB(88, 101, 242),
			Thickness = 1.5
		}):Play()
	end)
	TextButton2.Activated:Connect(function()
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

	local Frame6 = Instance.new("Frame")

	Frame6.Name = "HeaderLine"
	Frame6.Position = UDim2.fromOffset(18, 80)
	Frame6.Size = UDim2.new(1, -36, 0, 1)
	Frame6.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
	Frame6.BorderSizePixel = 0
	Frame6.ZIndex = 21
	Frame6.Parent = Frame2

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
	ScrollingFrame.Parent = Frame2

	local t7 = {}

	local function createFrame(p22)
		local Frame7 = Instance.new("Frame")

		Frame7.Name = p22.Name
		Frame7.BackgroundColor3 = Color3.fromRGB(21, 21, 27)
		Frame7.BorderSizePixel = 0
		Frame7.ClipsDescendants = false
		Frame7.ZIndex = 12
		Frame7.Parent = ScrollingFrame
		t2.value27(Frame7, 6)

		local value28 = t2.value28
		local Popular = p22.Popular

		if Popular then
			Popular = Color3.fromRGB(255, 139, 34)
		end

		value28(Frame7, Popular or Color3.fromRGB(58, 58, 70), p22.Popular and 2.5 or 1.2, 0)

		local Frame8 = Instance.new("Frame")

		Frame8.Name = "AccentBar"
		Frame8.Position = UDim2.fromOffset(0, 0)
		Frame8.Size = UDim2.new(1, 0, 0, 4)
		Frame8.BackgroundColor3 = p22.Accent
		Frame8.BorderSizePixel = 0
		Frame8.ZIndex = 14
		Frame8.Parent = Frame7
		t2.value27(Frame8, 3)

		local TextLabel5

		if p22.Popular then
			TextLabel5 = Instance.new("TextLabel")
			TextLabel5.Name = "PopularBadge"
			TextLabel5.AnchorPoint = Vector2.new(0.5, 0)
			TextLabel5.Position = UDim2.new(0.5, 0, 0, 12)
			TextLabel5.Size = UDim2.fromOffset(176, 28)
			TextLabel5.BackgroundColor3 = Color3.fromRGB(50, 35, 18)
			TextLabel5.BorderSizePixel = 0
			TextLabel5.Text = "MOST POPULAR  *"
			TextLabel5.TextColor3 = Color3.fromRGB(255, 191, 33)
			TextLabel5.Font = Enum.Font.GothamBold
			TextLabel5.TextSize = 13
			TextLabel5.ZIndex = 15
			TextLabel5.Parent = Frame7
			t2.value27(TextLabel5, 4)
			t2.value28(TextLabel5, Color3.fromRGB(255, 146, 35), 1, 0.15)
		else
			TextLabel5 = nil
		end

		local TextLabel6 = Instance.new("TextLabel")

		TextLabel6.Name = "CardTitle"
		TextLabel6.Position = UDim2.fromOffset(14, p22.Popular and 48 or 18)
		TextLabel6.Size = UDim2.new(1, -28, 0, 31)
		TextLabel6.BackgroundTransparency = 1
		TextLabel6.Text = p22.Title
		TextLabel6.TextColor3 = p22.Accent
		TextLabel6.Font = Enum.Font.GothamBold
		TextLabel6.TextSize = 23
		TextLabel6.TextXAlignment = Enum.TextXAlignment.Center
		TextLabel6.ZIndex = 15
		TextLabel6.Parent = Frame7

		local Frame9 = Instance.new("Frame")

		Frame9.Name = "LogoBox"
		Frame9.Position = UDim2.fromOffset(14, p22.Popular and 86 or 58)
		Frame9.Size = UDim2.new(1, -28, 0, 76)
		Frame9.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
		Frame9.BorderSizePixel = 0
		Frame9.ZIndex = 13
		Frame9.Parent = Frame7
		t2.value27(Frame9, 4)
		t2.value28(Frame9, Color3.fromRGB(50, 50, 62), 1, 0.15)

		if t2.value16(p22.Logo) then
			local ImageLabel3 = Instance.new("ImageLabel")

			ImageLabel3.Name = "CardLogo"
			ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel3.Position = UDim2.fromScale(0.5, 0.5)
			ImageLabel3.Size = UDim2.fromOffset(58, 58)
			ImageLabel3.BackgroundTransparency = 1
			ImageLabel3.Image = p22.Logo
			ImageLabel3.ScaleType = Enum.ScaleType.Fit
			ImageLabel3.ZIndex = 15
			ImageLabel3.Parent = Frame9
		elseif p22.LogoKind == "ADS" then
			local Frame10 = Instance.new("Frame")

			Frame10.Name = "AdsLogo"
			Frame10.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame10.Position = UDim2.fromScale(0.5, 0.5)
			Frame10.Size = UDim2.fromOffset(62, 50)
			Frame10.BackgroundColor3 = Color3.fromRGB(18, 33, 38)
			Frame10.BorderSizePixel = 0
			Frame10.ZIndex = 15
			Frame10.Parent = Frame9
			t2.value27(Frame10, 8)
			t2.value28(Frame10, p22.Accent, 2, 0)

			local Frame11 = Instance.new("Frame")

			Frame11.Name = "AdScreen"
			Frame11.Position = UDim2.fromOffset(8, 7)
			Frame11.Size = UDim2.new(1, -16, 1, -18)
			Frame11.BackgroundColor3 = Color3.fromRGB(12, 20, 24)
			Frame11.BorderSizePixel = 0
			Frame11.ZIndex = 16
			Frame11.Parent = Frame10
			t2.value27(Frame11, 5)
			t2.value28(Frame11, Color3.fromRGB(55, 105, 112), 1, 0.15)

			local TextLabel7 = Instance.new("TextLabel")

			TextLabel7.Name = "AdText"
			TextLabel7.Size = UDim2.fromScale(1, 1)
			TextLabel7.BackgroundTransparency = 1
			TextLabel7.Text = "AD"
			TextLabel7.TextColor3 = p22.Accent
			TextLabel7.Font = Enum.Font.GothamBold
			TextLabel7.TextSize = 23
			TextLabel7.ZIndex = 17
			TextLabel7.Parent = Frame11

			local Frame12 = Instance.new("Frame")

			Frame12.Name = "AdStand"
			Frame12.AnchorPoint = Vector2.new(0.5, 0)
			Frame12.Position = UDim2.new(0.5, 0, 1, -9)
			Frame12.Size = UDim2.fromOffset(18, 3)
			Frame12.BackgroundColor3 = p22.Accent
			Frame12.BorderSizePixel = 0
			Frame12.ZIndex = 17
			Frame12.Parent = Frame10
			t2.value27(Frame12, 2)
		else
			local TextLabel7 = Instance.new("TextLabel")

			TextLabel7.Name = "CardLogoText"
			TextLabel7.Size = UDim2.fromScale(1, 1)
			TextLabel7.BackgroundTransparency = 1
			TextLabel7.Text = p22.LogoText or p22.Title
			TextLabel7.TextColor3 = p22.Accent
			TextLabel7.Font = Enum.Font.GothamBold
			TextLabel7.TextSize = 28
			TextLabel7.ZIndex = 15
			TextLabel7.Parent = Frame9
		end

		local Frame10 = Instance.new("Frame")

		Frame10.Name = "DetailBox"
		Frame10.Position = UDim2.fromOffset(14, p22.Popular and 170 or 142)
		Frame10.Size = UDim2.new(1, -28, 0, 92)
		Frame10.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
		Frame10.BorderSizePixel = 0
		Frame10.ZIndex = 13
		Frame10.Parent = Frame7
		t2.value27(Frame10, 4)

		local TextLabel7 = Instance.new("TextLabel")

		TextLabel7.Name = "CardDetail"
		TextLabel7.Position = UDim2.fromOffset(12, 8)
		TextLabel7.Size = UDim2.new(1, -24, 1, -16)
		TextLabel7.BackgroundTransparency = 1
		TextLabel7.Text = p22.Detail
		TextLabel7.TextColor3 = Color3.fromRGB(213, 213, 222)
		TextLabel7.Font = Enum.Font.Gotham
		TextLabel7.TextSize = 15
		TextLabel7.TextWrapped = true
		TextLabel7.TextXAlignment = Enum.TextXAlignment.Center
		TextLabel7.TextYAlignment = Enum.TextYAlignment.Center
		TextLabel7.ZIndex = 15
		TextLabel7.Parent = Frame10

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
		TextButton3.Parent = Frame7
		t2.value27(TextButton3, 4)

		local v213 = t2.value28(TextButton3, p22.Accent, 1.5, 0)
		local Frame11 = Instance.new("Frame")

		Frame11.Position = UDim2.new(0, 0, 0, 7)
		Frame11.Size = UDim2.new(0, 4, 1, -14)
		Frame11.BackgroundColor3 = p22.Accent
		Frame11.BorderSizePixel = 0
		Frame11.ZIndex = 16
		Frame11.Parent = TextButton3
		t2.value27(Frame11, 2)
		TextButton3.MouseEnter:Connect(function()
			local value17 = t2.value17
			local v216 = TextButton3
			local tweenInfo = TweenInfo.new(0.12)

			value17.Create(value17, v216, tweenInfo, {
				BackgroundColor3 = p22.Accent,
				TextColor3 = Color3.fromRGB(12, 12, 16)
			}):Play()

			local value172 = t2.value17
			local v219 = v213
			local tweenInfo2 = TweenInfo.new(0.12)
			local t8 = {
				Color = t2.value23,
				Thickness = 2
			}

			value172.Create(value172, v219, tweenInfo2, t8):Play()
		end)
		TextButton3.MouseLeave:Connect(function()
			local value17 = t2.value17
			local v223 = TextButton3
			local tweenInfo = TweenInfo.new(0.12)
			local Color3_ = Color3

			value17.Create(value17, v223, tweenInfo, {
				BackgroundColor3 = Color3_.fromRGB(18, 18, 24),
				TextColor3 = p22.Accent
			}):Play()
			t2.value17:Create(v213, TweenInfo.new(0.12), {
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
				local Parent = TextButton3

				if Parent then
					Parent = TextButton3.Parent
				end

				if not Parent then
					return
				end

				TextButton3.Text = "COPY LINK"
				TextButton3.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
				TextButton3.TextColor3 = p22.Accent
			end)
		end)

		local v227 = t7

		table.insert(v227, {
			Frame = Frame7,
			Title = TextLabel6,
			LogoBox = Frame9,
			DetailBox = Frame10,
			PopularBadge = TextLabel5
		})

		return Frame7
	end

	createFrame({
		Name = "LifetimeCard",
		Title = "LIFETIME",
		Detail = "Lifetime key\nCrypto payment\nPermanent access",
		Link = t2.value4,
		Accent = Color3.fromRGB(164, 63, 255),
		Logo = t2.value5,
		LogoText = "LIFE",
		Popular = false
	})
	createFrame({
		Name = "PremiumCard",
		Title = "PREMIUM",
		Detail = "Multiple key durations\n1-day key from $0.99",
		Link = t2.value6,
		Accent = Color3.fromRGB(255, 190, 28),
		Logo = t2.value7,
		LogoText = "VIP",
		Popular = true
	})
	createFrame({
		Name = "AdsCard",
		Title = "ADS",
		Detail = "Free key with ads\n3 checkpoints",
		Link = t2.value8,
		Accent = Color3.fromRGB(95, 226, 234),
		Logo = t2.value9,
		LogoKind = "ADS",
		Popular = false
	})

	local function v228()
		local v229 = t2.value31()
		local v230 = v229.X - 12
		local v231 = math.max(210, v230)
		local v232 = v229.Y - 12
		local v233 = math.max(250, v232)
		local v234

		if v231 >= 760 then
			v234 = v233 >= 460
		else
			v234 = false
		end

		UIScale.Scale = 1

		if v234 then
			local v235 = math.min(900, v231)
			local v236 = math.min(500, v233)

			Frame2.Size = UDim2.fromOffset(v235, v236)
			ImageLabel.Visible = true
			TextLabel.Visible = true
			Frame4.AnchorPoint = Vector2.new(0.5, 0)
			Frame4.Position = UDim2.new(0.5, 0, 0, 10)
			Frame4.Size = UDim2.fromOffset(270, 62)
			Frame5.Visible = true
			Frame5.Position = UDim2.fromOffset(22, 7)
			Frame5.Size = UDim2.fromOffset(48, 48)
			TextLabel2.Position = UDim2.fromOffset(80, 4)
			TextLabel2.Size = UDim2.fromOffset(176, 30)
			TextLabel2.TextSize = 24
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel3.Visible = true
			TextLabel3.Position = UDim2.fromOffset(81, 33)
			TextLabel3.Size = UDim2.fromOffset(180, 21)
			TextLabel3.TextSize = 11
			TextButton2.Size = UDim2.fromOffset(168, 48)
			TextButton2.Position = UDim2.new(1, -18, 0, 16)
			ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel2.Position = UDim2.new(0, 11, 0.5, 0)
			ImageLabel2.Size = UDim2.fromOffset(30, 30)
			TextLabel4.Visible = true
			Frame6.Position = UDim2.fromOffset(18, 80)
			Frame6.Size = UDim2.new(1, -36, 0, 1)
			ScrollingFrame.Position = UDim2.fromOffset(6, 88)
			ScrollingFrame.Size = UDim2.new(1, -12, 1, -96)
			ScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
			ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
			ScrollingFrame.ScrollBarThickness = 0

			local n2 = 24
			local clamp = math.clamp
			local v239 = v235 * 0.024
			local v240 = clamp(math.floor(v239), 12, 22)
			local v241 = (v235 - n2 * 2 - v240 * 2) / 3
			local v242 = math.floor(v241)
			local v243 = v236 - 150
			local v244 = math.max(326, v243)
			local n3 = 24

			for i, v in ipairs(t7) do
				local v248 = n2 + (i - 1) * (v242 + v240)

				v.Frame.Position = UDim2.fromOffset(v248, n3)
				v.Frame.Size = UDim2.fromOffset(v242, v244)
				v.Title.TextSize = v242 < 240 and 19 or 23

				if v.PopularBadge then
					v.PopularBadge.Position = UDim2.new(0.5, 0, 0, 12)

					local PopularBadge = v.PopularBadge
					local uDim2 = UDim2.fromOffset
					local v251 = v242 - 24

					PopularBadge.Size = uDim2(math.min(176, v251), 28)
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

		local v252 = math.min(420, v231)
		local v253 = math.min(620, v233)
		local v254 = v252 < 320

		Frame2.Size = UDim2.fromOffset(v252, v253)
		ImageLabel.Visible = false
		TextLabel.Visible = false
		TextButton.Position = UDim2.fromOffset(10, 14)
		TextButton.Size = UDim2.fromOffset(38, 38)
		TextButton.TextSize = 21
		TextButton2.Size = UDim2.fromOffset(42, 38)
		TextButton2.Position = UDim2.new(1, -10, 0, 14)
		ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel2.Position = UDim2.fromScale(0.5, 0.5)
		ImageLabel2.Size = UDim2.fromOffset(25, 25)
		TextLabel4.Visible = false

		local v255 = v252 - 128
		local v256 = math.max(104, v255)

		Frame4.AnchorPoint = Vector2.new(0.5, 0)
		Frame4.Position = UDim2.new(0.5, 0, 0, 7)
		Frame4.Size = UDim2.fromOffset(v256, 58)

		if v254 then
			Frame5.Visible = false
			TextLabel2.Position = UDim2.fromOffset(0, 7)
			TextLabel2.Size = UDim2.new(1, 0, 0, 28)
			TextLabel2.TextSize = 18
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
			TextLabel3.Visible = false
		else
			Frame5.Visible = true
			Frame5.Position = UDim2.fromOffset(4, 9)
			Frame5.Size = UDim2.fromOffset(40, 40)
			TextLabel2.Position = UDim2.fromOffset(50, 5)
			TextLabel2.Size = UDim2.new(1, -52, 0, 27)
			TextLabel2.TextSize = v252 < 360 and 18 or 20
			TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel3.Visible = v252 >= 350
			TextLabel3.Position = UDim2.fromOffset(51, 31)
			TextLabel3.Size = UDim2.new(1, -54, 0, 19)
			TextLabel3.TextSize = 9
		end

		Frame6.Position = UDim2.fromOffset(10, 70)
		Frame6.Size = UDim2.new(1, -20, 0, 1)
		ScrollingFrame.Position = UDim2.fromOffset(4, 76)
		ScrollingFrame.Size = UDim2.new(1, -8, 1, -82)
		ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
		ScrollingFrame.ScrollBarThickness = v254 and 3 or 4

		local n4 = 14
		local v258 = v254 and 8 or 12
		local v259 = v254 and 284 or 310
		local v260 = v252 - v258 * 2 - 8
		local v261 = 10 + v259 * #t7 + n4 * (#t7 - 1) + 14

		ScrollingFrame.CanvasSize = UDim2.fromOffset(0, v261)

		local n5 = 10

		for i, v in ipairs(t7) do
			local v265 = n5 + (i - 1) * (v259 + n4)

			v.Frame.Position = UDim2.fromOffset(v258, v265)
			v.Frame.Size = UDim2.fromOffset(v260, v259)
			v.Title.TextSize = v254 and 18 or 21

			if v.PopularBadge then
				v.PopularBadge.Position = UDim2.new(0.5, 0, 0, 9)

				local PopularBadge = v.PopularBadge
				local uDim2 = UDim2.fromOffset
				local v268 = v260 - 20

				PopularBadge.Size = uDim2(math.min(176, v268), 26)
				v.Title.Position = UDim2.fromOffset(12, 40)
				v.LogoBox.Position = UDim2.fromOffset(12, 70)
				v.LogoBox.Size = UDim2.new(1, -24, 0, v254 and 58 or 66)
				v.DetailBox.Position = UDim2.fromOffset(12, v254 and 136 or 145)
			else
				v.Title.Position = UDim2.fromOffset(12, 11)
				v.LogoBox.Position = UDim2.fromOffset(12, 41)
				v.LogoBox.Size = UDim2.new(1, -24, 0, v254 and 58 or 66)
				v.DetailBox.Position = UDim2.fromOffset(12, v254 and 107 or 116)
			end

			v.DetailBox.Size = UDim2.new(1, -24, 0, v254 and 76 or 84)
		end
	end

	v228()

	local CurrentCamera = t2.value20.CurrentCamera

	if not CurrentCamera then
		Frame2.BackgroundTransparency = 1
		v121.Transparency = 1
		v296 = UIScale.Scale
		v297 = v296 * 0.94
		UIScale.Scale = math.max(0.5, v297)
		t2.value17:Create(UIScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = v296
		}):Play()
		t2.value17:Create(Frame2, TweenInfo.new(0.18), {
			BackgroundTransparency = 0
		}):Play()
		v298 = t2.value17
		v299 = TweenInfo
		v298.Create(v298, v121, v299.new(0.22), {
			Transparency = 0
		}):Play()

		return
	end

	CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if t2.value37 ~= ScreenGui then
			return
		end

		v228()
	end)
	Frame2.BackgroundTransparency = 1
	v121.Transparency = 1

	local Scale = UIScale.Scale
	local v271 = Scale * 0.94

	UIScale.Scale = math.max(0.5, v271)
	t2.value17:Create(UIScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = Scale
	}):Play()
	t2.value17:Create(Frame2, TweenInfo.new(0.18), {
		BackgroundTransparency = 0
	}):Play()

	local value17 = t2.value17
	local TweenInfo_ = TweenInfo

	value17.Create(value17, v121, TweenInfo_.new(0.22), {
		Transparency = 0
	}):Play()
end

local Main = t5.Main

Main.AddInput(Main, "KeyInput", {
	Title = "Access Key:",
	Default = t2.value13,
	Placeholder = "Paste your Luarmor key here...",
	Numeric = false,
	Finished = false,
	Callback = function(p23)
		t2.value13 = p23
	end
})

local Main2 = t5.Main

t1.value6 = Main2.AddButton
t1.value7 = {
	Title = "1. Get Key",
	Description = "Lifetime, Premium, or Free Key with Ads",
	Callback = function()
		t2.value39()
	end
}
t1.value6(Main2, t1.value7)

local Main3 = t5.Main

t1.value6 = Main3.AddButton
t1.value6(Main3, {
	Title = "2. Check Key",
	Description = "Click here after pasting your key above",
	Callback = function()
		v106(t2.value13)
	end
})
v97:SelectTab(1)
t1.value6 = t2.value13

if t1.value6 == "" then
	t2.value35("Welcome!", "Please get a key to use Games Hub")

	return
end

task.spawn(function()
	v106(t2.value13)
end)
