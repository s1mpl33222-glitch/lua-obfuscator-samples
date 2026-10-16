-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
pcall(function()
	local LennonHubUpdated = LocalPlayer.PlayerGui:FindFirstChild("LennonHubUpdated")

	if LennonHubUpdated then
		LennonHubUpdated:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "LennonHubUpdated"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")

Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.fromScale(0.5, 0.5)
Frame.Size = UDim2.fromOffset(310, 225)
Frame.BackgroundColor3 = Color3.fromRGB(7, 10, 8)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 16)

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Color3.fromRGB(0, 220, 100)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.15
UIStroke.Parent = Frame
local ImageLabel = Instance.new("ImageLabel")

ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
ImageLabel.Position = UDim2.new(0.5, 0, 0, 18)
ImageLabel.Size = UDim2.fromOffset(78, 78)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://103090301992311"
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.Parent = Frame
local TextLabel = Instance.new("TextLabel")

TextLabel.Position = UDim2.new(0, 15, 0, 105)
TextLabel.Size = UDim2.new(1, -30, 0, 25)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "LENNON HUB IS UPDATED!"
TextLabel.TextColor3 = Color3.fromRGB(240, 255, 245)
TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextStrokeTransparency = 0.25
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 18
TextLabel.Parent = Frame
local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Position = UDim2.new(0, 15, 0, 132)
TextLabel2.Size = UDim2.new(1, -30, 0, 20)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "LENNON HUB FOI ATUALIZADO"
TextLabel2.TextColor3 = Color3.fromRGB(115, 190, 135)
TextLabel2.Font = Enum.Font.GothamMedium
TextLabel2.TextSize = 11
TextLabel2.Parent = Frame
local TextButton = Instance.new("TextButton")

TextButton.Position = UDim2.new(0, 18, 1, -57)
TextButton.Size = UDim2.new(1, -36, 0, 40)
TextButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
TextButton.BorderSizePixel = 0
TextButton.Text = "GET SCRIPT"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 14
TextButton.AutoButtonColor = false
TextButton.Parent = Frame
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

local ImageLabel2 = Instance.new("ImageLabel")

ImageLabel2.AnchorPoint = Vector2.new(0, 0.5)
ImageLabel2.Position = UDim2.new(0, 13, 0.5, 0)
ImageLabel2.Size = UDim2.fromOffset(22, 22)
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.Image = "rbxassetid://121807029290075"
ImageLabel2.ScaleType = Enum.ScaleType.Fit
ImageLabel2.Parent = TextButton
TextButton.MouseEnter:Connect(function()
	TweenService:Create(TextButton, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(105, 117, 255)
	}):Play()
end)
TextButton.MouseLeave:Connect(function()
	TweenService:Create(TextButton, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(88, 101, 242)
	}):Play()
end)
TextButton.MouseButton1Click:Connect(function()
	pcall(function()
		if setclipboard then
			setclipboard("https://discord.gg/xuPkkjQfRR")

			return
		end

		if toclipboard then
			toclipboard("https://discord.gg/xuPkkjQfRR")
		end
	end)

	local TextButtonText = TextButton.Text

	TextButton.Text = "DISCORD COPIED!"
	task.delay(1.5, function()
		local v14 = TextButton

		if v14 then
			v14 = TextButton.Parent
		end

		if v14 then
			TextButton.Text = TextButtonText
		end
	end)
end)
