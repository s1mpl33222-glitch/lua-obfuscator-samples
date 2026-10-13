-- This file was generated at discord.gg/syncrypt

local LocalPlayer = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 100)
TextLabel.Position = UDim2.new(0, 0, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "hi, user!"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextTransparency = 1
TextLabel.TextStrokeTransparency = 0
TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Parent = ScreenGui
for i = 1, 20 do
	TextLabel.TextTransparency = 1 - i / 20
	task.wait(0.05)
end
task.wait(2)

for i = 1, 20 do
	TextLabel.TextTransparency = i / 20
	task.wait(0.05)
end
TextLabel:Destroy()
local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 250, 0, 60)
TextButton.Position = UDim2.new(0.5, -125, 0.7, 0)
TextButton.Text = "start optimization!"
TextButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextStrokeTransparency = 0
TextButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Parent = ScreenGui
local t1 = {
	"ParticleEmitter",
	"Trail",
	"Fire",
	"Smoke",
	"Sparkles",
	"Beam",
	"Explosion"
}
local function v8(p1)
	local v10, v11, v12 = ipairs(t1)

	repeat
		local v13

		v12, v13 = v10(v11, v12)

		if not v12 then
			local v14 = p1:IsA("BasePart")

			if v14 then
				v14 = p1.Material ~= Enum.Material.Plastic
			end

			if v14 then
				p1.Material = Enum.Material.Plastic
			end

			return
		end
	until p1:IsA(v13)

	p1:Destroy()
end
TextButton.MouseButton1Click:Connect(function()
	TextButton.Text = "Wait 5 Sec..."
	TextButton.Active = false
	task.wait(5)

	for _, descendant in ipairs(workspace:GetDescendants()) do
		v8(descendant)
	end

	workspace.DescendantAdded:Connect(v8)
	TextButton.Text = "Script is Active!"
	task.wait(2)
	TextButton:Destroy()
	task.wait(2)

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 100)
	TextLabel2.Position = UDim2.new(0, 0, 0.5, -50)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "thanks for using my script!"
	TextLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
	TextLabel2.TextScaled = true
	TextLabel2.TextTransparency = 1
	TextLabel2.TextStrokeTransparency = 0
	TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel2.Parent = ScreenGui

	for i = 1, 20 do
		TextLabel2.TextTransparency = 1 - i / 20
		task.wait(0.05)
	end

	task.wait(3)

	for i = 1, 20 do
		TextLabel2.TextTransparency = i / 20
		task.wait(0.05)
	end

	TextLabel2:Destroy()
	task.wait(4)

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, 0, 0, 100)
	TextLabel3.Position = UDim2.new(0, 0, 0.5, -50)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "my telegram chennel DanikPrivet559!"
	TextLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
	TextLabel3.TextScaled = true
	TextLabel3.TextTransparency = 1
	TextLabel3.TextStrokeTransparency = 0
	TextLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel3.Parent = ScreenGui

	for i = 1, 20 do
		TextLabel3.TextTransparency = 1 - i / 20
		task.wait(0.05)
	end

	task.wait(3)

	for i = 1, 20 do
		TextLabel3.TextTransparency = i / 20
		task.wait(0.05)
	end

	TextLabel3:Destroy()
	task.wait(4)

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, 0, 0, 100)
	TextLabel4.Position = UDim2.new(0, 0, 0.5, -50)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "my tiktok @danikprivet"
	TextLabel4.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel4.TextScaled = true
	TextLabel4.TextTransparency = 1
	TextLabel4.TextStrokeTransparency = 0
	TextLabel4.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel4.Parent = ScreenGui

	for i = 1, 20 do
		TextLabel4.TextTransparency = 1 - i / 20
		task.wait(0.05)
	end

	task.wait(3)

	for i = 1, 20 do
		TextLabel4.TextTransparency = i / 20
		task.wait(0.05)
	end

	TextLabel4:Destroy()
end)
