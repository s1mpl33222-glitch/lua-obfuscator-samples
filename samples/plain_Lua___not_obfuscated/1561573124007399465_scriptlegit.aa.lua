-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- VARIABLES
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local visitedPositions = {}
local isActive = false
local flySpeed = 15
local collected = 0
local startTime = 0
local antiAFK = false

player.CharacterAdded:Connect(function(char)
	character = char
	rootPart = char:WaitForChild("HumanoidRootPart")
	visitedPositions = {}
end)

-- SOUND
local collectSound = Instance.new("Sound", rootPart)
collectSound.SoundId = "rbxassetid://12221967"
collectSound.Volume = 1

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 300) -- Slightly taller to fit credits
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(110, 110, 160)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "Coin/Beach Balls Autofarm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local separator = Instance.new("Frame", frame)
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.new(0, 10, 0, 45)
separator.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
separator.BorderSizePixel = 0

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, -20, 0, 20)
credit.Position = UDim2.new(0, 10, 1, -20)
credit.Text = "Made by XenaMm2"
credit.TextColor3 = Color3.fromRGB(170, 170, 170)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextXAlignment = Enum.TextXAlignment.Right

local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 110, 0, 35)
hideBtn.Position = UDim2.new(1, -120, 1, -45)
hideBtn.Text = "Hide GUI"
hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 6)

hideBtn.MouseEnter:Connect(function()
	hideBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
end)
hideBtn.MouseLeave:Connect(function()
	hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
end)
hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	hideBtn.Text = frame.Visible and "Hide GUI" or "Show GUI"
end)

local function makeButton(y, text)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 240, 0, 30)
	btn.Position = UDim2.new(0.5, -120, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local function makeLabel(y, text)
	local lbl = Instance.new("TextLabel", frame)
	lbl.Size = UDim2.new(0, 240, 0, 20)
	lbl.Position = UDim2.new(0.5, -120, 0, y)
	lbl.Text = text
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	return lbl
end

local toggleBtn = makeButton(60, "Auto Farm: OFF")
local afkBtn = makeButton(100, "Anti-AFK: OFF")
local speedBtn = makeButton(140, "Tween Speed: 15")
local counterLabel = makeLabel(180, "Coins/Eggs/Balss Collected: 0")
local timerLabel = makeLabel(205, "Time Active: 0s")
local rateLabel = makeLabel(230, "Est. Coins/Hour: 0")
local resetBtn = makeButton(255, "🔄 Reset Counter")

resetBtn.MouseButton1Click:Connect(function()
	collected = 0
	startTime = tick()
	counterLabel.Text = "Coins/Eggs Collected: 0"
	timerLabel.Text = "Time Active: 0s"
	rateLabel.Text = "Est. Coins/Hour: 0"
end)

-- AFK
afkBtn.MouseButton1Click:Connect(function()
	antiAFK = not antiAFK
	afkBtn.Text = antiAFK and "Anti-AFK: ON" or "Anti-AFK: OFF"
end)

player.Idled:Connect(function()
	if antiAFK then
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end
end)

RunService.Stepped:Connect(function()
	if isActive and character then
		for _, v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	flySpeed += 1
	if flySpeed > 25 then flySpeed = 10 end
	speedBtn.Text = "Tween Speed: " .. flySpeed
end)

local function flyTo(pos, speed)
	if not rootPart then return end
	local distance = (pos - rootPart.Position).Magnitude
	local duration = distance / speed
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local goal = {CFrame = CFrame.new(pos)}
	local tween = TweenService:Create(rootPart, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
end

local function isNear(pos1, pos2)
	return (pos1 - pos2).Magnitude < 250
end

toggleBtn.MouseButton1Click:Connect(function()
	isActive = not isActive
	toggleBtn.Text = isActive and "Auto Farm: ON" or "Auto Farm: OFF"
	toggleBtn.BackgroundColor3 = isActive and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(50, 50, 70)

	if isActive then
		collected = 0
		startTime = tick()
		visitedPositions = {}

		-- Timer updater
		task.spawn(function()
			while isActive do
				local elapsed = tick() - startTime
				timerLabel.Text = "Time Active: " .. math.floor(elapsed) .. "s"
				local rate = elapsed > 0 and math.floor((collected / elapsed) * 3600) or 0
				rateLabel.Text = "Est. Coins/Hour: " .. rate
				task.wait(0.1)
			end
		end)

		-- Main coin search loop
		task.spawn(function()
			while isActive do
				character = player.Character or player.CharacterAdded:Wait()
				rootPart = character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					local closest, shortest = nil, math.huge
					for _, obj in ipairs(workspace:GetDescendants()) do
						if obj:IsA("BasePart") and obj.Name == "Coin_Server" then
							local dist = (obj.Position - rootPart.Position).Magnitude
							if dist < shortest and dist < 250 and not visitedPositions[obj] then
								closest = obj
								shortest = dist
							end
						end
					end

					if closest and closest.Parent and closest:IsDescendantOf(workspace) then
						flyTo(closest.Position, flySpeed)
						if closest and closest.Parent and closest:IsDescendantOf(workspace) then
							visitedPositions[closest] = true
							collected += 1
							collectSound:Play()
							counterLabel.Text = "Coins/Eggs/Balls Collected: " .. collected
						end
					end
				end
				task.wait(0.1)
			end
		end)
	end
end)
