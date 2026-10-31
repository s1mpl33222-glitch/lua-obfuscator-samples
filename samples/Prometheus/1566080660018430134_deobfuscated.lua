-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local genv = getgenv and getgenv() or _G

if genv.JNHH_AnimalStop then
	genv.JNHH_AnimalStop()
end

local u9 = true
local t1 = {
	Throw = false,
	Train = false,
	Equip = false
}
local t2 = {
	Throw = 0,
	Train = 0,
	Equip = 0
}

function genv.JNHH_AnimalStop()
	u9 = false

	for k in pairs(t1) do
		t1[k] = false
		t2[k] = t2[k] + 1
	end
end

local function v13(p1, p2, p3)
	local v14 = nil
	local v15 = nil

	local function v16()
		local v17 = StarterGui
		local t3 = {
			Title = p1,
			Text = v15,
			Duration = v14 or 5
		}

		v17.SetCore(v17, "SendNotification", t3)
	end

	v15 = p2
	v14 = p3
	pcall(v16)
end

local u19 = nil

local function v20()
	if not setclipboard then
		return
	end

	setclipboard("https://discord.gg/QwU4gBGEKf")
	u19 = true
end

u19 = false
pcall(v20)

local JNHH_AnimalScript = PlayerGui:FindFirstChild("JNHH_AnimalScript")

if JNHH_AnimalScript then
	JNHH_AnimalScript:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "JNHH_AnimalScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 2147483647
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 310, 0, 370)
Frame.Position = UDim2.new(0.5, -155, 0.5, -185)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ZIndex = 100
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke")

UIStroke.Parent = Frame
UIStroke.Color = Color3.fromRGB(130, 80, 255)
UIStroke.Thickness = 2

local Frame2 = Instance.new("Frame")

Frame2.Parent = Frame
Frame2.Size = UDim2.new(1, 0, 0, 65)
Frame2.BackgroundColor3 = Color3.fromRGB(45, 32, 75)
Frame2.BorderSizePixel = 0
Frame2.Active = true
Frame2.ZIndex = 101
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 12)

local TextLabel = Instance.new("TextLabel")

TextLabel.Parent = Frame2
TextLabel.Size = UDim2.new(1, -55, 1, 0)
TextLabel.Position = UDim2.new(0, 12, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Throw Food for Animals\nScript by JN HH Gaming"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 15
TextLabel.TextWrapped = true
TextLabel.ZIndex = 102

local TextButton = Instance.new("TextButton")

TextButton.Parent = Frame2
TextButton.Size = UDim2.new(0, 30, 0, 30)
TextButton.Position = UDim2.new(1, -40, 0, 15)
TextButton.BackgroundColor3 = Color3.fromRGB(200, 55, 65)
TextButton.Text = "X"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 16
TextButton.ZIndex = 103
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 7)

local function v28(p4, p5)
	local u29 = false
	local Position = nil
	local Position2 = nil
	local u32 = nil

	local function v33(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u29 = true
		Position = input.Position
		Position2 = p4.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u29 = false
		end)
	end

	p5.InputBegan:Connect(v33)

	local function v34(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u32 = input
	end

	p5.InputChanged:Connect(v34)
	UserInputService.InputChanged:Connect(function(input)
		local v35 = u29

		if v35 then
			v35 = input == u32
		end

		if not v35 then
			return
		end

		local v36 = input.Position - Position

		p4.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v36.X, Position2.Y.Scale, Position2.Y.Offset + v36.Y)
	end)
end

v28(Frame, Frame2)

local TextButton2 = Instance.new("TextButton")

TextButton2.Parent = Frame
TextButton2.Position = UDim2.new(0, 15, 0, 77)
TextButton2.Size = UDim2.new(1, -30, 0, 40)
TextButton2.BackgroundColor3 = Color3.fromRGB(85, 60, 170)
TextButton2.Text = "COPY DISCORD LINK"
TextButton2.TextColor3 = Color3.new(1, 1, 1)
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 14
TextButton2.ZIndex = 102
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 8)
TextButton2.MouseButton1Click:Connect(function()
	if not setclipboard then
		v13("JN HH Gaming", "Clipboard not supported.")

		return
	end

	local ok = pcall(function()
		setclipboard("https://discord.gg/QwU4gBGEKf")
	end)

	v13("JN HH Gaming", ok and "Discord link copied!" or ok or "Unable to copy Discord link.")
end)

local function createTextButton(p6, p7, p8, p9)
	local TextButton3 = Instance.new("TextButton")

	TextButton3.Parent = Frame
	TextButton3.Position = UDim2.new(0, 15, 0, p7)
	TextButton3.Size = UDim2.new(1, -30, 0, 45)
	TextButton3.BackgroundColor3 = Color3.fromRGB(48, 48, 62)
	TextButton3.Text = p6 .. " : OFF"
	TextButton3.TextColor3 = Color3.new(1, 1, 1)
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextSize = 15
	TextButton3.ZIndex = 102
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 8)
	TextButton3.MouseButton1Click:Connect(function()
		t1[p8] = not t1[p8]
		t2[p8] = t2[p8] + 1

		local v41 = t2[p8]

		if not t1[p8] then
			TextButton3.Text = p6 .. " : OFF"
			TextButton3.BackgroundColor3 = Color3.fromRGB(48, 48, 62)
			v13("JN HH Gaming", p6 .. " Disabled")

			return
		end

		TextButton3.Text = p6 .. " : ON"
		TextButton3.BackgroundColor3 = Color3.fromRGB(30, 155, 90)
		v13("JN HH Gaming", p6 .. " Enabled")
		task.spawn(function()
			p9(function()
				local v42 = u9

				if not v42 then
					return v42
				end

				v42 = t1[p8]

				if not v42 then
					return v42
				end

				v42 = t2[p8] == v41

				return v42
			end)
		end)
	end)

	return TextButton3
end

createTextButton("Auto Throw", 130, "Throw", function(p10)
	while true do
		if not p10() then
			return
		end

		local Character = LocalPlayer.Character

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if Character then
			Character.CFrame = CFrame.new(0, 6.1, -45)
		end

		local CurrentCamera = workspace.CurrentCamera
		local n1

		if CurrentCamera then
			local ViewportSize = CurrentCamera.ViewportSize

			local function v47()
				VirtualInputManager:SendMouseButtonEvent(ViewportSize.X / 2, ViewportSize.Y / 2, 0, true, game, 0)
			end

			pcall(v47)
			task.wait(0.05)
			pcall(function()
				VirtualInputManager:SendMouseButtonEvent(ViewportSize.X / 2, ViewportSize.Y / 2, 0, false, game, 0)
			end)
			n1 = 0
		else
			n1 = 0
		end

		while true do
			if true then
				local v48

				if n1 < 1 then
					v48 = p10()
				else
					v48 = false
				end
			end

			if not v61 then
				break
			end

			task.wait(0.1)
			n1 = n1 + 0.1
		end
	end
end)
createTextButton("Auto Train", 185, "Train", function(p11)
	local Training_Start = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Training_Start")

	while p11() do
		pcall(function()
			Training_Start:InvokeServer()
		end)
		task.wait(1)
	end
end)
createTextButton("Auto Equip Best", 240, "Equip", function(p12)
	local v50 = ReplicatedStorage
	local Plot_EquipBest = v50.WaitForChild(v50, "Remotes"):WaitForChild("Plot_EquipBest")

	while p12() do
		pcall(function()
			Plot_EquipBest:InvokeServer()
		end)
		task.wait(1)
	end
end)

local TextButton3 = Instance.new("TextButton")

TextButton3.Parent = Frame
TextButton3.Position = UDim2.new(0, 15, 0, 295)
TextButton3.Size = UDim2.new(1, -30, 0, 45)
TextButton3.BackgroundColor3 = Color3.fromRGB(85, 60, 170)
TextButton3.Text = "MISC FEATURES"
TextButton3.TextColor3 = Color3.new(1, 1, 1)
TextButton3.Font = Enum.Font.GothamBold
TextButton3.TextSize = 15
TextButton3.ZIndex = 102
Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 8)
TextButton3.MouseButton1Click:Connect(function()
	v13("JN HH Gaming", "Loading Misc Features...")
	task.spawn(function()
		local ok, result = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/JNHHGaming/All-Roblox-Games-Script/refs/heads/main/JN%20HH%20Gaming", true))()
		end)

		if ok then
			return
		end

		warn(result)
		v13("JN HH Gaming", "Misc Features failed to load!")
	end)
end)

local ImageButton = Instance.new("ImageButton")

ImageButton.Name = "OpenButton"
ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0, 0, 0.19, 0)
ImageButton.Size = UDim2.new(0, 46, 0, 45)
ImageButton.Image = "rbxassetid://15596526922"
ImageButton.Active = true
ImageButton.Selectable = true
ImageButton.ZIndex = 2147483647
ImageButton.Visible = false
Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(0, 9)
v28(ImageButton, ImageButton)
TextButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	ImageButton.Visible = true
end)
ImageButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
	ImageButton.Visible = false
end)
v13("JN HH Gaming", u19 and "Script Loaded! Made by JN HH Gaming. Discord copied!" or "Script Loaded! Made by JN HH Gaming.", 7)
