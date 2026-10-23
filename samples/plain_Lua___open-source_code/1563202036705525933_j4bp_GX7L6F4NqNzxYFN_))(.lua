repeat
	task.wait()
until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

local function fn()
	local ok, result = pcall(function()
		if gethui then
			return gethui()
		end
		return nil
	end)

	if ok and result then
		return result
	end

	local ok2, result2 = pcall(function()
		return game:GetService("CoreGui")
	end)

	if ok2 and result2 then
		return result2
	end
	return localPlayer:WaitForChild("PlayerGui")
end

local v = fn()

local autoSteal = {
	AutoStealEnabled = true,
	StealRadius = 55,
	StealDuration = 0.1,
	Mode = "half",
	HalfFireRange = 2,
	HalfHoldMin = 1.3,
	HalfHoldMax = 5,
	HalfEntryDelay = 0.3,
	Data = {},
}

local tbl = {
	StealRadius = 80,
	HalfFireRange = 10,
	HalfHoldMin = 1.3,
	HalfHoldMax = 2.6,
	HalfEntryDelay = 0.3,
	autoEnabled = true,
}

local tbl2 = {
	StealRadius = 55,
	HalfFireRange = 10,
	HalfHoldMin = 1.3,
	HalfHoldMax = 2.6,
	HalfEntryDelay = 0.3,
	autoEnabled = true,
}

local tbl3 = {
	StealRadius = 55,
	HalfFireRange = 10,
	HalfHoldMin = 1.3,
	HalfHoldMax = 2.6,
	HalfEntryDelay = 0.3,
	autoEnabled = true,
}

local flag = false
local now = nil
local connection = nil
_G.StealProgress = 0
local v2 = nil

local function fn2(arg)
	if v2 then
		v2.Size = UDim2.new(math.clamp(arg, 0, 1), 0, 1, 0)
	end
end

local connection2 = nil

local function fn3()
	if connection2 then
		return
	end

	connection2 = RunService.Heartbeat:Connect(function()
		fn2(_G.StealProgress)
	end)
end

local function fn4(arg)
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return false
	end
	local v3 = plots:FindFirstChild(arg)
	if not v3 then
		return false
	end
	local plotSign = v3:FindFirstChild("PlotSign")

	if plotSign then
		local yourBase = plotSign:FindFirstChild("YourBase")
		if yourBase and yourBase:IsA("BillboardGui") then
			return yourBase.Enabled == true
		end
	end

	return false
end

local function fn5()
	local character = localPlayer.Character
	if not character then
		return nil
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if not humanoidRootPart then
		return nil
	end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return nil
	end
	local huge = math.huge
	local v3 = nil

	for _, child in ipairs(plots:GetChildren()) do
		if child:IsA("Model") and not fn4(child.Name) then
			local animalPodiums = child:FindFirstChild("AnimalPodiums")

			if animalPodiums then
				for _, child2 in ipairs(animalPodiums:GetChildren()) do
					local base = child2:FindFirstChild("Base")
					base = base and base:FindFirstChild("Spawn")

					if base then
						local magnitude = (base.Position - humanoidRootPart.Position).Magnitude

						if magnitude <= autoSteal.StealRadius and magnitude < huge then
							local promptAttachment = base:FindFirstChild("PromptAttachment")
							local v4 = nil

							if promptAttachment then
								v4 = nil

								for _, child3 in ipairs(promptAttachment:GetChildren()) do
									if child3:IsA("ProximityPrompt") and child3.ActionText and child3.ActionText:find("Steal") then
										v4 = child3
									end
								end
							end

							if not v4 then
								for _, descendant in ipairs(base:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and descendant.ActionText and descendant.ActionText:find("Steal") then
										v4 = descendant
									end
								end
							end

							if v4 then
								huge = magnitude
								v3 = v4
							end
						end
					end
				end
			end
		end
	end

	return v3
end

local function fn6(arg)
	local character = localPlayer.Character
	if not character then
		return math.huge
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if not humanoidRootPart then
		return math.huge
	end
	local parent = arg.Parent

	if parent and parent:IsA("Attachment") then
		parent = parent.Parent
	end

	if parent and parent:IsA("BasePart") then
		return (parent.Position - humanoidRootPart.Position).Magnitude
	end

	local ok, result = pcall(function()
		return arg.Parent and arg.Parent.WorldPosition
	end)

	if ok and result then
		return (result - humanoidRootPart.Position).Magnitude
	end
	return math.huge
end

local function fn7(arg)
	if flag then
		return
	end

	if not autoSteal.Data[arg] then
		autoSteal.Data[arg] = { hold = {}, trigger = {}, ready = true }

		if getconnections then
			for _, v3 in ipairs(getconnections(arg.PromptButtonHoldBegan)) do
				if v3.Function then
					table.insert(autoSteal.Data[arg].hold, v3.Function)
				end
			end

			for _, v3 in ipairs(getconnections(arg.Triggered)) do
				if v3.Function then
					table.insert(autoSteal.Data[arg].trigger, v3.Function)
				end
			end
		end
	end

	local v3 = autoSteal.Data[arg]
	if not v3.ready then
		return
	end
	v3.ready = false
	flag = true
	now = tick()
	_G.StealProgress = 0

	if autoSteal.Mode == "half" then
		task.spawn(function()
			for _, v4 in ipairs(v3.hold) do
				task.spawn(v4)
			end

			task.wait(autoSteal.HalfHoldMin)
			local halfFireRange = autoSteal.HalfFireRange
			local flag2 = fn6(arg) <= halfFireRange
			local halfHoldMax = autoSteal.HalfHoldMax

			while true do
				local n = tick() - now

				if n > halfHoldMax or not arg.Parent then
					_G.StealProgress = 1
					task.wait(0.1)
					_G.StealProgress = 0
					task.wait(0.05)
					v3.ready = true
					flag = false
					_G.StealProgress = 0
					return
				end

				_G.StealProgress = math.min(n / halfHoldMax, 1)
				local halfFireRange2 = autoSteal.HalfFireRange
				if fn6(arg) <= halfFireRange2 then
					break
				end
				task.wait()
			end

			if not flag2 then
				task.wait(autoSteal.HalfEntryDelay)
			end

			_G.StealProgress = 1

			for _, v4 in ipairs(v3.trigger) do
				task.spawn(v4)
			end

			task.wait(0.1)
			_G.StealProgress = 0
			task.wait(0.05)
			v3.ready = true
			flag = false
			_G.StealProgress = 0
		end)
	else
		task.spawn(function()
			for _, v4 in ipairs(v3.hold) do
				task.spawn(v4)
			end

			local stealDuration = autoSteal.StealDuration
			local now2 = tick()
			local exitTo = nil

			while true do
				local n = tick() - now2

				if stealDuration <= n then
					exitTo = 1
					break
				else
					if arg.Parent then
						_G.StealProgress = math.min(n / stealDuration, 1)
						task.wait()
						continue
					end

					break
				end
			end

			if exitTo == 1 then
				_G.StealProgress = 1

				for _, v4 in ipairs(v3.trigger) do
					task.spawn(v4)
				end

				task.wait(0.1)
				_G.StealProgress = 0
			else
				_G.StealProgress = 0
			end

			task.wait(0.05)
			v3.ready = true
			flag = false
			_G.StealProgress = 0
		end)
	end
end

local function fn8(arg)
	if flag then
		return
	end

	if not autoSteal.Data[arg] then
		autoSteal.Data[arg] = { hold = {}, trigger = {}, ready = true }

		if getconnections then
			for _, v3 in ipairs(getconnections(arg.PromptButtonHoldBegan)) do
				if v3.Function then
					table.insert(autoSteal.Data[arg].hold, v3.Function)
				end
			end

			for _, v3 in ipairs(getconnections(arg.Triggered)) do
				if v3.Function then
					table.insert(autoSteal.Data[arg].trigger, v3.Function)
				end
			end
		end
	end

	local v3 = autoSteal.Data[arg]
	if not v3.ready then
		return
	end
	v3.ready = false
	flag = true
	now = tick()

	if autoSteal.Mode == "half" then
		task.spawn(function()
			for _, v4 in ipairs(v3.hold) do
				task.spawn(v4)
			end

			task.wait(autoSteal.HalfHoldMin)
			local halfFireRange = autoSteal.HalfFireRange
			local flag2 = fn6(arg) <= halfFireRange

			while true do
				local halfHoldMax = autoSteal.HalfHoldMax

				if not (tick() - now > halfHoldMax or not arg.Parent) then
					local halfFireRange2 = autoSteal.HalfFireRange

					if fn6(arg) <= halfFireRange2 then
						if not flag2 then
							task.wait(autoSteal.HalfEntryDelay)
						end

						for _, v4 in ipairs(v3.trigger) do
							task.spawn(v4)
						end

						task.wait(0.05)
						v3.ready = true
						flag = false
						return
					else
						task.wait()
						continue
					end
				end

				break
			end

			task.wait(0.05)
			v3.ready = true
			flag = false
		end)
	else
		task.spawn(function()
			for _, v4 in ipairs(v3.hold) do
				task.spawn(v4)
			end

			local n = 0

			while n < autoSteal.StealDuration do
				n += task.wait()
				if arg.Parent then
					continue
				end
				break
			end

			for _, v4 in ipairs(v3.trigger) do
				task.spawn(v4)
			end

			task.wait(0.05)
			v3.ready = true
			flag = false
		end)
	end
end

local n = 1
local tbl4 = { "v1", "v2", "v3" }

local function fn9(arg)
	if n == 2 then
		fn8(arg)
	else
		fn7(arg)
	end
end

local function fn10()
	if connection then
		return
	end

	connection = RunService.Heartbeat:Connect(function()
		if not autoSteal.AutoStealEnabled or flag then
			return
		end
		local v3 = fn5()

		if v3 then
			fn9(v3)
		end
	end)
end

local function fn11()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	flag = false
	_G.StealProgress = 0
end

_G.AutoSteal = autoSteal

local function fn12(arg)
	if not arg then
		return
	end
	local position = arg.Position
	local tbl5 = { X = position.X.Scale, XOffset = position.X.Offset, Y = position.Y.Scale, YOffset = position.Y.Offset }

	pcall(function()
		writefile("ChocolateAutoGrabPos.txt", HttpService:JSONEncode(tbl5))
	end)
end

local function fn13()
	local data = nil

	pcall(function()
		data = HttpService:JSONDecode(readfile("ChocolateAutoGrabPos.txt"))
	end)

	if data then
		return UDim2.new(data.X, data.XOffset, data.Y, data.YOffset)
	end
	return nil
end

local function fn14(arg)
	pcall(function()
		writefile("ChocolateAutoGrabRadius.txt", tostring(arg))
	end)
end

local function fn15()
	local num = nil

	pcall(function()
		num = tonumber(readfile("ChocolateAutoGrabRadius.txt"))
	end)

	if num and num >= 10 and num <= 150 then
		return num
	end
	return nil
end

local function fn16(arg)
	pcall(function()
		writefile("ChocolateAutoGrabScale.txt", tostring(arg))
	end)
end

local function fn17()
	local num

	pcall(function()
		num = tonumber(readfile("ChocolateAutoGrabScale.txt"))
	end)

	if num and num >= 0.5 and num <= 1.5 then
		return num
	end
	return nil
end

local function fn18(arg)
	pcall(function()
		writefile("ChocolateAutoGrabToggle.txt", arg and "1" or "0")
	end)
end

local function fn19()
	local txt = nil

	pcall(function()
		txt = readfile("ChocolateAutoGrabToggle.txt")
	end)

	if txt == "1" then
		return true
	end

	if txt == "0" then
		return false
	end
	return nil
end

local v3 = fn15()

if v3 then
	autoSteal.StealRadius = v3
end

local scale = fn17() or 1
local v4 = fn19()
local flag2 = v4 == nil and true or v4

if v4 == nil then
	pcall(fn18, true)
end

local tbl5 = {}

local function fn20(arg)
	local v5

	if arg == 1 then
		v5 = tbl
	elseif arg == 2 then
		v5 = tbl2
	else
		v5 = tbl3
	end

	autoSteal.StealRadius = v5.StealRadius
	autoSteal.HalfFireRange = v5.HalfFireRange
	autoSteal.HalfHoldMin = v5.HalfHoldMin
	autoSteal.HalfHoldMax = v5.HalfHoldMax
	autoSteal.HalfEntryDelay = v5.HalfEntryDelay
	autoSteal.AutoStealEnabled = v5.autoEnabled
	fn11()

	if autoSteal.AutoStealEnabled then
		fn10()
	end

	if tbl5.updateUI then
		tbl5.updateUI()
	end
end

local function fn21(arg)
	if arg == n then
		return
	end
	n = arg
	fn20(arg)

	if tbl5.versionValLabel then
		tbl5.versionValLabel.Text = tbl4[n]
	end

	if tbl5.dropdown then
		for _, child in ipairs(tbl5.dropdown:GetChildren()) do
			if child:IsA("TextButton") and child.Name:match("ver%d+") then
				if tonumber(child.Name:match("(%d+)")) == n then
					child.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
					child.TextColor3 = Color3.fromRGB(0, 0, 0)
				else
					child.BackgroundColor3 = Color3.fromRGB(0, 60, 110)
					child.TextColor3 = Color3.fromRGB(200, 230, 255)
				end
			end
		end
	end

	if tbl5.updateUI then
		tbl5.updateUI()
	end
end

local function fn22(arg, arg2)
	flag2 = arg and true or false

	if not arg2 then
		fn18(flag2)
	end

	if tbl5 and tbl5.toggleBtn then
		if flag2 then
			tbl5.toggleBtn.Text = "ON"
			tbl5.toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 90, 170)
		else
			tbl5.toggleBtn.Text = "OFF"
			tbl5.toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 45, 85)
		end
	end
end

local function fn23()
	pcall(function()
		local autoStealGui = v:FindFirstChild("AutoStealGui")

		if autoStealGui then
			autoStealGui:Destroy()
		end
	end)

	pcall(function()
		local autoStealGui = localPlayer.PlayerGui:FindFirstChild("AutoStealGui")

		if autoStealGui then
			autoStealGui:Destroy()
		end
	end)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AutoStealGui"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 999
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = v
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 320, 0, 52)
	local v5 = fn13()

	if v5 then
		frame.Position = v5
	else
		frame.Position = UDim2.new(0.5, -160, 0.6, 0)
	end

	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = screenGui
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 2
	uiStroke.Transparency = 0.3
	uiStroke.Parent = frame
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 12)
	uiCorner.Parent = frame
	local frame2 = Instance.new("Frame")
	frame2.Name = "TopRow"
	frame2.Size = UDim2.new(1, -16, 0, 22)
	frame2.Position = UDim2.new(0, 8, 0, 3)
	frame2.BackgroundTransparency = 1
	frame2.Parent = frame
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TitleLabel"
	textLabel.Size = UDim2.new(0.5, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "LWZ HUB"
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextSize = 13
	textLabel.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = frame2
	local uiGradient = Instance.new("UIGradient")
	local colorSequence = ColorSequence.new
	local tbl6 = {}
	local v6 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
	local v7 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255))
	local new = ColorSequenceKeypoint.new
	local color = Color3.fromRGB
	tbl6[1] = v6
	tbl6[2] = v7

	do
		local values = table.pack(new(1, color(200, 230, 255)))
		table.move(values, 1, values.n, 3, tbl6)
	end

	uiGradient.Color = colorSequence(tbl6)
	uiGradient.Parent = textLabel
	local textButton = Instance.new("TextButton")
	textButton.Name = "GearBtn"
	textButton.Size = UDim2.new(0, 20, 0, 20)
	textButton.Position = UDim2.new(1, 0, 0.5, 0)
	textButton.AnchorPoint = Vector2.new(1, 0.5)
	textButton.BackgroundTransparency = 1
	textButton.BorderSizePixel = 0
	textButton.Text = "â"
	textButton.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton.TextSize = 17
	textButton.Font = Enum.Font.GothamBlack
	textButton.AutoButtonColor = false
	textButton.Parent = frame2
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Name = "FPSLabel"
	textLabel2.Size = UDim2.new(0, 50, 1, 0)
	textLabel2.Position = UDim2.new(1, -26, 0.5, 0)
	textLabel2.AnchorPoint = Vector2.new(1, 0.5)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = "0 FPS"
	textLabel2.Font = Enum.Font.GothamBold
	textLabel2.TextSize = 12
	textLabel2.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel2.TextXAlignment = Enum.TextXAlignment.Right
	textLabel2.TextYAlignment = Enum.TextYAlignment.Center
	textLabel2.Parent = frame2
	local textButton2 = Instance.new("TextButton")
	textButton2.Name = "ToggleBtn"
	textButton2.Size = UDim2.new(0, 46, 0, 18)
	textButton2.Position = UDim2.new(1, -82, 0.5, 0)
	textButton2.AnchorPoint = Vector2.new(1, 0.5)
	textButton2.BackgroundColor3 = flag2 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
	textButton2.BackgroundTransparency = 0
	textButton2.BorderSizePixel = 0
	textButton2.Text = flag2 and "ON" or "OFF"
	textButton2.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton2.TextSize = 13
	textButton2.Font = Enum.Font.GothamBlack
	textButton2.TextStrokeTransparency = 1
	textButton2.TextXAlignment = Enum.TextXAlignment.Center
	textButton2.TextYAlignment = Enum.TextYAlignment.Center
	textButton2.AutoButtonColor = false
	textButton2.Parent = frame2
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 5)
	uiCorner2.Parent = textButton2
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = Color3.fromRGB(255, 255, 255)
	uiStroke2.Thickness = 1
	uiStroke2.Transparency = 0.4
	uiStroke2.Parent = textButton2
	local frame3 = Instance.new("Frame")
	frame3.Name = "VersionDropdown"
	frame3.Size = UDim2.new(0, 90, 0, 82)
	frame3.Position = UDim2.new(1, -98, 0, 26)
	frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame3.BackgroundTransparency = 0.05
	frame3.BorderSizePixel = 0
	frame3.Visible = false
	frame3.ZIndex = 100
	frame3.Parent = frame
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 8)
	uiCorner3.Parent = frame3
	local uiStroke3 = Instance.new("UIStroke")
	uiStroke3.Color = Color3.fromRGB(255, 255, 255)
	uiStroke3.Thickness = 1
	uiStroke3.Transparency = 0.4
	uiStroke3.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Name = "ProgressBarBg"
	frame4.Size = UDim2.new(1, -16, 0, 16)
	frame4.Position = UDim2.new(0, 8, 0, 28)
	frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame4.BackgroundTransparency = 0.3
	frame4.BorderSizePixel = 0
	frame4.ClipsDescendants = true
	frame4.Parent = frame
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 8)
	uiCorner4.Parent = frame4
	local frame5 = Instance.new("Frame")
	frame5.Name = "ProgressFill"
	frame5.Size = UDim2.new(0, 0, 1, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame5.BorderSizePixel = 0
	frame5.Parent = frame4
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 8)
	uiCorner5.Parent = frame5
	v2 = frame5
	fn3()
	local frame6 = Instance.new("Frame")
	frame6.Name = "Glow"
	frame6.Size = UDim2.new(1, 0, 0.5, 0)
	frame6.Position = UDim2.new(0, 0, 0, 0)
	frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame6.BackgroundTransparency = 0.75
	frame6.BorderSizePixel = 0
	frame6.Parent = frame5
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0, 8)
	uiCorner6.Parent = frame6
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Name = "PercentLabel"
	textLabel3.Size = UDim2.new(1, 0, 1, 0)
	textLabel3.Position = UDim2.new(0, 0, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = "0%"
	textLabel3.Font = Enum.Font.GothamBlack
	textLabel3.TextSize = 14
	textLabel3.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel3.TextStrokeTransparency = 0.3
	textLabel3.TextXAlignment = Enum.TextXAlignment.Center
	textLabel3.TextYAlignment = Enum.TextYAlignment.Center
	textLabel3.Parent = frame4

	RunService.Heartbeat:Connect(function()
		textLabel3.Text = math.floor(math.clamp(_G.StealProgress or 0, 0, 1) * 100) .. "%"
	end)

	local frame7 = Instance.new("Frame")
	frame7.Name = "OptionsPanel"
	frame7.Size = UDim2.new(1, -16, 0, 82)
	frame7.Position = UDim2.new(0, 8, 0, 48)
	frame7.BackgroundTransparency = 1
	frame7.BorderSizePixel = 0
	frame7.Visible = false
	frame7.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 2)
	uiListLayout.Parent = frame7
	local frame8 = Instance.new("Frame")
	frame8.Name = "VerRow"
	frame8.Size = UDim2.new(1, 0, 0, 24)
	frame8.BackgroundTransparency = 1
	frame8.LayoutOrder = 0
	frame8.Parent = frame7
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(0, 60, 1, 0)
	textLabel4.Position = UDim2.new(0, 0, 0, 0)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "VERSION"
	textLabel4.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel4.TextSize = 12
	textLabel4.Font = Enum.Font.GothamBold
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.TextYAlignment = Enum.TextYAlignment.Center
	textLabel4.Parent = frame8
	local textButton3 = Instance.new("TextButton")
	textButton3.Size = UDim2.new(0, 24, 1, 0)
	textButton3.Position = UDim2.new(0, 65, 0, 0)
	textButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton3.BackgroundTransparency = 0.4
	textButton3.BorderSizePixel = 0
	textButton3.Text = "â"
	textButton3.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton3.TextSize = 18
	textButton3.Font = Enum.Font.GothamBold
	textButton3.Parent = frame8
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, 5)
	uiCorner7.Parent = textButton3
	local textButton4 = Instance.new("TextButton")
	textButton4.Name = "VersionVal"
	textButton4.Size = UDim2.new(0, 40, 1, 0)
	textButton4.Position = UDim2.new(0, 92, 0, 0)
	textButton4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton4.BackgroundTransparency = 0.3
	textButton4.BorderSizePixel = 0
	textButton4.Text = tbl4[n]
	textButton4.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton4.TextSize = 13
	textButton4.Font = Enum.Font.GothamBold
	textButton4.AutoButtonColor = false
	textButton4.Parent = frame8
	local uiCorner8 = Instance.new("UICorner")
	uiCorner8.CornerRadius = UDim.new(0, 5)
	uiCorner8.Parent = textButton4
	local textButton5 = Instance.new("TextButton")
	textButton5.Size = UDim2.new(0, 24, 1, 0)
	textButton5.Position = UDim2.new(0, 135, 0, 0)
	textButton5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton5.BackgroundTransparency = 0.4
	textButton5.BorderSizePixel = 0
	textButton5.Text = "+"
	textButton5.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton5.TextSize = 18
	textButton5.Font = Enum.Font.GothamBold
	textButton5.Parent = frame8
	local uiCorner9 = Instance.new("UICorner")
	uiCorner9.CornerRadius = UDim.new(0, 5)
	uiCorner9.Parent = textButton5

	textButton3.Activated:Connect(function()
		local n2 = n - 1

		if n2 < 1 then
			n2 = 3
		end

		fn21(n2)
	end)

	textButton5.Activated:Connect(function()
		local n2 = n + 1

		if n2 > 3 then
			n2 = 1
		end

		fn21(n2)
	end)

	textButton4.Activated:Connect(function()
		frame3.Visible = not frame3.Visible
	end)

	local function createTextButton(text, arg, arg2)
		local textButton6 = Instance.new("TextButton")
		textButton6.Name = "ver" .. arg2
		textButton6.Size = UDim2.new(1, -8, 0, 24)
		textButton6.Position = UDim2.new(0, 4, 0, arg)
		textButton6.BackgroundColor3 = arg2 == n and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
		textButton6.BackgroundTransparency = 0.2
		textButton6.TextColor3 = arg2 == n and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
		textButton6.Font = Enum.Font.GothamBold
		textButton6.TextSize = 12
		textButton6.Text = text
		textButton6.ZIndex = 101
		textButton6.BorderSizePixel = 0
		local uiCorner10 = Instance.new("UICorner")
		uiCorner10.CornerRadius = UDim.new(0, 5)
		uiCorner10.Parent = textButton6

		textButton6.Activated:Connect(function()
			fn21(arg2)
			frame3.Visible = false
		end)

		textButton6.Parent = frame3
		return textButton6
	end

	createTextButton("v1", 4, 1)
	createTextButton("v2", 30, 2)
	createTextButton("v3", 56, 3)
	local frame9 = Instance.new("Frame")
	frame9.Name = "RadRow"
	frame9.Size = UDim2.new(1, 0, 0, 24)
	frame9.BackgroundTransparency = 1
	frame9.LayoutOrder = 1
	frame9.Parent = frame7
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Size = UDim2.new(0, 60, 1, 0)
	textLabel5.Position = UDim2.new(0, 0, 0, 0)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "RADIO"
	textLabel5.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel5.TextSize = 12
	textLabel5.Font = Enum.Font.GothamBold
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.TextYAlignment = Enum.TextYAlignment.Center
	textLabel5.Parent = frame9
	local textButton6 = Instance.new("TextButton")
	textButton6.Size = UDim2.new(0, 24, 1, 0)
	textButton6.Position = UDim2.new(0, 65, 0, 0)
	textButton6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton6.BackgroundTransparency = 0.4
	textButton6.BorderSizePixel = 0
	textButton6.Text = "â"
	textButton6.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton6.TextSize = 18
	textButton6.Font = Enum.Font.GothamBold
	textButton6.Parent = frame9
	local uiCorner10 = Instance.new("UICorner")
	uiCorner10.CornerRadius = UDim.new(0, 5)
	uiCorner10.Parent = textButton6
	local textLabel6 = Instance.new("TextLabel")
	textLabel6.Size = UDim2.new(0, 40, 1, 0)
	textLabel6.Position = UDim2.new(0, 92, 0, 0)
	textLabel6.BackgroundTransparency = 1
	textLabel6.Text = tostring(autoSteal.StealRadius)
	textLabel6.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel6.TextSize = 14
	textLabel6.Font = Enum.Font.GothamBold
	textLabel6.TextXAlignment = Enum.TextXAlignment.Center
	textLabel6.TextYAlignment = Enum.TextYAlignment.Center
	textLabel6.Parent = frame9
	local textButton7 = Instance.new("TextButton")
	textButton7.Size = UDim2.new(0, 24, 1, 0)
	textButton7.Position = UDim2.new(0, 135, 0, 0)
	textButton7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton7.BackgroundTransparency = 0.4
	textButton7.BorderSizePixel = 0
	textButton7.Text = "+"
	textButton7.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton7.TextSize = 18
	textButton7.Font = Enum.Font.GothamBold
	textButton7.Parent = frame9
	local uiCorner11 = Instance.new("UICorner")
	uiCorner11.CornerRadius = UDim.new(0, 5)
	uiCorner11.Parent = textButton7

	local function fn24(arg)
		local stealRadius = math.clamp(arg, 10, 150)
		autoSteal.StealRadius = stealRadius
		textLabel6.Text = tostring(stealRadius)
		fn14(stealRadius)
	end

	textButton6.Activated:Connect(function()
		fn24(tonumber(textLabel6.Text) - 5)
	end)

	textButton7.Activated:Connect(function()
		fn24(tonumber(textLabel6.Text) + 5)
	end)

	local frame10 = Instance.new("Frame")
	frame10.Name = "ScaleRow"
	frame10.Size = UDim2.new(1, 0, 0, 24)
	frame10.BackgroundTransparency = 1
	frame10.LayoutOrder = 2
	frame10.Parent = frame7
	local textLabel7 = Instance.new("TextLabel")
	textLabel7.Size = UDim2.new(0, 60, 1, 0)
	textLabel7.Position = UDim2.new(0, 0, 0, 0)
	textLabel7.BackgroundTransparency = 1
	textLabel7.Text = "ESCALA"
	textLabel7.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel7.TextSize = 12
	textLabel7.Font = Enum.Font.GothamBold
	textLabel7.TextXAlignment = Enum.TextXAlignment.Left
	textLabel7.TextYAlignment = Enum.TextYAlignment.Center
	textLabel7.Parent = frame10
	local textButton8 = Instance.new("TextButton")
	textButton8.Size = UDim2.new(0, 24, 1, 0)
	textButton8.Position = UDim2.new(0, 65, 0, 0)
	textButton8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton8.BackgroundTransparency = 0.4
	textButton8.BorderSizePixel = 0
	textButton8.Text = "â"
	textButton8.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton8.TextSize = 18
	textButton8.Font = Enum.Font.GothamBold
	textButton8.Parent = frame10
	local uiCorner12 = Instance.new("UICorner")
	uiCorner12.CornerRadius = UDim.new(0, 5)
	uiCorner12.Parent = textButton8
	local textLabel8 = Instance.new("TextLabel")
	textLabel8.Size = UDim2.new(0, 40, 1, 0)
	textLabel8.Position = UDim2.new(0, 92, 0, 0)
	textLabel8.BackgroundTransparency = 1
	textLabel8.Text = string.format("%.1f", scale)
	textLabel8.TextColor3 = Color3.fromRGB(25, 25, 25)
	textLabel8.TextSize = 14
	textLabel8.Font = Enum.Font.GothamBold
	textLabel8.TextXAlignment = Enum.TextXAlignment.Center
	textLabel8.TextYAlignment = Enum.TextYAlignment.Center
	textLabel8.Parent = frame10
	local textButton9 = Instance.new("TextButton")
	textButton9.Size = UDim2.new(0, 24, 1, 0)
	textButton9.Position = UDim2.new(0, 135, 0, 0)
	textButton9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textButton9.BackgroundTransparency = 0.4
	textButton9.BorderSizePixel = 0
	textButton9.Text = "+"
	textButton9.TextColor3 = Color3.fromRGB(25, 25, 25)
	textButton9.TextSize = 18
	textButton9.Font = Enum.Font.GothamBold
	textButton9.Parent = frame10
	local uiCorner13 = Instance.new("UICorner")
	uiCorner13.CornerRadius = UDim.new(0, 5)
	uiCorner13.Parent = textButton9
	local uiScale = Instance.new("UIScale")
	uiScale.Scale = scale
	uiScale.Parent = frame

	local function fn25(arg)
		local scale2 = math.clamp(arg, 0.5, 1.5)
		uiScale.Scale = scale2
		textLabel8.Text = string.format("%.1f", scale2)
		fn16(scale2)
	end

	textButton8.Activated:Connect(function()
		fn25((tonumber(textLabel8.Text) or 1) - 0.1)
	end)

	textButton9.Activated:Connect(function()
		fn25((tonumber(textLabel8.Text) or 1) + 0.1)
	end)

	fn25(scale)
	local n2 = 0
	local now2 = tick()
	local n3 = 0

	RunService.RenderStepped:Connect(function()
		n2 += 1
		local now3 = tick()

		if now3 - now2 >= 0.5 then
			n3 = math.floor(n2 / (now3 - now2))
			n2 = 0
			now2 = now3
			textLabel2.Text = n3 .. " FPS"
		end
	end)

	local visible = false

	textButton.MouseButton1Click:Connect(function()
		visible = not visible
		frame7.Visible = visible

		if not visible then
			frame3.Visible = false
		end

		if visible then
			frame.Size = UDim2.new(0, 320, 0, 136)
		else
			frame.Size = UDim2.new(0, 320, 0, 52)
		end
	end)

	local flag3 = false
	local position = nil
	local position2 = nil

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag3 = true
			position = input.Position
			position2 = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag3 = false
					fn12(frame)
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not flag3 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local n4 = input.Position.X - position.X
			local n5 = input.Position.Y - position.Y
			local currentCamera = workspace.CurrentCamera
			currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1000, 1000)
			local absoluteSize = frame.AbsoluteSize
			local n6 = position2.X.Scale * currentCamera.X
			frame.Position = UDim2.new(position2.X.Scale, math.clamp(n6 + position2.X.Offset + n4, absoluteSize.X / 2, currentCamera.X - absoluteSize.X / 2) - n6, position2.Y.Scale, math.clamp(position2.Y.Scale * currentCamera.Y + position2.Y.Offset + n5, 0, currentCamera.Y - absoluteSize.Y) - position2.Y.Scale * currentCamera.Y)
		end
	end)

	screenGui.AncestryChanged:Connect(function()
		if not screenGui.Parent then
			fn12(frame)
		end
	end)

	tbl5 = {
		versionValLabel = textButton4,
		dropdown = frame3,
		toggleBtn = textButton2,
		updateUI = function()
			textLabel6.Text = tostring(autoSteal.StealRadius)
		end,
	}

	textButton2.Activated:Connect(function()
		fn22(not flag2)
	end)

	fn22(flag2, true)
end

fn20(n)
fn23()