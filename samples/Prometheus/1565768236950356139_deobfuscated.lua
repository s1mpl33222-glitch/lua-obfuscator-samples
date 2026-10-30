-- This file was generated at discord.gg/syncrypt

local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = nil

task.spawn(function()
	local _ = workspace.CurrentCamera

	repeat
		task.wait()
	until workspace.CurrentCamera

	CurrentCamera = workspace.CurrentCamera
end)

local BlurEffect = Instance.new("BlurEffect")

BlurEffect.Size = 0
BlurEffect.Parent = Lighting
TweenService:Create(BlurEffect, TweenInfo.new(0.5), {
	Size = 24
}):Play()

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "KeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 240, 0, 140)
Frame.Position = UDim2.new(0.5, -120, 0.5, -70)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")

UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(90, 90, 90)
UIStroke.Transparency = 1
UIStroke.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "ACCESS REQUIRED"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 14
TextLabel.Parent = Frame

local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(0.85, 0, 0, 32)
TextBox.Position = UDim2.new(0.075, 0, 0.4, 0)
TextBox.PlaceholderText = "Enter Key"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BorderSizePixel = 0
TextBox.Parent = Frame

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = TextBox

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0.85, 0, 0, 32)
TextButton.Position = UDim2.new(0.075, 0, 0.7, 0)
TextButton.Text = "UNLOCK"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TextButton.BorderSizePixel = 0
TextButton.Parent = Frame

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = TextButton
TweenService:Create(Frame, TweenInfo.new(0.6), {
	BackgroundTransparency = 0
}):Play()
TweenService:Create(UIStroke, TweenInfo.new(0.6), {
	Transparency = 0.4
}):Play()

local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.Name = "WallHopHUD"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.Enabled = false
ScreenGui2.Parent = PlayerGui

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(0, 100, 0, 34)
Frame2.Position = UDim2.new(0.1, 0, 0.7, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Frame2.BorderSizePixel = 0
Frame2.Parent = ScreenGui2

local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(0, 8)
UICorner4.Parent = Frame2

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Thickness = 1
UIStroke2.Color = Color3.fromRGB(90, 90, 90)
UIStroke2.Parent = Frame2

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(1, 0, 1, 0)
TextButton2.BackgroundTransparency = 1
TextButton2.Text = "OFF"
TextButton2.TextColor3 = Color3.fromRGB(200, 200, 200)
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 13
TextButton2.Parent = Frame2

local u24 = nil
local Position = nil
local Position2 = nil

Frame.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u24 = true
	Position = input.Position
	Position2 = Frame.Position
end)
UserInputService.InputChanged:Connect(function(input)
	if not u24 then
		return
	end

	local v27 = input.Position - Position

	Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v27.X, Position2.Y.Scale, Position2.Y.Offset + v27.Y)
end)
UserInputService.InputEnded:Connect(function(input)
	local _ = input.UserInputType == Enum.UserInputType.MouseButton1
end)
TextButton.MouseButton1Click:Connect(function()
	if TextBox.Text == "MadeByDamon" then
		TextBox.Active = false
		TextButton.Active = false
		TextButton.Text = "VERIFYING..."

		local Frame3 = Instance.new("Frame")

		Frame3.Size = UDim2.new(0.85, 0, 0, 6)
		Frame3.Position = UDim2.new(0.075, 0, 0.85, 0)
		Frame3.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		Frame3.BorderSizePixel = 0
		Frame3.Parent = Frame

		local Frame4 = Instance.new("Frame")

		Frame4.Size = UDim2.new(0, 0, 1, 0)
		Frame4.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
		Frame4.BorderSizePixel = 0
		Frame4.Parent = Frame3

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(1, 0)
		UICorner5.Parent = Frame4

		local v32 = TweenService
		local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local UDim2_ = UDim2

		v32.Create(v32, Frame4, tweenInfo, {
			Size = UDim2_.new(1, 0, 1, 0)
		}):Play()
		task.wait(1.3)
		TextButton.Text = "ACCESS GRANTED"
		task.wait(0.4)

		local v35 = TweenService
		local v36 = BlurEffect
		local TweenInfo_ = TweenInfo

		v35.Create(v35, v36, TweenInfo_.new(0.4), {
			Size = 0
		}):Play()
		TweenService:Create(Frame, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.4)
		ScreenGui:Destroy()
		ScreenGui2.Enabled = true
	else
		TextButton.Text = "WRONG KEY"
		task.wait(1)
		TextButton.Text = "UNLOCK"
	end
end)

local u38 = nil

local function v39()
	local t1 = {}

	if u38 then
		TextButton2.Text = "ON"
		t1.TextColor3 = Color3.fromRGB(0, 200, 120)
		UIStroke2.Color = Color3.fromRGB(0, 200, 120)
	else
		TextButton2.Text = "OFF"
		t1.TextColor3 = Color3.fromRGB(200, 200, 200)
		UIStroke2.Color = Color3.fromRGB(90, 90, 90)
	end

	TweenService:Create(TextButton2, TweenInfo.new(0.18), t1):Play()
end

u38 = false
v39()
TextButton2.MouseButton1Click:Connect(function()
	u38 = not u38
	v39()
end)

local function v41()
	local Character = LocalPlayer.Character
	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChild("Humanoid")
	else
		Humanoid = Character
	end

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not (Humanoid and Character) then
		return
	end

	Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	Character.Velocity = Vector3.new(Character.Velocity.X, 50, Character.Velocity.Z)

	if not CurrentCamera then
		return
	end

	local CFrame_ = CurrentCamera.CFrame

	CurrentCamera.CFrame = CFrame_ * CFrame.Angles(0, 3.141592653589793, 0)
	task.wait(0.01)
	CurrentCamera.CFrame = CFrame_
end

RunService.Heartbeat:Connect(function()
	if not u38 then
		return
	end

	local Character = LocalPlayer.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	if not (HumanoidRootPart and CurrentCamera) then
		return
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterDescendantsInstances = { Character }
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local hit = workspace:Raycast(HumanoidRootPart.Position, CurrentCamera.CFrame.LookVector * 3, raycastParams)
	local Instance_

	if hit then
		Instance_ = hit.Instance

		if Instance_ then
			Instance_ = hit.Instance:IsA("BasePart")

			if Instance_ then
				Instance_ = hit.Instance.CanCollide
			end
		end
	else
		Instance_ = hit
	end

	if not Instance_ then
		return
	end

	if hit.Instance ~= nil and tick() - 0 > 0.05 then
		tick()
		v41()
	end

	local _ = hit.Instance
end)
