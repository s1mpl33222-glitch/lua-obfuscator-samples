local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local u6 = false
local u7 = false
local u8 = false
local Z = Enum.KeyCode.Z
local V = Enum.KeyCode.V
local X = Enum.KeyCode.X
local J = Enum.KeyCode.J
local t1 = {}
local color3 = Color3.fromRGB(18, 22, 32)
local color32 = Color3.fromRGB(92, 151, 255)
local color33 = Color3.fromRGB(240, 61, 86)
local color34 = Color3.fromRGB(50, 215, 75)

Color3.fromRGB(35, 40, 55)

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "Sw1ftSyncX_AimbotUNI_GUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")

Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 340, 0, 240)
Frame.Position = UDim2.new(0, 80, 0, 180)
Frame.BackgroundColor3 = color3
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 0, 6)
Frame2.BackgroundColor3 = color32
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Name = "MinimizeBtn"
TextButton.Size = UDim2.new(0, 28, 0, 28)
TextButton.Position = UDim2.new(1, -34, 0, 7)
TextButton.BackgroundColor3 = color33
TextButton.Text = "-"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.GothamBlack
TextButton.TextSize = 22
TextButton.BorderSizePixel = 0
TextButton.AutoButtonColor = true
TextButton.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Text = "Sw1ftSyncX | Universal Aimbot"
TextLabel.Size = UDim2.new(1, 0, 0, 38)
TextLabel.Position = UDim2.new(0, 0, 0, 7)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = color32
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextSize = 22
TextLabel.Parent = Frame

local TextButton2 = Instance.new("TextButton")

TextButton2.Name = "AimLockBtn"
TextButton2.Text = "AimLock (" .. Z.Name .. "): OFF"
TextButton2.Size = UDim2.new(1, -36, 0, 42)
TextButton2.Position = UDim2.new(0, 18, 0, 54)
TextButton2.BackgroundColor3 = color33
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.Font = Enum.Font.GothamBold
TextButton2.TextSize = 18
TextButton2.BorderSizePixel = 0
TextButton2.AutoButtonColor = true
TextButton2.Parent = Frame

local TextButton3 = Instance.new("TextButton")

TextButton3.Name = "AimAssistBtn"
TextButton3.Text = "Aim Assist (" .. V.Name .. "): OFF"
TextButton3.Size = UDim2.new(1, -36, 0, 42)
TextButton3.Position = UDim2.new(0, 18, 0, 102)
TextButton3.BackgroundColor3 = color33
TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton3.Font = Enum.Font.GothamBold
TextButton3.TextSize = 18
TextButton3.BorderSizePixel = 0
TextButton3.AutoButtonColor = true
TextButton3.Parent = Frame

local TextButton4 = Instance.new("TextButton")

TextButton4.Name = "ESPBtn"
TextButton4.Text = "ESP (" .. X.Name .. "): OFF"
TextButton4.Size = UDim2.new(1, -36, 0, 42)
TextButton4.Position = UDim2.new(0, 18, 0, 150)
TextButton4.BackgroundColor3 = color33
TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton4.Font = Enum.Font.GothamBold
TextButton4.TextSize = 18
TextButton4.BorderSizePixel = 0
TextButton4.AutoButtonColor = true
TextButton4.Parent = Frame

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Text = "Toggle GUI: [J] | Use os bot\195\181es para ativar/desativar"
TextLabel2.Size = UDim2.new(1, -36, 0, 24)
TextLabel2.Position = UDim2.new(0, 18, 0, 196)
TextLabel2.BackgroundTransparency = 1
TextLabel2.TextColor3 = Color3.fromRGB(120, 130, 180)
TextLabel2.Font = Enum.Font.GothamSemibold
TextLabel2.TextSize = 13
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame;
(function(p1)
	local Position = nil
	local u28 = nil
	local u29 = nil
	local Position2 = nil

	p1.Active = true
	p1.Selectable = true
	p1.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u28 = true
		Position2 = input.Position
		Position = p1.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u28 = false
		end)
	end)
	p1.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		u29 = input
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input ~= u29 or not u28 then
			return
		end

		local v31 = input.Position - Position2

		p1.Position = UDim2.new(Position.X.Scale, Position.X.Offset + v31.X, Position.Y.Scale, Position.Y.Offset + v31.Y)
	end)
end)(Frame)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= J then
		return
	end

	Frame.Visible = not Frame.Visible
end)

local function v32()
	local huge = math.huge
	local v34 = Players
	local v35, v36

	v34, v35, v36 = ipairs(v34:GetPlayers())

	local v37 = nil

	while true do
		local v38

		v36, v38 = v34(v35, v36)

		if v36 == nil then
			break
		end

		if v38 ~= LocalPlayer and v38.Character and (v38.Character:FindFirstChild("HumanoidRootPart") and (v38.Character:FindFirstChildOfClass("Humanoid") and v38.Character:FindFirstChildOfClass("Humanoid").Health > 0)) then
			local value = select(2, CurrentCamera:WorldToViewportPoint(v38.Character.HumanoidRootPart.Position))

			if value then
				value = (CurrentCamera.CFrame.Position - v38.Character.HumanoidRootPart.Position).Magnitude

				if value < huge then
					v37 = v38
					huge = value
				end
			end
		end
	end

	return v37
end
local function v40(p2, p3, p4)
	return p2 + (p3 - p2) * p4
end

RunService.RenderStepped:Connect(function()
	local Unit, Position

	if u6 then
		Unit = v32()

		if not (Unit and Unit.Character and Unit.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		Position = CurrentCamera.CFrame.Position
		Unit = (Unit.Character.HumanoidRootPart.Position - Position).Unit
		CurrentCamera.CFrame = CFrame.new(Position, Position + Unit)
	else
		if not u7 then
			return
		end

		Unit = v32()

		if not (Unit and Unit.Character and Unit.Character:FindFirstChild("HumanoidRootPart")) then
			return
		end

		Position = CurrentCamera.CFrame.Position
		Unit = (Unit.Character.HumanoidRootPart.Position - Position).Unit
		Unit = v40(CurrentCamera.CFrame.LookVector, Unit, 0.12)
		CurrentCamera.CFrame = CFrame.new(Position, Position + Unit)
	end
end)
task.spawn(function()
	while true do
		local v43, v44, v45, v46

		if u8 then
			v43 = Players
			v43, v44, v45 = ipairs(v43:GetPlayers())

			while true do
				v45, v46 = v43(v44, v45)

				if v45 == nil then
					break
				end

				if v46 ~= LocalPlayer and v46.Character and (v46.Character:FindFirstChild("HumanoidRootPart") and (not t1[v46] or (not t1[v46].Parent or t1[v46].Adornee ~= v46.Character))) then
					if t1[v46] and t1[v46].Parent then
						t1[v46]:Destroy()
					end

					local Highlight = Instance.new("Highlight")

					Highlight.Name = "RedESP"
					Highlight.FillColor = Color3.fromRGB(255, 0, 0)
					Highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
					Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					Highlight.FillTransparency = 0.5
					Highlight.Adornee = v46.Character
					Highlight.Parent = v46.Character
					t1[v46] = Highlight
				end

				continue
			end

			v43, v44, v45 = pairs(t1)

			while true do
				v45, v46 = v43(v44, v45)

				if v45 == nil then
					break
				end

				if not (v45.Parent and v45.Character and v45.Character:FindFirstChild("HumanoidRootPart")) then
					if v46 and v46.Parent then
						v46:Destroy()
					end

					t1[v45] = nil
				end
			end
		else
			v43, v44, v45 = pairs(t1)

			while true do
				v45, v46 = v43(v44, v45)

				if v45 == nil then
					break
				end

				if v46 and v46.Parent then
					v46:Destroy()
				end

				t1[v45] = nil
			end
		end

		wait(0.1)

		continue
	end
end)
TextButton2.MouseButton1Click:Connect(function()
	u6 = not u6

	if not u6 then
		TextButton2.Text = "AimLock (" .. Z.Name .. "): " .. (u6 and "ON" or "OFF")
		TextButton2.BackgroundColor3 = u6 and color34 or color33
		TextButton3.Text = "Aim Assist (" .. V.Name .. "): OFF"
		TextButton3.BackgroundColor3 = color33

		return
	end

	u7 = false
	TextButton2.Text = "AimLock (" .. Z.Name .. "): " .. (u6 and "ON" or "OFF")
	TextButton2.BackgroundColor3 = u6 and color34 or color33
	TextButton3.Text = "Aim Assist (" .. V.Name .. "): OFF"
	TextButton3.BackgroundColor3 = color33
end)
TextButton3.MouseButton1Click:Connect(function()
	u7 = not u7

	if not u7 then
		TextButton3.Text = "Aim Assist (" .. V.Name .. "): " .. (u7 and "ON" or "OFF")
		TextButton3.BackgroundColor3 = u7 and color34 or color33
		TextButton2.Text = "AimLock (" .. Z.Name .. "): OFF"
		TextButton2.BackgroundColor3 = color33

		return
	end

	u6 = false
	TextButton3.Text = "Aim Assist (" .. V.Name .. "): " .. (u7 and "ON" or "OFF")
	TextButton3.BackgroundColor3 = u7 and color34 or color33
	TextButton2.Text = "AimLock (" .. Z.Name .. "): OFF"
	TextButton2.BackgroundColor3 = color33
end)
TextButton4.MouseButton1Click:Connect(function()
	u8 = not u8
	TextButton4.Text = "ESP (" .. X.Name .. "): " .. (u8 and "ON" or "OFF")
	TextButton4.BackgroundColor3 = u8 and color34 or color33
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	else
		if input.KeyCode ~= Z then
			if input.KeyCode ~= V then
				if input.KeyCode ~= X then
					return
				end

				u8 = not u8
				TextButton4.Text = "ESP (" .. X.Name .. "): " .. (u8 and "ON" or "OFF")
				TextButton4.BackgroundColor3 = u8 and color34 or color33
			else
				u7 = not u7

				if u7 then
					u6 = false
				end

				TextButton3.Text = "Aim Assist (" .. V.Name .. "): " .. (u7 and "ON" or "OFF")
				TextButton3.BackgroundColor3 = u7 and color34 or color33
				TextButton2.Text = "AimLock (" .. Z.Name .. "): OFF"
				TextButton2.BackgroundColor3 = color33
			end
		else
			u6 = not u6

			if u6 then
				u7 = false
			end

			TextButton2.Text = "AimLock (" .. Z.Name .. "): " .. (u6 and "ON" or "OFF")
			TextButton2.BackgroundColor3 = u6 and color34 or color33
			TextButton3.Text = "Aim Assist (" .. V.Name .. "): OFF"
			TextButton3.BackgroundColor3 = color33
		end

		return
	end
end)
TextButton2.BackgroundColor3 = color33
TextButton4.BackgroundColor3 = color33
TextButton3.BackgroundColor3 = color33

local u48 = false
local uDim2 = UDim2.new(0, 340, 0, 240)
local Position = Frame.Position
local uDim22 = UDim2.new(0, 110, 0, 40)
local uDim23 = UDim2.new(0, Position.X.Offset, 0, Position.Y.Offset)

TextButton.MouseButton1Click:Connect(function()
	u48 = not u48

	if u48 then
		Frame.Size = uDim22
		Frame.Position = uDim23
		TextButton2.Visible = false
		TextButton3.Visible = false
		TextButton4.Visible = false
		TextLabel2.Visible = false
		TextLabel.Visible = false
		Frame2.Visible = false
		TextButton.Text = "+"
	else
		Frame.Size = uDim2
		Frame.Position = Position
		TextButton2.Visible = true
		TextButton3.Visible = true
		TextButton4.Visible = true
		TextLabel2.Visible = true
		TextLabel.Visible = true
		Frame2.Visible = true
		TextButton.Text = "-"
	end
end)
