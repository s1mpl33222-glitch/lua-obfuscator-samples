-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

if not table.find({
	"theyluvzmonsy",
	"andrei89788",
	"dreironny",
	"andrei89788",
	"jhieromacauba"
}, LocalPlayer.Name) then
	return
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "MONSY_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 180, 0, 140)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.new(1, 1, 1)
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)

local TextLabel = Instance.new("TextLabel", Frame)

TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "MONSY"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 20

local TextBox = Instance.new("TextBox", Frame)

TextBox.Size = UDim2.new(0, 140, 0, 32)
TextBox.Position = UDim2.new(0.5, -70, 0, 38)
TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.PlaceholderText = "Seconds : 1-10000"
TextBox.Text = ""
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 16
TextBox.ClearTextOnFocus = true
TextBox.BorderSizePixel = 2
TextBox.BorderColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)

local TextButton = Instance.new("TextButton", Frame)

TextButton.Size = UDim2.new(0, 140, 0, 40)
TextButton.Position = UDim2.new(0.5, -70, 0, 82)
TextButton.Text = "SPAWN : OFF"
TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 16
TextButton.BorderSizePixel = 2
TextButton.BorderColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 10)

local u11 = false
local connection = nil
local n1 = 0

TextButton.MouseButton1Click:Connect(function()
	if u11 then
		return
	end

	local Text = TextBox.Text
	local v15 = tonumber(Text)
	local v16 = (not v15 or v15 < 1) and 1 or v15
	local v17 = v16 > 1000 and 1000 or v16

	TextBox.Text = tostring(v17)
	n1 = v17

	if n1 < 1 then
		return
	end

	u11 = true
	TextButton.Text = "SPAWN : ON"
	TextButton.BorderColor3 = Color3.new(0, 1, 0)

	local now = tick()

	connection = RunService.Heartbeat:Connect(function()
		if not u11 then
			return
		end

		local now2 = tick()
		local math_ = math
		local v21 = now2 - now
		local v22 = math_.ceil(n1 - v21)

		if v22 > 0 then
			TextButton.Text = "SPAWN : " .. v22 .. "s"
			pcall(function()
				ReplicatedStorage.Crate.OpenCrate:FireServer("Legendary", -10000)
			end)

			return
		end

		u11 = false
		TextButton.Text = "SPAWN : OFF"
		TextButton.BorderColor3 = Color3.new(1, 1, 1)

		if not connection then
			return
		end

		connection:Disconnect()
	end)
end)

local function v23(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= Enum.KeyCode.K then
		return
	end

	Frame.Visible = not Frame.Visible

	local v24 = not Frame.Visible

	if v24 then
		v24 = u11
	end

	if not v24 then
		return
	end

	TextButton.Text = "SPAWN : OFF"
	TextButton.BorderColor3 = Color3.new(1, 1, 1)

	if not connection then
		return
	end

	connection:Disconnect()
end

UserInputService.InputBegan:Connect(v23)
