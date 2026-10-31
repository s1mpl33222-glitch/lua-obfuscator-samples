-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local setclipboard_ = setclipboard or (toclipboard or set_clipboard)

local function v6(p1)
	local Sound = Instance.new("Sound")

	Sound.SoundId = "rbxassetid://876939830"
	Sound.Volume = 1
	Sound.Parent = p1
	Sound:Play()
	game:GetService("Debris"):AddItem(Sound, 2)
end

local BladeBallMenu = PlayerGui:FindFirstChild("BladeBallMenu")

if BladeBallMenu then
	BladeBallMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)

ScreenGui.Name = "BladeBallMenu"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)

Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 330, 0, 270)
Frame.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
Frame.BackgroundTransparency = 0.05
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", Frame)

UIStroke.Color = Color3.fromRGB(120, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.4

local Frame2 = Instance.new("Frame", Frame)

Frame2.Size = UDim2.new(1, 0, 0, 30)
Frame2.BackgroundTransparency = 1

local TextLabel = Instance.new("TextLabel", Frame2)

TextLabel.Size = UDim2.new(1, -60, 1, 0)
TextLabel.Position = UDim2.new(0, 10, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 16
TextLabel.Text = "🌲 Jujutsu Shenanigans Scripts"
TextLabel.TextColor3 = Color3.fromRGB(220, 255, 220)
TextLabel.TextXAlignment = "Left"

local TextButton = Instance.new("TextButton", Frame2)

TextButton.Size = UDim2.new(0, 35, 0, 25)
TextButton.Position = UDim2.new(1, -40, 0.5, -12)
TextButton.Text = "-"
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 20
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)

ScrollingFrame.Size = UDim2.new(1, -20, 1, -90)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = "Center"

local function v17(p2, p3, p4, p5)
	local TextButton2 = Instance.new("TextButton", ScrollingFrame)

	TextButton2.Size = UDim2.new(0.92, 0, 0, 32)
	TextButton2.Text = p2
	TextButton2.Font = Enum.Font.GothamMedium
	TextButton2.TextSize = 14
	TextButton2.TextColor3 = Color3.fromRGB(235, 235, 235)
	TextButton2.AutoButtonColor = false
	Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 7)

	if p4 then
		TextButton2.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		Instance.new("UIGradient", TextButton2).Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 220)), ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 180, 255)) })
	else
		TextButton2.BackgroundColor3 = Color3.fromRGB(42, 45, 52)

		local UIStroke2 = Instance.new("UIStroke", TextButton2)

		UIStroke2.Color = Color3.fromRGB(120, 170, 255)
		UIStroke2.Transparency = 0.5
		UIStroke2.Thickness = 1
	end

	TextButton2.MouseButton1Click:Connect(function()
		v6(TextButton2)

		local v20 = TweenService
		local v21 = TextButton2
		local tweenInfo = TweenInfo.new(0.1)
		local uDim2New = UDim2.new

		v20.Create(v20, v21, tweenInfo, {
			Size = uDim2New(0.95, 0, 0, 34)
		}):Play()
		task.wait(0.1)
		TweenService:Create(TextButton2, TweenInfo.new(0.1), {
			Size = UDim2.new(0.92, 0, 0, 32)
		}):Play()

		if p5 then
			if not setclipboard_ then
				game.StarterGui:SetCore("SendNotification", {
					Title = "Copied!",
					Text = "Follow my Youtube TikTok for updates!",
					Duration = 5
				})

				return
			end

			setclipboard_("https://www.youtube.com/@Yong3469")
			game.StarterGui:SetCore("SendNotification", {
				Title = "Copied!",
				Text = "Follow my Youtube TikTok for updates!",
				Duration = 5
			})
		else
			if not p3 then
				return
			end

			loadstring(game:HttpGet(p3))()
		end
	end)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

v17("TBO Hub", "https://raw.githubusercontent.com/cool5013/TBO/main/TBOscript")
v17("Plutonium Hub", "https://raw.githubusercontent.com/PawsThePaw/Plutonium.AA/main/Plutonium.Loader.lua")
v17("MD Hub", "https://raw.githubusercontent.com/zenin-com/MDHub-Jujutsu-Shenanigans/refs/heads/main/%5BMdhub-jjs_v2%5D")
v17("Spotlight Hub", "https://raw.githubusercontent.com/NotEnoughJack/LuaFluentDependancies/refs/heads/main/main.lua")

local Frame3 = Instance.new("Frame", Frame)

Frame3.Size = UDim2.new(1, -20, 0, 30)
Frame3.Position = UDim2.new(0, 10, 1, -35)
Frame3.BackgroundTransparency = 1

local UIListLayout2 = Instance.new("UIListLayout", Frame3)

UIListLayout2.FillDirection = "Horizontal"
UIListLayout2.Padding = UDim.new(0, 8)
UIListLayout2.HorizontalAlignment = "Center"

local t1 = {
	{
		name = "TikTok",
		color = Color3.fromRGB(255, 0, 128),
		link = "www.tiktok.com/@renan1627"
	},
	{
		name = "YouTube",
		color = Color3.fromRGB(255, 0, 0),
		link = "https://www.youtube.com/@Yong3469"
	},
	{
		name = "Discord",
		color = Color3.fromRGB(114, 137, 218),
		link = "https://discord.gg/RbhFbKbABe"
	}
}

for _, v in pairs(t1) do
	local TextButton2 = Instance.new("TextButton", Frame3)

	TextButton2.Size = UDim2.new(0.3, 0, 1, 0)
	TextButton2.Text = v.name
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 13
	TextButton2.TextColor3 = Color3.new(1, 1, 1)
	TextButton2.BackgroundColor3 = v.color
	Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)
	TextButton2.MouseButton1Click:Connect(function()
		v6(TextButton2)

		if not setclipboard_ then
			game.StarterGui:SetCore("SendNotification", {
				Title = "Copied!",
				Text = v.name .. " link copied.",
				Duration = 4
			})

			return
		end

		setclipboard_(v.link)
		game.StarterGui:SetCore("SendNotification", {
			Title = "Copied!",
			Text = v.name .. " link copied.",
			Duration = 4
		})
	end)
end

local TextButton2 = Instance.new("TextButton", ScreenGui)

TextButton2.Size = UDim2.new(0, 45, 0, 45)
TextButton2.Position = UDim2.new(0, 20, 0.7, 0)
TextButton2.Text = "≡"
TextButton2.Visible = false
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 20
TextButton2.TextColor3 = Color3.new(1, 1, 1)
TextButton2.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)
TextButton.MouseButton1Click:Connect(function()
	v6(TextButton)
	TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.25)
	Frame.Visible = false
	TextButton2.Visible = true
end)
TextButton2.MouseButton1Click:Connect(function()
	v6(TextButton2)
	Frame.Visible = true
	TextButton2.Visible = false
	Frame.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 330, 0, 270),
		BackgroundTransparency = 0.05
	}):Play()
end)

local function v31(p6)
	local u32 = false
	local u33 = nil
	local Position = nil
	local Position2 = nil

	p6.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u32 = true
		Position = input.Position
		Position2 = p6.Position
	end)
	p6.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		u33 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		local v36

		if input == u33 then
			v36 = u32
		else
			v36 = false
		end

		if not v36 then
			return
		end

		local v37 = input.Position - Position

		p6.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v37.X, Position2.Y.Scale, Position2.Y.Offset + v37.Y)
	end)
	UserInputService.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1
	end)
end

v31(Frame)
v31(TextButton2)
