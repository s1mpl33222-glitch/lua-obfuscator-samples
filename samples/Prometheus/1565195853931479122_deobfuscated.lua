-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("modernKeySystem") then
	PlayerGui.modernKeySystem:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "modernKeySystem"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Folder = Instance.new("Folder")

Folder.Name = "snowContainer"
Folder.Parent = ScreenGui
task.spawn(function()
	while ScreenGui.Parent do
		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(0, 20, 0, 20)
		TextLabel.Position = UDim2.new(math.random(), 0, -0.05, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "."
		TextLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
		TextLabel.TextSize = math.random(14, 24)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextTransparency = math.random(30, 70) / 100
		TextLabel.Parent = Folder

		local v8 = math.random(4, 8)
		local v9 = TweenService
		local tweenInfo = TweenInfo.new(v8, Enum.EasingStyle.Linear)
		local UDim2_ = UDim2
		local v12 = v9.Create(v9, TextLabel, tweenInfo, {
			Position = UDim2_.new(TextLabel.Position.X.Scale, math.random(-30, 30), 1.1, 0)
		})

		v12:Play()
		v12.Completed:Connect(function()
			TextLabel:Destroy()
		end)
		task.wait(math.random(0.2, 0.6))
	end
end)

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 420, 0, 350)
Frame.Position = UDim2.new(0.5, -210, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.35
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Color3.fromRGB(255, 140, 0)
UIStroke.Thickness = 2.5
UIStroke.Parent = Frame
task.spawn(function()
	local n1 = 0

	while Frame.Parent do
		n1 = n1 + RunService.RenderStepped:Wait() * 2

		local v17 = 0.6 + math.sin(n1) * 0.4

		UIStroke.Color = Color3.fromRGB(255 * v17, 140 * v17, 0)
	end
end)

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, -40, 0, 45)
TextLabel.Position = UDim2.new(0, 20, 0, 15)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "🎃 authentication required"
TextLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
TextLabel.TextSize = 20
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, -40, 0, 45)
Frame2.Position = UDim2.new(0, 20, 0, 65)
Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame2.BackgroundTransparency = 0.5
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Frame2

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = Color3.fromRGB(255, 140, 0)
UIStroke2.Thickness = 1.5
UIStroke2.Parent = Frame2

local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(1, -20, 1, 0)
TextBox.Position = UDim2.new(0, 10, 0, 0)
TextBox.BackgroundTransparency = 1
TextBox.PlaceholderText = "enter key here..."
TextBox.PlaceholderColor3 = Color3.fromRGB(150, 100, 50)
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14
TextBox.Font = Enum.Font.GothamMedium
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame2

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, -40, 0, 20)
TextLabel2.Position = UDim2.new(0, 20, 0, 115)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = ""
TextLabel2.TextColor3 = Color3.fromRGB(255, 140, 0)
TextLabel2.TextSize = 13
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0.48, -10, 0, 40)
TextButton.Position = UDim2.new(0, 20, 0, 140)
TextButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TextButton.BackgroundTransparency = 0.1
TextButton.AutoButtonColor = false
TextButton.Text = "submit"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14
TextButton.Font = Enum.Font.GothamBold
TextButton.Parent = Frame

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = TextButton

local UIStroke3 = Instance.new("UIStroke")

UIStroke3.Color = Color3.fromRGB(255, 140, 0)
UIStroke3.Thickness = 1
UIStroke3.Parent = TextButton

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(0.48, -10, 0, 40)
TextButton2.Position = UDim2.new(0.52, 0, 0, 140)
TextButton2.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TextButton2.BackgroundTransparency = 0.1
TextButton2.AutoButtonColor = false
TextButton2.Text = "get key"
TextButton2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton2.TextSize = 14
TextButton2.Font = Enum.Font.GothamBold
TextButton2.Parent = Frame

local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(0, 8)
UICorner4.Parent = TextButton2

local UIStroke4 = Instance.new("UIStroke")

UIStroke4.Color = Color3.fromRGB(255, 140, 0)
UIStroke4.Thickness = 1
UIStroke4.Parent = TextButton2

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Size = UDim2.new(1, -40, 0, 20)
TextLabel3.Position = UDim2.new(0, 20, 0, 195)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "included features:"
TextLabel3.TextColor3 = Color3.fromRGB(255, 140, 0)
TextLabel3.TextSize = 13
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = Frame

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, -40, 0, 110)
Frame3.Position = UDim2.new(0, 20, 0, 220)
Frame3.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame3.BackgroundTransparency = 0.5
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame

local UICorner5 = Instance.new("UICorner")

UICorner5.CornerRadius = UDim.new(0, 8)
UICorner5.Parent = Frame3

local UIStroke5 = Instance.new("UIStroke")

UIStroke5.Color = Color3.fromRGB(255, 140, 0)
UIStroke5.Thickness = 1
UIStroke5.Parent = Frame3

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = Frame3

local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingBottom = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = Frame3

for _, v in ipairs({
	"hitbox:hitbox extender",
	"auto tp:auto teleport",
	"auto capture:auto capture",
	"walkspeed:walkspeed modifier",
	"jumppower:jumppower modifier"
}) do
	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, 0, 0, 16)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = v
	TextLabel4.TextColor3 = Color3.fromRGB(220, 220, 220)
	TextLabel4.TextSize = 11
	TextLabel4.Font = Enum.Font.GothamMedium
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame3
end

TextButton2.MouseButton1Click:Connect(function()
	if pcall(function()
		setclipboard("https://unskyo")
	end) then
		TextLabel2.Text = "discord has been copided to clipbord (key is in discord)"
	else
		TextLabel2.Text = "failed to copy link (executor unsupported)"
	end
end)
TextButton.MouseButton1Click:Connect(function()
	if TextBox.Text ~= "unskyo61" then
		TextLabel2.Text = "invalid"

		local Position = Frame.Position

		for _ = 1, 3 do
			Frame.Position = Position + UDim2.new(0, math.random(-4, 4), 0, 0)
			task.wait(0.04)
		end

		Frame.Position = Position

		return
	end

	TextLabel2.Text = "success! loading script..."

	local v41 = TweenService
	local v42 = Frame
	local tweenInfo = TweenInfo.new(0.3)
	local v44 = v41.Create(v41, v42, tweenInfo, {
		BackgroundTransparency = 1
	})

	v44:Play()
	v44.Completed:Wait()
	ScreenGui:Destroy()

	local ok, result = pcall(function()
		loadstring("loadstring(game:HttpGet(\"https://pastebin.com/raw/7nPuVFRm\"))()")()
	end)

	if not ok then
		warn("failed to load target script: " .. tostring(result))
	end
end)
