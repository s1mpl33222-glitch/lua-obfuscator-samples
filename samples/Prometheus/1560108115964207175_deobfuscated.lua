-- This file was generated at discord.gg/syncrypt

task.spawn(function()
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")
	local Lighting = game:GetService("Lighting")
	local BlurEffect = Instance.new("BlurEffect")

	BlurEffect.Size = 12
	BlurEffect.Parent = Lighting

	local v5 = math.random(50, 67)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "ProfessionalLoader"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 999999
	ScreenGui.Parent = CoreGui

	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromHex("#0A0A0F")
	Frame.BackgroundTransparency = 0.35
	Frame.BorderSizePixel = 0

	local Frame2 = Instance.new("Frame", ScreenGui)

	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame2.Size = UDim2.new(0.98, 0, 0.8, 0)
	Frame2.BackgroundColor3 = Color3.fromHex("#11111A")
	Frame2.BorderSizePixel = 0
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 18)

	local UIStroke = Instance.new("UIStroke", Frame2)

	UIStroke.Color = Color3.fromHex("#8B5CF6")
	UIStroke.Thickness = 1.5
	UIStroke.Transparency = 0.2

	local TextLabel = Instance.new("TextLabel", Frame2)

	TextLabel.Size = UDim2.new(1, 0, 0.05, 0)
	TextLabel.Position = UDim2.new(0, 0, 0.02, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "NOT WORKING ON XENO OR SOLARA • USE DELTA, WAVE, VOLT OR RONIX"
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextScaled = true
	TextLabel.TextColor3 = Color3.fromHex("#A855F7")

	local TextLabel2 = Instance.new("TextLabel", Frame2)

	TextLabel2.Size = UDim2.new(1, 0, 0.15, 0)
	TextLabel2.Position = UDim2.new(0, 0, 0.08, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "DUPE/SPAWNER/TRADE SCRIPT"
	TextLabel2.Font = Enum.Font.GothamBlack
	TextLabel2.TextScaled = true
	TextLabel2.TextColor3 = Color3.new(1, 1, 1)

	local TextLabel3 = Instance.new("TextLabel", Frame2)

	TextLabel3.Size = UDim2.new(1, 0, 0.1, 0)
	TextLabel3.Position = UDim2.new(0, 0, 0.2, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = Enum.Font.GothamMedium
	TextLabel3.TextScaled = true
	TextLabel3.TextColor3 = Color3.fromHex("#9CA3AF")

	local t1 = {
		"Initializing brainrot duplicator...",
		"Loading spawn queue...",
		"Bypassing trade cooldown...",
		"Cloning selected brainrots...",
		"Injecting spawn commands...",
		"Syncing with dupe database...",
		"Preparing rare spawns...",
		"Generating duplicate traits...",
		"Verifying inventory slots...",
		"Duplication module ready!"
	}

	task.spawn(function()
		while TextLabel3.Parent do
			TextLabel3.Text = t1[math.random(1, #t1)]
			task.wait(math.random(2, 4))
		end
	end)

	local TextLabel4 = Instance.new("TextLabel", Frame2)

	TextLabel4.Size = UDim2.new(0, 70, 0, 70)
	TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel4.Position = UDim2.new(0.5, 0, 0.45, 0)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "⏳"
	TextLabel4.Font = Enum.Font.GothamBold
	TextLabel4.TextScaled = true
	TextLabel4.TextColor3 = Color3.fromHex("#8B5CF6")
	task.spawn(function()
		while TextLabel4.Parent do
			local v28 = TextLabel4
			local s1 = "Rotation"

			v28[s1] = v28[s1] + 6
			task.wait()
		end
	end)

	local Frame3 = Instance.new("Frame", Frame2)

	Frame3.Size = UDim2.new(0.6, 0, 0, 12)
	Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame3.Position = UDim2.new(0.5, 0, 0.62, 0)
	Frame3.BackgroundColor3 = Color3.fromHex("#181824")
	Frame3.BorderSizePixel = 0
	Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)

	local Frame4 = Instance.new("Frame", Frame3)

	Frame4.Size = UDim2.new(0, 0, 1, 0)
	Frame4.BackgroundColor3 = Color3.fromHex("#8B5CF6")
	Frame4.BorderSizePixel = 0
	Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

	local TextLabel5 = Instance.new("TextLabel", Frame2)

	TextLabel5.Size = UDim2.new(1, 0, 0.08, 0)
	TextLabel5.Position = UDim2.new(0, 0, 0.68, 0)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Font = Enum.Font.GothamBold
	TextLabel5.TextScaled = true
	TextLabel5.TextColor3 = Color3.fromHex("#A855F7")

	local TextLabel6 = Instance.new("TextLabel", Frame2)

	TextLabel6.Size = UDim2.new(1, 0, 0.07, 0)
	TextLabel6.Position = UDim2.new(0, 0, 0.78, 0)
	TextLabel6.BackgroundTransparency = 1
	TextLabel6.Text = "Stay in the match while DUPE/SPAWNER/TRADE initializes"
	TextLabel6.Font = Enum.Font.Gotham
	TextLabel6.TextScaled = true
	TextLabel6.TextColor3 = Color3.fromHex("#9CA3AF")

	local TextLabel7 = Instance.new("TextLabel", Frame2)

	TextLabel7.Size = UDim2.new(1, 0, 0.05, 0)
	TextLabel7.Position = UDim2.new(0, 0, 0.87, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = "created by Oblivion-Hub  |  oblivionhub.xyz  |  discord.gg/oblivionhub"
	TextLabel7.Font = Enum.Font.Gotham
	TextLabel7.TextScaled = true
	TextLabel7.TextColor3 = Color3.new(1, 1, 1)

	local timestamp = tick()

	while true do
		local v21 = tick() - timestamp
		local v22 = math.max(0, v5 - v21)
		local v23 = math.floor(v22 / 60)
		local v24 = v22 % 60

		TextLabel5.Text = "ESTIMATED TIME " .. string.format("%02d:%02d", v23, v24)
		Frame4.Size = UDim2.new(math.clamp(v21 / v5, 0, 1), 0, 1, 0)

		if v22 <= 0 then
			break
		end

		task.wait(0.1)
	end

	TweenService:Create(Frame2, TweenInfo.new(0.4), {
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(Frame, TweenInfo.new(0.4), {
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.45)
	ScreenGui:Destroy()
	BlurEffect:Destroy()
end)
