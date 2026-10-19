local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

getgenv().BodyLockEnabled = false

local u7 = nil
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = ""
ScreenGui.ResetOnSpawn = false

local TextButton = LocalPlayer

ScreenGui.Parent = LocalPlayer.WaitForChild(TextButton, "PlayerGui")

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 200, 0, 40)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
ScreenGui = Instance.new("UIStroke", Frame)
ScreenGui.Thickness = 2
ScreenGui.Color = Color3.fromRGB(80, 80, 80)
ScreenGui = Instance.new("TextLabel")
ScreenGui.Size = UDim2.new(1, -10, 0, 30)
ScreenGui.Position = UDim2.new(0, 5, 0, 5)
ScreenGui.BackgroundTransparency = 1
ScreenGui.TextColor3 = Color3.fromRGB(255, 255, 255)
ScreenGui.Text = "Slient Aim"
ScreenGui.Font = Enum.Font.SourceSansBold
ScreenGui.TextSize = 20
ScreenGui.TextXAlignment = Enum.TextXAlignment.Left
ScreenGui.Parent = Frame
ScreenGui = Instance.new("Frame")
ScreenGui.Size = UDim2.new(0, 60, 0, 30)
ScreenGui.Position = UDim2.new(1, -80, 0, 5)
ScreenGui.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScreenGui.BorderSizePixel = 0
ScreenGui.Parent = Frame
Instance.new("UICorner", ScreenGui).CornerRadius = UDim.new(1, 0)

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(0, 24, 0, 24)
Frame2.Position = UDim2.new(0, 3, 0, 3)
Frame2.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Frame2.Parent = ScreenGui
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)
TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.BackgroundTransparency = 1
TextButton.Text = ""
TextButton.Parent = ScreenGui
ScreenGui = Instance.new("TextLabel")
ScreenGui.Size = UDim2.new(1, -10, 0, 20)
ScreenGui.Position = UDim2.new(0, 5, 1, -25)
ScreenGui.BackgroundTransparency = 1
ScreenGui.TextColor3 = Color3.fromRGB(200, 200, 200)
ScreenGui.Text = ""
ScreenGui.Font = Enum.Font.SourceSansBold
ScreenGui.TextSize = 16
ScreenGui.TextXAlignment = Enum.TextXAlignment.Left
ScreenGui.Parent = Frame

local function v12()
	if getgenv().BodyLockEnabled then
		Frame2.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
		TweenService:Create(Frame2, TweenInfo.new(0.25), {
			["Position"] = UDim2.new(1, -27, 0, 3)
		}):Play()
	else
		Frame2.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		TweenService:Create(Frame2, TweenInfo.new(0.25), {
			["Position"] = UDim2.new(0, 3, 0, 3)
		}):Play()
	end
end
local function v13()
	local Character = LocalPlayer.Character
	local huge, v16, v17, v18, v19, v20, Humanoid, HumanoidRootPart

	if not Character then
		if Character then
			huge = math.huge
			v16, v17, v18 = ipairs(workspace.Live:GetChildren())
			v19 = nil

			while true do
				v18, v20 = v16(v17, v18)

				if v18 == nil then
					break
				end

				if v20:IsA("Model") and v20 ~= LocalPlayer.Character then
					Humanoid = v20:FindFirstChildOfClass("Humanoid")
					HumanoidRootPart = v20:FindFirstChild("HumanoidRootPart")

					if Humanoid and (Humanoid.Health > 0 and HumanoidRootPart) and (v20.Name == "Weakest Dummy" or Players:GetPlayerFromCharacter(v20)) then
						Humanoid = select(2, CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position))

						if Humanoid then
							Humanoid = (Character.Position - HumanoidRootPart.Position).Magnitude

							if Humanoid < huge then
								v19 = v20
								huge = Humanoid
							end
						end
					end
				end
			end

			return v19
		else
			return nil
		end

		return
	end

	Character = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if Character then
		huge = math.huge
		v16, v17, v18 = ipairs(workspace.Live:GetChildren())
		v19 = nil

		while true do
			v18, v20 = v16(v17, v18)

			if v18 == nil then
				break
			end

			if v20:IsA("Model") and v20 ~= LocalPlayer.Character then
				Humanoid = v20:FindFirstChildOfClass("Humanoid")
				HumanoidRootPart = v20:FindFirstChild("HumanoidRootPart")

				if Humanoid and (Humanoid.Health > 0 and HumanoidRootPart) and (v20.Name == "Weakest Dummy" or Players:GetPlayerFromCharacter(v20)) then
					Humanoid = select(2, CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position))

					if Humanoid then
						Humanoid = (Character.Position - HumanoidRootPart.Position).Magnitude

						if Humanoid < huge then
							v19 = v20
							huge = Humanoid
						end
					end
				end
			end
		end

		return v19
	else
		return nil
	end
end

ScreenGui = function()
	if getgenv().BodyLockEnabled then
		getgenv().BodyLockEnabled = false
		u7 = nil
	else
		getgenv().BodyLockEnabled = true
		u7 = v13()
	end

	v12()
end
TextButton.MouseButton1Click:Connect(ScreenGui)
v12()

local u23 = nil
local u24 = nil
local Position = nil
local Position2 = nil

local function v27(p1)
	local v28 = p1.Position - Position

	Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v28.X, Position2.Y.Scale, Position2.Y.Offset + v28.Y)
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	u23 = true
	Position = input.Position
	Position2 = Frame.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		u23 = false
	end)
end)
Frame.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end

	u24 = input
end)
UserInputService.InputChanged:Connect(function(input)
	if input ~= u24 or not u23 then
		return
	end

	v27(input)
end)
RunService.RenderStepped:Connect(function()
	if not getgenv().BodyLockEnabled then
		return
	end

	local Character = LocalPlayer.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	if Character:FindFirstChild("Ragdoll") then
		return
	end

	Character = u7 and u7.Parent and u7:FindFirstChild("HumanoidRootPart")

	if not Character then
		return
	end

	Character = Vector3.new(Character.Position.X, HumanoidRootPart.Position.Y, Character.Position.Z)
	HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, Character)
end)
