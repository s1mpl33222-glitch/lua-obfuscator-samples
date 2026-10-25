-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "InfoPopup_TG"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local TextButton = Instance.new("TextButton")

	TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.BackgroundTransparency = 0.35
	TextButton.BorderSizePixel = 0
	TextButton.AutoButtonColor = false
	TextButton.Text = ""
	TextButton.Size = UDim2.fromScale(1, 1)
	TextButton.Parent = ScreenGui
	TextButton.ZIndex = 1000

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(0, 380, 0, 210)
	Frame.Position = UDim2.new(0.5, -190, 0.5, -105)
	Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame.BorderSizePixel = 0
	Frame.Parent = TextButton
	Frame.ZIndex = 1001
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

	local UIStroke = Instance.new("UIStroke", Frame)

	UIStroke.Thickness = 1
	UIStroke.Color = Color3.fromRGB(70, 70, 70)

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 38)
	Frame2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame
	Frame2.ZIndex = 1002
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 12)

	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.fromScale(1, 1)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 18
	TextLabel.Text = "Subscribe to my Discord channel!"
	TextLabel.Parent = Frame2
	TextLabel.ZIndex = 1003

	local TextButton2 = Instance.new("TextButton")

	TextButton2.AnchorPoint = Vector2.new(1, 0.5)
	TextButton2.Position = UDim2.new(1, -8, 0.5, 0)
	TextButton2.Size = UDim2.new(0, 28, 0, 24)
	TextButton2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	TextButton2.TextColor3 = Color3.new(1, 1, 1)
	TextButton2.Text = "×"
	TextButton2.Font = Enum.Font.SourceSansBold
	TextButton2.TextSize = 20
	TextButton2.Parent = Frame2
	TextButton2.ZIndex = 1003
	Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 8)

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Position = UDim2.new(0, 16, 0, 52)
	TextLabel2.Size = UDim2.new(1, -32, 0, 48)
	TextLabel2.TextWrapped = true
	TextLabel2.Font = Enum.Font.SourceSans
	TextLabel2.TextSize = 17
	TextLabel2.TextColor3 = Color3.fromRGB(230, 230, 230)
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel2.Text = "Verified scripts and more!"
	TextLabel2.Parent = Frame
	TextLabel2.ZIndex = 1002

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Position = UDim2.new(0, 16, 0, 104)
	TextLabel3.Size = UDim2.new(1, -32, 0, 22)
	TextLabel3.Font = Enum.Font.SourceSansBold
	TextLabel3.TextSize = 18
	TextLabel3.TextColor3 = Color3.fromRGB(100, 185, 255)
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Text = "https://discord.com/invite/cbh7ZkcAfj"
	TextLabel3.Parent = Frame
	TextLabel3.ZIndex = 1002

	local function createTextButton(p1, p2)
		local TextButton3 = Instance.new("TextButton")

		TextButton3.Size = UDim2.new(0, 160, 0, 32)
		TextButton3.Position = p2
		TextButton3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton3.Text = p1
		TextButton3.Font = Enum.Font.SourceSansBold
		TextButton3.TextSize = 15
		TextButton3.Parent = Frame
		TextButton3.ZIndex = 1002
		Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 8)

		return TextButton3
	end

	local copyLink = createTextButton("Copy link", UDim2.new(0, 16, 0, 140))
	local ok = createTextButton("OK", UDim2.new(1, -176, 0, 178))

	local function v18(p3)
		pcall(function()
			local t1 = {
				Title = "Information",
				Text = p3,
				Duration = 5
			}

			game.StarterGui:SetCore("SendNotification", t1)
		end)
	end

	copyLink.MouseButton1Click:Connect(function()
		local function v20()
			local setclipboard_ = setclipboard

			if typeof(setclipboard_) == "function" then
				setclipboard("https://discord.com/invite/cbh7ZkcAfj")
				v18("The link has been copied to the clipboard!")
			else
				error("no_setclipboard")
			end
		end

		if pcall(v20) then
			return
		end

		v18("Copy manually: https://discord.com/invite/cbh7ZkcAfj")
	end)

	local function v22()
		local Parent = ScreenGui

		if Parent then
			Parent = ScreenGui.Parent
		end

		if not Parent then
			return
		end

		ScreenGui:Destroy()
	end

	ok.MouseButton1Click:Connect(v22)

	local MouseButton1Click = TextButton2.MouseButton1Click

	MouseButton1Click.Connect(MouseButton1Click, v22)

	local v25 = nil
	local u26 = nil

	local function v27(p4)
		local v28 = p4.Position - nil

		Frame.Position = UDim2.new(v25.X.Scale, v25.X.Offset + v28.X, v25.Y.Scale, v25.Y.Offset + v28.Y)
	end

	v25 = nil

	local function v29(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u26 = true

		local _ = input.Position
		local _ = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u26 = false
		end)
	end

	Frame2.InputBegan:Connect(v29)
	UserInputService.InputChanged:Connect(function(input)
		local v32 = u26

		if v32 then
			v32 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v32 then
			return
		end

		v27(input)
	end)
end)

local ok, result = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/francybot2/catmiov2/refs/heads/main/catmio.lua"))()
end)

if ok then
	return
end

pcall(function()
	local StarterGui = game.StarterGui
	local v36 = result

	StarterGui.SetCore(StarterGui, "SendNotification", {
		Title = "Loading Error",
		Text = tostring(v36),
		Duration = 8
	})
end)
