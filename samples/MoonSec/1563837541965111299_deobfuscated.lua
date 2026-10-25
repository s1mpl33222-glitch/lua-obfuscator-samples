local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local function v4(p1, p2)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = p1,
			Text = p2,
			Icon = "rbxassetid://76291409027520",
			Duration = 6
		})
	end)
end

task.spawn(function()
	v4("RTX SHADER", "You executed a script by kei_0. Thank you for using my script!")
end)

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "LightingToggleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 220, 0, 110)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.15
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "RTX SHADER PREMIUM"
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0.9, 0, 0, 40)
TextButton.Position = UDim2.new(0.05, 0, 0.45, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TextButton.Text = "SHADER: OFF"
TextButton.Font = Enum.Font.GothamSemibold
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.Parent = Frame

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = TextButton

local u11 = false

local function v12()
	local v13 = Lighting

	for _, child in pairs(v13:GetChildren()) do
		if child:IsA("Sky") or (child:IsA("Atmosphere") or (child:IsA("BloomEffect") or (child:IsA("BlurEffect") or (child:IsA("ColorCorrectionEffect") or child:IsA("SunRaysEffect"))))) then
			child:Destroy()
		end
	end

	local BloomEffect = Instance.new("BloomEffect", Lighting)

	BloomEffect.Intensity = 0.3
	BloomEffect.Size = 10
	BloomEffect.Threshold = 0.8
	Instance.new("BlurEffect", Lighting).Size = 5

	local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", Lighting)

	ColorCorrectionEffect.Brightness = 0.1
	ColorCorrectionEffect.Contrast = 0.5
	ColorCorrectionEffect.Saturation = -0.3
	ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 235, 203)

	local SunRaysEffect = Instance.new("SunRaysEffect", Lighting)

	SunRaysEffect.Intensity = 0.075
	SunRaysEffect.Spread = 0.727

	local Sky = Instance.new("Sky", Lighting)

	Sky.SkyboxBk = "http://www.roblox.com/asset/?id=151165214"
	Sky.SkyboxDn = "http://www.roblox.com/asset/?id=151165197"
	Sky.SkyboxFt = "http://www.roblox.com/asset/?id=151165224"
	Sky.SkyboxLf = "http://www.roblox.com/asset/?id=151165191"
	Sky.SkyboxRt = "http://www.roblox.com/asset/?id=151165206"
	Sky.SkyboxUp = "http://www.roblox.com/asset/?id=151165227"
	Sky.SunAngularSize = 10

	local Atmosphere = Instance.new("Atmosphere", Lighting)

	Atmosphere.Density = 0.364
	Atmosphere.Offset = 0.556
	Atmosphere.Color = Color3.fromRGB(199, 175, 166)
	Atmosphere.Decay = Color3.fromRGB(44, 39, 33)
	Atmosphere.Glare = 0.36
	Atmosphere.Haze = 1.72
	Lighting.Ambient = Color3.fromRGB(2, 2, 2)
	Lighting.Brightness = 2.25
	Lighting.ClockTime = 17
end
local function v21()
	Lighting:ClearAllChildren()
	Lighting.Ambient = Color3.fromRGB(128, 128, 128)
	Lighting.Brightness = 1
	Lighting.ClockTime = 12
	Lighting.FogEnd = 100000
end

TextButton.MouseButton1Click:Connect(function()
	u11 = not u11

	if u11 then
		TextButton.Text = "SHADER: ON"
		v12()
	else
		TextButton.Text = "SHADER: OFF"
		v21()
	end
end)
