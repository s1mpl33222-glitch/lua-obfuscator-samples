local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Enabled = false

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "RynxFR FPS Changer"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,280,0,160)
Frame.Position = UDim2.new(0.5,-140,0.5,-80)
Frame.BackgroundColor3 = Color3.fromRGB(45,20,75)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = Gui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(170,0,255)
Stroke.Thickness = 2
Stroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "RynxFR FPS Changer"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Frame

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.85,0,0,45)
Toggle.Position = UDim2.new(0.075,0,0.45,0)
Toggle.BackgroundColor3 = Color3.fromRGB(120,0,220)
Toggle.Text = "FPS Mode: OFF"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextScaled = true
Toggle.Parent = Frame
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,10)

local Hide = Instance.new("TextButton")
Hide.Size = UDim2.new(0,55,0,55)
Hide.Position = UDim2.new(0,15,1,-70)
Hide.BackgroundColor3 = Color3.fromRGB(120,0,220)
Hide.Text = "☰"
Hide.TextScaled = true
Hide.TextColor3 = Color3.new(1,1,1)
Hide.Parent = Gui
Instance.new("UICorner", Hide).CornerRadius = UDim.new(1,0)

Hide.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

local function EnableFPS()
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Texture") or v:IsA("Decal") then
			v:Destroy()
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail")
			or v:IsA("Smoke") or v:IsA("Fire")
			or v:IsA("Sparkles") then
			v.Enabled = false
		elseif v:IsA("BasePart") then
			v.Material = Enum.Material.SmoothPlastic
			v.CastShadow = false
			v.Reflectance = 0
		end
	end
end

Toggle.MouseButton1Click:Connect(function()
	Enabled = not Enabled

	if Enabled then
		Toggle.Text = "FPS Mode: ON"
		Toggle.BackgroundColor3 = Color3.fromRGB(0,170,80)
		EnableFPS()
	else
		Toggle.Text = "FPS Mode: OFF"
		Toggle.BackgroundColor3 = Color3.fromRGB(120,0,220)
		warn("Textures that were destroyed cannot be restored by this simple script.")
	end
end)