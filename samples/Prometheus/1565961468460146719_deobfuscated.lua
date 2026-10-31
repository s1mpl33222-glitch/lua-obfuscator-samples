-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
	local InvisScript = _G.InvisScript

	if InvisScript then
		local InvisScript2 = _G.InvisScript

		InvisScript = type(InvisScript2) == "table"
	end

	if not InvisScript then
		return
	end

	for _, v in pairs(_G.InvisScript) do
		pcall(function()
			local v10 = v

			if typeof(v10) == "RBXScriptConnection" then
				v:Disconnect()

				return
			end

			if not v:IsA("Instance") then
				return
			end

			v:Destroy()
		end)
	end
end)
_G.InvisScript = {}

local t1 = {
	ToggleKey = Enum.KeyCode.X,
	TeleportHeight = -200000,
	Transparency = 0.7,
	AccentColor = Color3.fromRGB(138, 43, 226),
	BackgroundColor = Color3.fromRGB(15, 15, 22),
	TextColor = Color3.fromRGB(255, 255, 255),
	ActiveColor = Color3.fromRGB(0, 255, 130),
	InactiveColor = Color3.fromRGB(255, 75, 75)
}
local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
local u15 = false
local t2 = {}
local connections = {}
local u18 = false
local ScreenGui = nil
local Frame = nil
local TextButton = nil

local function v22()
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	t2 = {}

	local v23, v24, v25 = pairs(Character:GetDescendants())

	while true do
		local v26

		v25, v26 = v23(v24, v25)

		if not v25 then
			break
		end

		if v26:IsA("BasePart") then
			local v27 = t2

			table.insert(v27, v26)
		end
	end

	if not u15 then
		return
	end

	for _, v in pairs(t2) do
		v.Transparency = t1.Transparency
	end
end
local function v30()
	u15 = not u15

	local v31, v32, v33 = pairs(t2)

	while true do
		local v34

		v33, v34 = v31(v32, v33)

		if not v33 then
			break
		end

		if v34:IsA("BasePart") then
			local s1 = "Transparency"
			local Transparency = u15

			if Transparency then
				Transparency = t1.Transparency
			end

			v34[s1] = Transparency or 0
		end
	end

	if not Frame then
		return
	end

	local ToggleBtn = Frame:FindFirstChild("ToggleBtn", true)
	local StatusGlow = Frame:FindFirstChild("StatusGlow", true)
	local StatusLabel = Frame:FindFirstChild("StatusLabel", true)

	if ToggleBtn then
		local v40 = TweenService
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
		local s2 = "BackgroundColor3"
		local ActiveColor = u15

		if ActiveColor then
			ActiveColor = t1.ActiveColor
		end

		v40:Create(ToggleBtn, tweenInfo, {
			[s2] = ActiveColor or Color3.fromRGB(25, 25, 35)
		}):Play()
		ToggleBtn.Text = u15 and "STATUS: ACTIVE" or "STATUS: IDLE"

		local s3 = "TextColor3"
		local color3 = u15

		if color3 then
			color3 = Color3.fromRGB(10, 10, 10)
		end

		ToggleBtn[s3] = color3 or t1.TextColor
	end

	if StatusGlow then
		local v46 = TweenService
		local tweenInfo = TweenInfo.new(0.3)
		local s4 = "BackgroundColor3"
		local ActiveColor = u15

		if ActiveColor then
			ActiveColor = t1.ActiveColor
		end

		v46:Create(StatusGlow, tweenInfo, {
			[s4] = ActiveColor or t1.InactiveColor
		}):Play()
	end

	if not StatusLabel then
		return
	end

	StatusLabel.Text = u15 and "CLOAKED" or "VISIBLE"

	local s5 = "TextColor3"
	local ActiveColor = u15

	if ActiveColor then
		ActiveColor = t1.ActiveColor
	end

	StatusLabel[s5] = ActiveColor or t1.InactiveColor
end

local uDim2 = UDim2.new(1, -280, 0.5, -85)

local function v53()
	if Frame and TextButton then
		u18 = not u18

		if u18 then
			uDim2 = Frame.Position

			local AbsolutePosition = Frame.AbsolutePosition

			TextButton.Position = UDim2.new(0, AbsolutePosition.X + 101, 0, AbsolutePosition.Y + 56)
			Frame.Visible = false
			TextButton.Visible = true
			TextButton.Size = UDim2.new(0, 0, 0, 0)
			TextButton.BackgroundTransparency = 1
			TweenService:Create(TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 58, 0, 58),
				BackgroundTransparency = 0.1
			}):Play()

			return
		else
			Frame.Position = uDim2

			local AbsolutePosition = TextButton.AbsolutePosition

			Frame.Position = UDim2.new(0, AbsolutePosition.X - 101, 0, AbsolutePosition.Y - 56)

			local v56 = TweenService
			local v57 = TextButton
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
			local UDim2_ = UDim2

			v56.Create(v56, v57, tweenInfo, {
				Size = UDim2_.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.15)
			TextButton.Visible = false
			Frame.Visible = true
			Frame.Size = UDim2.new(0, 0, 0, 0)

			local v60 = TweenService
			local v61 = Frame
			local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local v63 = uDim2

			v60.Create(v60, v61, tweenInfo2, {
				Size = UDim2.new(0, 260, 0, 170),
				Position = v63
			}):Play()

			return
		end
	end
end
local function v64()
	if ScreenGui then
		ScreenGui:Destroy()
	end

	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "RoccoInvisGUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0, 260, 0, 170)
	Frame.Position = uDim2
	Frame.BackgroundColor3 = t1.BackgroundColor
	Frame.BackgroundTransparency = 0.08
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.AccentColor
	UIStroke.Thickness = 1.8
	UIStroke.Transparency = 0.3
	UIStroke.Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 42)
	Frame2.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 12)
	UICorner2.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, 0, 0, 6)
	Frame3.Position = UDim2.new(0, 0, 1, -6)
	Frame3.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -50, 1, 0)
	TextLabel.Position = UDim2.new(0, 14, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "@byexploiterrocco"
	TextLabel.TextColor3 = t1.AccentColor
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0, 30, 0, 30)
	TextButton2.Position = UDim2.new(1, -36, 0.5, -15)
	TextButton2.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	TextButton2.Text = "-"
	TextButton2.TextColor3 = t1.TextColor
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 16
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = Frame2

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 6)
	UICorner3.Parent = TextButton2
	TextButton2.MouseButton1Click:Connect(function()
		v53()
	end)

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, -24, 1, -54)
	Frame4.Position = UDim2.new(0, 12, 0, 48)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Name = "ToggleBtn"
	TextButton3.Size = UDim2.new(1, 0, 0, 48)
	TextButton3.Position = UDim2.new(0, 0, 0, 4)
	TextButton3.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	TextButton3.Text = "STATUS: IDLE"
	TextButton3.TextColor3 = t1.TextColor
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextSize = 13
	TextButton3.AutoButtonColor = false
	TextButton3.Parent = Frame4

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = TextButton3

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = t1.AccentColor
	UIStroke2.Thickness = 1
	UIStroke2.Transparency = 0.4
	UIStroke2.Parent = TextButton3
	TextButton3.MouseButton1Click:Connect(function()
		v30()
	end)

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 36)
	Frame5.Position = UDim2.new(0, 0, 0, 60)
	Frame5.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame4

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 8)
	UICorner5.Parent = Frame5

	local Frame6 = Instance.new("Frame")

	Frame6.Name = "StatusGlow"
	Frame6.Size = UDim2.new(0, 8, 0, 8)
	Frame6.Position = UDim2.new(0, 14, 0.5, -4)
	Frame6.BackgroundColor3 = t1.InactiveColor
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(1, 0)
	UICorner6.Parent = Frame6

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = "StatusLabel"
	TextLabel2.Size = UDim2.new(1, -35, 1, 0)
	TextLabel2.Position = UDim2.new(0, 32, 0, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "VISIBLE"
	TextLabel2.TextColor3 = t1.InactiveColor
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 11
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame5
	TextButton = Instance.new("TextButton")
	TextButton.Name = "RCFloatButton"
	TextButton.Size = UDim2.new(0, 58, 0, 58)
	TextButton.Position = UDim2.new(1, -79, 0.5, -29)
	TextButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	TextButton.BackgroundTransparency = 0.1
	TextButton.Visible = false
	TextButton.Text = "RC"
	TextButton.TextColor3 = t1.TextColor
	TextButton.Font = Enum.Font.SpecialElite
	TextButton.TextSize = 18
	TextButton.AutoButtonColor = false
	TextButton.Active = true
	TextButton.Draggable = true

	local UICorner7 = Instance.new("UICorner")

	UICorner7.CornerRadius = UDim.new(1, 0)
	UICorner7.Parent = TextButton
	TextButton.MouseButton1Click:Connect(function()
		v53()
	end)
	Frame.Parent = ScreenGui
	TextButton.Parent = ScreenGui

	local InvisScript = _G.InvisScript
	local v84 = ScreenGui

	table.insert(InvisScript, v84)
end
local function v85()
	connections.Heartbeat = RunService.Heartbeat:Connect(function()
		local Parent = u15

		if Parent then
			Parent = Character

			if Parent then
				Parent = HumanoidRootPart

				if Parent then
					Parent = Humanoid

					if Parent then
						Parent = HumanoidRootPart.Parent
					end
				end
			end
		end

		if not Parent then
			return
		end

		local CFrame_ = HumanoidRootPart.CFrame
		local CameraOffset = Humanoid.CameraOffset
		local cFrame = CFrame_ * CFrame.new(0, t1.TeleportHeight, 0)

		HumanoidRootPart.CFrame = cFrame
		Humanoid.CameraOffset = cFrame:ToObjectSpace(CFrame.new(CFrame_.Position)).Position
		RunService.RenderStepped:Wait()

		local Parent2 = HumanoidRootPart

		if Parent2 then
			Parent2 = HumanoidRootPart.Parent
		end

		if not Parent2 then
			return
		end

		HumanoidRootPart.CFrame = CFrame_
		Humanoid.CameraOffset = CameraOffset
	end)
end

v22()
v64()
v85()
connections.KeyToggle = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= t1.ToggleKey then
		return
	end

	v30()
end)
connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	v22()
	v64()
end)
connections.PlayerLeaving = LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
	if LocalPlayer.Parent then
		return
	end

	for _, connection in pairs(connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
end)
_G.InvisScript.Connections = connections
print("[@byexploiterrocco] System Loaded Successfully!")
