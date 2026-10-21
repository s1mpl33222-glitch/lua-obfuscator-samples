-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")

game:GetService("RunService")
Players = Players.LocalPlayer

local u2 = nil
local u3 = nil

local function v4(p1)
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil, nil
	end

	local RD_Billboard = HumanoidRootPart:FindFirstChild("RD_Billboard")

	if not RD_Billboard then
		RD_Billboard = Instance.new("BillboardGui")
		RD_Billboard.Name = "RD_Billboard"
		RD_Billboard.Adornee = HumanoidRootPart
		RD_Billboard.Size = UDim2.new(0, 140, 0, 36)
		RD_Billboard.AlwaysOnTop = true
		RD_Billboard.ResetOnSpawn = false
		RD_Billboard.Enabled = false
		RD_Billboard.StudsOffset = Vector3.new(3.2, 2.5, 0)
		v8 = Instance.new("Frame", RD_Billboard)
		v8.Size = UDim2.new(1, 0, 1, 0)
		v8.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
		v8.BackgroundTransparency = 0.45
		v8.BorderSizePixel = 0
		Instance.new("UICorner", v8).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", v8).Color = Color3.fromRGB(255, 50, 50)
		v8 = Instance.new("TextLabel", v8)
		v8.Size = UDim2.new(1, 0, 1, 0)
		v8.BackgroundTransparency = 1
		v8.Text = "RAGDOLL: 3"
		v8.TextColor3 = Color3.fromRGB(255, 70, 70)
		v8.Font = Enum.Font.GothamBlack
		v8.TextSize = 15
		v8.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		v8.TextStrokeTransparency = 0.2
		RD_Billboard.Parent = HumanoidRootPart

		return RD_Billboard, v8
	end

	RD_Billboard:Destroy()
	RD_Billboard = Instance.new("BillboardGui")
	RD_Billboard.Name = "RD_Billboard"
	RD_Billboard.Adornee = HumanoidRootPart
	RD_Billboard.Size = UDim2.new(0, 140, 0, 36)
	RD_Billboard.AlwaysOnTop = true
	RD_Billboard.ResetOnSpawn = false
	RD_Billboard.Enabled = false
	RD_Billboard.StudsOffset = Vector3.new(3.2, 2.5, 0)

	local Frame = Instance.new("Frame", RD_Billboard)

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
	Frame.BackgroundTransparency = 0.45
	Frame.BorderSizePixel = 0
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", Frame).Color = Color3.fromRGB(255, 50, 50)
	Frame = Instance.new("TextLabel", Frame)
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Text = "RAGDOLL: 3"
	Frame.TextColor3 = Color3.fromRGB(255, 70, 70)
	Frame.Font = Enum.Font.GothamBlack
	Frame.TextSize = 15
	Frame.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	Frame.TextStrokeTransparency = 0.2
	RD_Billboard.Parent = HumanoidRootPart

	return RD_Billboard, Frame
end
local function v9(p2)
	if u2 then
		u2:Disconnect()
		u2 = nil
	end

	local v10

	if not u3 then
		v12 = p2:WaitForChild("HumanoidRootPart", 6)
		v13 = p2:WaitForChild("Humanoid", 6)

		if v12 and v13 then
			v12, v10 = v4(p2)

			if not v12 then
				return
			end

			return
		else
			return
		end

		return
	end

	u3:Disconnect()
	u3 = nil

	local HumanoidRootPart = p2:WaitForChild("HumanoidRootPart", 6)
	local Humanoid = p2:WaitForChild("Humanoid", 6)

	if HumanoidRootPart and Humanoid then
		HumanoidRootPart, v10 = v4(p2)

		if not HumanoidRootPart then
			return
		end

		return
	else
		return
	end
end

if Players.Character then
	task.spawn(v9, Players.Character)
end

Players = Players.CharacterAdded

local v14 = v9

Players:Connect(function(p3)
	task.wait(0.15)
	task.spawn(v14, p3)
end)
task.delay(86400, function()
	if u2 then
		u2:Disconnect()
	end

	if not u3 then
		return
	end

	u3:Disconnect()
end)
