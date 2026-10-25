-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local t1 = {
	value1 = game:GetService("Lighting")
}

game:GetService("RunService")
t1.value2 = game:GetService("UserInputService")
t1.value3 = game:GetService("Workspace")
t1.value4 = game:GetService("TweenService")

local SoundService = game:GetService("SoundService")

t1.value5 = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

t1.value6 = LocalPlayer:WaitForChild("PlayerGui")
game:GetService("TeleportService")
t1.value7 = game:GetService("Debris")
t1.value8 = "rbxassetid://120102995443063"
t1.value9 = "rbxassetid://8755541422"
t1.value10 = t1.value1.FogEnd
t1.value11 = t1.value1.FogColor
t1.value12 = settings().Rendering.QualityLevel

local ok, value13 = pcall(function()
	return t1.value3.Terrain.Decoration
end)

t1.value13 = value13

if ok then
	ok = t1.value13
end

t1.value13 = ok or true
t1.value14 = t1.value1.GlobalShadows
t1.value15 = t1.value1.Ambient or Color3.new(0, 0, 0)
t1.value16 = t1.value1.OutdoorAmbient or Color3.new(0.5, 0.5, 0.5)
t1.value17 = t1.value1.Brightness or 1
t1.value18 = nil
t1.value19 = 0.5
t1.value20 = Instance.new("BlurEffect")
t1.value20.Name = "VenusBlur"
t1.value20.Size = 0
t1.value20.Enabled = false
t1.value20.Parent = t1.value1
t1.value21 = {
	Theme = {
		bg = Color3.fromRGB(16, 16, 20),
		panel = Color3.fromRGB(28, 16, 48),
		accent = Color3.fromRGB(158, 56, 255),
		text = Color3.fromRGB(240, 240, 250),
		muted = Color3.fromRGB(140, 140, 140)
	},
	Tween = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
}

function t1.value22(p1, p2)
	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, p2 or 8)
	UICorner.Parent = p1
end
function t1.value23(p3, p4, p5)
	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = p4 or 1
	UIStroke.Color = p5 or t1.value21.Theme.panel
	UIStroke.Transparency = 0
	UIStroke.Parent = p3
end
function t1.value24(p6, p7)
	local v9 = t1.value1:FindFirstChild(p7 or p6)
	local isA

	if v9 then
		isA = v9:IsA(p6)
	else
		isA = v9
	end

	if isA then
		return v9
	else
		local v11 = v9 or t1.value1:FindFirstChildOfClass(p6)
		local isA2

		if v11 then
			isA2 = v11:IsA(p6)
		else
			isA2 = v11
		end

		if isA2 then
			return v11
		else
			local instance = Instance.new(p6)

			instance.Name = p7 or p6
			instance.Parent = t1.value1

			return instance
		end
	end
end

t1.value25 = nil

function t1.value26(p8, p9)
	local Sound = Instance.new("Sound")

	Sound.SoundId = p8
	Sound.Volume = p9 or 0.5
	Sound.Parent = t1.value6
	Sound:Play()
	t1.value7:AddItem(Sound, 2)
end
function t1.value27()
	t1.value26(t1.value9, 0.4)
end
function t1.value28(p10, p11)
	local value18 = t1.value18

	if value18 then
		value18 = t1.value18.Parent
	end

	if not value18 then
		v27 = p10 or t1.value8
		t1.value19 = p11 or t1.value19
		v28 = Instance.new("Sound")
		v28.SoundId = v27
		v28.Volume = t1.value19
		v28.Looped = true
		v28.Parent = t1.value6
		v28:Play()
		t1.value18 = v28

		return
	end

	t1.value18:Destroy()

	local value8 = p10 or t1.value8

	t1.value19 = p11 or t1.value19

	local Sound = Instance.new("Sound")

	Sound.SoundId = value8
	Sound.Volume = t1.value19
	Sound.Looped = true
	Sound.Parent = t1.value6
	Sound:Play()
	t1.value18 = Sound
end
function t1.value29()
	local ipairs_ = ipairs
	local value1 = t1.value1

	for _, child in ipairs_(value1.GetChildren(value1)) do
		if child:IsA("PostEffect") or (child:IsA("BlurEffect") or (child:IsA("Atmosphere") or (child:IsA("Sky") or child:IsA("Clouds")))) then
			local v22

			if child.Name == "PerformanceBlur" then
				v22 = false
			else
				v22 = child.Name ~= "VenusBlur"
			end

			if v22 then
				child:Destroy()
			else
				child.Enabled = false
			end
		end
	end
end

t1.value30 = false

function t1.value31()
	if t1.value30 then
		return
	end

	t1.value30 = true
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/p0e1/1/main/SimpleShader.lua"))()
	end)
end

t1.value32 = false
t1.value33 = false
t1.value25 = false
t1.value34 = false
t1.value35 = false
t1.value36 = false
t1.value37 = nil
t1.value38 = nil

function t1.value39(p12)
	local GetDescendants = p12.GetDescendants

	for _, v in pairs(GetDescendants(p12)) do
		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		elseif v:IsA("BasePart") then
			if v.Material ~= Enum.Material.Neon then
				v.Material = Enum.Material.SmoothPlastic
			end

			v.TopSurface = Enum.SurfaceType.Smooth
			v.BottomSurface = Enum.SurfaceType.Smooth
		elseif v:IsA("MeshPart") then
			v.Material = Enum.Material.SmoothPlastic
		end
	end
end
function t1.value40(p13)
	if p13:IsA("Decal") or p13:IsA("Texture") then
		p13:Destroy()

		return
	end

	if p13:IsA("BasePart") then
		if p13.Material == Enum.Material.Neon then
			p13.TopSurface = Enum.SurfaceType.Smooth
			p13.BottomSurface = Enum.SurfaceType.Smooth

			return
		end

		p13.Material = Enum.Material.SmoothPlastic
		p13.TopSurface = Enum.SurfaceType.Smooth
		p13.BottomSurface = Enum.SurfaceType.Smooth
	else
		if not p13:IsA("MeshPart") then
			return
		end

		p13.Material = Enum.Material.SmoothPlastic
	end
end
function t1.value41(p14)
	local BlurEffect = t1.value24("BlurEffect", "PerformanceBlur")

	BlurEffect.Enabled = p14

	if p14 then
		BlurEffect.Size = 2

		return
	end

	local PerformanceBlur = t1.value1:FindFirstChild("PerformanceBlur")

	if not PerformanceBlur then
		return
	end

	PerformanceBlur:Destroy()
end

t1.value42 = false
t1.value43 = "UniversHub"
t1.value44 = "rbxassetid://133736456706911"
t1.value45 = Instance.new("ScreenGui")
t1.value45.Name = "UniversHubLoading"
t1.value45.ResetOnSpawn = false
t1.value45.IgnoreGuiInset = true
t1.value45.Parent = t1.value6
t1.value46 = Instance.new("VideoFrame")
t1.value46.Name = "DarkBackground"
t1.value46.Size = UDim2.fromScale(1, 1)
t1.value46.Video = "rbxassetid://5670799859"
t1.value46.Looped = true
t1.value46.Playing = true
t1.value46.Volume = 0
t1.value46.BorderSizePixel = 0
t1.value46.BackgroundTransparency = 1
t1.value46.Parent = t1.value45
t1.value47 = Instance.new("Frame")
t1.value47.Name = "CenterContainer"
t1.value47.Size = UDim2.new(0.6, 0, 0.5, 0)
t1.value47.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value47.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value47.BackgroundTransparency = 1
t1.value47.Parent = t1.value46
t1.value48 = Instance.new("TextLabel")
t1.value48.Size = UDim2.new(1, 0, 0.2, 0)
t1.value48.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value48.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value48.BackgroundTransparency = 1
t1.value48.Text = "loading config..."
t1.value48.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value48.TextSize = 0
t1.value48.Font = Enum.Font.Highway
t1.value48.Parent = t1.value47
t1.value48.TextTransparency = 1
t1.value49 = Instance.new("TextLabel")
t1.value49.Size = UDim2.new(1, 0, 0.15, 0)
t1.value49.Position = UDim2.new(0.5, 0, 0.15, 0)
t1.value49.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value49.BackgroundTransparency = 1
t1.value49.Text = "loading config0/10"
t1.value49.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value49.TextSize = 26
t1.value49.Font = Enum.Font.Highway
t1.value49.Parent = t1.value47
t1.value49.Visible = false
t1.value49.TextTransparency = 1
t1.value50 = Instance.new("Frame")
t1.value50.Size = UDim2.new(0.6, 0, 0.1, 0)
t1.value50.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value50.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value50.BackgroundTransparency = 1
t1.value50.Parent = t1.value47
t1.value50.Visible = false

local UIListLayout = Instance.new("UIListLayout", t1.value50)

UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)
t1.value51 = 6
t1.value52 = {}

local function toggleValue25()
	t1.value25 = not t1.value25

	local t2 = {
		"BloomEffect",
		"SunRaysEffect",
		"ColorCorrectionEffect",
		"BlurEffect",
		"DepthOfFieldEffect",
		"Atmosphere"
	}

	local function v31(p15, p16)
		local GetChildren = p15.GetChildren

		for _, v in ipairs(GetChildren(p15)) do
			for _, v2 in ipairs(t2) do
				if v:IsA(v2) then
					v.Enabled = p16
				end
			end
		end
	end

	if t1.value25 then
		v31(t1.value1, false)

		if t1.value3.CurrentCamera then
			v31(t1.value3.CurrentCamera, false)

			return
		else
			return
		end
	end

	v31(t1.value1, true)

	if not t1.value3.CurrentCamera then
		return
	end

	v31(t1.value3.CurrentCamera, true)
end
local function v37()
	if t1.value36 then
		return
	end

	local function v38()
		while t1.value36 do
			setfpscap(99999)
			wait(1)
		end
	end

	setfpscap(99999)
	t1.value36 = true
	spawn(v38)
end
local function toggleValue35()
	t1.value35 = not t1.value35

	local Terrain = t1.value3:FindFirstChild("Terrain")

	if t1.value35 then
		t1.value39(t1.value3)

		if not Terrain then
			t1.value37 = t1.value3.ChildAdded:Connect(t1.value39)
			t1.value38 = t1.value3.DescendantAdded:Connect(t1.value40)

			return
		end

		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		t1.value37 = t1.value3.ChildAdded:Connect(t1.value39)
		t1.value38 = t1.value3.DescendantAdded:Connect(t1.value40)
	else
		if t1.value37 then
			t1.value37:Disconnect()
		end

		if t1.value38 then
			t1.value38:Disconnect()
		end

		if not Terrain then
			return
		end

		Terrain.WaterReflectance = 1
		Terrain.WaterTransparency = 0.5
		Terrain.WaterWaveSize = 0.2
		Terrain.WaterWaveSpeed = 1
	end
end
local function toggleValue32()
	t1.value32 = not t1.value32

	if t1.value32 then
		t1.value1.GlobalShadows = false
		settings().Rendering.Shadows = false
	else
		t1.value1.GlobalShadows = t1.value14
		settings().Rendering.Shadows = true
	end
end
local function toggleValue34()
	t1.value34 = not t1.value34

	local Terrain = t1.value3.Terrain

	if t1.value34 then
		local MaterialProperties = Instance.new("MaterialProperties")

		MaterialProperties.DiffuseColor = Color3.fromRGB(150, 150, 150)
		MaterialProperties.SpecularColor = Color3.new(0, 0, 0)
		MaterialProperties.FuzzyColor = Color3.new(0, 0, 0)
		MaterialProperties.Reflectance = 0
		MaterialProperties.DetailScale = 0
		MaterialProperties.FuzzyColor = Color3.new(0, 0, 0)
		Terrain.MaterialProperties = MaterialProperties
	else
		Terrain.MaterialProperties = nil
	end
end
local function v45()
	t1.value1.Technology = Enum.Technology.Voxel
	settings().Rendering.QualityLevel = 1
end
local function v46()
	settings().Rendering.ResolutionScale = 0.5
end
local function v47()
	local Terrain = t1.value3.Terrain

	if pcall(function()
		return Terrain.Decoration
	end) then
		t1.value33 = not t1.value33

		if t1.value33 then
			Terrain.Decoration = false

			return
		else
			Terrain.Decoration = t1.value13 == nil and true or (t1.value13 or true)

			return
		end
	end
end

for _ = 1, t1.value51 do
	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(0, 50, 0, 50)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1
	Frame.Parent = t1.value50

	local value52 = t1.value52

	table.insert(value52, Frame)
end

t1.value53 = Instance.new("TextLabel", t1.value47)
t1.value53.Size = UDim2.new(0, 50, 0, 50)
t1.value53.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value53.AnchorPoint = Vector2.new(1, 0.5)
t1.value53.BackgroundTransparency = 1
t1.value53.Text = "『"
t1.value53.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value53.TextSize = 65
t1.value53.Font = Enum.Font.Highway
t1.value53.TextTransparency = 1
t1.value54 = Instance.new("TextLabel", t1.value47)
t1.value54.Size = UDim2.new(0, 50, 0, 50)
t1.value54.Position = UDim2.new(0.5, 0, 0.5, 0)
t1.value54.AnchorPoint = Vector2.new(0, 0.5)
t1.value54.BackgroundTransparency = 1
t1.value54.Text = "』"
t1.value54.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value54.TextSize = 65
t1.value54.Font = Enum.Font.Highway
t1.value54.TextTransparency = 1
t1.value55 = Instance.new("TextButton", t1.value47)
t1.value55.Name = "SkipButton"
t1.value55.Size = UDim2.new(0, 80, 0, 30)
t1.value55.Position = UDim2.new(0.5, 0, 0.75, 0)
t1.value55.AnchorPoint = Vector2.new(0.5, 0.5)
t1.value55.BackgroundTransparency = 1
t1.value55.Text = "「skip」"
t1.value55.TextColor3 = Color3.fromRGB(255, 255, 255)
t1.value55.TextSize = 30
t1.value55.Font = Enum.Font.Highway
t1.value55.TextTransparency = 1
t1.value55.Visible = false
t1.value56 = Instance.new("Sound")
t1.value56.Name = "LoadingMusic"
t1.value56.SoundId = "rbxassetid://15930255433"
t1.value56.Volume = 0.5
t1.value56.Looped = true
t1.value56.Parent = SoundService
t1.value57 = true
t1.value58 = Instance.new("ScreenGui")
t1.value58.Name = "VenusHubSingle"
t1.value58.ResetOnSpawn = false
t1.value58.IgnoreGuiInset = true
t1.value58.Parent = t1.value6
t1.value59 = Instance.new("ImageButton", t1.value58)
t1.value59.Name = "VenusLauncher"
t1.value59.Size = UDim2.new(0, 56, 0, 56)
t1.value59.Position = UDim2.new(0.02, 0, 1, -66)
t1.value59.AnchorPoint = Vector2.new(0, 1)
t1.value59.BackgroundColor3 = t1.value21.Theme.panel
t1.value59.BorderSizePixel = 0
t1.value59.Image = "rbxassetid://135187475680901"
t1.value22(t1.value59, 28)
t1.value23(t1.value59, 1, t1.value21.Theme.accent)
t1.value59.Visible = false

function t1.value60()
	t1.value57 = false
	t1.value5:SetCore("SendNotification", {
		Title = "UniversHub by bao9002",
		Text = "✅ Script Graphics successfully loaded.",
		Duration = 5
	})
	t1.value5:SetCore("SendNotification", {
		Title = "INFORMATION ABOUT ME🚀",
		Text = "https://github.com/Uranus197",
		Icon = nil,
		Duration = 5
	})
	t1.value4:Create(t1.value56, TweenInfo.new(1), {
		Volume = 0
	}):Play()

	local tween = t1.value4:Create(t1.value46, TweenInfo.new(1), {
		BackgroundTransparency = 1
	})

	local function v53()
		t1.value28(t1.value8, t1.value19)
	end

	delay(0.4, v53)
	tween:Play()
	tween.Completed:Wait()
	t1.value56:Destroy()
	t1.value45:Destroy()
	t1.value42 = true
	t1.value59.Visible = true
end

t1.value55.MouseButton1Click:Connect(t1.value60)

function t1.value61()
	t1.value47:Destroy()

	local ImageLabel = Instance.new("ImageLabel", t1.value46)

	ImageLabel.Size = UDim2.fromScale(0.22, 0.22)
	ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = t1.value44
	ImageLabel.Rotation = 10
	ImageLabel.ZIndex = 3
	Instance.new("UIAspectRatioConstraint", ImageLabel).AspectRatio = 1
	Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0.25, 0)

	local UIStroke = Instance.new("UIStroke", ImageLabel)

	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 1.5
	UIStroke.Transparency = 0.6

	local Frame = Instance.new("Frame", t1.value46)

	Frame.Size = UDim2.fromScale(0.6, 0.25)
	Frame.Position = UDim2.fromScale(0.65, 0.5)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundTransparency = 1

	local t3 = {}

	for i = 1, #t1.value43 do
		local text = t1.value43:sub(i, i)
		local TextLabel = Instance.new("TextLabel", Frame)

		TextLabel.Size = UDim2.fromScale(0.085, 0.6)
		TextLabel.Position = UDim2.fromScale((i - 1) * 0.055, 0.5)
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = text
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextScaled = true
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.TextTransparency = 1
		table.insert(t3, TextLabel)
	end

	local TextButton = Instance.new("TextButton", t1.value46)

	TextButton.Size = UDim2.fromScale(0.18, 0.07)
	TextButton.Position = UDim2.fromScale(0.5, 0.72)
	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TextButton.Text = "【 PLAY 】"
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextScaled = true
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.TextTransparency = 1
	TextButton.BackgroundTransparency = 1
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0.4, 0)
	task.spawn(function()
		while true do
			local value57 = t1.value57

			if value57 then
				value57 = ImageLabel.Parent
			end

			if not value57 then
				return
			end

			t1.value4:Create(UIStroke, TweenInfo.new(1), {
				Transparency = 0.85
			}):Play()
			task.wait(1)

			local value4 = t1.value4
			local v64 = UIStroke
			local TweenInfo_ = TweenInfo

			value4.Create(value4, v64, TweenInfo_.new(1), {
				Transparency = 0.6
			}):Play()
			task.wait(1)
		end
	end)
	task.spawn(function()
		while true do
			local value57 = t1.value57

			if value57 then
				value57 = ImageLabel.Parent
			end

			if not value57 then
				return
			end

			local value4 = t1.value4
			local v68 = ImageLabel
			local tweenInfo = TweenInfo.new(1.2)

			value4.Create(value4, v68, tweenInfo, {
				Size = UDim2.fromScale(0.235, 0.235)
			}):Play()
			task.wait(1.2)

			local value42 = t1.value4
			local v71 = ImageLabel
			local tweenInfoNew = TweenInfo.new

			value42.Create(value42, v71, tweenInfoNew(1.2), {
				Size = UDim2.fromScale(0.22, 0.22)
			}):Play()
			task.wait(1.2)
		end
	end)
	task.spawn(function()
		while true do
			local value57 = t1.value57

			if value57 then
				value57 = TextButton.BackgroundTransparency == 1
			end

			if not value57 then
				break
			end

			task.wait(0.1)
		end

		while true do
			local value57 = t1.value57

			if value57 then
				value57 = TextButton.Parent
			end

			if not value57 then
				return
			end

			t1.value4:Create(TextButton, TweenInfo.new(0.6), {
				TextTransparency = 0.4
			}):Play()
			task.wait(0.6)
			t1.value4:Create(TextButton, TweenInfo.new(0.6), {
				TextTransparency = 0
			}):Play()
			task.wait(0.6)
		end
	end)
	TextButton.MouseEnter:Connect(function()
		local value4 = t1.value4
		local v76 = TextButton
		local tweenInfo = TweenInfo.new(0.2)
		local color3 = Color3.fromRGB

		value4.Create(value4, v76, tweenInfo, {
			BackgroundColor3 = color3(45, 45, 45),
			Size = UDim2.fromScale(0.19, 0.075)
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		local value4 = t1.value4
		local v80 = TextButton
		local tweenInfo = TweenInfo.new(0.2)
		local color3 = Color3.fromRGB

		value4.Create(value4, v80, tweenInfo, {
			BackgroundColor3 = color3(30, 30, 30),
			Size = UDim2.fromScale(0.18, 0.07)
		}):Play()
	end)

	local MouseButton1Click = TextButton.MouseButton1Click

	local function v84()
		t1.value57 = false
		t1.value4:Create(TextButton, TweenInfo.new(0.3), {
			TextTransparency = 1,
			BackgroundTransparency = 1
		}):Play()

		local value4 = t1.value4
		local v86 = ImageLabel
		local tweenInfo = TweenInfo.new(0.4)

		value4.Create(value4, v86, tweenInfo, {
			Size = UDim2.fromScale(0, 0),
			ImageTransparency = 1
		}):Play()

		for _, v in ipairs(t3) do
			local value42 = t1.value4

			value42.Create(value42, v, TweenInfo.new(0.3), {
				TextTransparency = 1
			}):Play()
		end

		task.wait(0.4)
		t1.value60()
	end

	MouseButton1Click.Connect(MouseButton1Click, v84)

	local function v91()
		local value4 = t1.value4
		local v93 = ImageLabel
		local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Linear)
		local v95 = value4.Create(value4, v93, tweenInfo, {
			Rotation = ImageLabel.Rotation + 360
		})

		v95:Play()
		v95.Completed:Wait()
	end
	local function v96()
		for _, v in ipairs(t3) do
			if not t1.value57 then
				return
			end

			local value4 = t1.value4
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			value4.Create(value4, v, tweenInfoNew(0.25, EasingStyle.Back), {
				Size = UDim2.fromScale(0.11, 0.75)
			}):Play()
			task.wait(0.08)

			local value42 = t1.value4
			local tweenInfo = TweenInfo.new(0.15)
			local UDim2_ = UDim2

			value42.Create(value42, v, tweenInfo, {
				Size = UDim2_.fromScale(0.085, 0.6)
			}):Play()
		end
	end

	task.spawn(function()
		v91()

		local value4 = t1.value4
		local v106 = ImageLabel
		local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart)

		value4.Create(value4, v106, tweenInfo, {
			Position = UDim2.fromScale(0.25, 0.5)
		}):Play()
		task.wait(0.25)

		for _, v in ipairs(t3) do
			v.Position = v.Position - UDim2.fromScale(0, 0.08)
			t1.value4:Create(v, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
				TextTransparency = 0,
				Position = v.Position + UDim2.fromScale(0, 0.08)
			}):Play()
			task.wait(0.05)
		end

		task.wait(0.3)
		t1.value4:Create(TextButton, TweenInfo.new(0.5), {
			BackgroundTransparency = 0,
			TextTransparency = 0
		}):Play()
		task.wait(0.3)

		while t1.value57 do
			v91()
			v96()
		end
	end)
end
function t1.value62()
	local t4 = {
		0.1,
		0.2,
		0.3,
		0.4,
		0.5,
		0.6,
		0.7,
		0.8,
		0.9
	}

	return t4[math.random(1, #t4)]
end
function t1.value63(p17)
	if not (p17 <= t1.value51) then
		return
	end

	local v111 = t1.value52[p17]

	for _ = 1, 3 do
		if not t1.value57 then
			break
		end

		t1.value4:Create(v111, TweenInfo.new(0.05), {
			BackgroundTransparency = 0.2
		}):Play()
		task.wait(0.05)
		t1.value4:Create(v111, TweenInfo.new(0.05), {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.05)
	end

	t1.value4:Create(v111, TweenInfo.new(0.05), {
		BackgroundTransparency = 0
	}):Play()
end

coroutine.wrap(function()
	local tween = t1.value4:Create(t1.value46, TweenInfo.new(1), {
		BackgroundTransparency = 0
	})

	tween:Play()
	tween.Completed:Wait()
	task.wait(0.5)
	t1.value56:Play()

	local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local n1 = 180

	t1.value53.TextTransparency = 0
	t1.value54.TextTransparency = 0
	t1.value4:Create(t1.value53, tweenInfo, {
		Position = UDim2.new(0.5, -n1, 0.5, 0)
	}):Play()

	local value4 = t1.value4
	local value54 = t1.value54
	local v118 = value4.Create(value4, value54, tweenInfo, {
		Position = UDim2.new(0.5, n1, 0.5, 0)
	})

	v118:Play()
	v118.Completed:Wait()
	t1.value48.TextSize = 0
	t1.value48.TextTransparency = 0

	local tween2 = t1.value4:Create(t1.value48, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		TextSize = 48
	})

	tween2:Play()
	tween2.Completed:Wait()
	task.wait(0.3)
	t1.value4:Create(t1.value48, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Position = UDim2.new(0.5, 0, 0.15, 0),
		TextSize = 26
	}):Play()
	task.wait(0.5)
	t1.value48.Visible = false
	t1.value49.Visible = true
	t1.value49.TextTransparency = 0
	t1.value50.Visible = true
	t1.value55.Visible = true

	local tween3 = t1.value4:Create(t1.value55, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})

	t1.value55.Size = UDim2.new(0, 180, 0, 50)
	tween3:Play()
	task.wait(0.3)

	local tween4 = t1.value4:Create(t1.value55, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		TextTransparency = 0.5
	})

	tween4:Play()

	local value42 = t1.value4
	local value49 = t1.value49
	local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local n2 = 1
	local v126 = value42.Create(value42, value49, tweenInfo2, {
		TextTransparency = 0.5
	})

	v126:Play()

	local v127 = n2 < 0
	local v128 = 1 - n2
	local n3 = 25
	local n4 = 10
	local n5 = 0

	while true do
		v128 = v128 + n2

		local v132 = ((not v127 or n3 > v128) and true or false) and not v127

		if v132 then
			v132 = v128 <= n3
		end

		if not (v132 and t1.value57) then
			t1.value49.Text = string.format("loading config%d/10", n4)
			v126:Cancel()
			t1.value49.TextTransparency = 0
			t1.value49.Text = "complete"
			task.wait(0.5)
			tween4:Cancel()

			local tween5 = t1.value4:Create(t1.value49, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
				TextTransparency = 1
			})

			tween5:Play()

			for i = 1, t1.value51 do
				t1.value4:Create(t1.value52[i], tween5.TweenInfo, {
					BackgroundTransparency = 1
				}):Play()
			end

			t1.value4:Create(t1.value53, tween5.TweenInfo, {
				TextTransparency = 1
			}):Play()
			t1.value4:Create(t1.value54, tween5.TweenInfo, {
				TextTransparency = 1
			}):Play()
			t1.value4:Create(t1.value55, tween5.TweenInfo, {
				TextTransparency = 1
			}):Play()
			task.wait(0.5)
			t1.value61()

			return
		end

		local v135 = v128 / 25 * n4
		local v136 = math.min(v135, n4)
		local v137 = n5 + 1
		local v138

		if v137 <= n4 then
			v138 = v137 <= v136
		else
			v138 = false
		end

		if v138 then
			t1.value49.Text = string.format("loading config%d/10", v137)
			t1.value63(v137)
		elseif n5 < n4 then
			if math.random(1, 2) == 1 then
				t1.value49.Text = string.format("loading config%d/10", n5)
				v137 = n5
			else
				local v139 = n5 + t1.value62()
				local v140

				if v139 < v137 then
					v140 = v139 < n4
				else
					v140 = false
				end

				if v140 then
					t1.value49.Text = string.format("loading config%.1f/10", v139)
					v137 = n5
				else
					t1.value49.Text = string.format("loading config%d/10", n5)
					v137 = n5
				end
			end
		else
			v137 = n5
		end

		task.wait(0.228)
		n5 = v137
	end
end)()
t1.value64 = false
t1.value65 = nil
t1.value66 = nil
t1.value67 = nil

function t1.value68(p18)
	local v141 = p18.Position - t1.value65
	local t5 = {
		Position = UDim2.new(t1.value66.X.Scale, t1.value66.X.Offset + v141.X, t1.value66.Y.Scale, t1.value66.Y.Offset + v141.Y)
	}

	t1.value4:Create(t1.value59, TweenInfo.new(0.06, Enum.EasingStyle.Linear), t5):Play()
end

t1.value59.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.Touch and true or input.UserInputType == Enum.UserInputType.MouseButton1) then
		return
	end

	t1.value64 = true

	local _ = input.Position
	local _ = t1.value59.Position

	t1.value67 = input
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t1.value64 = false
	end)
end)
t1.value2.InputChanged:Connect(function(input)
	local value64 = t1.value64

	if value64 then
		value64 = input == t1.value67
	end

	if not value64 then
		return
	end

	t1.value68(input)
end)
t1.value69 = Instance.new("Frame", t1.value58)
t1.value69.Name = "VenusMain"
t1.value69.Size = UDim2.new(0, 380, 0, 320)
t1.value69.Position = UDim2.new(0.5, -190, 0.5, -160)
t1.value69.AnchorPoint = Vector2.new(0, 0)
t1.value69.BackgroundColor3 = t1.value21.Theme.bg
t1.value69.BorderSizePixel = 0
t1.value22(t1.value69, 12)
t1.value23(t1.value69, 1.5, t1.value21.Theme.accent)
t1.value69.Visible = false
t1.value69.ClipsDescendants = true
t1.value69.Size = UDim2.new(0, 0, 0, 0)
t1.value70 = Instance.new("ImageLabel", t1.value69)
t1.value70.Size = UDim2.new(1, 0, 1, 0)
t1.value70.Position = UDim2.new(0, 0, 0, 0)
t1.value70.BackgroundTransparency = 1
t1.value70.ImageTransparency = 0.8
t1.value70.ZIndex = 1

local Frame = Instance.new("Frame", t1.value69)

Frame.Size = UDim2.new(1, -12, 1, -12)
Frame.Position = UDim2.new(0, 6, 0, 6)
Frame.BackgroundTransparency = 1
Frame.ZIndex = 2
t1.value71 = false
t1.value72 = nil
t1.value73 = nil
t1.value73 = nil
t1.value74 = nil

function t1.value75(p19)
	local v147 = p19.Position - t1.value72
	local t6 = {
		Position = UDim2.new(t1.value73.X.Scale, t1.value73.X.Offset + v147.X, t1.value73.Y.Scale, t1.value73.Y.Offset + v147.Y)
	}

	t1.value4:Create(t1.value69, TweenInfo.new(0.06, Enum.EasingStyle.Linear), t6):Play()
end

t1.value69.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value71 = true

	local _ = input.Position
	local _ = t1.value69.Position

	t1.value74 = input
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t1.value71 = false
	end)
end)
t1.value2.InputChanged:Connect(function(input)
	local value71 = t1.value71

	if value71 then
		value71 = input == t1.value74
	end

	if not value71 then
		return
	end

	t1.value75(input)
end)

local Frame2 = Instance.new("Frame", Frame)

Frame2.Size = UDim2.new(1, 0, 0, 44)
Frame2.Position = UDim2.new(0, 0, 0, 0)
Frame2.BackgroundTransparency = 1

local ImageLabel = Instance.new("ImageLabel", Frame2)

ImageLabel.Size = UDim2.new(0, 24, 0, 24)
ImageLabel.Position = UDim2.new(0, 8, 0.5, -12)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://114584661024711"
ImageLabel.ZIndex = 3

local TextLabel = Instance.new("TextLabel", Frame2)

TextLabel.Size = UDim2.new(1, -120, 1, 0)
TextLabel.Position = UDim2.new(0, 38, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Univers Hub | Graphics script"
TextLabel.TextColor3 = t1.value21.Theme.text
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

local ImageLabel2 = Instance.new("ImageLabel", Frame2)

ImageLabel2.Size = UDim2.new(0, 24, 0, 24)
ImageLabel2.Position = UDim2.new(0, 245, 0.5, -12)
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.Image = "rbxassetid://71607909219378"
ImageLabel2.ZIndex = 3

local TextButton = Instance.new("TextButton", Frame2)

TextButton.Size = UDim2.new(0, 28, 0, 28)
TextButton.Position = UDim2.new(1, -72, 0.5, -14)
TextButton.Text = "—"
TextButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextButton.TextColor3 = Color3.fromRGB(250, 250, 250)
t1.value22(TextButton, 6)
t1.value23(TextButton, 1)

local TextButton2 = Instance.new("TextButton", Frame2)

TextButton2.Size = UDim2.new(0, 28, 0, 28)
TextButton2.Position = UDim2.new(1, -40, 0.5, -14)
TextButton2.Text = "X"
TextButton2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
TextButton2.TextColor3 = Color3.fromRGB(250, 250, 250)
t1.value22(TextButton2, 6)
t1.value23(TextButton2, 1)
t1.value76 = Instance.new("Frame", t1.value58)
t1.value76.Name = "UniversTopBar"
t1.value76.Size = UDim2.new(0, 320, 0, 45)
t1.value76.Position = UDim2.new(0.5, -160, 0, 10)
t1.value76.BackgroundColor3 = t1.value21.Theme.panel
t1.value76.Visible = false
t1.value22(t1.value76, 10)
t1.value23(t1.value76, 1, t1.value21.Theme.accent)

local ImageLabel3 = Instance.new("ImageLabel", t1.value76)

ImageLabel3.Size = UDim2.new(0, 35, 0, 35)
ImageLabel3.Position = UDim2.new(0, 5, 0.5, -17.5)
ImageLabel3.BackgroundTransparency = 1
ImageLabel3.Image = "rbxassetid://112179445825929"

local TextLabel2 = Instance.new("TextLabel", t1.value76)

TextLabel2.Size = UDim2.new(0, 150, 0, 20)
TextLabel2.Position = UDim2.new(0, 45, 0, 2)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "UniversHub [Graphics]"
TextLabel2.TextColor3 = t1.value21.Theme.text
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextSize = 14
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel3 = Instance.new("TextLabel", t1.value76)

TextLabel3.Size = UDim2.new(0, 200, 0, 15)
TextLabel3.Position = UDim2.new(0, 45, 0, 22)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "by bao9002 | https://github.com/Uranus197"
TextLabel3.TextColor3 = t1.value21.Theme.muted
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.TextSize = 10
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.TextTransparency = 0.3

local TextButton3 = Instance.new("TextButton", t1.value76)

TextButton3.Size = UDim2.new(0, 38, 0, 38)
TextButton3.Position = UDim2.new(1, -43, 0.5, -19)
TextButton3.BackgroundColor3 = t1.value21.Theme.bg
TextButton3.Text = "▽"
TextButton3.TextColor3 = t1.value21.Theme.accent
TextButton3.Font = Enum.Font.GothamBold
TextButton3.TextSize = 25
t1.value22(TextButton3, 8)
t1.value77 = false
t1.value78 = nil
t1.value79 = nil
t1.value76.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value77 = true
	t1.value78 = input.Position
	t1.value79 = t1.value76.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t1.value77 = false
	end)
end)
t1.value2.InputChanged:Connect(function(input)
	if not (t1.value77 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local v162 = input.Position - t1.value78
	local value4 = t1.value4
	local value76 = t1.value76
	local tweenInfo = TweenInfo.new(0.05)
	local uDim2New = UDim2.new
	local Scale = t1.value79.X.Scale
	local value79 = t1.value79

	value4.Create(value4, value76, tweenInfo, {
		Position = uDim2New(Scale, value79.X.Offset + v162.X, t1.value79.Y.Scale, t1.value79.Y.Offset + v162.Y)
	}):Play()
end)
t1.value80 = Instance.new("Frame", t1.value58)
t1.value80.Size = UDim2.new(0, 260, 0, 140)
t1.value80.Position = UDim2.new(0.5, -130, 0.5, -70)
t1.value80.BackgroundColor3 = t1.value21.Theme.bg
t1.value80.Visible = false
t1.value80.ZIndex = 20
t1.value22(t1.value80, 12)
t1.value23(t1.value80, 2, Color3.fromRGB(255, 50, 50))
t1.value81 = Instance.new("TextLabel", t1.value80)
t1.value81.Size = UDim2.new(1, 0, 0.3, 0)
t1.value81.Position = UDim2.new(0, 0, 0.05, 0)
t1.value81.BackgroundTransparency = 1
t1.value81.Text = "Do you want to escape?"
t1.value81.TextColor3 = t1.value21.Theme.text
t1.value81.Font = Enum.Font.GothamBold
t1.value81.TextSize = 16
t1.value81.ZIndex = 21
t1.value82 = Instance.new("ImageLabel", t1.value80)
t1.value82.Size = UDim2.new(0, 50, 0, 50)
t1.value82.Position = UDim2.new(0.5, -25, 0.45, -15)
t1.value82.BackgroundTransparency = 1
t1.value82.Image = "rbxassetid://126601715821016"
t1.value82.ZIndex = 21
t1.value83 = Instance.new("TextButton", t1.value80)
t1.value83.Size = UDim2.new(0, 100, 0, 35)
t1.value83.Position = UDim2.new(0, 20, 0.65, 0)
t1.value83.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
t1.value83.Text = "Yes"
t1.value83.TextColor3 = Color3.new(1, 1, 1)
t1.value83.Font = Enum.Font.GothamBold
t1.value83.ZIndex = 21
t1.value22(t1.value83, 6)

local TextButton4 = Instance.new("TextButton", t1.value80)

TextButton4.Size = UDim2.new(0, 100, 0, 35)
TextButton4.Position = UDim2.new(1, -120, 0.65, 0)
TextButton4.BackgroundColor3 = t1.value21.Theme.panel
TextButton4.Text = "No"
TextButton4.TextColor3 = t1.value21.Theme.text
TextButton4.Font = Enum.Font.GothamBold
TextButton4.ZIndex = 21
t1.value22(TextButton4, 6)
t1.value84 = 1
t1.value83.MouseButton1Click:Connect(function()
	t1.value26("rbxassetid://12221967", 0.6)

	if t1.value84 == 1 then
		t1.value81.Text = "don\'t leave me pls"
		t1.value82.Image = "rbxassetid://105863999014084"
		t1.value83.Text = "Confim"

		return
	end

	if not game:GetService("Lighting"):FindFirstChild("VenusBlur") then
		t1.value58:Destroy()
		script:Destroy()

		return
	end

	game:GetService("Lighting").VenusBlur:Destroy()
	t1.value58:Destroy()
	script:Destroy()
end)
TextButton4.MouseButton1Click:Connect(function()
	t1.value26("rbxassetid://12221967", 0.6)
	t1.value80.Visible = false
	t1.value69.Visible = true
	t1.value20.Enabled = false
	t1.value81.Text = "Do you want to escape?"
	t1.value82.Image = "rbxassetid://126601715821016"
	t1.value83.Text = "Yes"
end)
TextButton.MouseButton1Click:Connect(function()
	t1.value26("rbxassetid://12221976", 0.6)

	local Position = t1.value69.Position
	local uDim2 = UDim2.new(Position.X.Scale, Position.X.Offset, 0, -50)
	local value4 = t1.value4
	local value69 = t1.value69
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local v175 = value4.Create(value4, value69, tweenInfo, {
		Position = uDim2,
		Size = UDim2.new(0, 380, 0, 0),
		BackgroundTransparency = 1
	})

	t1.value4:Create(t1.value20, TweenInfo.new(0.3), {
		Size = 0
	}):Play()
	v175:Play()
	v175.Completed:Wait()
	t1.value69.Visible = false
	t1.value20.Enabled = false
	t1.value76.Visible = true
	t1.value76.Position = UDim2.new(0.5, -160, 0, -50)

	local value42 = t1.value4
	local value76 = t1.value76
	local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Quint)
	local uDim2New = UDim2.new

	value42.Create(value42, value76, tweenInfo2, {
		Position = uDim2New(0.5, -160, 0, 10)
	}):Play()
end)
TextButton3.MouseButton1Click:Connect(function()
	t1.value26("rbxassetid://12221976", 0.6)

	local value4 = t1.value4
	local value76 = t1.value76
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local v183 = value4.Create(value4, value76, tweenInfo, {
		Position = UDim2.new(0.5, -160, 0, -50)
	})

	v183:Play()
	v183.Completed:Wait()
	t1.value76.Visible = false
	t1.value69.Visible = true
	t1.value69.Size = UDim2.new(0, 380, 0, 0)
	t1.value69.Position = UDim2.new(0.5, -190, 0, -50)
	t1.value69.BackgroundTransparency = 1
	t1.value20.Enabled = true
	t1.value4:Create(t1.value20, TweenInfo.new(0.4), {
		Size = 10
	}):Play()
	t1.value4:Create(t1.value69, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -190, 0.5, -160),
		Size = UDim2.new(0, 380, 0, 320),
		BackgroundTransparency = 0
	}):Play()
end)
TextButton2.MouseButton1Click:Connect(function()
	t1.value26("rbxassetid://12221967", 0.6)
	t1.value69.Visible = false
	t1.value76.Visible = false
	t1.value80.Visible = true
	t1.value20.Enabled = true
end)
t1.value85 = Instance.new("ScrollingFrame", Frame)
t1.value85.Name = "TabFrame"
t1.value85.Size = UDim2.new(0, 130, 1, -125)
t1.value85.Position = UDim2.new(0, 8, 0, 52)
t1.value85.BackgroundTransparency = 1
t1.value85.ScrollBarThickness = 6
t1.value85.CanvasSize = UDim2.new(0, 0, 0, 0)
t1.value85.Active = true
t1.value85.ClipsDescendants = true
t1.value85.ScrollingEnabled = true
t1.value85.ZIndex = 6
t1.value85.ScrollBarImageColor3 = t1.value21.Theme.accent
t1.value85.ScrollBarImageTransparency = 0
t1.value85.VerticalScrollBarInset = Enum.ScrollBarInset.None
t1.value86 = Instance.new("UIListLayout", t1.value85)
t1.value86.Padding = UDim.new(0, 8)
t1.value86:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	t1.value85.CanvasSize = UDim2.new(0, 0, 0, t1.value86.AbsoluteContentSize.Y + 12)
end)
t1.value87 = false
t1.value88 = Vector2.new(0, 0)
t1.value89 = Vector2.new(0, 0)
t1.value85.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value87 = true
	t1.value88 = input.Position
	t1.value89 = t1.value85.CanvasPosition
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t1.value87 = false
	end)
end)
t1.value2.InputChanged:Connect(function(input)
	if not (t1.value87 and input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local v184 = input.Position - t1.value88
	local v185 = math.max(0, t1.value85.CanvasSize.Y.Offset - t1.value85.AbsoluteSize.Y)
	local v186 = t1.value89.Y - v184.Y
	local v187 = math.clamp(v186, 0, v185)

	t1.value85.CanvasPosition = Vector2.new(0, v187)
end)

local function createTextButton(p20, p21)
	local TextButton5 = Instance.new("TextButton", t1.value85)

	TextButton5.Size = UDim2.new(1, -6, 0, 40)
	TextButton5.BackgroundColor3 = t1.value21.Theme.panel
	TextButton5.Text = "  " .. p20
	TextButton5.TextColor3 = t1.value21.Theme.text
	TextButton5.Font = Enum.Font.GothamSemibold
	TextButton5.TextSize = 14
	TextButton5.ZIndex = 7
	t1.value22(TextButton5, 8)
	t1.value23(TextButton5, 1)

	if not p21 then
		return TextButton5
	end

	local ImageLabel4 = Instance.new("ImageLabel", TextButton5)

	ImageLabel4.Size = UDim2.new(0, 28, 0, 28)
	ImageLabel4.Position = UDim2.new(0, 8, 0.5, -14)
	ImageLabel4.Image = p21
	ImageLabel4.BackgroundTransparency = 1
	ImageLabel4.ZIndex = 8
	t1.value22(ImageLabel4, 6)

	return TextButton5
end

t1.value90 = Instance.new("Frame", Frame)
t1.value90.Size = UDim2.new(1, -154, 1, -60)
t1.value90.Position = UDim2.new(0, 146, 0, 52)
t1.value90.BackgroundTransparency = 1
t1.value91 = {}

local function createScrollingFrame()
	local ScrollingFrame = Instance.new("ScrollingFrame", t1.value90)

	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.ScrollBarThickness = 8
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.Visible = false

	local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

	UIListLayout2.Padding = UDim.new(0, 8)
	UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout2.AbsoluteContentSize.Y + 12)
	end)

	local v194 = #t1.value91 + 1

	t1.value91[v194] = ScrollingFrame

	return ScrollingFrame
end

function t1.value92(p22)
	for i, v in ipairs(t1.value91) do
		v.Visible = i == p22
	end
end

local function createTextButton2(p23, p24, p25)
	local TextButton5 = Instance.new("TextButton", p23)

	TextButton5.Size = UDim2.new(1, -12, 0, 36)
	TextButton5.BackgroundColor3 = t1.value21.Theme.accent
	TextButton5.Text = p24
	TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton5.Font = Enum.Font.GothamSemibold
	TextButton5.TextSize = 14
	t1.value22(TextButton5, 6)
	t1.value23(TextButton5, 1, Color3.fromRGB(120, 80, 200))
	TextButton5.MouseButton1Click:Connect(function()
		t1.value27()
		pcall(p25)
	end)

	return TextButton5
end

local v199 = createScrollingFrame()
local TextButton5 = Instance.new("TextButton", v199)

TextButton5.Size = UDim2.new(1, -12, 0, 36)
TextButton5.Text = "Edit Background"
TextButton5.BackgroundColor3 = t1.value21.Theme.panel
TextButton5.TextColor3 = t1.value21.Theme.text
t1.value22(TextButton5, 6)
t1.value93 = (function(p26, p27, p28)
	local Frame3 = Instance.new("Frame", p26)

	Frame3.Size = UDim2.new(1, -12, 0, 32)
	Frame3.BackgroundTransparency = 1

	local TextBox = Instance.new("TextBox", Frame3)

	TextBox.Size = UDim2.new(1, 0, 1, 0)
	TextBox.BackgroundColor3 = t1.value21.Theme.panel
	TextBox.TextColor3 = t1.value21.Theme.text
	TextBox.PlaceholderText = p27
	TextBox.ClearTextOnFocus = false
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.TextSize = 14
	TextBox.TextWrapped = true
	t1.value22(TextBox, 6)
	TextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			enterPressed = TextBox.Text

			if enterPressed then
				enterPressed = TextBox.Text ~= ""
			end
		end

		if not enterPressed then
			return
		end

		pcall(p28, TextBox.Text)
		TextBox.Text = ""
	end)

	return TextBox
end)(v199, "Paste Image ID", function(p29)
	local match = p29:match("rbxassetid://(%d+)") or p29:match("^(%d+)$")

	t1.value70.Image = "rbxassetid://" .. (match or p29)
end)
t1.value93.Parent.Visible = false
TextButton5.MouseButton1Click:Connect(function()
	t1.value27()
	t1.value93.Parent.Visible = not t1.value93.Parent.Visible
end)

local Frame3 = Instance.new("Frame", v199)

Frame3.Size = UDim2.new(1, -12, 0, 80)
Frame3.BackgroundTransparency = 1

local UIListLayout2 = Instance.new("UIListLayout", Frame3)

UIListLayout2.Padding = UDim.new(0, 4)
UIListLayout2.FillDirection = Enum.FillDirection.Vertical
t1.value94 = Instance.new("TextBox", Frame3)
t1.value94.Size = UDim2.new(1, 0, 0, 28)
t1.value94.BackgroundColor3 = t1.value21.Theme.panel
t1.value94.TextColor3 = t1.value21.Theme.text
t1.value94.Text = "120102995443063"
t1.value94.PlaceholderText = "Paste Music ID"
t1.value94.ClearTextOnFocus = false
t1.value22(t1.value94, 6)
t1.value94.FocusLost:Connect(function(enterPressed)
	if not enterPressed then
		return
	end

	t1.value27()

	local Text = t1.value94.Text
	local match = Text:match("rbxassetid://") and Text and Text or ("rbxassetid://" .. Text:match("^(%d+)$") or Text)

	t1.value94.Text = match
	t1.value28(match, t1.value19)
end)

local Frame4 = Instance.new("Frame", Frame3)

Frame4.Size = UDim2.new(1, 0, 0, 28)
Frame4.BackgroundTransparency = 1
t1.value95 = Instance.new("TextLabel", Frame4)
t1.value95.Size = UDim2.new(0, 60, 1, 0)
t1.value95.Position = UDim2.new(0, 0, 0, 0)
t1.value95.BackgroundTransparency = 1
t1.value95.Text = "Volume:"
t1.value95.TextColor3 = t1.value21.Theme.text
t1.value95.Font = Enum.Font.GothamSemibold
t1.value95.TextSize = 12
t1.value95.TextXAlignment = Enum.TextXAlignment.Left
t1.value96 = Instance.new("Frame", Frame4)
t1.value96.Size = UDim2.new(1, -68, 0, 10)
t1.value96.Position = UDim2.new(0, 68, 0.5, -5)
t1.value96.BackgroundColor3 = t1.value21.Theme.panel
t1.value22(t1.value96, 5)
t1.value97 = Instance.new("Frame", t1.value96)
t1.value97.Size = UDim2.new(t1.value19 / 1, 0, 1, 0)
t1.value97.BackgroundColor3 = t1.value21.Theme.accent
t1.value22(t1.value97, 5)
t1.value98 = Instance.new("Frame", t1.value96)
t1.value98.Size = UDim2.new(0, 10, 0, 10)
t1.value98.Position = UDim2.new(t1.value19 / 1, -5, 0.5, -5)
t1.value98.BackgroundColor3 = t1.value21.Theme.text
t1.value22(t1.value98, 5)
t1.value99 = false

function t1.value100(p30)
	local v209 = p30.Position.X - t1.value96.AbsolutePosition.X
	local X = t1.value96.AbsoluteSize.X
	local v211 = t1
	local v212 = math.clamp(v209, 0, X) / t1.value96.AbsoluteSize.X * 100

	v211.value19 = math.floor(v212) / 100
	t1.value97.Size = UDim2.new(t1.value19, 0, 1, 0)
	t1.value98.Position = UDim2.new(t1.value19, -5, 0.5, -5)

	if not t1.value18 then
		v240 = t1.value95
		v241 = string.format
		v242 = t1.value19 * 100
		v240.Text = v241("Volume: %d%%", (math.floor(v242)))

		return
	end

	t1.value18.Volume = t1.value19

	local value95 = t1.value95
	local format = string.format
	local v215 = t1.value19 * 100

	value95.Text = format("Volume: %d%%", (math.floor(v215)))
end

t1.value96.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value99 = true
	t1.value100(input)

	local connection = t1.value2.InputChanged:Connect(function(input2)
		if not (t1.value99 and input2.UserInputType == Enum.UserInputType.MouseMovement and true or input2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t1.value100(input2)
	end)

	t1.value2.InputEnded:Connect(function(input2)
		if not (input2.UserInputType == Enum.UserInputType.MouseButton1 and true or input2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		connection:Disconnect()
		ended:Disconnect()
	end)
end)

local value95 = t1.value95
local format = string.format
local v219 = t1.value19 * 100

value95.Text = format("Volume: %d%%", (math.floor(v219)))

local Frame5 = Instance.new("Frame", v199)

Frame5.Size = UDim2.new(1, -12, 0, 40)
Frame5.BackgroundTransparency = 1
t1.value101 = Instance.new("TextLabel", Frame5)
t1.value101.Size = UDim2.new(0, 80, 1, 0)
t1.value101.Position = UDim2.new(0, 0, 0, 0)
t1.value101.BackgroundTransparency = 1
t1.value101.Text = "FOV:"
t1.value101.TextColor3 = t1.value21.Theme.text
t1.value101.Font = Enum.Font.GothamSemibold
t1.value101.TextSize = 12
t1.value101.TextXAlignment = Enum.TextXAlignment.Left
t1.value102 = Instance.new("Frame", Frame5)
t1.value102.Size = UDim2.new(1, -88, 0, 10)
t1.value102.Position = UDim2.new(0, 88, 0.5, -5)
t1.value102.BackgroundColor3 = t1.value21.Theme.panel
t1.value22(t1.value102, 5)
t1.value103 = 70
t1.value104 = 120

local CurrentCamera = t1.value3.CurrentCamera

if CurrentCamera then
	CurrentCamera = t1.value3.CurrentCamera.FieldOfView
end

t1.value105 = CurrentCamera or 70

local value105 = t1.value105
local value103 = t1.value103
local value104 = t1.value104

t1.value105 = math.clamp(value105, value103, value104)
t1.value106 = Instance.new("Frame", t1.value102)
t1.value106.Size = UDim2.new((t1.value105 - t1.value103) / (t1.value104 - t1.value103), 0, 1, 0)
t1.value106.BackgroundColor3 = t1.value21.Theme.accent
t1.value22(t1.value106, 5)
t1.value107 = Instance.new("Frame", t1.value102)
t1.value107.Size = UDim2.new(0, 10, 0, 10)
t1.value107.Position = UDim2.new((t1.value105 - t1.value103) / (t1.value104 - t1.value103), -5, 0.5, -5)
t1.value107.BackgroundColor3 = t1.value21.Theme.text
t1.value22(t1.value107, 5)
t1.value108 = false

function t1.value109(p31)
	local v225 = p31.Position.X - t1.value102.AbsolutePosition.X
	local X = t1.value102.AbsoluteSize.X
	local v227 = math.clamp(v225, 0, X) / t1.value102.AbsoluteSize.X
	local v228 = t1
	local value1032 = t1.value103
	local v230 = v227 * (t1.value104 - t1.value103) * 100

	v228.value105 = value1032 + math.floor(v230) / 100
	t1.value106.Size = UDim2.new((t1.value105 - t1.value103) / (t1.value104 - t1.value103), 0, 1, 0)
	t1.value107.Position = UDim2.new((t1.value105 - t1.value103) / (t1.value104 - t1.value103), -5, 0.5, -5)

	local value101 = t1.value101
	local format2 = string.format
	local value1052 = t1.value105

	value101.Text = format2("FOV: %d", (math.floor(value1052)))

	if not t1.value3.CurrentCamera then
		return
	end

	t1.value3.CurrentCamera.FieldOfView = t1.value105
end

t1.value102.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value108 = true
	t1.value109(input)

	local connection = t1.value2.InputChanged:Connect(function(input2)
		if not (t1.value108 and input2.UserInputType == Enum.UserInputType.MouseMovement and true or input2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t1.value109(input2)
	end)

	t1.value2.InputEnded:Connect(function(input2)
		if not (input2.UserInputType == Enum.UserInputType.MouseButton1 and true or input2.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		connection:Disconnect()
		ended:Disconnect()
	end)
end)

local value101 = t1.value101
local format2 = string.format
local value1052 = t1.value105

value101.Text = format2("FOV: %d", (math.floor(value1052)))
createTextButton2(v199, "Show FPS & Ping", function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranus197/ShowFpsAndPing/639b304eb30dff9b82fa13f170c46fddb246f178/ShowFPSAndPING"))()
	end)
end)
createTextButton2(v199, "Show Server Info", function()
	pcall(function()
		loadstring(game:HttpGet("https://pastebin.com/raw/Ggsdbxfd"))()
	end)
end)
createTextButton2(v199, "OFF ALL", function()
	t1.value29()
	t1.value30 = false
	t1.value29()
	t1.value93.Parent.Visible = false
	t1.value20.Enabled = false
	t1.value70.Image = ""
	t1.value41(false)
	settings().Rendering.QualityLevel = t1.value12 or 10
	settings().Rendering.Shadows = true
	settings().Rendering.TextureQuality = 0
	settings().Rendering.ResolutionScale = 1

	local function v238()
		t1.value3.Terrain.Decoration = t1.value13
	end

	pcall(v238)
	t1.value1.GlobalShadows = t1.value14
	t1.value1.FogEnd = t1.value10
	t1.value1.FogColor = t1.value11
	t1.value1.SpecularScale = 1
	t1.value1.Reflectance = 0
	t1.value1.Ambient = t1.value15
	t1.value1.OutdoorAmbient = t1.value16
	t1.value1.Brightness = t1.value17
	t1.value1.Technology = Enum.Technology.Future

	for _, child in ipairs(t1.value1:GetChildren()) do
		if child:IsA("Sky") or (child:IsA("Atmosphere") or (child:IsA("Clouds") or (child:IsA("PostEffect") or child:IsA("BlurEffect")))) then
			local v243

			if child.Name == "PerformanceBlur" then
				v243 = false
			else
				v243 = child.Name ~= "VenusBlur"
			end

			if v243 then
				child:Destroy()
			else
				child.Enabled = false
			end
		end
	end

	local t7 = {
		"BloomEffect",
		"SunRaysEffect",
		"ColorCorrectionEffect",
		"BlurEffect",
		"DepthOfFieldEffect",
		"Atmosphere"
	}

	local function v244(p32)
		for _, child in ipairs(p32:GetChildren()) do
			for _, v in ipairs(t7) do
				if child:IsA(v) then
					child.Enabled = true
				end
			end
		end
	end

	v244(t1.value1)

	if t1.value3.CurrentCamera then
		v244(t1.value3.CurrentCamera)
	end

	t1.value3.Terrain.MaterialProperties = nil

	local PerformanceBlur = t1.value1:FindFirstChild("PerformanceBlur")

	if PerformanceBlur then
		PerformanceBlur:Destroy()
	end

	local Clouds = t1.value1:FindFirstChildOfClass("Clouds")

	if Clouds then
		Clouds.Enabled = true
	end

	if t1.value37 then
		t1.value37:Disconnect()
	end

	if not t1.value38 then
		setfpscap(60)

		return
	end

	t1.value38:Disconnect()
	setfpscap(60)
end)

local v250 = createScrollingFrame()

createTextButton2(v250, "Remove Textures", toggleValue35)
createTextButton2(v250, "Remove Grass", v47)
createTextButton2(v250, "Disable Shadow", toggleValue32)
createTextButton2(v250, "Disable Effect", toggleValue25)
createTextButton2(v250, "Disable Terrain Textures", toggleValue34)
createTextButton2(v250, "Lighting Voxel", v45)
createTextButton2(v250, "Dynamic Resolution", v46)
createTextButton2(v250, "Uncap FPS", v37)

local v251 = createScrollingFrame()

createTextButton2(v251, "Simple", function()
	if t1.value30 then
		t1.value30 = false
		t1.value29()
	else
		t1.value31()
	end
end)
createTextButton2(v251, "Premium", function()
	pcall(function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Premium-RTX-Shader-59847"))()
	end)
end)
createTextButton2(v251, "Sunlight", function()
	pcall(function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Vibrant-Visual-v1-59523"))()
	end)
end)
createTextButton2(v251, "Summer", function()
	pcall(function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Graphic-Enchance-41296"))()
	end)
end)
createTextButton2(v251, "Clarity", function()
	pcall(function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Better-Graphic-20516"))()
	end)
end)
createTextButton2(v251, "BodyCam / VHS", function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranus197/VHS-Cam-Retro-or-BodyCam/refs/heads/main/VHS%20CAM%20RETRO%20OR%20BODYCAM"))()
	end)
end)

local v252 = createScrollingFrame()

createTextButton2(v252, "Boost FPS 1", function()
	pcall(function()
		loadstring(game:HttpGet("https://pastebin.com/raw/tZXpzBNs"))()
	end)
end)
createTextButton2(v252, "Boost FPS 2", function()
	pcall(function()
		loadstring(game:HttpGet("https://pastefy.app/dhiPeX7H/raw"))()
	end)
end)
createTextButton2(v252, "Boost FPS 3", function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/MerebennieOfficial/ExoticJn/refs/heads/main/Fpsboosterv2"))()
	end)
end)
createTextButton2(v252, "Boost FPS 4", function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/VikiChardd/AntiLag_TSB/main/Protect_MeowTBS1999.lua.txt"))()
	end)
end)
createTextButton2(v252, "Boost FPS 5", function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/refs/heads/main/TSB%20Anti%20Lag%20Rewrited.lua"))()
	end)
end)
createTextButton2(v252, "BloxTrap", function()
	getgenv().autosetup = {
		path = "Bloxstrap",
		setup = true
	}
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua"))()
	end)
end)

local v253 = createScrollingFrame()

local function v254(p33)
	local pairs_ = pairs
	local value1 = t1.value1

	for _, child in pairs_(value1.GetChildren(value1)) do
		if child:IsA("Sky") then
			child:Destroy()
		end
	end

	local ok2, result = pcall(function()
		return game:GetObjects("rbxassetid://" .. p33)[1]
	end)

	if not (ok2 and result) then
		return
	end

	if result:IsA("Sky") then
		result.Parent = t1.value1

		return
	end

	local Sky = result:FindFirstChildOfClass("Sky")

	if Sky then
		Sky.Parent = t1.value1

		return
	end

	result.Parent = t1.value1
end

for _, v in ipairs({
	{
		name = "Sunset",
		id = 407719830
	},
	{
		name = "TropicalSunset",
		id = 169210648
	},
	{
		name = "LightingKit",
		id = 5877137658
	},
	{
		name = "Realistic Cloudy",
		id = 4607457995
	},
	{
		name = "Realistic Bright",
		id = 3146864089
	},
	{
		name = "Realistic Afternoon",
		id = 10256505900
	},
	{
		name = "Realistic Lighting",
		id = 8613979186
	},
	{
		name = "Brookhaven",
		id = 10594723714
	},
	{
		name = "Clouds",
		id = 3146864089
	},
	{
		name = "SkyRainbow",
		id = 16573649975
	},
	{
		name = "Rainy Cloud",
		id = 246481636
	},
	{
		name = "Snow Cloud",
		id = 4604073339
	},
	{
		name = "Carton Cloud",
		id = 6216752998
	},
	{
		name = "Crossroads",
		id = 11549102836
	},
	{
		name = "Minecraft",
		id = 8735253332
	},
	{
		name = "Classic",
		id = 8539737017
	},
	{
		name = "Grayish",
		id = 9355798790
	},
	{
		name = "Orange",
		id = 12425447749
	},
	{
		name = "Green",
		id = 95200634
	},
	{
		name = "Purple",
		id = 17279880951
	},
	{
		name = "Yellow",
		id = 15670851503
	},
	{
		name = "Pinkie",
		id = 12635340429
	},
	{
		name = "Aurora",
		id = 340909375
	},
	{
		name = "ScaryNight",
		id = 7975080965
	},
	{
		name = "SparklingNight",
		id = 90988519
	},
	{
		name = "RedNight",
		id = 5834531764
	},
	{
		name = "StarryNight",
		id = 911025794
	}
}) do
	createTextButton2(v253, v.name, function()
		v254(v.id)
	end)
end

local Settings = createTextButton("Settings", "rbxassetid://139424222270133")
local Remove = createTextButton("Remove", "rbxassetid://71292653854408")
local Shader = createTextButton("Shader", "rbxassetid://88123362631320")
local v267 = createTextButton("    Boost FPS", "rbxassetid://76659062910300")
local skyBox = createTextButton("Sky Box", "rbxassetid://99697599568686")

Settings.MouseButton1Click:Connect(function()
	t1.value27()
	t1.value92(1)
end)
Remove.MouseButton1Click:Connect(function()
	t1.value27()
	t1.value92(2)
end)
Shader.MouseButton1Click:Connect(function()
	t1.value27()
	t1.value92(3)
end)
v267.MouseButton1Click:Connect(function()
	t1.value27()
	t1.value92(4)
end)
skyBox.MouseButton1Click:Connect(function()
	t1.value27()
	t1.value92(5)
end)
t1.value92(2)

local _ = t1.value94.Text
local ImageLabel4 = Instance.new("ImageLabel", Frame)

ImageLabel4.Size = UDim2.new(0, 56, 0, 56)
ImageLabel4.Position = UDim2.new(0, 8, 1, -68)
ImageLabel4.BackgroundTransparency = 1

local UserId = LocalPlayer.UserId

ImageLabel4.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(UserId) .. "&w=420&h=420"
t1.value22(ImageLabel4, 28)
ImageLabel4.ZIndex = 2
t1.value23(ImageLabel4, 1)
t1.value59.MouseButton1Click:Connect(function()
	t1.value26("rbxassetid://7148585764", 0.6)

	local uDim2 = UDim2.new(0, 56, 0, 56)
	local value4 = t1.value4
	local value59 = t1.value59
	local tweenInfo = TweenInfo.new(0.1)
	local uDim2New = UDim2.new

	value4.Create(value4, value59, tweenInfo, {
		Size = uDim2New(0, 56, 0, 46)
	}):Play()
	task.delay(0.1, function()
		local value42 = t1.value4
		local value592 = t1.value59
		local TweenInfo_ = TweenInfo
		local t8 = {
			Size = uDim2
		}

		value42.Create(value42, value592, TweenInfo_.new(0.3, Enum.EasingStyle.Elastic), t8):Play()
	end)

	if not t1.value42 then
		return
	end

	if t1.value69.Visible then
		t1.value4:Create(t1.value69, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		t1.value4:Create(t1.value20, TweenInfo.new(0.2), {
			Size = 0
		}):Play()
		task.delay(0.25, function()
			t1.value69.Visible = false
			t1.value20.Enabled = false
		end)

		return
	end

	t1.value69.Visible = true

	if t1.value76 then
		t1.value76.Visible = false
	end

	if not t1.value80 then
		t1.value20.Enabled = true
		t1.value4:Create(t1.value20, TweenInfo.new(0.3), {
			Size = 10
		}):Play()
		t1.value4:Create(t1.value69, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 380, 0, 320),
			BackgroundTransparency = 0
		}):Play()

		return
	end

	t1.value80.Visible = false
	t1.value20.Enabled = true
	t1.value4:Create(t1.value20, TweenInfo.new(0.3), {
		Size = 10
	}):Play()
	t1.value4:Create(t1.value69, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 380, 0, 320),
		BackgroundTransparency = 0
	}):Play()
end)
task.spawn(function()
	local _ = t1.value42

	repeat
		task.wait(0.2)
	until t1.value42
end)
