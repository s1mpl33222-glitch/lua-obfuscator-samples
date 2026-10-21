local Players = game:GetService("Players")
local player = Players.LocalPlayer

local presets = {
	{ name = "Fuse",     pos = Vector3.new(-78.36, 3.40, 148.82) },
	{ name = "Security", pos = Vector3.new(-210.14, 3.85, 152.84) },
	{ name = "Bonnie",   path = "workspace.Game.Animatronics.Animatronics.Bonnie" },
}

local gui = Instance.new("ScreenGui")
gui.Name = "TpGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 40 + (#presets * 30))
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "So Dih"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -26, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = true
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local function tpToCFrame(cf)
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.Anchored = false
	hrp.CFrame = cf
	hrp.Velocity = Vector3.zero
	hrp.RotVelocity = Vector3.zero

	task.spawn(function()
		for i = 1, 8 do
			task.wait(0.05)
			if hrp and hrp.Parent then
				hrp.CFrame = cf
			end
		end
	end)
end

local function tpToPosition(pos)
	tpToCFrame(CFrame.new(pos + Vector3.new(0, 4, 0)))
end

local function resolvePath(path)
	local ok, result = pcall(function()
		local obj = game
		for segment in string.gmatch(path, "[^%.]+") do
			obj = obj[segment]
			if not obj then return nil end
		end
		return obj
	end)
	return ok and result or nil
end

local function tpToPath(path)
	local obj = resolvePath(path)
	if not obj then
		warn("Path not found:", path)
		return
	end

	local cf
	if obj:IsA("BasePart") then
		cf = obj.CFrame
	elseif obj:IsA("Model") then
		if obj.PrimaryPart then
			cf = obj.PrimaryPart.CFrame
		else
			local p = obj:FindFirstChildWhichIsA("BasePart", true)
			if p then cf = p.CFrame end
		end
	end

	if cf then
		tpToCFrame(cf + Vector3.new(0, 5, 0))
	else
		warn("Ga nemu CFrame di:", path)
	end
end

local y = 34
for _, p in ipairs(presets) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 26)
	btn.Position = UDim2.new(0, 8, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 110, 180)
	btn.BorderSizePixel = 0
	btn.Text = p.name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		if p.pos then
			tpToPosition(p.pos)
		elseif p.path then
			tpToPath(p.path)
		end
	end)

	y = y + 30
end

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end
end)