local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local HitboxEnabled = false
local HitboxSize = 10

local function ApplyHitbox()
	if not HitboxEnabled then return end
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local char = player.Character
			local head = char:FindFirstChild("Head")
			local root = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			
			if hum and hum.Health > 0 then
				if root then
					root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
					root.Transparency = 0.7
					root.Color = Color3.fromRGB(255, 215, 0)
					root.Material = Enum.Material.Neon
					root.CanCollide = false
				end
				if head then
					head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
					head.Transparency = 0.7
					head.CanCollide = false
				end
			end
		end
	end
end

local function ResetHitbox()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local char = player.Character
			local head = char:FindFirstChild("Head")
			local root = char:FindFirstChild("HumanoidRootPart")
			
			if root then
				root.Size = Vector3.new(2, 2, 1)
				root.Transparency = 1
				root.CanCollide = true
			end
			if head then
				head.Size = Vector3.new(2, 1, 1)
				head.Transparency = 0
				head.CanCollide = true
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if HitboxEnabled then
		ApplyHitbox()
	end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AjnurHitboxHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 155)
frame.Position = UDim2.new(0.5, -110, 0.5, -77)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 35)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
label.Text = "Ajnur Hub - Hitbox"
label.TextColor3 = Color3.fromRGB(255, 215, 0)
label.Font = Enum.Font.GothamBold
label.TextSize = 12
label.Parent = frame

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 8)
corner2.Parent = label

local hitBtn = Instance.new("TextButton")
hitBtn.Size = UDim2.new(0, 180, 0, 35)
hitBtn.Position = UDim2.new(0, 20, 0, 55)
hitBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
hitBtn.Text = "HITBOX EXPANDER [OFF]"
hitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hitBtn.Font = Enum.Font.GothamBold
hitBtn.TextSize = 11
hitBtn.Parent = frame

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 6)
c1.Parent = hitBtn

hitBtn.MouseButton1Click:Connect(function()
	HitboxEnabled = not HitboxEnabled
	if HitboxEnabled then
		hitBtn.Text = "HITBOX EXPANDER [ON]"
		hitBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	else
		hitBtn.Text = "HITBOX EXPANDER [OFF]"
		hitBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		ResetHitbox()
	end
end)

local sizeBtn = Instance.new("TextButton")
sizeBtn.Size = UDim2.new(0, 180, 0, 35)
sizeBtn.Position = UDim2.new(0, 20, 0, 100)
sizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
sizeBtn.Text = "HITBOX SIZE: 10"
sizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeBtn.Font = Enum.Font.GothamBold
sizeBtn.TextSize = 11
sizeBtn.Parent = frame

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0, 6)
c2.Parent = sizeBtn

local sizes = {5, 10, 15, 25, 40}
local currentSizeIndex = 2

sizeBtn.MouseButton1Click:Connect(function()
	currentSizeIndex = currentSizeIndex + 1
	if currentSizeIndex > #sizes then currentSizeIndex = 1 end
	
	HitboxSize = sizes[currentSizeIndex]
	sizeBtn.Text = "HITBOX SIZE: " .. HitboxSize
	if HitboxEnabled then
		ApplyHitbox()
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		frame.Visible = not frame.Visible
	end
end)