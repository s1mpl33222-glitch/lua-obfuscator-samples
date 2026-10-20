-- This file was generated at discord.gg/syncrypt

local u1 = false
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

Players = Players.LocalPlayer

if not isfolder("ZHPEKeystem") then
	makefolder("ZHPEKeystem")
end

u1 = isfile("ZHPEKeystem/key.txt") and readfile("ZHPEKeystem/key.txt") == "31FOG-JSCBD-ZANVB-K41SU" and true or u1

if u1 then
	repeat
		task.wait()
	until u1 == true

	return
end

if Players.PlayerGui:FindFirstChild("KeySystemUI") then
	Players.PlayerGui.KeySystemUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "Keysystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")

Frame.Name = "Main"
Frame.Size = UDim2.new(0, 320, 0, 264)
Frame.Position = UDim2.new(0.5, -160, 0.5, -132)
Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
Players = Instance.new("UIStroke", Frame)
Players.Color = Color3.fromRGB(70, 70, 90)
Players.Thickness = 1
Players = Instance.new("Frame")
Players.Size = UDim2.new(1, 0, 0, 36)
Players.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Players.BorderSizePixel = 0
Players.Parent = Frame
Instance.new("UICorner", Players).CornerRadius = UDim.new(0, 10)

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 0, 10)
Frame2.Position = UDim2.new(0, 0, 1, -10)
Frame2.BackgroundColor3 = Players.BackgroundColor3
Frame2.BorderSizePixel = 0
Frame2.Parent = Players
Frame2 = Instance.new("TextLabel")
Frame2.BackgroundTransparency = 1
Frame2.Size = UDim2.new(1, -20, 1, 0)
Frame2.Position = UDim2.new(0, 12, 0, 0)
Frame2.Text = "Project Yielding Keysystem"
Frame2.TextColor3 = Color3.fromRGB(255, 255, 255)
Frame2.TextXAlignment = Enum.TextXAlignment.Left
Frame2.Font = Enum.Font.GothamBold
Frame2.TextSize = 16
Frame2.Parent = Players
Players = Instance.new("TextLabel")
Players.BackgroundTransparency = 1
Players.Size = UDim2.new(1, -40, 0, 20)
Players.Position = UDim2.new(0, 20, 0, 46)
Players.Text = "Enter your key to continue"
Players.TextColor3 = Color3.fromRGB(160, 160, 170)
Players.Font = Enum.Font.Gotham
Players.TextSize = 13
Players.TextXAlignment = Enum.TextXAlignment.Left
Players.Parent = Frame
Players = Instance.new("TextBox")
Players.Size = UDim2.new(1, -40, 0, 36)
Players.Position = UDim2.new(0, 20, 0, 72)
Players.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
Players.PlaceholderText = "Key here..."
Players.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
Players.Text = ""
Players.TextColor3 = Color3.fromRGB(255, 255, 255)
Players.Font = Enum.Font.Gotham
Players.TextSize = 14
Players.ClearTextOnFocus = false
Players.Parent = Frame
Instance.new("UICorner", Players).CornerRadius = UDim.new(0, 6)
Frame2 = Instance.new("UIStroke", Players)
Frame2.Color = Color3.fromRGB(70, 70, 90)
Frame2.Thickness = 1
Frame2 = Instance.new("UIPadding", Players)
Frame2.PaddingLeft = UDim.new(0, 10)
Frame2.PaddingRight = UDim.new(0, 10)
Frame2 = Instance.new("TextButton")
Frame2.Size = UDim2.new(1, -40, 0, 36)
Frame2.Position = UDim2.new(0, 20, 0, 120)
Frame2.BackgroundColor3 = Color3.fromRGB(90, 70, 230)
Frame2.Text = "Submit"
Frame2.TextColor3 = Color3.fromRGB(255, 255, 255)
Frame2.Font = Enum.Font.GothamBold
Frame2.TextSize = 15
Frame2.AutoButtonColor = false
Frame2.Parent = Frame
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 6)

local MouseEnter = Frame2.MouseEnter
local v8 = TweenService
local v9 = Frame2

MouseEnter:Connect(function()
	v8:Create(v9, TweenInfo.new(0.15), {
		["BackgroundColor3"] = Color3.fromRGB(105, 85, 245),
	}):Play()
end)
MouseEnter = Frame2.MouseLeave

local v10 = TweenService
local v11 = Frame2

MouseEnter:Connect(function()
	v10:Create(v11, TweenInfo.new(0.15), {
		["BackgroundColor3"] = Color3.fromRGB(90, 70, 230),
	}):Play()
end)
MouseEnter = Instance.new("TextLabel")
MouseEnter.BackgroundTransparency = 1
MouseEnter.Size = UDim2.new(1, -40, 0, 18)
MouseEnter.Position = UDim2.new(0, 20, 0, 166)
MouseEnter.Text = "Join our discord server for the key"
MouseEnter.TextColor3 = Color3.fromRGB(160, 160, 170)
MouseEnter.Font = Enum.Font.Gotham
MouseEnter.TextSize = 13
MouseEnter.TextXAlignment = Enum.TextXAlignment.Left
MouseEnter.Parent = Frame
MouseEnter = Instance.new("TextButton")
MouseEnter.Size = UDim2.new(1, -40, 0, 36)
MouseEnter.Position = UDim2.new(0, 20, 0, 188)
MouseEnter.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
MouseEnter.Text = "Copy discord server link"
MouseEnter.TextColor3 = Color3.fromRGB(255, 255, 255)
MouseEnter.Font = Enum.Font.GothamBold
MouseEnter.TextSize = 14
MouseEnter.AutoButtonColor = false
MouseEnter.Parent = Frame
Instance.new("UICorner", MouseEnter).CornerRadius = UDim.new(0, 6)

local BackgroundColor3 = MouseEnter.BackgroundColor3
local MouseEnter2 = MouseEnter.MouseEnter
local v14 = TweenService
local v15 = MouseEnter

MouseEnter2:Connect(function()
	v14:Create(v15, TweenInfo.new(0.15), {
		["BackgroundColor3"] = Color3.fromRGB(103, 115, 245),
	}):Play()
end)
MouseEnter2 = MouseEnter.MouseLeave

local v16 = TweenService
local v17 = MouseEnter
local v18 = BackgroundColor3

MouseEnter2:Connect(function()
	v16:Create(v17, TweenInfo.new(0.15), {
		["BackgroundColor3"] = v18,
	}):Play()
end)
BackgroundColor3 = MouseEnter.MouseButton1Click

local v19 = MouseEnter

BackgroundColor3:Connect(function()
	setclipboard("discord.gg/ProjectYielding")
	v19.Text = "Copied!"
	task.delay(1.5, function()
		if v19.Text ~= "Copied!" then
			return
		end

		v19.Text = "Copy discord server link"
	end)
end)

local TextLabel = Instance.new("TextLabel")

TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, -40, 0, 16)
TextLabel.Position = UDim2.new(0, 20, 0, 232)
TextLabel.Text = ""
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextSize = 12
TextLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

local v21 = Players
local v22 = TweenService
local v23 = ScreenGui

local function v24()
	local Text = v21.Text

	if Text == "" then
		TextLabel.Text = "Please enter a key."
		TextLabel.TextColor3 = Color3.fromRGB(255, 90, 90)

		return
	else
		if Text == "31FOG-JSCBD-ZANVB-K41SU" then
			TextLabel.Text = "Key accepted!"
			TextLabel.TextColor3 = Color3.fromRGB(90, 255, 130)
			writefile("ZHPEKeystem/key.txt", "31FOG-JSCBD-ZANVB-K41SU")
			task.wait(0.4)
			Text = v22:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
				["Size"] = UDim2.new(0, 320, 0, 0),
				["BackgroundTransparency"] = 1,
			})
			Text:Play()
			Text.Completed:Wait()
			v23:Destroy()
			u1 = true

			return
		else
			TextLabel.Text = "Invalid key. Try again."
			TextLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
			v21.Text = ""
			Text = Frame.Position

			for i = 1, 4 do
				Frame.Position = Text + UDim2.new(0, i % 2 ~= 0 and -6 or 6, 0, 0)
				task.wait(0.03)
			end

			Frame.Position = Text

			return
		end

		return
	end
end

Frame2.MouseButton1Click:Connect(v24)
Players.FocusLost:Connect(function(enterPressed)
	if not enterPressed then
		return
	end

	v24()
end)

repeat
	task.wait()
until u1 == true
